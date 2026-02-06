.PHONY: help up down restart deploy logs status clean reset \
        backup upload-backup backup-and-upload \
        list-backups list-backups-remote latest-backup \
        restore restore-latest check-env check-backup-env doctor

# ======================================
# Carrega variáveis do .env (se existir)
# ======================================
ifneq (,$(wildcard .env))
  include .env
  export
endif

# =========================
# Variáveis
# =========================

VOLUME_NAME ?= imersao-agentes-ia-hashtag_n8n-data
BACKUP_DIR  ?= backup
BACKUP_FILE ?=

# =========================
# Ajuda
# =========================

help:
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make up                 → Sobe o n8n"
	@echo "  make down               → Para o n8n"
	@echo "  make restart            → Reinicia o n8n"
	@echo "  make deploy             → Atualiza e sobe o n8n"
	@echo "  make logs               → Logs do n8n"
	@echo "  make status             → Status dos containers"
	@echo ""
	@echo "  make backup              → Backup criptografado (local + Drive)"
	@echo "  make upload-backup       → Envia backups locais para o Drive"
	@echo "  make list-backups        → Lista backups locais"
	@echo "  make list-backups-remote → Lista backups no Drive"
	@echo "  make restore             → Restaura backup específico"
	@echo "  make restore-latest      → Restaura o backup mais recente"
	@echo ""
	@echo "  make doctor              → Verificação do ambiente"
	@echo "  make reset               → Remove containers e volumes (⚠️ DADOS)"
	@echo "  make clean               → Limpa recursos Docker"
	@echo ""

# =========================
# Verificações
# =========================

check-env:
	@test -f .env || (echo "❌ Arquivo .env não encontrado" && exit 1)

check-backup-env:
	@test -n "$(BACKUP_PASSPHRASE)" || (echo "❌ BACKUP_PASSPHRASE não definida no .env" && exit 1)

doctor: check-env
	@echo "🔎 Verificando ambiente..."
	@docker --version >/dev/null 2>&1 || (echo "❌ Docker não encontrado" && exit 1)
	@docker compose version >/dev/null 2>&1 || (echo "❌ Docker Compose não encontrado" && exit 1)
	@command -v gpg >/dev/null 2>&1 || echo "⚠️ gpg não instalado"
	@command -v rclone >/dev/null 2>&1 || echo "⚠️ rclone não instalado"
	@docker volume inspect $(VOLUME_NAME) >/dev/null 2>&1 || echo "⚠️ Volume $(VOLUME_NAME) não encontrado"
	@echo "✅ Ambiente OK"

# =========================
# Comandos principais
# =========================

up: check-env
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

deploy: check-env
	docker compose pull
	docker compose up -d

logs:
	docker compose logs -f n8n

status:
	docker compose ps

# =========================
# Manutenção
# =========================

clean:
	docker system prune -f

reset:
	docker compose down -v

# =========================
# Backup criptografado
# =========================

backup: check-env check-backup-env
	@mkdir -p $(BACKUP_DIR)
	@BACKUP_NAME=n8n_backup_$$(date +%Y%m%d_%H%M%S); \
	echo "📦 Criando backup $$BACKUP_NAME..." && \
	docker run --rm \
	  -v $(VOLUME_NAME):/home/node/.n8n \
	  -v "$(PWD)/$(BACKUP_DIR)":/backup \
	  alpine \
	  sh -c "tar czf /backup/$$BACKUP_NAME.tar.gz /home/node/.n8n" && \
	echo "🔐 Criptografando backup..." && \
	gpg --batch --yes --passphrase "$(BACKUP_PASSPHRASE)" \
	  -c $(BACKUP_DIR)/$$BACKUP_NAME.tar.gz && \
	rm -f $(BACKUP_DIR)/$$BACKUP_NAME.tar.gz && \
	echo "☁️ Enviando para o Google Drive..." && \
	rclone sync $(BACKUP_DIR) gdrive:n8n-backups && \
	echo "✅ Backup criptografado concluído"

upload-backup:
	@command -v rclone >/dev/null 2>&1 || (echo "❌ rclone não instalado" && exit 1)
	rclone sync $(BACKUP_DIR) gdrive:n8n-backups

# =========================
# Listagem
# =========================

list-backups:
	@echo "📦 Backups locais:"
	@ls -lh $(BACKUP_DIR)/n8n_backup_*.tar.gz.gpg 2>/dev/null || \
		echo "⚠️ Nenhum backup encontrado"

latest-backup:
	@ls -t $(BACKUP_DIR)/n8n_backup_*.tar.gz.gpg 2>/dev/null | head -n 1 || \
		echo "⚠️ Nenhum backup encontrado"

list-backups-remote:
	@echo "☁️ Backups no Google Drive:"
	rclone ls gdrive:n8n-backups

# =========================
# Restore criptografado
# =========================

restore: check-env check-backup-env
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "❌ Informe o arquivo de backup (.gpg):"; \
		echo "   make restore BACKUP_FILE=backup/n8n_backup_YYYYMMDD_HHMMSS.tar.gz.gpg"; \
		exit 1; \
	fi

	@if [ ! -f "$(BACKUP_FILE)" ]; then \
		echo "❌ Arquivo não encontrado: $(BACKUP_FILE)"; \
		exit 1; \
	fi

	@echo ""
	@echo "⚠️  ATENÇÃO: RESTORE DE BACKUP"
	@echo "----------------------------------------"
	@echo "Backup: $(BACKUP_FILE)"
	@echo "Este processo irá APAGAR o volume atual."
	@printf "Deseja continuar? (y/n): "
	@read CONFIRM && \
		case "$$CONFIRM" in \
		  y|Y ) echo "✔ Confirmado";; \
		  n|N ) echo "❌ Cancelado"; exit 1;; \
		  * )   echo "❌ Opção inválida"; exit 1;; \
		esac

	@echo "🔓 Descriptografando backup..."
	@gpg --batch --yes --passphrase "$(BACKUP_PASSPHRASE)" \
	  -o /tmp/n8n_restore.tar.gz \
	  -d $(BACKUP_FILE)

	@echo "🛑 Parando n8n..."
	docker compose down

	@echo "🧹 Recriando volume..."
	docker volume rm $(VOLUME_NAME) || true
	docker volume create $(VOLUME_NAME)

	@echo "♻️ Restaurando dados..."
	docker run --rm \
	  -v $(VOLUME_NAME):/home/node/.n8n \
	  -v /tmp:/backup \
	  alpine \
	  sh -c "tar xzf /backup/n8n_restore.tar.gz -C /"

	@rm -f /tmp/n8n_restore.tar.gz

	@echo "🚀 Subindo n8n..."
	docker compose up -d

	@echo "✅ Restore concluído com sucesso"

restore-latest:
	@LATEST=$$(ls -t $(BACKUP_DIR)/n8n_backup_*.tar.gz.gpg 2>/dev/null | head -n 1); \
	[ -z "$$LATEST" ] && echo "❌ Nenhum backup encontrado" && exit 1; \
	$(MAKE) restore BACKUP_FILE=$$LATEST
