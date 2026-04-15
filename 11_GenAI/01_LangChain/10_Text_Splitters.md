> # Text Splitters
- (GitHub) https://github.com/campusx-official/langchain-text-splitters
- Docs: https://docs.langchain.com/oss/python/integrations/splitters
- Video Tutorial: https://www.youtube.com/watch?v=SEWS9P4ODmc&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=13

Text Splitting is the process of breaking large chunk of texts (like articles, PDFs, webpages, or books) into smaller, manageable pieces (chunks) that an LLM can handle effectively. 

Text splitting can be perfomed in various ways:
1. Length Based Text Splitting
2. Text Structure Based Text Splitting
3. Document Structure Based Text Splitting
4. Semantic Meaning Based Text Splitting

### 1. Length Based Text Splitting
```python
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader

loader = PyPDFLoader('dl-curriculum.pdf')
docs = loader.load()
splitter = CharacterTextSplitter(
    chunk_size=200,
    chunk_overlap=0,
    separator=''
)

result = splitter.split_documents(docs)
print(result[1].page_content)
```

### 2. Text Structure Based Text Splitting
This splitting technique first splits bases on paragraph. If chunk is bigger then it splits further based on words and then chars.
```python
from langchain.text_splitter import RecursiveCharacterTextSplitter
text = """
Space exploration has led to incredible scientific discoveries. From landing on the Moon to exploring Mars, humanity continues to push the boundaries of what’s possible beyond our planet.

These missions have not only expanded our knowledge of the universe but have also contributed to advancements in technology here on Earth. Satellite communications, GPS, and even certain medical imaging techniques trace their roots back to innovations driven by space programs.
"""
# Initialize the splitter
splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,
    chunk_overlap=0,
)

# Perform the split
chunks = splitter.split_text(text)
print(len(chunks))
print(chunks)
```

### 3. Document Structure Based Text Splitting

**SPLITTING PYTHON CODE AS TEXT**:
```python
from langchain.text_splitter import RecursiveCharacterTextSplitter,Language

text = """
class Student:
    def __init__(self, name, age, grade):
        self.name = name
        self.age = age
        self.grade = grade  # Grade is a float (like 8.5 or 9.2)

    def get_details(self):
        return self.name"

    def is_passing(self):
        return self.grade >= 6.0

# Example usage
student1 = Student("Aarav", 20, 8.2)
print(student1.get_details())

if student1.is_passing():
    print("The student is passing.")
else:
    print("The student is not passing.")

"""
# Initialize the splitter
splitter = RecursiveCharacterTextSplitter.from_language(
    language=Language.PYTHON,
    chunk_size=300,
    chunk_overlap=0,
)
# Perform the split
chunks = splitter.split_text(text)

print(len(chunks))
print(chunks[1])
```

**SPLITTING MARKDOWN TEXT**
```python
from langchain.text_splitter import RecursiveCharacterTextSplitter,Language

text = """
# Project Name: Smart Student Tracker
A simple Python-based project to manage and track student data, including their grades, age, and academic status.

## Features
- Add new students with relevant info
- View student details
- Check if a student is passing
- Easily extendable class-based design

## 🛠 Tech Stack
- Python 3.10+
- No external dependencies

## Getting Started
1. Clone the repo  
   ```bash
   git clone https://github.com/your-username/student-tracker.git
"""
# Initialize the splitter
splitter = RecursiveCharacterTextSplitter.from_language(
    language=Language.MARKDOWN,
    chunk_size=200,
    chunk_overlap=0,
)

# Perform the split
chunks = splitter.split_text(text)

print(len(chunks))
print(chunks[0])
```

### 4. Semantic Meaning Based Text Splitting (Experimental)

```python
from langchain_experimental.text_splitter import SemanticChunker
from langchain_openai.embeddings import OpenAIEmbeddings
from dotenv import load_dotenv

load_dotenv()
text_splitter = SemanticChunker(
    OpenAIEmbeddings(), breakpoint_threshold_type="standard_deviation",
    breakpoint_threshold_amount=3
)

sample = """
Farmers were working hard in the fields, preparing the soil and planting seeds for the next season. The sun was bright, and the air smelled of earth and fresh grass. The Indian Premier League (IPL) is the biggest cricket league in the world. People all over the world watch the matches and cheer for their favourite teams.


Terrorism is a big danger to peace and safety. It causes harm to people and creates fear in cities and villages. When such attacks happen, they leave behind pain and sadness. To fight terrorism, we need strong laws, alert security forces, and support from people who care about peace and safety.
"""

docs = text_splitter.create_documents([sample])
print(len(docs))
print(docs)
```