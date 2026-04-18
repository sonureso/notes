> # 1. Tools Calling in LangChain

### Reference:
- Video: https://www.youtube.com/watch?v=EzYaFF7ahKw&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=19
- Doc: https://www.langchain.com/blog/tool-calling-with-langchain
- Colab: https://colab.research.google.com/drive/1-xMYU9ExZqoySEX-XHAvEaE17PCWvc9H?usp=sharing

### 01. Tool Binding
Tool Binding is the step where you register tools with a language model so that:
- The LLM knows what tools are available.
- It knows what each tools does (via description)
- It knows what input format to use (via schema)

```python
import os
os.environ["OPENAI_API_KEY"] = "sk-proj-..."

!pip install -q langchain-openai langchain-core requests

from langchain_openai import ChatOpenAI
from langchain_core.tools import tool
from langchain_core.messages import HumanMessage
import requests

# tool create
@tool
def multiply(a: int, b: int) -> int:
  """Given 2 numbers a and b this tool returns their product"""
  return a * b

print(multiply.invoke({'a':3, 'b':4}))  # ->  12

# Create LLM and bind this multiple tool.
llm = ChatOpenAI()
llm_with_tools = llm.bind_tools([multiply])
```

### 02. Tool Calling 
Tool Calling is the process where the LLM decides, duraing a conversation or task, that it needs to use a specific tool or function - and generates a strcutured output with:
- The name of the tool
- and the arguments to call it.


```python
messages = [HumanMessage('can you multiply 3 with 1000')]
result = llm_with_tools.invoke(messages)
messages.append(result)
print(messages)

""" ## Output of above print statement:
[HumanMessage(content='can you multiply 3 with 1000', additional_kwargs={}, response_metadata={}),
 AIMessage(content='', additional_kwargs={'tool_calls': [{'id': 'call_RxxH1pPDylDECUwpRe7MXkJi', 'function': {'arguments': '{"a":3,"b":1000}', 'name': 'multiply'}, 'type': 'function'}], 'refusal': None}, response_metadata={'token_usage': {'completion_tokens': 19, 'prompt_tokens': 63, 'total_tokens': 82, 'completion_tokens_details': {'accepted_prediction_tokens': 0, 'audio_tokens': 0, 'reasoning_tokens': 0, 'rejected_prediction_tokens': 0}, 'prompt_tokens_details': {'audio_tokens': 0, 'cached_tokens': 0}}, 'model_name': 'gpt-3.5-turbo-0125', 'system_fingerprint': None, 'id': 'chatcmpl-BR8rS3DNc8cckcVLJMmBDxHENKUlV', 'finish_reason': 'tool_calls', 'logprobs': None}, id='run-8035ac83-7820-4681-b8c0-1d15aa24ca77-0', tool_calls=[{'name': 'multiply', 'args': {'a': 3, 'b': 1000}, 'id': 'call_RxxH1pPDylDECUwpRe7MXkJi', 'type': 'tool_call'}], usage_metadata={'input_tokens': 63, 'output_tokens': 19, 'total_tokens': 82, 'input_token_details': {'audio': 0, 'cache_read': 0}, 'output_token_details': {'audio': 0, 'reasoning': 0}})]
"""
```
### 03. Tool Execution
Tool execution is the step where the actual python function (tool) is run using the input arguments that the LLM suggested during tool calling. Output of tool execution via ".invoke()" will be a ToolMessage object.


```python
# Tool Execution:
tool_result = multiply.invoke(result.tool_calls[0])
print(tool_result)
# Output -> ToolMessage(content='3000', name='multiply', tool_call_id='call_RxxH1pPDylDECUwpRe7MXkJi')

messages.append(tool_result)

# Call LLM again after LLM requested tools are executed:
llm_with_tools.invoke(messages).content
# Output: The product of 3 and 1000 is 3000
```
## Currency Conversion Example (InjectedToolArg):

```python
# tool create
from langchain_core.tools import InjectedToolArg
from typing import Annotated

@tool
def get_conversion_factor(base_currency: str, target_currency: str) -> float:
  """
  This function fetches the currency conversion factor between a given base currency and a target currency
  """
  url = f'https://v6.exchangerate-api.com/v6/c754eab14ffab33112e380ca/pair/{base_currency}/{target_currency}'
  response = requests.get(url)
  return response.json()

@tool
def convert(base_currency_value: int, conversion_rate: Annotated[float, InjectedToolArg]) -> float:
  """
  given a currency conversion rate this function calculates the target currency value from a given base currency value
  """
  return base_currency_value * conversion_rate

get_conversion_factor.invoke({'base_currency':'USD','target_currency':'INR'}) # -> 85.16
convert.invoke({'base_currency_value':10, 'conversion_rate':85.16}) # -> 851.999 

# tool binding
llm = ChatOpenAI()
llm_with_tools = llm.bind_tools([get_conversion_factor, convert])
messages = [HumanMessage('What is the conversion factor between INR and USD, and based on that can you convert 10 inr to usd')]
ai_message = llm_with_tools.invoke(messages)
messages.append(ai_message)

# Handling InjectedToolArg from developer end:
import json
for tool_call in ai_message.tool_calls:
  # execute the 1st tool and get the value of conversion rate
  if tool_call['name'] == 'get_conversion_factor':
    tool_message1 = get_conversion_factor.invoke(tool_call)
    # fetch this conversion rate
    conversion_rate = json.loads(tool_message1.content)['conversion_rate']
    # append this tool message to messages list
    messages.append(tool_message1)
  # execute the 2nd tool using the conversion rate from tool 1
  if tool_call['name'] == 'convert':
    # fetch the current arg
    tool_call['args']['conversion_rate'] = conversion_rate
    tool_message2 = convert.invoke(tool_call)
    messages.append(tool_message2)

# Call LLM again with all tools called:
llm_with_tools.invoke(messages).content

```