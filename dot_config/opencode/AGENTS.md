# OpenCode Agent Instructions

## Core Principles

### Research & Memory

- After each research of docs/projects, save findings to memory using `memory_remember`
- Store key decisions, patterns, and learnings with appropriate tags (e.g., "pattern", "learning", "context")
- Recall relevant memories when approaching similar tasks

### Code Quality

- Write clean, readable code following project conventions
- Match existing code style in the file being edited
- Use meaningful variable and function names
- Add comments only when explaining complex logic or non-obvious decisions

### Communication

- Give meaningful, specific feedback rather than generic responses
- Don't assume intent, requirements, or context - ask instead
- Be concise but complete; answer directly without unnecessary preamble
- When uncertain, ask clarifying questions before proceeding

### Error Handling

- Handle failures gracefully; don't let one failed operation crash unrelated work
- Provide meaningful, specific error messages
- Fail fast with clear messages for configuration errors

## Workflow Guidelines

1. **Before implementing**: Confirm understanding by asking if unclear
2. **During research**: Save important findings to memory
3. **After completion**: Summarize what was done concisely
4. **When stuck**: Ask for guidance instead of making assumptions
