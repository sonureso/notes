> # 1. Tools in LangChain

### Reference:
- Video: https://www.youtube.com/watch?v=etnLX7m2MiA&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=18
- Doc: https://docs.langchain.com/oss/python/integrations/tools
- Colab: https://colab.research.google.com/drive/1GHHGsDFB5266Cc0xDsZ6OWzkB5GGSxFW?usp=sharing

### What are Tools?
Tool is just a Python function (or API) that is packaged in a way that LLM can understand and call when needed.
LangChain Tools can be of 2 types: **Builtin Tools** and **Custom Tools**.
- Agent = LLM (Reasoning + Decision Making) + Tools (Actions)

### 1. Builtin Tools
LangChain provides a set of built-in tools that can be used out of the box. These tools include:
- **DuckDuckGo Search**: A tool for performing web searches using the DuckDuckGo search engine.
- **Python REPL**: A tool that allows the agent to execute Python code and return the results.
- **Terminal**: A tool that allows the agent to execute terminal commands and return the results.
- **Requests**: A tool that allows the agent to make HTTP requests and return the results.
- **ShellTool**: A tool that allows the agent to execute shell commands and return the results.
- **GamilSendMessageTool**: A tool that allows the agent to send emails using Gmail.

**DuckDuckGo Search Tool:**
```python
!pip install langchain langchain-core langchain-community pydantic duckduckgo-search langchain_experimental

# 01. DuckDuckGo Search Tool:
from langchain_community.tools import DuckDuckGoSearchRun
search_tool = DuckDuckGoSearchRun()
results = search_tool.invoke('top news in india today')
print(results)

print(search_tool.name)
print(search_tool.description)
print(search_tool.args)
```

**Shell Tool:**
```python
# 02. Shell Tool:
from langchain_community.tools import ShellTool
shell_tool = ShellTool()
results = shell_tool.invoke('ls')
print(results)
```

### 2. Custom Tools
A custom tool is a tool that you define yourself.

**2.1 USING TOOL DECORATOR:**

This has 3 steps:
- Create the function.
- Add type hints to the function parameters.
- Decorate the function with `@tool` decorator.

```python
from langchain_core.tools import tool

@tool
def multiply(a: int, b:int) -> int:
    """Multiply two numbers"""
    return a*b

result = multiply.invoke({"a":3, "b":5})
print(result)

# every tool function contains: name, description and args
print(multiply.name)
print(multiply.description)
print(multiply.args)
# Print the JSON schema for the tool's arguments
print(multiply.args_schema.model_json_schema())
```

**2.2 USING StructuredTool & Pydantic:**

A structured tool in LangChain is a special type of tool where the input to the tool follows a structured schema, typically defined using a pydantic model.

```python
from langchain.tools import StructuredTool
from pydantic import BaseModel, Field

class MultiplyInput(BaseModel):
    a: int = Field(required=True, description="The first number to add")
    b: int = Field(required=True, description="The second number to add")

def multiply_func(a: int, b: int) -> int:
    return a * b

multiply_tool = StructuredTool.from_function(
    func=multiply_func,
    name="multiply",
    description="Multiply two numbers",
    args_schema=MultiplyInput
)

result = multiply_tool.invoke({'a':3, 'b':3})

print(result)
print(multiply_tool.name)
print(multiply_tool.description)
print(multiply_tool.args)
```
**2.3 Using BaseTool**

BaseTool is the abstract base class for all tools in LangChain, It defines the core strcuture and interface that any tool must follow, whether its a simple one-liner or a fully customized function.

All other tool types - @tool, StructuredTool are build on top of BaseTool.

```python
from langchain.tools import BaseTool
from typing import Type

# arg schema using pydantic
class MultiplyInput(BaseModel):
    a: int = Field(required=True, description="The first number to add")
    b: int = Field(required=True, description="The second number to add")

class MultiplyTool(BaseTool):
    name: str = "multiply"
    description: str = "Multiply two numbers"

    args_schema: Type[BaseModel] = MultiplyInput

    def _run(self, a: int, b: int) -> int:
        return a * b

# Create the custom baseTool object:
multiply_tool = MultiplyTool()

result = multiply_tool.invoke({'a':3, 'b':3})

print(result)
print(multiply_tool.name)
print(multiply_tool.description)

print(multiply_tool.args)
```
### 3. Toolkit
A toolkit is just a collection of tools that serve a common purpose - packaged together for convenience and reusability.

```python
from langchain_core.tools import tool

# Custom tools
@tool
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b

@tool
def multiply(a: int, b: int) -> int:
    """Multiply two numbers"""
    return a * b

class MathToolkit:
    def get_tools(self):
        return [add, multiply]

toolkit = MathToolkit()
tools = toolkit.get_tools()

for tool in tools:
    print(tool.name, "=>", tool.description)
```