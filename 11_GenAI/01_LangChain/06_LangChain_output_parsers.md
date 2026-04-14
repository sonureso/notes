> # LangChain Output Parsers
- (parsers) https://github.com/campusx-official/langchain-output-parsers
- (Docs): https://reference.langchain.com/python/langchain-core/output_parsers
- Video Tutorial: https://www.youtube.com/watch?v=Op6PbJZ5b2Q&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0&index=8

**Output Parsers**: Outut Parsers in LangChain helps convert LLM responses in strcutured formats like JSON, CSV, Pydentic models and more. They ensure consistency, validation and ease of use in applications.

### 01. StrOutputParser
**StrOutputParser** is simplest output parser in langchain. It is used to parse of output of the LLM and return the plain text. This will allow you to use the 'chain' instead of calling invoke function separately.
```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

load_dotenv()
model = ChatOpenAI()
# 1st prompt -> detailed report
template1 = PromptTemplate(
    template='Write a detailed report on {topic}',
    input_variables=['topic']
)
# 2nd prompt -> summary
template2 = PromptTemplate(
    template='Write a 5 line summary on the following text. /n {text}',
    input_variables=['text']
)

parser = StrOutputParser()
chain = template1 | model | parser | template2 | model | parser
result = chain.invoke({'topic':'black hole'})
print(result)
```

### 02. JSONOutputParser

```python
from langchain_huggingface import ChatHuggingFace, HuggingFaceEndpoint
from dotenv import load_dotenv
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import JsonOutputParser

load_dotenv()
llm = HuggingFaceEndpoint(
    repo_id="google/gemma-2-2b-it",
    task="text-generation"
)

model = ChatHuggingFace(llm=llm)
parser = JsonOutputParser()

template = PromptTemplate(
    template='Give me 5 facts about {topic} \n {format_instruction}',
    input_variables=['topic'],
    partial_variables={'format_instruction': parser.get_format_instructions()}
)
chain = template | model | parser
result = chain.invoke({'topic':'black hole'})
print(result)
```
Since JSONOutputParser doesn't enforce schema, so we require the strcuturedOutputParser.

### 03. StructuredOutputParser
This parser helps extract structured JSON data from LLM response based on predefined field schema.
It works by defining the list of fields (ResponseSchema) that the model should return, ensuring the output follows a structured format.

```python
from langchain_huggingface import ChatHuggingFace, HuggingFaceEndpoint
from dotenv import load_dotenv
from langchain_core.prompts import PromptTemplate
from langchain.output_parsers import StructuredOutputParser, ResponseSchema

load_dotenv()
# Define the model
llm = HuggingFaceEndpoint(
    repo_id="google/gemma-2-2b-it",
    task="text-generation"
)
model = ChatHuggingFace(llm=llm)
schema = [
    ResponseSchema(name='fact_1', description='Fact 1 about the topic'),
    ResponseSchema(name='fact_2', description='Fact 2 about the topic'),
    ResponseSchema(name='fact_3', description='Fact 3 about the topic'),
]
parser = StructuredOutputParser.from_response_schemas(schema)
template = PromptTemplate(
    template='Give 3 fact about {topic} \n {format_instruction}',
    input_variables=['topic'],
    partial_variables={'format_instruction':parser.get_format_instructions()}
)

chain = template | model | parser
result = chain.invoke({'topic':'black hole'})
print(result)
```

### 04. PydanticOutputParser
PydanticOutputParser is a structured output parser in langchain  that uses pydantic models to enforce schema validation when processing LLM responses.

```python
from langchain_huggingface import ChatHuggingFace, HuggingFaceEndpoint
from dotenv import load_dotenv
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import PydanticOutputParser
from pydantic import BaseModel, Field

load_dotenv()
# Define the model
llm = HuggingFaceEndpoint(
    repo_id="google/gemma-2-2b-it",
    task="text-generation"
)
model = ChatHuggingFace(llm=llm)

class Person(BaseModel):
    name: str = Field(description='Name of the person')
    age: int = Field(gt=18, description='Age of the person')
    city: str = Field(description='Name of the city the person belongs to')

parser = PydanticOutputParser(pydantic_object=Person)
template = PromptTemplate(
    template='Generate the name, age and city of a fictional {place} person \n {format_instruction}',
    input_variables=['place'],
    partial_variables={'format_instruction':parser.get_format_instructions()}
)

chain = template | model | parser
final_result = chain.invoke({'place':'sri lankan'})
print(final_result)
```