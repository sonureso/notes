# Generative AI - Complete Notes (User Perspective + LangChain Fundamentals)

**Playlist**: [Generative AI using LangChain - CampusX](https://www.youtube.com/watch?v=pSVk-5WemQ0&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0)

**Focus**: 
- User Perspective of Generative AI
- Deep dive into LangChain Fundamentals (starting from Video 3)

These notes combine high-level User Perspective concepts with practical LangChain implementation details, including code examples for both **closed-source** and **open-source** LLMs.

---

## 1. Two Perspectives of Generative AI

### 1.1 User Perspective (This Document)
Focuses on **leveraging** existing LLMs to build useful applications quickly.
- Building apps with LangChain
- Prompt Engineering
- RAG
- Agents
- Memory, Chains, Indexes
- LLMOps and production practices

**Goal**: Create intelligent, reliable LLM-powered applications with minimal infrastructure.

### 1.2 Builder Perspective (Separate Notes)
Focuses on core technology:
- Transformers, Pretraining, Optimizers, Fine-Tuning, Evaluation, Deployment.

---

## 2. User Perspective - Core Topics Overview

### 2.1 Building Basic LLM Apps using LangChain
- Framework for composing LLMs with prompts, data, tools, and memory.
- Modern approach uses **LCEL** (LangChain Expression Language) with `|` operator.

### 2.2 Prompt Engineering
- Core skill for getting reliable outputs from LLMs.
- Techniques: Zero-shot, Few-shot, Chain-of-Thought, ReAct, Role prompting.

### 2.3 Retrieval Augmented Generation (RAG)
- Solves hallucination and knowledge cutoff by adding external data retrieval.

### 2.4 Fine-Tuning (User View)
- When prompt engineering + RAG is insufficient.
- Popular methods: LoRA, QLoRA using tools like Unsloth or Axolotl.

### 2.5 Agents
- LLMs that can reason and use tools autonomously.

### 2.6 LLMOps
- Observability, evaluation, monitoring, deployment, and cost control.

### 2.7 Miscellaneous
- Memory types, structured output, streaming, local LLMs, security.

---

## 3. LangChain Fundamentals - Deep Dive

**Video Reference**: Starting from Video 3 onwards (Models, Prompts, Chains, Memory, Indexes, Agents).

### 3.1 Models (Language Models & Embedding Models)

#### 3.1.1 Language Models (LLMs / Chat Models)

**Closed-Source Examples**
```python
from langchain_openai import ChatOpenAI
from langchain_groq import ChatGroq

llm_openai = ChatOpenAI(
    model="gpt-4o-mini",
    temperature=0.7,
    max_tokens=512
)

llm_groq = ChatGroq(
    model="llama-3.1-70b-versatile",
    temperature=0.7
)
```

**Open-Source Examples**
```python
from langchain_ollama import ChatOllama
from langchain_huggingface import HuggingFaceEndpoint

llm_ollama = ChatOllama(
    model="llama3.2",        # or mistral, gemma2, phi3
    temperature=0.7
)

llm_hf = HuggingFaceEndpoint(
    repo_id="meta-llama/Llama-3.1-8B-Instruct"
)
```
Key Parameters:temperature: 0 = deterministic, higher = more creative
Use Chat models for conversational applications.

**3.1.2 Embedding Models**
#### Used for converting text into dense vector representations for semantic search and retrieval (core component of RAG).
```python
from langchain_openai import OpenAIEmbeddings
from langchain_huggingface import HuggingFaceEmbeddings

# Closed-Source Embedding Model
embeddings_openai = OpenAIEmbeddings(model="text-embedding-3-small")

# Open-Source Embedding Model (local & free)
embeddings_hf = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2"
    # Other good options: "BAAI/bge-small-en-v1.5", "thenlper/gte-base"
)

# Uses:
text = "What is LangChain?"
vector = embeddings_openai.embed_query(text)   # Returns a list of floats
print(len(vector))  # e.g., 1536
```

#### Key Points about Embedding Models:
- Embeddings turn variable-length text into fixed-size vectors (e.g., 1536 dimensions for text-embedding-3-small).
- Higher dimension usually means better quality but slower and more expensive.
- Choose model based on task: OpenAI models are strong but cost money; open-source models like MiniLM or BGE run locally and are free.
- Always use the same embedding model for indexing documents and for querying.

**3.2 Prompts**
```python
from langchain_core.prompts import ChatPromptTemplate

chat_prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant specialized in {domain}."),
    ("human", "Explain {topic} in simple terms.")
])

formatted = chat_prompt.format_messages(domain="physics", topic="quantum entanglement")
```
##### Best Practices:
- Use clear role prompting.
- Specify desired output format (JSON, bullet points, etc.).
- Use delimiters and few-shot examples when needed.

**3.3 Chains (LCEL - LangChain Expression Language)**
```python
from langchain_core.output_parsers import StrOutputParser
chain = chat_prompt | llm_openai | StrOutputParser()
response = chain.invoke({"domain": "AI", "topic": "Transformers"})
```
##### Useful Methods:
- .invoke() – single input
- .batch() – multiple inputs
- .stream() – streaming response
- .ainvoke() – async version

**3.4 Memory**
```python
from langchain.memory import ConversationBufferMemory, ConversationSummaryMemory
memory = ConversationBufferMemory(return_messages=True)
summary_memory = ConversationSummaryMemory(llm=llm_openai)
```
##### Modern Approach:
- Use RunnableWithMessageHistory with ChatMessageHistory for persistent conversations.

**3.5 Indexes (Retrieval & Vector Stores) - Foundation of RAG**
```python
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.vectorstores import Chroma

# 1. Load & Split
loader = PyPDFLoader("document.pdf")
docs = loader.load()
splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
chunks = splitter.split_documents(docs)

# 2. Create Vector Store
vectorstore = Chroma.from_documents(chunks, embedding=embeddings_openai)

# 3. Retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
```
**3.6 Agents**
```python
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain.tools import tool

@tool
def search_web(query: str) -> str:
    """Search the web for up-to-date information."""
    # Implement search logic here
    return "Search results for: " + query

tools = [search_web]

agent = create_tool_calling_agent(llm=llm_openai, tools=tools, prompt=agent_prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

response = agent_executor.invoke({"input": "What is the latest news about xAI?"})
```
##### Agent Types:
- Tool-calling agent (recommended for modern models)
- ReAct agent
- Use LangGraph for advanced stateful workflows.

