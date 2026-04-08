```markdown
# LangChain Code Examples - CampusX Playlist (Updated)

**Playlist**: [Generative AI using LangChain - CampusX](https://www.youtube.com/watch?v=pSVk-5WemQ0&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0)

**Repositories Covered**:
- **Models**: https://github.com/campusx-official/langchain-models  
  (Covers LLMs, Chat Models, and Embedding Models)
- **Prompts**: https://github.com/campusx-official/langchain-prompts
- **Structured Output**: https://github.com/campusx-official/langchain-structured-output

All important code examples from these repositories are organized below with clear headings, file names, and explanations.  
These files align with the early videos of the playlist (Models → Prompts → Structured Output).

---

## 1. Models Repository (https://github.com/campusx-official/langchain-models)

### 1.1 1.LLMs / 1_llm_demo.py

```python
from langchain_openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

# Using legacy completion style LLM
llm = OpenAI(model='gpt-3.5-turbo-instruct')

result = llm.invoke("What is the capital of India?")

print(result)
```

### 1.2 2.ChatModels (Typical Chat Model Examples)

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

### 1.3 3.EmbeddingModels (Embedding Demo)

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

---

## 2. Prompts Repository (https://github.com/campusx-official/langchain-prompts)

### 2.1 prompt_template.py

```python
from langchain_core.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv

load_dotenv()

model = ChatOpenAI()

template = PromptTemplate(
    template='Greet this person in 5 languages. The name of the person is {name}',
    input_variables=['name']
)

prompt = template.invoke({'name': 'Nitish'})
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

prompt = chat_template.invoke({'domain': 'cricket', 'topic': 'Dusra'})
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
print(result.content)
```

### 2.4 chatbot.py (Simple Interactive Chatbot)

```python
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from dotenv import load_dotenv

load_dotenv()

model = ChatOpenAI()
chat_history = [SystemMessage(content='You are a helpful AI assistant')]

while True:
    user_input = input('You: ')
    if user_input.lower() == 'exit':
        break
    chat_history.append(HumanMessage(content=user_input))
    result = model.invoke(chat_history)
    chat_history.append(AIMessage(content=result.content))
    print("AI:", result.content)
```

### 2.5 temperature.py

```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv

load_dotenv()

model = ChatOpenAI(model='gpt-4o-mini', temperature=1.5)
result = model.invoke("Write a 5 line poem on cricket")
print(result.content)
```

### 2.6 prompt_generator.py (Advanced Template for Research Summary)

```python
from langchain_core.prompts import PromptTemplate

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
    input_variables=['paper_input', 'style_input', 'length_input']
)

template.save('template.json')
```

### 2.7 prompt_ui.py (Streamlit UI for Research Tool)

```python
import streamlit as st
from langchain_openai import ChatOpenAI
from langchain_core.prompts import load_prompt
from dotenv import load_dotenv

load_dotenv()
model = ChatOpenAI()

st.header('Research Paper Summarizer Tool')

paper_input = st.selectbox("Select Research Paper Name", [
    "Attention Is All You Need",
    "BERT: Pre-training of Deep Bidirectional Transformers",
    "GPT-3: Language Models are Few-Shot Learners"
])

style_input = st.selectbox("Select Explanation Style", [
    "Beginner-Friendly", "Technical", "Code-Oriented", "Mathematical"
])

length_input = st.selectbox("Select Explanation Length", [
    "Short (1-2 paragraphs)", "Medium (3-5 paragraphs)", "Long (detailed explanation)"
])

template = load_prompt('template.json')

if st.button('Summarize'):
    chain = template | model
    result = chain.invoke({
        'paper_input': paper_input,
        'style_input': style_input,
        'length_input': length_input
    })
    st.write(result.content)
```

---

## 3. Structured Output Repository (https://github.com/campusx-official/langchain-structured-output)

### 3.1 pydantic_demo.py

```python
from pydantic import BaseModel, EmailStr, Field
from typing import Optional

class Student(BaseModel):
    name: str = 'nitish'
    age: Optional[int] = None
    email: EmailStr
    cgpa: float = Field(gt=0, lt=10, default=5, description='A decimal value representing the cgpa of the student')

# Example usage
new_student = {'age': 32, 'email': 'abc@gmail.com'}
student = Student(**new_student)
print(student.model_dump())
```

### 3.2 with_structured_output_pydantic.py (Main Structured Output Example)

```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
from pydantic import BaseModel, Field
from typing import Optional, Literal

load_dotenv()

model = ChatOpenAI(model="gpt-4o-mini")

class Review(BaseModel):
    key_themes: list[str] = Field(description="Write down all the key themes discussed in the review in a list")
    summary: str = Field(description="A brief summary of the review")
    sentiment: Literal["pos", "neg"] = Field(description="Return sentiment of the review either positive or negative")
    pros: Optional[list[str]] = Field(default=None, description="Write down all the pros inside a list")
    cons: Optional[list[str]] = Field(default=None, description="Write down all the cons inside a list")
    name: Optional[str] = Field(default=None, description="Write the name of the reviewer")

structured_model = model.with_structured_output(Review)

review_text = """I recently upgraded to the Samsung Galaxy S24 Ultra..."""  # (paste full review from video/repo)

result = structured_model.invoke(review_text)
print(result)
```

### 3.3 Other Structured Output Variants

**Using TypedDict** or **JSON Schema** follows a similar pattern with `model.with_structured_output(schema)`.

---

**Setup Instructions**:
1. Create a `.env` file in the project root with your API keys:
   ```
   OPENAI_API_KEY=your_key_here
   ```
2. Install dependencies:
   ```bash
   pip install langchain langchain-openai langchain-huggingface pydantic streamlit python-dotenv
   ```
3. Run any `.py` file using `python filename.py`

**Tips**:
- Use `ChatOpenAI` for most modern examples instead of legacy `OpenAI`.
- Always load environment variables with `load_dotenv()`.
- These examples form the foundation for Chains, Memory, RAG, and Agents in later videos.

**Happy Learning!**  
Add your own experiments and video timestamps next to each section as you watch the playlist.

You can now copy this entire Markdown content into a file named `langchain_campusx_code_examples.md`.
```