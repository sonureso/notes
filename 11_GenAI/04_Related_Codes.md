```markdown
# LangChain Code Examples - CampusX Playlist

**Repositories Covered**:
- https://github.com/campusx-official/langchain-models (LLMs demo)
- https://github.com/campusx-official/langchain-prompts (Prompts)
- https://github.com/campusx-official/langchain-structured-output (Structured Output)
```

### 1.1 LLMs / 1_llm_demo.py

```python
from langchain_openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

# Using legacy completion style LLM
llm = OpenAI(model='gpt-3.5-turbo-instruct')

result = llm.invoke("What is the capital of India?")

print(result)
```

### 1.2 ChatModels (Typical Chat Model Examples)

**Basic Chat Model Usage**
```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
from langchain_core.messages import HumanMessage, SystemMessage

load_dotenv()

model = ChatOpenAI(model="gpt-4o-mini", temperature=0.7)

messages = [
    SystemMessage(content="You are a helpful assistant."),
    HumanMessage(content="What is LangChain?")
]

result = model.invoke(messages)
print(result.content)
```

### 1.3 EmbeddingModels (Embedding Demo)

```python
from langchain_openai import OpenAIEmbeddings
from langchain_huggingface import HuggingFaceEmbeddings
from dotenv import load_dotenv

load_dotenv()

# Closed-source
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")

# Open-source alternative
embeddings_hf = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

text = "LangChain is a framework for building LLM applications."
vector = embeddings.embed_query(text)

print(len(vector))  # Dimension of embedding vector
print(vector[:5])   # First 5 values
```


## 2. Prompts Repository

### 2.1 prompt_template.py

```python
from langchain_core.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
load_dotenv()
model = ChatOpenAI()
# detailed way
template2 = PromptTemplate(
    template='Greet this person in 5 languages. The name of the person is {name}',
    input_variables=['name']
)
# fill the values of the placeholders
prompt = template2.invoke({'name':'nitish'})
result = model.invoke(prompt)
print(result.content)
```

### 2.2 chat_prompt_template.py

```python
from langchain_core.prompts import ChatPromptTemplate
chat_template = ChatPromptTemplate([
    ('system', 'You are a helpful {domain} expert'),
    ('human', 'Explain in simple terms, what is {topic}')
])
prompt = chat_template.invoke({'domain':'cricket','topic':'Dusra'})
print(prompt)
```

### 2.3 messages.py

```python
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv

load_dotenv()

model = ChatOpenAI()

messages = [
    SystemMessage(content='You are a helpful assistant'),
    HumanMessage(content='Tell me about LangChain')
]

result = model.invoke(messages)

messages.append(AIMessage(content=result.content))

print(messages)
```

### 2.4 chatbot.py

```python
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from dotenv import load_dotenv
load_dotenv()
model = ChatOpenAI()
chat_history = [ SystemMessage(content='You are a helpful AI assistant') ]
while True:
    user_input = input('You: ')
    chat_history.append(HumanMessage(content=user_input))
    if user_input == 'exit':
        break
    result = model.invoke(chat_history)
    chat_history.append(AIMessage(content=result.content))
    print("AI: ",result.content)
    print(chat_history)
```

### 2.5 temperature.py

```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
load_dotenv()
model = ChatOpenAI(model='gpt-4', temperature=1.5)
result = model.invoke("Write a 5 line poem on cricket")
print(result.content)
```

### 2.6 prompt_generator.py

```python
from langchain_core.prompts import PromptTemplate # template 
template = PromptTemplate(
    template=""" 
Please summarize the research paper titled "{paper_input}" with the following specifications: 
Explanation Style: {style_input} 
Explanation Length: {length_input} 

1. Mathematical Details: 
- Include relevant mathematical equations if present in the paper. 
- Explain the mathematical concepts using simple, intuitive code snippets where applicable. 

2. Analogies: 
- Use relatable analogies to simplify complex ideas. 

If certain information is not available in the paper, respond with: "Insufficient information available" instead of guessing. 

Ensure the summary is clear, accurate, and aligned with the provided style and length. 
""", 
    input_variables=['paper_input', 'style_input','length_input'], 
    validate_template=True 
) 
template.save('template.json')
```

### 2.7 prompt_ui.py (Streamlit UI)

```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
import streamlit as st
from langchain_core.prompts import PromptTemplate,load_prompt

load_dotenv()
model = ChatOpenAI()

st.header('Reasearch Tool')

paper_input = st.selectbox( 
    "Select Research Paper Name", 
    ["Attention Is All You Need", 
     "BERT: Pre-training of Deep Bidirectional Transformers", 
     "GPT-3: Language Models are Few-Shot Learners", 
     "Diffusion Models Beat GANs on Image Synthesis"] 
)

style_input = st.selectbox( 
    "Select Explanation Style", 
    ["Beginner-Friendly", "Technical", "Code-Oriented", "Mathematical"] 
) 

length_input = st.selectbox( 
    "Select Explanation Length", 
    ["Short (1-2 paragraphs)", "Medium (3-5 paragraphs)", "Long (detailed explanation)"] 
)

template = load_prompt('template.json')

if st.button('Summarize'):
    chain = template | model
    result = chain.invoke({
        'paper_input':paper_input,
        'style_input':style_input,
        'length_input':length_input
    })
    st.write(result.content)
```

### 2.8 message_placeholder.py

```python
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder 

# chat template 
chat_template = ChatPromptTemplate([
    ('system','You are a helpful customer support agent'), 
    MessagesPlaceholder(variable_name='chat_history'), 
    ('human','{query}') 
])

chat_history = []

# load chat history 
with open('chat_history.txt') as f: 
    chat_history.extend(f.readlines()) 

print(chat_history)

# create prompt 
prompt = chat_template.invoke({'chat_history':chat_history, 'query':'Where is my refund'}) 
print(prompt)
```

---

## 3. Structured Output Repository

### 3.1 pydantic_demo.py (Pydantic Basics)

```python
from pydantic import BaseModel, EmailStr, Field 
from typing import Optional 

class Student(BaseModel):
    name: str = 'nitish'
    age: Optional[int] = None
    email: EmailStr
    cgpa: float = Field(gt=0, lt=10, default=5, description='A decimal value representing the cgpa of the student')

new_student = {'age':'32', 'email':'abc@gmail.com'}
student = Student(**new_student)
student_dict = dict(student)
print(student_dict['age'])
student_json = student.model_dump_json()
```

### 3.2 typeddict_demo.py (TypedDict Basics)

```python
from typing import TypedDict

class Person(TypedDict):
    name: str
    age: int

new_person: Person = {'name':'nitish', 'age':'35'}
print(new_person)
```

### 3.3 with_structured_output_pydantic.py

```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
from typing import TypedDict, Annotated, Optional, Literal
from pydantic import BaseModel, Field

load_dotenv()

model = ChatOpenAI()

# schema
class Review(BaseModel):

    key_themes: list[str] = Field(description="Write down all the key themes discussed in the review in a list")
    summary: str = Field(description="A brief summary of the review")
    sentiment: Literal["pos", "neg"] = Field(description="Return sentiment of the review either negative, positive or neutral")
    pros: Optional[list[str]] = Field(default=None, description="Write down all the pros inside a list")
    cons: Optional[list[str]] = Field(default=None, description="Write down all the cons inside a list")
    name: Optional[str] = Field(default=None, description="Write the name of the reviewer")
    

structured_model = model.with_structured_output(Review)

result = structured_model.invoke("""I recently upgraded to the Samsung Galaxy S24 Ultra, and I must say, it’s an absolute powerhouse! ... [full review text as in repo]""")

print(result)
```

### 3.4 with_structured_output_llama.py (Using Local/Open-source via HuggingFace)

```python
from dotenv import load_dotenv
from typing import Optional, Literal
from pydantic import BaseModel, Field
from langchain_huggingface import ChatHuggingFace, HuggingFaceEndpoint

load_dotenv()

llm = HuggingFaceEndpoint(
    repo_id="TinyLlama/TinyLlama-1.1B-Chat-v1.0",
    task="text-generation"
)

model = ChatHuggingFace(llm=llm)

# schema (same as above)
class Review(BaseModel):

    key_themes: list[str] = Field(description="Write down all the key themes discussed in the review in a list")
    summary: str = Field(description="A brief summary of the review")
    sentiment: Literal["pos", "neg"] = Field(description="Return sentiment of the review either negative, positive or neutral")
    pros: Optional[list[str]] = Field(default=None, description="Write down all the pros inside a list")
    cons: Optional[list[str]] = Field(default=None, description="Write down all the cons inside a list")
    name: Optional[str] = Field(default=None, description="Write the name of the reviewer")
    

structured_model = model.with_structured_output(Review)

result = structured_model.invoke("""I recently upgraded to the Samsung Galaxy S24 Ultra... [same review]""")

print(result)
```

**Note**: Other structured output files (`with_structured_output_json.py`, `with_structured_output_typeddict.py`) follow similar patterns using JSON schema or TypedDict with `.with_structured_output()`.

---

**Usage Tips**:
- Create a `.env` file with your `OPENAI_API_KEY` (and other keys if needed).
- Install required packages: `langchain`, `langchain-openai`, `langchain-huggingface`, `pydantic`, `streamlit`, `python-dotenv`.
- Run files individually to understand each concept.

