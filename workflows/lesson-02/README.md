# 🤖 AI-Powered Refund Agent

Este é um sistema de automação inteligente desenvolvido para gerenciar solicitações de reembolso de forma autônoma. Utilizando **n8n** como orquestrador e o **Google Gemini** como cérebro da operação, o agente processa dados de formulários, consulta bases de dados externas e toma decisões baseadas em regras de negócio e análise de sentimento.

---

## 🚀 Funcionalidades

* **Processamento Inteligente:** Extração e consolidação de dados via IA.
* **Análise de Sentimento:** Classificação automática de mensagens (Positivo, Neutro, Negativo, Muito Negativo).
* **Integração com Banco de Dados:** Consulta em tempo real no Google Sheets para validar histórico do cliente.
* **Roteamento Lógico (Decision Tree):**
    * **Within Deadline:** Confirmação automática e alerta de novo pedido.
    * **VIP Customer:** Tratamento prioritário para clientes de alto valor.
    * **Complaining Customer:** Escalonamento imediato para clientes insatisfeitos.
    * **Standard Customer:** Resposta automática padrão para prazos excedidos.
* **Notificações Multicanal:** Comunicação via Gmail e alertas em tempo real no Telegram.

---

## 🛠️ Stack Tecnológica

* **n8n:** Orquestração de workflow.
* **Google Gemini:** IA para lógica, extração de dados e análise de sentimento.
* **Google Sheets:** Banco de dados de clientes e pedidos.
* **Gmail & Telegram:** Canais de saída e notificações.

---

## ⚙️ Configuração do Ambiente

1. Renomeie o arquivo `.env.example` para `.env`.
2. Preencha as variáveis abaixo com suas credenciais:

```env
# Google Cloud (OAuth2)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# Google Sheets
SHEETS_REFUND_ID=
SHEETS_REFUND_TAB_NAME=

# Telegram
TELEGRAM_BOT_TOKEN=
TELEGRAM_REFUND_CHAT_ID=

# Gemini
GEMINI_API_KEY=