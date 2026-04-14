> # Runnables in LangChain
- (Runnables) https://github.com/campusx-official/langchain-runnables
- (Nakli Setup): https://colab.research.google.com/drive/1P11hpAPtjr0oIiqQ5pNsdnMxmascdbBY?usp=sharing#scrollTo=WPyqRUB0G2Fl
- Docs: https://reference.langchain.com/python/langchain-core/runnables
- Video Tutorial: https://www.youtube.com/watch?v=u3b-W1NgYa4&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=10

**Runnables**: Runnable is a standard interface that turns components into modular, composable building blocks. It is the foundation of the LangChain Expression Language (LCEL), enabling you to chain prompts, models, and parsers using a uniform API.

Runnables can be categoried in two types:
1. **Task Specific Runnables:** foundational components that have been designed to implement the Runnable interface, allowing them to perform discrete, specialized actions within an LLM-powered application pipeline. Example: promptTemplate, ChatOpenAI, etc.
2. **Runnable Premitives:** runnable primitives are the core building blocks used to orchestrate data flow and logic within the LangChain Expression Language (LCEL). Example: RunnableSequence, RunnableParallel, etc

> # Runnable Premitives
### 1. RunnableSequence
RunnableSequence is the sequencial chain of runnables in LangChain that executes each step one after another, passing the output of one step as the input of next. 

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from dotenv import load_dotenv
from langchain.schema.runnable import RunnableSequence

load_dotenv()
prompt1 = PromptTemplate(
    template='Write a joke about {topic}',
    input_variables=['topic']
)

model = ChatOpenAI()
parser = StrOutputParser()
prompt2 = PromptTemplate(
    template='Explain the following joke - {text}',
    input_variables=['text']
)

chain = RunnableSequence(prompt1, model, parser, prompt2, model, parser)
print(chain.invoke({'topic':'AI'}))
```
### 2. RunnableParallel
RunnableParallel is the runnable premitive that allows multiple runnables to execute in parallel. Each runnable receives the same input and processes it independently, producting a dictionary of outputs.
```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from dotenv import load_dotenv
from langchain.schema.runnable import RunnableSequence, RunnableParallel

load_dotenv()

prompt1 = PromptTemplate(
    template='Generate a tweet about {topic}',
    input_variables=['topic']
)
prompt2 = PromptTemplate(
    template='Generate a Linkedin post about {topic}',
    input_variables=['topic']
)
model = ChatOpenAI()
parser = StrOutputParser()

parallel_chain = RunnableParallel({
    'tweet': RunnableSequence(prompt1, model, parser),
    'linkedin': RunnableSequence(prompt2, model, parser)
})
result = parallel_chain.invoke({'topic':'AI'})
print(result['tweet'])
print(result['linkedin'])

```
### 3. RunnablePassthrough
RunnablePassthrough is a special runnable primitive that simple returns the input as output without modifying it.

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from dotenv import load_dotenv
from langchain.schema.runnable import RunnableSequence, RunnableParallel, RunnablePassthrough

load_dotenv()

prompt1 = PromptTemplate(
    template='Write a joke about {topic}',
    input_variables=['topic']
)
model = ChatOpenAI()
parser = StrOutputParser()
prompt2 = PromptTemplate(
    template='Explain the following joke - {text}',
    input_variables=['text']
)
joke_gen_chain = RunnableSequence(prompt1, model, parser)
parallel_chain = RunnableParallel({
    'joke': RunnablePassthrough(),
    'explanation': RunnableSequence(prompt2, model, parser)
})
final_chain = RunnableSequence(joke_gen_chain, parallel_chain)
print(final_chain.invoke({'topic':'cricket'}))
```
### 4. RunnableLambda
RunnableLambda is a runnable primitive that allows you to apply custom python functions without an AI pipeline. It acts as a middleware between different AI components, enabling preprocessing, transformation, API Calls, filtering and post-processing in a LangChain workflow.

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from dotenv import load_dotenv
from langchain.schema.runnable import RunnableSequence, RunnableLambda, RunnablePassthrough, RunnableParallel

load_dotenv()
def word_count(text):
    return len(text.split())

prompt = PromptTemplate(
    template='Write a joke about {topic}',
    input_variables=['topic']
)
model = ChatOpenAI()
parser = StrOutputParser()
joke_gen_chain = RunnableSequence(prompt, model, parser)
parallel_chain = RunnableParallel({
    'joke': RunnablePassthrough(),
    'word_count': RunnableLambda(word_count)
})

final_chain = RunnableSequence(joke_gen_chain, parallel_chain)
result = final_chain.invoke({'topic':'AI'})
final_result = """{} \n word count - {}""".format(result['joke'], result['word_count'])
print(final_result)
```
### 5. RunnableBranch
RunnableBranch is a control flow component in LangChain that allows you to conditionally route input data to different chains or runnable based on custom logic.
```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from dotenv import load_dotenv
from langchain.schema.runnable import RunnableSequence, RunnableParallel, RunnablePassthrough, RunnableBranch, RunnableLambda

load_dotenv()
prompt1 = PromptTemplate(
    template='Write a detailed report on {topic}',
    input_variables=['topic']
)
prompt2 = PromptTemplate(
    template='Summarize the following text \n {text}',
    input_variables=['text']
)
model = ChatOpenAI()
parser = StrOutputParser()
report_gen_chain = prompt1 | model | parser
branch_chain = RunnableBranch(
    (lambda x: len(x.split())>300, prompt2 | model | parser),
    RunnablePassthrough()
)

final_chain = RunnableSequence(report_gen_chain, branch_chain)
print(final_chain.invoke({'topic':'Russia vs Ukraine'}))
```
> ### LCEL
LangChain Expression Language (LCEL) is a declarative syntax designed to simplify the composition of LangChain components into production-ready chains. It uses a minimalist "pipe" operator (|) to link prompts, models, and parsers, similar to Unix piping.


# Nakli Setup
This code will help in understanding how runnables invokes output of previous runnable and passes the output to next runnable component.

```python
from abc import ABC, abstractmethod
import random

class Runnable(ABC):
  @abstractmethod
  def invoke(input_data):
    pass

class NakliLLM(Runnable):
  def __init__(self):
    print('LLM created')

  def invoke(self, prompt):
    response_list = [
        'Delhi is the capital of India',
        'IPL is a cricket league',
        'AI stands for Artificial Intelligence'
    ]
    return {'response': random.choice(response_list)}

class NakliPromptTemplate(Runnable):
  def __init__(self, template, input_variables):
    self.template = template
    self.input_variables = input_variables

  def invoke(self, input_dict):
    return self.template.format(**input_dict)

class NakliStrOutputParser(Runnable):
  def __init__(self):
    pass
  def invoke(self, input_data):
    return input_data['response']

class RunnableConnector(Runnable):
  def __init__(self, runnable_list):
    self.runnable_list = runnable_list

  def invoke(self, input_data):
    for runnable in self.runnable_list:
      input_data = runnable.invoke(input_data)
    return input_data

# Let's see how this can be used using this Nakli Setup:
template = NakliPromptTemplate(
    template='Write a {length} poem about {topic}',
    input_variables=['length', 'topic']
)
llm = NakliLLM()
parser = NakliStrOutputParser()
chain = RunnableConnector([template, llm, parser])
chain.invoke({'length':'long', 'topic':'india'})
```

