# Generative AI - User Perspective Notes

**Playlist**: [Generative AI using LangChain - CampusX](https://www.youtube.com/watch?v=pSVk-5WemQ0&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0)

**Focus**: How to effectively **use** and **build applications** with existing Large Language Models without training them from scratch.

---

## 1. Two Perspectives of Generative AI (Quick Recap)

### Builder Perspective
Focuses on understanding and building the core technology:
- Transformers, Pretraining, Optimizers, Fine-Tuning, Evaluation, Deployment.

### User Perspective (This Document)
Focuses on **leveraging** powerful LLMs to solve real problems quickly:
- Interacting with models
- Building intelligent applications
- Making LLMs reliable and useful in production

**Goal**: Become highly effective at creating LLM-powered applications using tools like LangChain.

---

## 2. User Perspective - Core Topics

### 2.1 Building Basic LLM Apps using LangChain

- **What is LangChain?**
  - Framework for developing applications powered by Large Language Models.
  - Provides modular components to chain LLMs with other tools and data.

- **Core Concepts**:
  - **LLM Wrappers** (OpenAI, Grok, Anthropic, Hugging Face, Ollama, etc.)
  - **Prompt Templates**
  - **Chains** – Simple sequential workflows
  - **Runnables** and **LCEL** (LangChain Expression Language)
  - **Output Parsers**
  - **Memory** (ConversationBufferMemory, etc.)

- **First App Flow**:
  1. Install LangChain + LangChain-community
  2. Set up LLM (e.g., ChatOpenAI)
  3. Create PromptTemplate
  4. Build chain using `|` operator (LCEL)
  5. Invoke the chain

- **Best Practices**:
  - Use `.with_config()` for debugging
  - Always handle exceptions gracefully
  - Start simple, then add complexity

---

### 2.2 Prompt Engineering

- **Why Prompt Engineering Matters**
  - LLMs are extremely sensitive to how you ask questions.

- **Core Techniques**:

  | Technique              | Description                                      | When to Use                     |
  |------------------------|--------------------------------------------------|---------------------------------|
  | Zero-shot              | Direct instruction                               | Simple tasks                    |
  | Few-shot               | Provide 2–5 examples                             | Consistent formatting           |
  | Chain-of-Thought (CoT) | "Think step by step"                             | Reasoning & math problems       |
  | Self-Consistency       | Generate multiple responses & vote               | High accuracy needed            |
  | ReAct                  | Reason + Act (Thought → Action → Observation)    | Tool-using agents               |
  | Tree of Thoughts       | Explore multiple reasoning paths                 | Complex planning                |

- **Advanced Tips**:
  - Role prompting ("You are an expert ...")
  - Delimiters (```, XML tags, JSON)
  - Specify output format clearly
  - Iterate prompts systematically
  - Use temperature and top_p effectively

- **Tools**: Promptfoo, LangSmith Prompt Playground, DSPy

---

### 2.3 Retrieval Augmented Generation (RAG)

- **Problem it Solves**: LLMs have knowledge cutoff + hallucinate on private data.

- **RAG Architecture**:
  1. **Indexing** – Load → Split → Embed → Store in Vector DB
  2. **Retrieval** – Query → Embed → Retrieve similar chunks
  3. **Generation** – Pass retrieved context + query to LLM

- **Key Components**:
  - Document Loaders (PDF, TXT, Web, YouTube, etc.)
  - Text Splitters (RecursiveCharacterTextSplitter)
  - Embeddings (OpenAI, HuggingFace, Cohere, etc.)
  - Vector Stores (Chroma, FAISS, Pinecone, Weaviate, PGVector)
  - Retrievers (Similarity, MMR, MultiQuery, Contextual Compression)
  - RAG Chain (Stuff, Map-Reduce, Refine, Map-Rerank)

- **Advanced RAG Techniques**:
  - HyDE (Hypothetical Document Embeddings)
  - Parent-Document Retriever
  - Self-RAG
  - Corrective RAG (CRAG)
  - Adaptive RAG
  - Graph RAG

- **Evaluation**:
  - Context Relevance
  - Groundedness / Faithfulness
  - Answer Relevance
  - RAGAS framework

---

### 2.4 Fine-Tuning (from User View)

- **When to Fine-Tune?**
  - When prompt engineering + RAG is not enough
  - Need consistent style, domain expertise, or specific behavior

- **User-Friendly Fine-Tuning Approaches**:
  - **Instruction Tuning** / SFT (Supervised Fine-Tuning)
  - **LoRA & QLoRA** (Most popular for individuals)
  - **Unsloth** (Faster & cheaper fine-tuning)
  - **Axolotl**, **LLaMA-Factory**, **Hugging Face TRL**

- **Popular Fine-Tuning Datasets**:
  - Alpaca, Evol-Instruct, UltraChat
  - Domain-specific (legal, medical, coding)

- **Alignment Techniques**:
  - RLHF, DPO, ORPO, KTO

- **User Tip**: Start with QLoRA on a 7B–13B model before attempting full fine-tuning.

---

### 2.5 Agents

- **What are Agents?**
  - LLMs that can **reason** and **use tools** autonomously to achieve goals.

- **Core Concepts**:
  - **Tools** (Search, Calculator, Python REPL, APIs, Custom functions)
  - **Agent Executor**
  - **Agent Types**:
    - ReAct Agent
    - Self-Ask
    - OpenAI Functions / Tool Calling Agent
    - Plan-and-Execute Agent
    - Multi-Agent systems

- **LangChain / LangGraph Support**:
  - `create_react_agent`
  - `create_tool_calling_agent`
  - LangGraph for building **stateful, controllable** agents with cycles, persistence, and human-in-the-loop

- **Best Practices**:
  - Give clear tool descriptions
  - Use structured output when possible
  - Add error handling and fallbacks
  - Monitor with LangSmith

---

### 2.6 LLMOps (Operations for LLMs)

- **What is LLMOps?**
  - DevOps practices adapted for LLM applications.

- **Key Areas**:

  | Area               | Tools / Concepts                              |
  |--------------------|-----------------------------------------------|
  | Experiment Tracking| LangSmith, Weights & Biases, Promptfoo       |
  | Observability      | LangSmith, Phoenix, Helicone, LangFuse       |
  | Prompt Management  | Versioning, A/B testing, Prompt registries   |
  | Evaluation         | RAGAS, DeepEval, LLM-as-Judge                 |
  | Cost Monitoring    | Token usage tracking, budget alerts           |
  | Deployment         | FastAPI, Streamlit, Gradio, Vercel, Modal    |
  | Testing            | Unit tests for chains, regression testing     |
  | Safety & Guardrails| NVIDIA NeMo Guardrails, Llama Guard           |

- **MLOps vs LLMOps**:
  - LLMs are non-deterministic → traditional metrics don’t apply directly

---

### 2.7 Miscellaneous Topics

- **Memory Types**:
  - ConversationBufferMemory
  - ConversationSummaryMemory
  - Entity Memory
  - VectorStore Retriever Memory

- **Multimodal LLMs**:
  - GPT-4o, Claude-3, LLaVA, Gemini

- **Function Calling / Tool Calling**
- **Structured Output** (JSON mode, PydanticOutputParser)
- **Caching** (In-memory, Redis, SQLite)
- **Async Support** in LangChain
- **Streaming Responses**
- **Local LLMs** (Ollama, LM Studio, llama.cpp)
- **Cost Optimization Techniques**
- **Security & Privacy** (Data leakage prevention)

---

## 3. Recommended Learning Path (User Perspective)

1. **Basics** – LangChain setup + simple chains
2. **Prompt Engineering** – Master prompting techniques
3. **RAG** – Build your first RAG application
4. **Memory & Chatbots** – Add conversation history
5. **Agents** – Build tool-using agents
6. **Advanced** – LangGraph, Evaluation, LLMOps
7. **Production** – Deployment, monitoring, cost control

---

**Happy Building!**  
Master the User Perspective first — it gives you immediate results and strong intuition before diving deeper into the Builder side.

You can now combine both perspectives for a complete understanding of Generative AI.