## Two Perspectives of Generative AI
Generative AI can be studied from two main angles:
> ### 1. User Perspective (Consumer / Prompt Engineer)
- How to **interact** effectively with pre-built GenAI models (ChatGPT, Claude, Gemini, Grok, etc.).
- Prompt engineering techniques.
- Chaining prompts, few-shot, chain-of-thought, ReAct, etc.
- Building simple applications using no-code/low-code tools or basic APIs.
- Evaluation from user standpoint (output quality, usefulness, safety).

**Goal**: Get maximum value from existing models without building anything from scratch.

#### 1.1 Curriculum/Topics under builders perspective:
- Building basic LLM Apps.
    - Open Source Vs Closed Source
    - Using LLM APIs.
    - LangChain / LlamaIndex / HayStack
    - HuggingFace
    - Ollama
- Prompt Engineering
- RAG
- Fine Tuning
- Agents
- LLMOPs
- Miscellaneous



> ### 2. Builder Perspective (Developer / ML Engineer)
- Understand and **build** the systems that power Generative AI.
- Focus on architecture, training, optimization, customization, evaluation, and production deployment.
- This is the core of the playlist (especially when moving beyond basic LangChain usage into deeper components).

**Goal**: Create, customize, improve, and productionize GenAI applications.

#### 2.1 Curriculum/Topics under builders perspective:
- Transformer Architecture: The foundational neural network design enabling sequence processing in GenAI models.
- Types of transformers:
    - Encoder Only (BERT): Models focused on bidirectional understanding for tasks like classification and sentiment analysis.
    - Decoder Only (GPT): Autoregressive models for generating text sequences, ideal for completion and creative writing.
    - Encoder & Decoder Based (T5): Versatile models for sequence-to-sequence tasks like translation and summarization.
- Pretraining:
    - Training Objecttives: Core goals like predicting masked tokens or next words to learn language patterns.
    - Tokenization Strategy: Techniques for splitting text into subword units for efficient model input.
    - Training Strategy: Methods for unsupervised learning on massive datasets to build general knowledge.
    - Handling Challenges: Solutions for issues like data scarcity, computational costs, and model stability.
- Optimization:
    - Training Optimization: Techniques to accelerate and stabilize the model training process.
    - Model Compression: Methods to reduce model size and complexity for better efficiency.
    - Optimizing Inference: Strategies to speed up and reduce costs of model predictions.
- Fine-tuning:
    - Task Specific Tuning (RLHF): Customizing models using reinforcement learning based on human feedback.
    - Instruction Tuning (PEFT): Adapting models efficiently for specific instructions with minimal parameters.
    - Continual Pretraining: Extending training on new data to adapt to specialized domains.
- Evaluation:
    - Metrics for GenAI (BLEU, ROUGE, Perplexity): Quantitative tools to assess text generation quality and fluency.
    - Human Evaluation: Subjective reviews by people to gauge relevance, coherence, and usefulness.
    - Benchmarks (GLUE, SuperGLUE, MMLU): Standardized tests for comparing model performance across tasks.
- Deployment:
    - Scaling and Serving Models: Approaches for handling large-scale requests and delivering predictions.
    - Cloud Deployment (AWS, GCP, Azure): Hosting and running models on cloud infrastructure platforms.
    - Edge Deployment: Implementing models on local devices for low-latency, offline use.
- Advanced Topics:
    - Reinforcement Learning from Human Feedback (RLHF): Iterative improvement using human preferences to align outputs.
    - Alignment and Safety: Ensuring models behave ethically and avoid harmful content.
    - Multimodal Models: Integrating text with images, audio, or other modalities for richer AI.
    - Ethical Considerations and Bias Mitigation: Addressing fairness, bias, and responsible AI practices.
