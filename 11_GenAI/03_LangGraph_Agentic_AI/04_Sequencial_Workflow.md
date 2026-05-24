> # Seting up things:
### Create environment and Install Dependencies

```shell
# Activate Environment:
python -m venv myenv
myenv\Scripts\activate

# Install LangGraph, LangChain:
pip install langgraph
pip install langchain
pip install langchain_openai
pip install dotenv
```

### Test the installations:
```python
from langgraph.graph import StateGraph
```

### 1. First WorkFlow
```python
from langgraph.graph import StateGraph, START, END
from typing import TypedDict

# define state
class BMIState(TypedDict):
    weight_kg: float
    height_m: float
    bmi: float
    category: str

def calculate_bmi(state: BMIState) -> BMIState:
    weight = state['weight_kg']
    height = state['height_m']
    bmi = weight/(height**2)
    state['bmi'] = round(bmi, 2)
    return state

def label_bmi(state: BMIState) -> BMIState:
    bmi = state['bmi']
    if bmi < 18.5:
        state["category"] = "Underweight"
    elif 18.5 <= bmi < 25:
        state["category"] = "Normal"
    elif 25 <= bmi < 30:
        state["category"] = "Overweight"
    else:
        state["category"] = "Obese"
    return state

# define your graph
graph = StateGraph(BMIState)

# add nodes to your graph
graph.add_node('calculate_bmi', calculate_bmi)
graph.add_node('label_bmi', label_bmi)

# add edges to your graph
graph.add_edge(START, 'calculate_bmi')
graph.add_edge('calculate_bmi', 'label_bmi')
graph.add_edge('label_bmi', END)

# compile the graph
workflow = graph.compile()

# execute the graph
intial_state = {'weight_kg':80, 'height_m':1.73}
final_state = workflow.invoke(intial_state)
print(final_state)

# Print your visual graph
from IPython.display import Image
Image(workflow.get_graph().draw_mermaid_png())
```

### 2. Simple LLM Based Workflow

```python
from langgraph.graph import StateGraph, START, END
from langchain_openai import ChatOpenAI
from typing import TypedDict
from dotenv import load_dotenv

load_dotenv()
model = ChatOpenAI()

# create a state
class LLMState(TypedDict):
    question: str
    answer: str

def llm_qa(state: LLMState) -> LLMState:
    # extract the question from state
    question = state['question']
    # form a prompt
    prompt = f'Answer the following question {question}'
    # ask that question to the LLM
    answer = model.invoke(prompt).content
    # update the answer in the state
    state['answer'] = answer
    return state

# create our graph
graph = StateGraph(LLMState)

# add nodes
graph.add_node('llm_qa', llm_qa)

# add edges
graph.add_edge(START, 'llm_qa')
graph.add_edge('llm_qa', END)

# compile
workflow = graph.compile()

# execute
intial_state = {'question': 'How far is moon from the earth?'}
final_state = workflow.invoke(intial_state)
print(final_state['answer'])

# Directly also we can invoke like this:
model.invoke('How far is moon from the earth?').content
```

### 3. Prompt Chaining
```python
from langgraph.graph import StateGraph, START, END
from langchain_openai import ChatOpenAI
from typing import TypedDict
from dotenv import load_dotenv

load_dotenv()
model = ChatOpenAI()

class BlogState(TypedDict):
    title: str
    outline: str
    content: str

def create_outline(state: BlogState) -> BlogState:
    # fetch title
    title = state['title']

    # call llm gen outline
    prompt = f'Generate a detailed outline for a blog on the topic - {title}'
    outline = model.invoke(prompt).content

    # update state
    state['outline'] = outline
    return state

def create_blog(state: BlogState) -> BlogState:
    title = state['title']
    outline = state['outline']
    prompt = f'Write a detailed blog on the title - {title} using the follwing outline \n {outline}'
    content = model.invoke(prompt).content
    state['content'] = content
    return state


graph = StateGraph(BlogState)
# nodes
graph.add_node('create_outline', create_outline)
graph.add_node('create_blog', create_blog)
# edges
graph.add_edge(START, 'create_outline')
graph.add_edge('create_outline', 'create_blog')
graph.add_edge('create_blog', END)
workflow = graph.compile()
# workflow   ## prints the workflow.

intial_state = {'title': 'Rise of AI in India'}
final_state = workflow.invoke(intial_state)
print(final_state)

# Check the Outline here:
print(final_state['outline'])

# Check the content here:
print(final_state['content'])
```