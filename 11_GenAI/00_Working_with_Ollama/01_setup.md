## Ollama Quick Reference## 1. Installation & Verification

   1. Go to the [Ollama Download Page](https://ollama.com/download).
   2. Download and run the installer for your OS (Windows, macOS, or Linux).
   3. Open your terminal/command prompt and verify the installation:
   
   ollama --version
   
   
## 2. Essential Commands## Model Management

* Run a model (Chat): ollama run <model_name> (e.g., ollama run llama3.1)
* Download a model: ollama pull <model_name>
* Delete a model: ollama rm <model_name>

## System Monitoring

* List saved models: ollama list
* See running models: ollama ps (Shows models active in RAM/VRAM)
* Unload running model: ollama stop <model_name> (Frees up memory instantly)

## Inside Chat Session

* Exit chat: /bye
* Help menu: /?

## List of models:
1. minimax-m2.7:cloud
2. gemma4:31b-cloud
3. llama3.2:1b

## Set the local model as agentic in VS COde:
1. ollama pull gemma4:31b-cloud
2. Install the extensions: Continue or Ollama
3. VS CODE: > Manage Language Models
    Select the model of Ollama.
4. Start using it in chat: View -> Chat
