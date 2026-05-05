> # 1. Curriculum
1. Foundation of Agentic AI
2. LangGraph Fundamentals
3. Advanced LangGraph
4. AI Agents and popular design patterns
5. Agentic RAG 
6. Productionization of Agentic AI

> # 2. Generative AI vs Agentic AI

### 2.1 Generative AI
**Generative AI:** Focuses on generating content based on input prompts. It is typically reactive and does not have the ability to plan or execute tasks autonomously. Examples are:
- LLM based apps like ChatGPT, Gemini, Claude, etc.
- Diffusion models for image generation like DALL-E, Stable Diffusion, etc.
- Code generating models like GitHub Copilot, CodeWhisperer, etc.
- TTS models for text-to-speech conversion like Azure TTS, ElevenLabs, etc.
- Video generation models like Sora, Google Veo etc. 

### 2.2 Agentic AI
**Agentic AI:** Goes beyond generating content and can autonomously plan, execute tasks, and interact with the environment. It can make decisions, learn from interactions, and adapt its behavior over time.

**Components of Agentic AI**
1. Brain: (LLM) Goal Interpretation, Planning, Reasoning, Tool Selection, Communication.
2. Orchestrator: Task Sequencing, Conditional Routing, Retry Logic, Looping, Delegation.
3. Tools: External Actions, Knowledge Base Access.
4. Memory: Short-Term Memory, Long-Term Memory, State tracking.
5. Supervisor: Approval Requests, Guardrails Enforcement, Edge Case Escalation.

**Characteristics of Agentic AI:**
1. **Autonomy:** Can operate without human intervention.
    Autonomy can be controlled by:
    - Permission control: The agent can only perform actions that it has been explicitly allowed to do.
    - Human in the loop (HITL): The agent can perform actions, but it requires human approval before executing certain actions.
    - Override control: The agent can perform actions, but a human can override its decisions at any time.
    - Guardrails: The agent can perform actions, but it is constrained by predefined rules or guidelines that prevent it from taking harmful or undesirable actions.
2. **Goal-Oriented:** Being goal oriented means that the AI system operates with a persitent objective in mind and continuosly directs its actions to achieve that objective, rather than just responding to isolated prompts.
    - Goals acts as a compass for autonomy.
    - Goals can come with constraints and rules that the agent must follow while pursuing its objectives.
    - Goals are stored in core memory.
    - Goals can be updated and modified over time based on new information or changing circumstances.
3. **Planning**: Planning is the agents ability to break down a high level goal into a structured sequence of actions or sub-goals and decide the best path to achieve the desired outcome.
    - STEP-1: Generate multiple candidate plans.
    - STEP-2: Evaluate the candidate plans based on factors such as feasibility, efficiency, and potential risks.
    - STEP-3: Select the best plan and execute it.
4. **Reasoning:** Reasoning is the congnitive process through which an agentic AI interprets information, draws conclusions, and make decisions - both while planning agead and while executing actions in real time.
    - Reasoning During Planning:
        - Goal Decomposition.
        - Tool Selection.
        - Resource Estimation.
    - Reasoning During Execution:
        - Decision Making: Choosing between options.
        - HITL handling: Knowing when to pause and ask for help.
        - Error Handling: Interpreting tools/API failures for recovery.
5. **Adaptability:** Adaptability is agents ability to modify its plan, strategy or action in response to unexpected conditions - all while staying aliged with the goals.
    - Failures
    - External Feedback
    - Changing Goals
6. **Context Awareness:** Context Awareness is the agents ability to understand, retain and utilize relevant information from the ongoing task, past interactions, user preferences and environmental cues to make better decision throughout a multi-step process.
    - Types of context:
        - The original goal.
        - Progress till now.
        - Environmenal stage.
        - User specific preferences.
        - Policy or Guardrails.
    - Context awareness is implemented throgh memory.
    - Short term memory / Long term memory
