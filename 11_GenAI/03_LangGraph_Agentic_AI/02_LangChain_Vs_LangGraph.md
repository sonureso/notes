> # LangGraph
LangGraph is an orchestration framework that enables you to build stateful, multi-step and event-driven workflows using LLMs. It is ideal for designing both single-agent and multi-agent agentic AI applications.

## When to use what?
**LangChain** - Use langchain when you are building simple, linear workflows - like a prompt chain, summarizer, or a basic retrieval system.

**LangGraph** - Use LangGraph when your use case involves complex, non-linear workflows that need:
- Conditional Path
- Loops
- Human-in-the-loop step
- Multi-agent coordination
- Asynchronous or event-driven execution

**Challenges** that LangGraph solves are:
- Control Flow Complexity.
- Handling state
- Event Driven Execution
- Fault Tolerence
- Human-in-the-loop
- Nested Workflows (This is a feature of LangGraph)

## Should we still use LangChain?
Yes, LangGraph is built on top of LangChain - It doesn't replace it. LangGraph handles workflow orchestration, while LangChain provides the building blocks for each step in that workflow.
You'll still use LangChain Components like:
- ChatOpenAI (model)
- PromptTemplate
- Retrievers
- DocumentLoaders
- Tools, etc

> # LangChain Vs LangGraph
LangChain is a framework for building linear LLM workflows (chains), while LangGraph is an extension of LangChain designed for creating complex, stateful, and cyclical agent workflows. LangChain excels at straightforward tasks like RAG, whereas LangGraph is superior for agent-style apps that require loops, planning, and persistence.