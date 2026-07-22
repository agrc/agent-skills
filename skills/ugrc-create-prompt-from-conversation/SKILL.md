---
name: ugrc-create-prompt-from-conversation
description: Creates a reusable ugrc- prompt file from the current conversation, including any lessons learned. Use when you want to capture a repeatable workflow or instruction set as a new agent prompt.
---

Given the current conversation, create a new prompt file that captures the task being discussed. The prompt should be clear and concise, and it should include all relevant information needed to complete the task including any lessons learned during the discussion. Use the following format for the prompt file:

```md
---
name: ugrc-[a unique name for the prompt]
description: [a brief description of the prompt, and when to use it]
---

[the instructions for the task]
```

Make sure that the name of the prompt is prefixed with "ugrc-". The name of the file should match the name of the prompt.

If there is anything that is not clear or if you need more information to create the prompt, ask clarifying questions before generating the prompt file.
