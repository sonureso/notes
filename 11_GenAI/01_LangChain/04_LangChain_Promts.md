> # LangChain Prompts
- (langchain-prompts) https://github.com/campusx-official/langchain-prompts
- (Docs): https://reference.langchain.com/python/langchain-core/prompts
- Video Tutorial: https://www.youtube.com/watch?v=3TGqlQxpuU0&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=6

**LangChain Prompts**: Prompts are input instructions or queries given to a model to guide its output.

**Static Vs Dynamic Prompts**: Static prompts are fixed, unchanging instructions used for consistent tasks, while dynamic prompts are flexible, context-aware templates that update in real-time based on user input, data retrieval, or conversation history.

**Prompt Template**: Prompt Template is a reusable, structured way to generate prompts by combining a static string (the "recipe") with dynamic variable.

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
> # LangChain Messages
- SystemMessage 
- HumanMessage
- AIMessage

Below is the example code that uses these messages with chat history:

```python
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from dotenv import load_dotenv

load_dotenv()

model = ChatOpenAI()

chat_history = [
    SystemMessage(content='You are a helpful AI assistant')
]

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

> # PromptTemplate Vs ChatPromptTemplate
PromptTemplate and ChatPromptTemplate in LangChain both create dynamic prompts but serve different model types. PromptTemplate handles plain string inputs for base LLMs, while ChatPromptTemplate structures messages with roles (System, Human, AI) specifically for conversational Chat Models, allowing for more precise control and structured, role-based interaction.

If we want to make a prompt dynamic:
- For a single message:   We use __PromptTemplate__.
- For a list of messages: We use __ChatPromptTemplate__.
```python
from langchain_core.prompts import ChatPromptTemplate
chat_template = ChatPromptTemplate([
    ('system', 'You are a helpful {domain} expert'),
    ('human', 'Explain in simple terms, what is {topic}')
])
prompt = chat_template.invoke({'domain':'cricket','topic':'batting'})
print(prompt)
```

### Message Placeholder
In LangChain, a MessagesPlaceholder is a specialized prompt template component used to inject a dynamic list of chat messages (such as conversation history) into a specific position within a larger prompt.

Below code gives an idea, how **message placeholders** are inserted in between of promts to give the idea of chat history to LLMs:
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


