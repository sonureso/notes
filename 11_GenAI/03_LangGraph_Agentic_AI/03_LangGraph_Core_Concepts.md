> # LangGraph
LangGraph is an orchestration framework that enables you to build stateful, multi-step and event-driven workflows using LLMs. It is ideal for designing both single-agent and multi-agent agentic AI applications.

It models your logic as a graph of nodes (tasks) and edges (routing) instead of a linear chain.

> # LLM Workflows
LLM workflows are a step by step process using which we can build complex LLM application. Each step performs a distinct task - such as prompting, reasoning, tool calling, memory access, or decision-making. Workflows can be linear, parallel, branched or looped, allowing for complex behaviours like retires, multi agent communication, or tool-augmented reasoning.

> # Common Workflows
1. Prompt Chaining: Chain of prompts
2. Routing: Based on some decision it routes towards some nodes.
3. Parallelization: Running nodes parallely.
4. Orchestrator Workers: an agentic architecture where a central controller breaks a complex user task into smaller subtasks, delegates them to parallel worker nodes, and synthesizes the workers' outputs into a final cohesive result.
5. Evaluator Optimizer: an agentic design pattern in LangGraph that continuously reframes responses through a self-improving loop.

> # Graph, Nodes & Edges
LangGraph models complex, stateful AI workflows (especially agents) as **graphs**. This structure allows for cycles (loops), branching, persistence, and dynamic control flows — going beyond simple linear chains.

### 1. Graph
- The **graph** is the overall workflow or application structure.
- It represents the entire program as a network of connected steps.
- Built using `StateGraph` (or similar), it defines:
  - A shared **State** schema (what data is passed around).
  - Nodes (the actions).
  - Edges (the connections and routing logic).
- Special markers: `START` (entry point) and `END` (termination).
- After defining nodes and edges, you **compile** the graph into a runnable application.
- Supports features like persistence (checkpoints), streaming, human-in-the-loop, subgraphs, and multi-agent coordination.

**Think of the graph** as a state machine or flowchart where execution moves from one step to another while updating and carrying forward a shared state.

### 2. Nodes
- **Nodes** are the individual units of computation or "steps" in the workflow.
- Each node is typically a **Python function** (or an LCEL runnable) that:
  - Receives the current **State** as input.
  - Performs work (e.g., call an LLM, invoke a tool, process data, make a decision).
  - Returns updates to the state (usually a dictionary with keys matching the state schema).
- Nodes can be simple (e.g., data transformation) or complex (e.g., full agents, tool callers).
- You add nodes with: `graph.add_node("node_name", function_name)`
- Nodes do the actual "work" — they are where logic, LLM calls, or side effects happen.

**Example analogy**: Nodes are like rooms or workers — each performs a specific task and updates the shared notebook (state) before passing it along.

### 3. Edges
- **Edges** define the flow: *what happens next* after a node finishes.
- They connect nodes and control the execution order.
- Two main types:

  **a. Normal (Fixed) Edges**
  - Always go from one specific node to another.
  - Added with: `graph.add_edge("node_a", "node_b")`
  - Used for straightforward sequential steps.

  **b. Conditional Edges**
  - Dynamically decide the next node based on the current state.
  - A routing function (often powered by an LLM or simple logic) inspects the state and returns the name of the next node.
  - Added with: `graph.add_conditional_edges("source_node", routing_function, {"option1": "node_x", "option2": "node_y"})`
  - Enables branching, loops, tool selection, or early termination.

- Edges from `START` define where execution begins.
- Edges to `END` signal that the graph should stop.

**Key Point**: Nodes perform actions; edges control routing and orchestration.

> # State, Reducers & LangGraph Execution Model
### 1. State
- **State** is the shared data structure that flows through the entire graph. It acts as the "memory" or context that all nodes can read from and write to.
- Defined as a schema using:
  - `TypedDict`
  - Pydantic model
  - Dataclass
- Nodes receive the current state as input and return **updates** (usually a dictionary/partial state) that get applied to it.
- Common example: `MessagesState` (contains `messages` list with built-in reducer).
- State enables persistence, checkpoints, and multi-turn/agentic workflows.

**Key Idea**: Everything in the graph revolves around updating and carrying forward this shared state.

### 2. Reducers
Reducers control **how updates** from nodes are merged into the existing state. They are crucial for handling concurrent updates, lists, and avoiding accidental overwrites.

- Each key/field in the state can have its own independent reducer.
- Defined using `Annotated` in the state schema:
  ```python
  from typing import Annotated
  from operator import add
  from langgraph.graph.message import add_messages

  class State(TypedDict):
      messages: Annotated[list, add_messages]   # appends messages
      findings: Annotated[list, add]            # concatenates lists
      counter: int                              # default: overwrite
  ```
- **Default behavior** (no reducer): Last write wins (overwrite).
- **Common built-in reducers**:
  - `add_messages`: Smart appending of chat messages (handles IDs, merging, etc.).
  - `operator.add`: Works for lists (concatenation).
  - Custom reducers: Any function `(current_value, update_value) -> new_value`.

**Why Reducers Matter**:
- In **parallel branches**, multiple nodes can update the same key simultaneously. Without a reducer, this can cause conflicts or data loss.
- In **loops** or multi-step flows, they allow accumulation (e.g., growing message history).
- They make state updates predictable and safe.

### 3. LangGraph Execution Model
LangGraph Execution Model: LangGraph uses a Pregel-inspired execution model that runs in discrete supersteps (ticks). 

In each superstep, all ready nodes execute in parallel, read the current state, produce updates, and reducers merge those updates into a new state. Edges then determine the next nodes to run. This cycle repeats until reaching END. The model natively supports parallelism, conditional routing, loops, streaming, and persistence via checkpoints after each superstep (enabling resume, time travel, and human-in-the-loop).


