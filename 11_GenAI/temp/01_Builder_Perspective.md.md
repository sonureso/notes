# Generative AI - Complete Notes (Builder Perspective)

**Playlist**: [Generative AI using LangChain - CampusX](https://www.youtube.com/watch?v=pSVk-5WemQ0&list=PLKnIA16_RmvaTbihpo4MtzVm4XOQa0ER0)

**Course Focus**: Hands-on building of intelligent, conversational, and reasoning AI applications using LangChain and related tools.

---

## 1. Two Perspectives of Generative AI

Generative AI can be studied from two main angles:

### 1.1 User Perspective (Consumer / Prompt Engineer)
- How to **interact** effectively with pre-built GenAI models (ChatGPT, Claude, Gemini, Grok, etc.).
- Prompt engineering techniques.
- Chaining prompts, few-shot, chain-of-thought, ReAct, etc.
- Building simple applications using no-code/low-code tools or basic APIs.
- Evaluation from user standpoint (output quality, usefulness, safety).

**Goal**: Get maximum value from existing models without building anything from scratch.

### 1.2 Builder Perspective (Developer / ML Engineer)
- Understand and **build** the systems that power Generative AI.
- Focus on architecture, training, optimization, customization, evaluation, and production deployment.
- This is the core of the playlist (especially when moving beyond basic LangChain usage into deeper components).

**Goal**: Create, customize, improve, and productionize GenAI applications.

---

## 2. Builder Perspective - Core Topics

### 2.1 Transformers (The Foundation of Modern GenAI)

- **Why Transformers?**
  - Replaced RNNs/LSTMs due to parallelization and long-range dependency handling.
  - Core architecture behind GPT, BERT, LLaMA, Mistral, etc.

- **Key Components**:
  - Self-Attention Mechanism
  - Multi-Head Attention
  - Positional Encoding
  - Feed-Forward Networks
  - Layer Normalization & Residual Connections
  - Encoder-Decoder vs Decoder-only (GPT-style) architectures

- **Important Concepts**:
  - Scaled Dot-Product Attention
  - Query, Key, Value matrices
  - Masking (causal masking in autoregressive models)
  - Tokenization & Vocabulary

- **Key Papers**:
  - "Attention Is All You Need" (Vaswani et al., 2017)

**To revise**: Draw the transformer block diagram and explain how information flows.

---

### 2.2 Pretraining

- **Objective**: Train a model on massive unlabeled text data to learn general language understanding and generation.
- **Common Pretraining Objectives**:
  - Causal Language Modeling (Next Token Prediction) → GPT-style
  - Masked Language Modeling → BERT-style
  - Other variants: Span corruption, prefix LM, etc.

- **Scale Matters**:
  - Data scale (trillions of tokens)
  - Model size (parameters)
  - Compute (FLOPs)

- **Popular Pretrained Models**:
  - OpenAI GPT series
  - Meta LLaMA family
  - Mistral, Gemma, Phi, etc.

- **Challenges**:
  - Data quality & cleaning
  - Compute cost
  - Emergent abilities with scale

---

### 2.3 Optimizers

- **Role**: Minimize the loss function during training.
- **Classic Optimizer**: Stochastic Gradient Descent (SGD)
- **Modern Optimizers used in LLMs**:

| Optimizer       | Key Features                          | Common Use Case          |
|-----------------|---------------------------------------|--------------------------|
| Adam            | Adaptive learning rates               | General deep learning    |
| AdamW           | Weight decay decoupled                | Most LLM pretraining     |
| RMSProp         | Root mean square propagation          | Older RNNs               |
| Lion            | Newer, memory efficient               | Some recent models       |
| Sophia          | Second-order inspired                 | Emerging for LLMs        |

- **Important Hyperparameters**:
  - Learning rate (often with warmup + cosine decay)
  - β1, β2 (in Adam)
  - Weight decay
  - Gradient clipping

- **Advanced Techniques**:
  - Learning rate schedulers
  - Mixed precision training (FP16/BF16)
  - ZeRO, FSDP for distributed training

---

### 2.4 Fine-Tuning

- **Why Fine-Tune?**
  - Adapt pretrained model to specific tasks/domains with less data & compute.

- **Types of Fine-Tuning**:

  1. **Full Fine-Tuning** — Update all parameters (expensive)
  2. **Parameter-Efficient Fine-Tuning (PEFT)**:
     - LoRA (Low-Rank Adaptation)
     - QLoRA (Quantized LoRA)
     - Adapter layers
     - Prefix Tuning / Prompt Tuning
  3. **Instruction Tuning** (Supervised Fine-Tuning - SFT)
  4. **Alignment** (RLHF, DPO, ORPO, KTO)
     - Reinforcement Learning from Human Feedback
     - Direct Preference Optimization

- **Datasets for Fine-Tuning**:
  - Alpaca, Dolly, OpenOrca, UltraChat, etc.
  - Domain-specific data

- **Best Practices**:
  - Use proper formatting (chat templates)
  - Avoid catastrophic forgetting
  - Evaluation during training

---

### 2.5 Evaluation

- **Why Evaluation is Critical**:
  - LLMs are stochastic → single metric is not enough.

- **Types of Evaluation**:

  **Automatic Metrics**:
  - Perplexity
  - BLEU, ROUGE (for translation/summarization)
  - BERTScore, MoverScore
  - LLM-as-a-Judge (GPT-4 evaluation)

  **Human Evaluation**:
  - Win rate, preference ranking
  - Helpfulness, Honesty, Harmlessness (HHH)

  **Task-Specific Benchmarks**:
  - MMLU, GSM8K, HumanEval, BIG-bench, HELM, etc.
  - Safety & bias benchmarks

- **Key Challenges**:
  - Evaluation contamination
  - Lack of robust automatic metrics for open-ended generation

---

### 2.6 Deployment

- **Goals**: Make the model fast, cheap, reliable, and scalable in production.

- **Key Stages**:
  1. **Inference Optimization**
     - Quantization (8-bit, 4-bit, GPTQ, AWQ)
     - Pruning & Distillation
     - Speculative decoding
     - Flash Attention, Paged Attention (vLLM)

  2. **Serving Frameworks**:
     - vLLM
     - TensorRT-LLM
     - Hugging Face Text Generation Inference (TGI)
     - Ollama, LM Studio (local)
     - LangChain + FastAPI

  3. **Scaling**:
     - Batch inference
     - Continuous batching
     - Distributed inference (multiple GPUs)

  4. **Production Concerns**:
     - Latency vs Throughput trade-off
     - Cost monitoring
     - Rate limiting & safety filters
     - Monitoring & logging (LangSmith, Phoenix, etc.)
     - A/B testing of models

- **Modern Deployment Stack** (typical):
  - Frontend → LangChain/LangGraph → LLM API or self-hosted model → Vector DB (for RAG)

---
