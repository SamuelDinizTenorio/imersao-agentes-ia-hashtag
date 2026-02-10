# 🤖 AI-Powered Customer Support Agent

Este é um sistema de atendimento automatizado desenvolvido para responder dúvidas de clientes de forma natural e contextual. Utilizando **n8n** como orquestrador e o **Google Gemini** como cérebro da operação, o agente monitora uma caixa de entrada, filtra mensagens internas e atua como um especialista comercial, esclarecendo dúvidas sobre cursos, preços e garantias.

---

## 🚀 Funcionalidades

* **Monitoramento Ativo:** Verificação contínua de novos e-mails via integração nativa com Gmail.
* **Filtro de Segurança (Loop Protection):** Bloqueio automático de respostas para e-mails internos (`@hashtag.com`) para evitar loops infinitos.
* **Memória Contextual (Thread-based):** Capacidade de manter o contexto da conversa, permitindo que o usuário faça perguntas sequenciais sem perder o fio da meada.
* **Base de Conhecimento Dinâmica:** Prompt estruturado com informações detalhadas sobre produtos (Excel, Python, Power BI) e políticas de vendas.
* **Respostas Formatadas:** Geração de saídas em HTML (listas, negrito, quebras de linha) para uma comunicação profissional.

---

## 🛠️ Stack Tecnológica

* **n8n:** Orquestração de workflow e gestão de memória.
* **Google Gemini:** IA para interpretação de intenção e geração de respostas persuasivas.
* **Gmail:** Interface de entrada (gatilho) e saída (resposta) de mensagens.

---

## ⚙️ Configuração do Ambiente

1. Certifique-se de que o arquivo `.env` na raiz do projeto já contém as credenciais compartilhadas.
2. As variáveis essenciais para este agente são:

```env
# Google Cloud (OAuth2) - Para acesso ao Gmail
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# Gemini - Para inteligência do agente
GEMINI_API_KEY=
