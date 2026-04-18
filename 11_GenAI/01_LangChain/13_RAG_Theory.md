> # 1. Retrieval Augmented Generation (RAG):
YouTube Video: https://www.youtube.com/watch?v=X0btK9X0Xnk&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=16

**Context**
LLMs Gives responses to the input query based on the **parameteric knowledge** they have been trained on. 

### 1.1 Problem with LLMs
**Problem with LLM**: LLMs have some problems when we are working with: 
- private data 
- recent data
- hallucination

### Solution 1: Fine Tuning
'Fine Tuning' the LLMs on the specific data is one solution but it is expensive and time consuming.

Fine tuning is the process of taking a pre-trained model and training it further on a specific dataset to adapt it to a particular task or domain. This allows the model to learn from the new data and improve its performance on that specific task.

This can be done in 2 ways:
1. Supervised Fine Tuning: In this method, the model is trained on a labeled dataset where the input data is paired with the correct output. The model learns to map the input to the output based on the provided examples.
2. Unsupervised Fine Tuning: In this method, the model is trained on an unlabeled dataset. The model learns to generate outputs based on the patterns and structures it identifies in the data without explicit guidance.

**Drawback of Fine Tuning:** Fine tuning can be computationally expensive and time-consuming, especially for large models. It may require significant resources and expertise to effectively fine-tune a model.

### Solution 2: In-context Learning
In-context learning is core capability of LLMs like GPT-3, GPt-4, Claude, Llama, where the model learns to solve a task purely by seeing examples in the prompt - without any parameter updates. This type of prompting is called __few-shot prompting.__ "In-context learning" is an emergent property of LLMs.

**What is an Emergent Property**: An emergent property is a behaviour or ability that suddenly appears in a system when it reaches a certain scale or complexity - even though it was not explicitly programmed.

**RAG:** Instead of doing few-shot prompting, if we give LLMs some context about the query, it can give better response. This is called Retrieval Augmented Generation (RAG). **RAG is a way to make language model smatter by giving it extra information at the time you ask your question.**

**FINAL SOLUTION**: So RAG is solving all the 3 problems of LLMs (private data, recent data, hallucination) without doing fine tuning. It is a way to make language model smarter by giving it extra information at the time you ask your question.

> # 2 RAG - How to implement it
To implement RAG, we need to follow these 4 steps:
1. Indexing
2. Retrieval
3. Augmentation
4. Generation
### 2.1 Indexing
Indexing is the process of preparing knowledge base so that it can be efficiently searched at query time. This steps consistes of below 4 sub-steps:
1. Document Ingestion: This is the process of collecting and organizing the documents that will be used as the knowledge base for RAG. You may be using various loaders like PyPDFLoader, TextLoader, CSVLoader, etc. to ingest documents into your system.
2. Text Chunking: Break large documents into small, semantically meaningful chunks. Ex: RecursiveCharacterTextSplitter, CharacterTextSplitter, etc.
3. Embedding Generation: Convert text chunks into vector representations (embeddings) using models like OpenAIEmbeddings, SentenceTransformerEmbeddings, InstructorEmbeddings, etc. These embeddings capture the semantic meaning of the text and allow for efficient similarity search.
4. Storage in a vector store: Store the vectors along with the original text + metadata in a vector database. Some popular vector databases are Pinecone, Weaviate, FAISS, etc.

### 2.2 Retrieval
Retrieval is the real-time process of finding relevant pieces of information from the indexed knowledge base based on the input query. This step involves:
STEP-1: query -> embedding vectors.
STEP-2: embedding vectors -> similarity search in vector database -> relevant chunks of text.
STEP-3: Rank the relevant chunks of text -> select top-k chunks of text -> CONTEXT.

### 2.3 Augmentation
Augmentation is the process of combining the retrieved context with the original query to create an enriched input for the language model. Basically, in this step, we combine QUERY + CONTEXT -> AUGMENTED QUERY.

### 2.4 Generation
Generation is the final step where the augmented query is fed into the language model to generate a response. The language model uses the additional context provided in the augmented query to produce a more accurate and relevant response to the user's original query.

## Summary:
1. RAG is a way to make language model smarter by giving it extra information at the time you ask your question.
2. RAG is solving all the 3 problems of LLMs (private data, recent data, hallucination) without doing fine tuning.
3. To implement RAG, we need to follow these 4 steps: Indexing, Retrieval, Augmentation, Generation.

> # 3. Evalucation of RAG
To evaluate the performance of a RAG system, we can use various metrics and methods. Some common evaluation approaches include:
1. Ragas: Ragas is a framework for evaluating the performance of RAG systems. It provides a set of metrics and tools to assess the quality of the generated responses based on relevance, coherence, and informativeness.
2. LangSmith: LangSmith is another evaluation framework that focuses on assessing the language generation capabilities of RAG systems. It evaluates the fluency, diversity, and creativity of the generated responses.
3. Human Evaluation: In addition to automated metrics, human evaluation is often used to assess the quality of RAG-generated responses. This involves having human evaluators rate the responses based on criteria such as relevance, coherence, and informativeness.

