> # RAG
- (GitHub) https://github.com/campusx-official/langchain-document-loaders/
- Docs: https://docs.langchain.com/oss/python/integrations/document_loaders
- Video Tutorial: https://www.youtube.com/watch?v=bL92ALSZ2Cg&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=12

RAG is a technique that combines information retrieval with language generation, where a model retrieves relevant documents from a knowledge base and then uses them as context to generate accurate and grounded responses. 

**Benefits of RAG**: 
- Use of up-to-date information.
- Better privacy
- No limit of document size

**Important Components** of RAG are:
1. Document Loaders
2. Text Splitters
3. Vector Databases
4. Retrievers

> # Document Loaders
Document Loaders are components in LangChain used to load data from various sources into a standardized format (Usually as document objects) which then can be used for chunking, embedding, retrieval, and generation.

### 1. TextLoader
TextLoader is a simple and commonly use document loader in LangChain that reads plain text(.txt) files and converts them into LangChain Document Obeject.
```python
from langchain_community.document_loaders import TextLoader
from langchain_openai import ChatOpenAI
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
from dotenv import load_dotenv

load_dotenv()
model = ChatOpenAI()

prompt = PromptTemplate(
    template='Write a summary for the following poem - \n {poem}',
    input_variables=['poem']
)

parser = StrOutputParser()
loader = TextLoader('cricket.txt', encoding='utf-8')
docs = loader.load()

print(type(docs)) # -> list
print(len(docs))  # -> 1
print(docs[0].page_content) # -> content of the file
print(docs[0].metadata)     # -> metadata about the file
chain = prompt | model | parser
print(chain.invoke({'poem':docs[0].page_content})) 

```

### 2. PyPDFLoader
PyPDFLoader is a document loader in LangChain used to load PDF files and convert each page into a document object.
```python
from langchain_community.document_loaders import PyPDFLoader

loader = PyPDFLoader('dl-curriculum.pdf')
docs = loader.load()
print(len(docs))             # -> number of pages in pdf
print(docs[0].page_content)  # -> content of first page.
print(docs[1].metadata)      # -> metadata of the document object at index 1.
```
**Other PDF Loaders**:
- PyPDFLoader: this is mainly for textual PDF files.
- PDFPlumberLoader: to handle PDF having tabular/columns wise data.
- UnstructuredPDFLoader / AmazonTextractPDFLoader: to handle image scanner PDF files.
- PyMuPDFLoader: Need Layout and Image data.
- UnstructuredPDFLoader: Need best structure extraction.

### 3. DirectoryLoader & lazy_load
**load():** This method fetches all data immediately and stores it in your RAM. If you are loading a 500MB PDF or thousands of small files, your application might crash due to memory limits.

**lazy_load():** Instead of a list, it returns a generator. The data is only fetched when you actually iterate over it (e.g., in a for loop). This allows you to stream documents directly into a vector store or processing pipeline without filling up your RAM
```python
from langchain_community.document_loaders import DirectoryLoader, PyPDFLoader
loader = DirectoryLoader(
    path='books',
    glob='*.pdf',
    loader_cls=PyPDFLoader
)
docs = loader.lazy_load() # this return an iterable and avoid loading all in one go.
for document in docs:
    print(document.metadata)
```
### 4. WebBaseLoader
WebBaseLoader is used to load and extract text content from web pages (URLs). It uses BeautifulSoup.
It read one URL Webpage as one document object.
```python
from langchain_community.document_loaders import WebBaseLoader
from langchain_openai import ChatOpenAI
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
from dotenv import load_dotenv

load_dotenv()
model = ChatOpenAI()
prompt = PromptTemplate(
    template='Answer the following question \n {question} from the following text - \n {text}',
    input_variables=['question','text']
)

parser = StrOutputParser()
url = 'https://www.flipkart.com/apple-macbook-air-m2-16-gb-256-gb-ssd-macos-sequoia-mc7x4hn-a/p/itmdc5308fa78421'
loader = WebBaseLoader(url)
docs = loader.load() # returns one document object | You can pass list if URLs also.

chain = prompt | model | parser
print(chain.invoke({'question':'What is the prodcut that we are talking about?', 'text':docs[0].page_content}))
```

### 5. CSVLoader
CSVLoader loads CSV Files into LangChain document objects - one object per row by default.

```python
from langchain_community.document_loaders import CSVLoader
loader = CSVLoader(file_path='Social_Network_Ads.csv')
docs = loader.load()
print(len(docs))  # -> number of rows = number of documents.
print(docs[1])
```