# 🤖 Agente Comercial de IA (Gmail + Gemini)

> **Aula 01** - Imersão Agentes de IA

Este workflow implementa um **Agente de Atendimento Comercial** totalmente automatizado utilizando n8n e Inteligência Artificial. O agente monitora uma caixa de entrada do Gmail, filtra mensagens internas, consulta uma base de conhecimento sobre os cursos da **Hashtag Treinamentos** e envia respostas persuasivas e formatadas em HTML.

---

## 🚀 Funcionalidades

* **Monitoramento Ativo**: Verifica novos e-mails a cada minuto usando *Polling* do Gmail.
* **Filtro de Segurança**: Impede que o agente responda e-mails internos da empresa (domínio `@hashtag.com`) ou loops de resposta.
* **Cérebro de IA (Gemini)**: Utiliza o modelo `Google Gemini (PaLM)` para interpretar a intenção do usuário.
* **Memória Contextual**: Mantém o contexto da conversa (buffer de 25 mensagens) baseado no `threadId` do e-mail, permitindo diálogos contínuos.
* **Base de Conhecimento**: O agente possui instruções detalhadas sobre:
    * Cursos (Excel, Python, Power BI, SQL, etc.).
    * Preços e Garantias (7 dias incondicional).
    * Links de inscrição específicos para cada produto.
* **Resposta Formatada**: Gera respostas em HTML válido (negrito, listas, quebras de linha) para melhor legibilidade no e-mail.

---

## 🛠️ Estrutura do Workflow

O fluxo é composto pelos seguintes nós principais:

1.  **Gmail Trigger**: Gatilho que inicia o fluxo ao receber um novo e-mail.
2.  **If (Filtro)**: Lógica condicional `notContains` para verificar se o remetente não é da própria organização (`hashtag.com`).
3.  **AI Agent**: O orquestrador central que conecta o modelo de linguagem, a memória e a ferramenta de resposta.
    * *System Prompt*: Contém a persona do "Especialista Comercial" e o catálogo de cursos.
4.  **Google Gemini Chat Model**: O provedor de LLM conectado ao agente.
5.  **Window Buffer Memory**: Gerencia o histórico da conversa.
6.  **Gmail Reply**: Ação final que envia a resposta gerada pela IA para a thread original.

---

## 📋 Pré-requisitos

Para executar este fluxo, você precisa da infraestrutura configurada no projeto principal:

1.  **Docker & n8n**: O container `n8n-hashtag` deve estar rodando.
    * Comando: `make up` (na raiz do projeto).
2.  **Credenciais do Google**:
    * **OAuth2 Client ID e Secret**: Para autenticação dos nós do Gmail.
    * **API Key do Gemini**: Para o nó do Google Gemini (PaLM).

---

## 📥 Como Usar

1.  **Importar**:
    * No n8n, clique no menu (canto superior direito) > `Import from File`.
    * Selecione o arquivo `n8n-gmail-agent.json` presente nesta pasta.

2.  **Configurar Credenciais**:
    * Abra o nó **Gmail Trigger** e selecione sua credencial `Gmail account`.
    * Abra o nó **Google Gemini Chat Model** e selecione sua credencial `Google Gemini(PaLM) Api account`.
    * Abra o nó **Reply to a message** e confirme a credencial do Gmail.

3.  **Testar**:
    * Clique em "Execute Workflow" e envie um e-mail para a conta monitorada perguntando sobre "Cursos de Python".

---

## 🧠 Personalização do Agente

O comportamento do agente é definido no parâmetro `System Message` dentro do nó **AI Agent**. Atualmente, ele está configurado para:

* **Tom de Voz**: Prestativo, comercial e especialista.
* **Regras de Formatação**: Sempre usar tags HTML (`<br>`, `<b>`, `<ul>`).
* **Links**: Inserir links de *checkout* ou ementa sempre que citar um curso específico.

> **Nota:** Para alterar os cursos ou preços, edite diretamente o texto dentro do campo "System Message" no nó do Agente.

---

## 🔍 Monitoramento

Se o fluxo falhar ou o e-mail não chegar, verifique os logs do container n8n via terminal na raiz do projeto:

```bash
make logs