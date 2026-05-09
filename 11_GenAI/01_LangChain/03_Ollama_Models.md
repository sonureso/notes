
> # Open Source Models | Ollama
### Ollama Setup Steps
1. Download the ollama software from Ollama website.
2. Install it on your computer with usual steps.
3. Check the version: ```ollama --version```
4. Pull the model: ```ollama pull llama3.2:1b```
5. Check the installation: ```ollama list```
6. Run this command to check the LLM: ```ollama run llama3.2:1b```
7. Exit using this command: ```/bye```

**ABOUT**: Open-source models (like Llama 3, Mistral, and Qwen) offer great flexibility, data privacy, and zero licensing costs, but they come with significant technical hurdles for the average user or developer. Ollama solves these problems by providing a containerized, user-friendly wrapper that handles the complexity of running large models locally.

In Short, **Ollama**  is a tool that lets you run LLMs on your own computer. You can think Ollama as Docker which contains Modelfile instead of image file.


- Ollama enables running models with a single command (e.g., ```ollama run llama3```). It abstracts away all environment configuration, drivers, and dependencies.
- ```ollama run llama3.2``` uses 2GB RAM.
- ```ollama run llama3.2:1b``` uses 1.3GB RAM (https://ollama.com/library/llama3.2)
- ```ollama run gemma2:2b``` uses 1.6GB RAM.
- ```ollama run deepseek-r1:1.5b``` uses 1.1GB RAM
- ```ollama run llama3.1:8b-instruct-q4_0``` uses 4.8 GB RAM
- More Open Source Models can be seen here: https://ollama.com/search

### About Modelfile:
**Problem:** LLMs are usually general-purpose, but in real world we want LLMs with specialized behaviour. We may want our LLM to be - A brutal honest code reviewer | A polite customer support | A content writing expert.

**Solution:** Modelfile is a configuratio file that defines how a model should behave, respond and be used. It acts as an instruction layer on base LLM model.
- Reference about Modelfile: https://docs.ollama.com/modelfile

**Modelfile** Example below:
```modelfile
FROM llama3.2:1b

# PARAMETERS: Optimization for high-speed API usage
PARAMETER temperature 0.1

# Small context is enough for classification (saves RAM)
PARAMETER num_ctx 1024

# We only need a few tokens for JSON
PARAMETER num_predict 20

# Narrow the vocabulary to only essential characters
PARAMETER top_k 10

# SYSTEM: Formatting Guardrails
SYSTEM """
You are a sentiment analysis API. 
You ONLY output JSON in the following schema: {"score": float, "label": "string"}.
Labels allowed: [POSITIVE, NEGATIVE, NEUTRAL].
Scores range from 0.0 to 1.0.
"""

# MESSAGE: Few-shot training (Solidifying the output)
MESSAGE user "This product is okay, but the shipping was slow."
MESSAGE assistant "{\"score\": 0.4, \"label\": \"NEUTRAL\"}"

MESSAGE user "Absolutely amazing experience, highly recommend!"
MESSAGE assistant "{\"score\": 0.95, \"label\": \"POSITIVE\"}"
```
**Create Custom Model using Modelfile**
```bash
# STEP-1: Create the Modelfile with above reference.
# STEP-2: Go to the directory containing Modelfile and open cmd.
ollama create sentiment_model:latest -f Modelfile
ollama ls
ollama run sentiment_model:latest "This is not good."
```

### Ollama Commands:
- ```ollama pull <model>```: Downloads a specific model from the Ollama library without running it.
- ```ollama rm <model>```: Removes a model from your local storage to free up disk space.
- ```ollama list```: Shows all models currently downloaded and stored on your system.
- ```ollama show <model>```: Displays detailed information about a specific model, including its license, parameters, and system prompt.
- ```ollama ps```: Lists all models that are currently active and loaded into your system's RAM/VRAM.
- ```ollama stop <model>```: Terminates a running model to free up system memory immediately.
- ```ollama help```: Displays a full list of available commands and flags for quick reference in the terminal

> # Using Ollama:
Once installed, we can use Ollama in mutiple ways.
1. CLI
2. with Ollama Library
3. Rest API
4. LangChain

### 1. CLI:
The CLI is the default method for downloading, managing, and chatting with models.

### 2.1 With Ollama Library: (generate - Context Unaware)
- 'generate' - This end point creates a response unaware of the context.
- 'chat' - Context Aware. Generate the next chat message in a conversation between a user and an assistant.
- https://docs.ollama.com/api/generate
- Code reference: https://github.com/campusx-official/Ollama-Youtube/blob/main/Ollama.ipynb
```python
# Install the python library
pip install ollama

# Import
import ollama

# Generate Response:
response = ollama.generate(model="llama3.2:1b",prompt="why does moon glow ?")
response.response

# STREAM RESPONSE
response = ollama.generate(model="llama3.2:1b",prompt="why does moon glow ?", stream=True)
for i in response:
    print(i["response"], end="")
```
**Sending Images via Prompt**
```python
# Sending Images in prompt:
import base64
import ollama

image_path= "Linkedin.jpg"

with open(image_path,"rb") as f: # OPENING THE IMAGE IN READ BINARY 
    image_bytes= f.read()    # READING THE IMAGE 
image_64= base64.b64encode(image_bytes).decode("utf-8") # ENCODING THE IMAGE IN BASE 64 BITS.

response= ollama.generate(model="gemma3:4b", images=[image_64], prompt="Give caption for the image.")
print(response.response)
```
**Sending Multiple Images via Prompt**
```python
image_paths = ["Linkedin.jpg","Green AI.png"]

images_base64=[]
for i in image_paths:
    with open(i , "rb") as f:
        image_bytes= f.read()
        images_base64.append(base64.b64encode(image_bytes).decode("utf-8"))

response= ollama.generate(model="gemma3:4b", images=images_base64,
                          prompt="Generate an story based on these images, make sure you take context from each and every image.")
print(response.response)
```
**Adding System Information**
```python
response = ollama.generate(model="llama3.2:1b",prompt="why does moon glow ?", system="You are an funny assistant , you explain things in funny way")
print(response.response)
```
**Option Parameters**
```python
# OPTIONS PARAMETER
response = ollama.generate(model="llama3.2:1b",prompt="why is the ocean blue",
                           options={"temperature":0.3, "top_p":0.5, "top_k":45}
                           )
print(response.response)
```
**Check Model Capabilities**
```python
models_details = ollama.show("qwen3:8b")
model_dict= models_details.dict()
print(model_dict["capabilities"]) #-> 'completion', 'tools', 'thinking'
print(model_dict["parameters"])
```
### 2.2 With Ollama Library: (chat - Context Aware)
- Refer this page: https://docs.ollama.com/api/chat
- Tools Calling: https://github.com/campusx-official/Ollama-Youtube/blob/main/Tool%20Calling.ipynb

### 3. Using Rest API
Ollama internally work using REST API hosted at port 11434. CLI and python library are just wrappers around the API end points. See these code around this topic: https://github.com/campusx-official/Ollama-Youtube/blob/main/Ollama%20using%20Rest%20API.ipynb

### 4. Using LangChain
- ChatOllama - For chat model of ollama
- OllamaEmbeddings - For Ollama Embedding Models.
- OllamaLLM - Ollama text generation (Context unaware)
- Refer Docs: https://docs.langchain.com/oss/python/integrations/llms/ollama
- Refer Codes: https://github.com/campusx-official/Ollama-Youtube/blob/main/Ollama%20Using%20LangChain.ipynb
**Installation**
```python
pip install  langchain-ollama
```
**ChatOllama**
```python
from langchain_ollama import ChatOllama

llm = ChatOllama(model="llama3.2:1b", temperature=0)
response = llm.invoke("Explain the concept of quantum entanglement in one sentence.")
print(response.content)
```
**OllamaLLM**
```python
from langchain_ollama import OllamaLLM

llm = OllamaLLM(model="llama3.2:1b")
response = llm.invoke("The capital of France is")
print(response)
```
**OllamaEmbeddings**
```python
from langchain_ollama import OllamaEmbeddings

embeddings = OllamaEmbeddings(model="embeddinggemma:latest")
# Embed Single Text/String:
query_result = embeddings.embed_query("What is LangChain?")

# Embed multiple documents:
doc_results = embeddings.embed_documents(["Document 1 content", "Document 2 content"])
print(f"Embedding length: {len(doc_results)}")
print(doc_results[0])
```

> # Ollama Cloud
**Problem**: We can't run models with large parameters due to the hardware cost constraints. Ex: I can't run a model with 50GB of size.

**Solution**: Ollama cloud is cloud-based extension of Ollama platform that lets you run LLMs without needing powerful local hardware. Instead of running on your own machine, the models are executed on powerful datacentre-graded hardware managed by Ollama.

**How to use ollama cloud models**
```shell
# STEP-1: signin to the ollama website.
ollama signin
# STEP-2: Copy the output link and paste in browser to signin.
ollama run deepseek-v3.1:671b-cloud 
```
```python
import ollama 
# make sure you are signin before you use ollama cloud models
response = ollama.generate(
    model="deepseek-v3.1:671b-cloud",
    prompt="Why do stars twinkle?"
)
print(response["response"])
```
