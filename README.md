# 🤖 Imersão Agentes de IA - Hashtag Treinamentos

Bem-vindo ao meu repositório de estudos da **Imersão Agentes de IA**. Aqui, organizo e versiono workflows do **n8n** focados em produtividade e automação inteligente, utilizando uma infraestrutura local robusta e segura.

## 🏗️ Infraestrutura e Tecnologias

Este projeto não é apenas uma coleção de arquivos JSON; ele foi construído para simular um ambiente de produção local:

* **n8n**: Plataforma core de automação via containers.
* **Docker & Docker Compose**: Orquestração do ambiente para garantir consistência em qualquer máquina.
* **Makefile**: Automação de tarefas repetitivas via terminal (WSL/Ubuntu).
* **GPG Encryption**: Segurança de dados sensíveis através de criptografia simétrica nos backups.
* **Rclone**: Sincronização automatizada com Google Drive.
* **Google Gemini API**: Inteligência artificial utilizada para o processamento de linguagem natural nos agentes.

---

## 🛠️ Comandos Rápidos (Makefile)

O gerenciamento do projeto é feito de forma simplificada através do terminal:

| Comando | Função |
| :--- | :--- |
| `make up` | Sobe o n8n. |
| `make down` | Para o n8n. |
| `make restart` | Reinicia o n8n. |
| `make deploy` | Atualiza e sobe o n8n. |
| `make logs` | Exibe os logs do n8n. |
| `make status` | Exibe o status dos containers. |
| `make backup` | Cria backup criptografado (local + Drive). |
| `make upload-backup` | Envia backups locais para o Drive. |
| `make list-backups` | Lista backups locais. |
| `make list-backups-remote` | Lista backups no Drive. |
| `make restore` | Restaura backup específico. |
| `make restore-latest` | Restaura o backup mais recente. |
| `make doctor` | Verificação do ambiente. |
| `make reset` | Remove containers e volumes (⚠️ DADOS). |
| `make clean` | Limpa recursos Docker. |

---

## 📂 Organização dos Workflows

Cada aula da imersão possui sua própria pasta com o workflow exportado e documentação específica:

*(Próximas aulas serão adicionadas aqui)*

---

## 🔒 Segurança e Boas Práticas

Para manter este repositório seguro e limpo:
1.  **Variáveis de Ambiente**: Arquivos `.env` são ignorados pelo Git para proteger credenciais. Use o `.env.example` como guia.
2.  **Backups**: A pasta `backup/` e arquivos `.gpg` ou `.tar.gz` são estritamente bloqueados no versionamento para evitar vazamento de dados do banco de dados do n8n.
3.  **Docker Hygiene**: O projeto utiliza um `.dockerignore` para garantir que o contexto de build seja leve e seguro.

---

## 🚀 Como Executar

1.  Certifique-se de ter o **Docker** e o **Make** instalados no seu WSL/Linux.
2.  Clone o repositório.
3.  Configure seu arquivo `.env` (use o `make doctor` para validar seu ambiente).
4.  Suba o ambiente:
    ```bash
    make up
    ```
5.  Acesse o n8n em `http://localhost:5678`.
