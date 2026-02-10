# 🤖 Imersão Agentes de IA - Hashtag Treinamentos

![CI Status](https://github.com/SamuelDinizTenorio/imersao-agentes-ia-hashtag/actions/workflows/ci.yml/badge.svg)
[![n8n](https://img.shields.io/badge/n8n-v1.0+-FF6C37?logo=n8n&logoColor=white)](https://n8n.io/)
[![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

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

### 📁 [Aula 01 - Criando seu primeiro agente de IA com n8n](./workflows/lesson-01)
* **Descrição**: Um agente autônomo que monitora o Gmail, filtra mensagens e utiliza o **Google Gemini** para responder dúvidas sobre os cursos da Hashtag Treinamentos.
* **Destaques Técnicos**: 
    * **Memory Buffer**: Retenção de contexto para conversas contínuas (Thread ID).
    * **System Prompt**: Engenharia de prompt para respostas em HTML estruturado.
    * **Filtro de Segurança**: Evita loops de resposta em domínios internos.
* **Arquivo Principal**: [`gmail-customer-support-agent.json`](./workflows/lesson-01/gmail-customer-support-agent.json)

### 📁 [Aula 02 - Agente de Reembolso Inteligente](./workflows/lesson-02)
* **Descrição**: Sistema de triagem automática de reembolsos que combina análise de sentimento com regras de negócio complexas.
* **Destaques Técnicos**: 
    * **Multi-Step Logic**: Árvore de decisão baseada em prazo de garantia, valor do cliente (VIP) e tom da mensagem.
    * **Data Enrichment**: Integração com Google Sheets para validação de dados históricos em tempo real.
    * **Multichannel Output**: Respostas personalizadas via Gmail e alertas críticos via Telegram.
* **Arquivo Principal**: [`process-refund-logic-agent`](./workflows/lesson-02/process-refund-logic-agent.json)

*(Próximas aulas serão adicionadas aqui)*

---

### 🌐 Configuração de Webhooks (Ngrok)
Como este projeto utiliza gatilhos externos (Gmail e Telegram), é necessário um túnel para que o n8n receba os eventos:

1. Inicie o Ngrok na porta 5678: `ngrok http 5678`
2. No arquivo `.env`, atualize a variável `WEBHOOK_URL` com o endereço gerado pelo Ngrok:
   `WEBHOOK_URL=https://sua-url-gerada.ngrok-free.dev/`
3. Reinicie o Docker para aplicar a nova URL.

---

## ⚙️ CI/CD & Automação de Qualidade

Este projeto utiliza **GitHub Actions** para garantir que a infraestrutura e as automações estejam sempre operacionais e seguras. O pipeline de Integração Contínua (CI) é executado automaticamente em cada `push` para a branch `main` ou na abertura de **Pull Requests**.

### O que o Pipeline valida:

* **🛡️ Segurança (DevSecOps)**: Utiliza o **Gitleaks** para auditar todo o histórico de commits à procura de chaves de API ou segredos expostos (como tokens do Gemini ou Gmail).
* **🏗️ Integridade da Infraestrutura**: Verifica se os arquivos essenciais (`docker-compose.yml`, `Makefile`, `.env.example`, etc.) estão presentes e se a sintaxe do Docker está correta.
* **🤖 Validação de Workflows (n8n)**: Realiza uma varredura recursiva em todas as subpastas de `workflows/`. Utiliza a ferramenta `jq` para validar a integridade de cada arquivo JSON, garantindo que nenhum fluxo corrompido seja versionado.



> [!IMPORTANT]
> O pipeline utiliza a configuração **`fetch-depth: 0`**, permitindo que o Gitleaks analise não apenas o código atual, mas todo o rastro histórico do repositório para garantir 100% de privacidade das credenciais.

### Como visualizar o status:

Você pode acompanhar a execução dos testes clicando na aba **Actions** do repositório. O pipeline está dividido em três jobs independentes:
1.  `infra-check`: Valida arquivos de configuração e Docker.
2.  `workflow-check`: Valida a integridade dos arquivos `.json`.
3.  `security`: Executa o scanning de segredos.

---

## 🔒 Segurança e Boas Práticas

Para manter este repositório seguro e limpo:
1.  **Variáveis de Ambiente**: Arquivos `.env` são ignorados pelo Git para proteger credenciais. Use o `.env.example` como guia.
2.  **Backups**: A pasta `backup/` e arquivos `.gpg` ou `.tar.gz` são estritamente bloqueados no versionamento para evitar vazamento de dados do banco de dados do n8n.
3.  **Docker Hygiene**: O projeto utiliza um `.dockerignore` para garantir que o contexto de build seja leve e seguro.

---

## 🚀 Como Executar

1.  Clone o repositório em um ambiente Linux/WSL.
2.  Configure seu `.env` baseando-se no `.env.example`.
3.  Execute a verificação inicial:
    ```bash
    make doctor
    ```
4.  Suba o ambiente:
    ```bash
    make up
    ```
5.  Acesse o n8n em: `http://localhost:5678`
