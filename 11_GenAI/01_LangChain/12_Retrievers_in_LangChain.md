> # 1. Retrievers in LangChain
- Google Collab: https://colab.research.google.com/drive/1vuuIYmJeiRgFHsH-ibH_NUFjtdc5D9P6?usp=sharing
- Docs: https://docs.langchain.com/oss/python/integrations/retrievers
- Video Tutorial: https://www.youtube.com/watch?v=pJdMxwXBsk0&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=15

A retriever is a component is LangChain that fetches relevant documents from a data source in response to user's query. All retrievers in LangChain are runnables. 

### Types of retrievers
**On Data Source Basis** we have various retrievers like:
- wikipedia retriever
- Vector Store retriever
- Archive retriever

**On Search Strategy Basis** we have various retrievers like:
- MMR (Maximal Marginal Relevance) retriever
- Multi Query Retriever
- Contextual Compression retriever

> ## 1.1 Wikipedia Retriever
The Wikipedia retriever is a retriever that fetches relevant documents from Wikipedia in response to user query. It uses the Wikipedia API to fetch relevant documents from Wikipedia.

```python
import os
os.environ["OPENAI_API_KEY"] = "sk-proj-..."

!pip install langchain chromadb faiss-cpu openai tiktoken langchain_openai langchain-community wikipedia

# Wikipedia Retriever:
from langchain_community.retrievers import WikipediaRetriever

# Initialize the retriever (optional: set language and top_k)
retriever = WikipediaRetriever(top_k_results=2, lang="en")

query = "the geopolitical history of india and pakistan from the perspective of a chinese"
docs = retriever.invoke(query)

# Print retrieved content
for i, doc in enumerate(docs):
    print(f"\n--- Result {i+1} ---")
    print(f"Content:\n{doc.page_content}...")  # truncate for display
```

> ## 1.2 Vector Store Retriever
The Vector Store retriever is a retriever that fetches relevant documents from a vector store in response to user query. It uses the vector store to fetch relevant documents from the vector store.

```python
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document

# Step 1: Your source documents
documents = [
    Document(page_content="LangChain helps developers build LLM applications easily."),
    Document(page_content="Chroma is a vector database optimized for LLM-based search."),
    Document(page_content="Embeddings convert text into high-dimensional vectors."),
    Document(page_content="OpenAI provides powerful embedding models."),
]

# Step 2: Initialize embedding model
embedding_model = OpenAIEmbeddings()

# Step 3: Create Chroma vector store in memory
vectorstore = Chroma.from_documents(
    documents=documents,
    embedding=embedding_model,
    collection_name="my_collection"
)

# Step 4: Convert vectorstore into a retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 2})

query = "What is Chroma used for?"

# APPROACH 1: Using the retriever interface
results = retriever.invoke(query)
for i, doc in enumerate(results):
    print(f"\n--- Result {i+1} ---")
    print(doc.page_content)

# APPROACH 2: Directly using the vectorstore's similarity search
results = vectorstore.similarity_search(query, k=2)
for i, doc in enumerate(results):
    print(f"\n--- Result {i+1} ---")
    print(doc.page_content)
```

> ## 1.3 MMR Retriever
Problem: How can we pick results that are not only relevant but also different from each other.
Solution: MMR (Maximal Marginal Relevance) retriever.

About: The MMR (Maximal Marginal Relevance) algorithm is a search strategy that aims to balance relevance and diversity in the retrieved results. This rettrieval algorithm is designed to reduce the redundancy in the retrieved results while maintaining the high relevance to the query.

```python 
from langchain_community.vectorstores import FAISS
# Sample documents
docs = [
    Document(page_content="LangChain makes it easy to work with LLMs."),
    Document(page_content="LangChain is used to build LLM based applications."),
    Document(page_content="Chroma is used to store and search document embeddings."),
    Document(page_content="Embeddings are vector representations of text."),
    Document(page_content="MMR helps you get diverse results when doing similarity search."),
    Document(page_content="LangChain supports Chroma, FAISS, Pinecone, and more."),
]

# Initialize OpenAI embeddings
embedding_model = OpenAIEmbeddings()

# Step 2: Create the FAISS vector store from documents
vectorstore = FAISS.from_documents(
    documents=docs,
    embedding=embedding_model
)

# Enable MMR in the retriever
# lambda_mult controls the balance between relevance and diversity where 0 means only relevance and 1 means only diversity. A common choice is around 0.5 for a good balance.
retriever = vectorstore.as_retriever(
    search_type="mmr",                   # <-- This enables MMR
    search_kwargs={"k": 3, "lambda_mult": 0.5}  # k = top results, lambda_mult = relevance-diversity balance
)
query = "What is langchain?"
results = retriever.invoke(query)
for i, doc in enumerate(results):
    print(f"\n--- Result {i+1} ---")
    print(doc.page_content)
```

> ## 1.4 Multi Query Retriever:
Problem: Sometimes a single query may not capture all the nuances of what you are looking for, especially if the query is complex or ambiguous.
Solution: Multi Query Retriever.

About: The Multi Query Retriever is a retrieval strategy that generates multiple sub-queries from the original query and retrieves results for each sub-query. This approach can help capture different aspects of the original query and provide a more comprehensive set of results.

```python
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document
from langchain_openai import ChatOpenAI
from langchain.retrievers.multi_query import MultiQueryRetriever

# Relevant health & wellness documents
all_docs = [
    Document(page_content="Regular walking boosts heart health and can reduce symptoms of depression.", metadata={"source": "H1"}),
    Document(page_content="Consuming leafy greens and fruits helps detox the body and improve longevity.", metadata={"source": "H2"}),
    Document(page_content="Deep sleep is crucial for cellular repair and emotional regulation.", metadata={"source": "H3"}),
    Document(page_content="Mindfulness and controlled breathing lower cortisol and improve mental clarity.", metadata={"source": "H4"}),
    Document(page_content="Drinking sufficient water throughout the day helps maintain metabolism and energy.", metadata={"source": "H5"}),
    Document(page_content="The solar energy system in modern homes helps balance electricity demand.", metadata={"source": "I1"}),
    Document(page_content="Python balances readability with power, making it a popular system design language.", metadata={"source": "I2"}),
    Document(page_content="Photosynthesis enables plants to produce energy by converting sunlight.", metadata={"source": "I3"}),
    Document(page_content="The 2022 FIFA World Cup was held in Qatar and drew global energy and excitement.", metadata={"source": "I4"}),
    Document(page_content="Black holes bend spacetime and store immense gravitational energy.", metadata={"source": "I5"}),
]

# Initialize OpenAI embeddings
embedding_model = OpenAIEmbeddings()

# Create FAISS vector store
vectorstore = FAISS.from_documents(documents=all_docs, embedding=embedding_model)

# Create retrievers
similarity_retriever = vectorstore.as_retriever(search_type="similarity", search_kwargs={"k": 5})

multiquery_retriever = MultiQueryRetriever.from_llm(
    retriever=vectorstore.as_retriever(search_kwargs={"k": 5}),
    llm=ChatOpenAI(model="gpt-3.5-turbo")
)

# Query
query = "How to improve energy levels and maintain balance?"

# Retrieve results
similarity_results = similarity_retriever.invoke(query)
multiquery_results= multiquery_retriever.invoke(query)

for i, doc in enumerate(similarity_results):
    print(f"\n--- Result {i+1} ---")
    print(doc.page_content)

print("*"*150)

for i, doc in enumerate(multiquery_results):
    print(f"\n--- Result {i+1} ---")
    print(doc.page_content)
```

> ## 1.5 Contextual Compression Retriever:
Problem: When retrieving documents, sometimes the retrieved documents may contain a lot of irrelevant information that can overwhelm the user or the downstream LLM.
Solution: Contextual Compression Retriever.

About: The Contextual Compression Retriever is a retrieval strategy that compresses the retrieved documents by removing irrelevant information while preserving the context that is relevant to the query. This can help provide more concise and focused results to the user or the downstream LLM.

```python
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain.retrievers.contextual_compression import ContextualCompressionRetriever
from langchain.retrievers.document_compressors import LLMChainExtractor
from langchain_core.documents import Document

# Recreate the document objects from the previous data
docs = [
    Document(page_content=(
        """The Grand Canyon is one of the most visited natural wonders in the world.
        Photosynthesis is the process by which green plants convert sunlight into energy.
        Millions of tourists travel to see it every year. The rocks date back millions of years."""
    ), metadata={"source": "Doc1"}),

    Document(page_content=(
        """In medieval Europe, castles were built primarily for defense.
        The chlorophyll in plant cells captures sunlight during photosynthesis.
        Knights wore armor made of metal. Siege weapons were often used to breach castle walls."""
    ), metadata={"source": "Doc2"}),

    Document(page_content=(
        """Basketball was invented by Dr. James Naismith in the late 19th century.
        It was originally played with a soccer ball and peach baskets. NBA is now a global league."""
    ), metadata={"source": "Doc3"}),

    Document(page_content=(
        """The history of cinema began in the late 1800s. Silent films were the earliest form.
        Thomas Edison was among the pioneers. Photosynthesis does not occur in animal cells.
        Modern filmmaking involves complex CGI and sound design."""
    ), metadata={"source": "Doc4"})
]

# Create a FAISS vector store from the documents
embedding_model = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(docs, embedding_model)

base_retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

# Set up the compressor using an LLM
llm = ChatOpenAI(model="gpt-3.5-turbo")
compressor = LLMChainExtractor.from_llm(llm)

# Create the contextual compression retriever
compression_retriever = ContextualCompressionRetriever(
    base_retriever=base_retriever,
    base_compressor=compressor
)

# Query the retriever
query = "What is photosynthesis?"
compressed_results = compression_retriever.invoke(query)

for i, doc in enumerate(compressed_results):
    print(f"\n--- Result {i+1} ---")
    print(doc.page_content)
```

> ## Other retrievers in LangChain:
- Archive Retriever: https://docs.langchain.com/oss/python/integrations/retrievers
- Google Search Retriever: https://docs.langchain.com/oss/python/integrations/retrievers/google_search
- Bing Search Retriever: https://docs.langchain.com/oss/python/integrations/retrievers/bing_search
- DuckDuckGo Search Retriever: https://docs.langchain.com/oss/python/integrations/retrievers/duckduckgo_search
- BM25 Retriever: https://docs.langchain.com/oss/python/integrations/retrievers/bm25
- ParentDocumentRetriever: https://docs.langchain.com/oss/python/integrations/retrievers/parent_document
- TimeWeightedRetriever: https://docs.langchain.com/oss/python/integrations/retrievers/time_weighted
- EnsambleRetriever: https://docs.langchain.com/oss/python/integrations/retrievers/ensemble
- ArxivRetriever: https://docs.langchain.com/oss/python/integrations/retrievers/arxiv

Summary: In this chapter, we explored various retrievers in LangChain that can be used to fetch relevant documents from different data sources. We covered the Wikipedia Retriever, Vector Store Retriever, MMR Retriever, Multi Query Retriever, and Contextual Compression Retriever. Each retriever has its own unique approach to fetching relevant documents based on the user query, and they can be used in different scenarios depending on the requirements of the application.

