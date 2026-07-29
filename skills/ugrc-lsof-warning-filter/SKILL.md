---
name: ugrc-lsof-warning-filter
description: Use this to filter out noisy `lsof` warnings when starting Firebase emulators
---

I’m seeing lots of `lsof` warnings in my terminal when I start the Firebase emulators in this project. Please:

1. Inspect the project to find every existing `firebase emulators:start` invocation, especially in `package.json` scripts.
2. Create a bash script wrapper that starts the emulators but filters out only the noisy `lsof`-related warnings from stderr, similar to this pattern:

```bash
#!/bin/bash

# Keep Firebase emulator output intact while filtering noisy macOS lsof warnings.
args=()

for arg in "$@"; do
  if [[ "$arg" != "--" ]]; then
    args+=("$arg")
  fi
done

firebase emulators:start "${args[@]}" 2> >(grep -Ev 'lsof|Output information may be incomplete|assuming "dev=.*" from mount table' >&2)
```

3. Preserve the exact Firebase CLI arguments already used by this project so no existing functionality is lost.
4. Replace the direct Firebase emulator CLI calls in `package.json` with calls to the new script.
5. Make the smallest change possible and keep the project’s existing style and structure.
6. Validate the result with a focused check, preferably by verifying the script syntax and confirming the updated package scripts still invoke Firebase correctly without changing their behavior.
7. Tell me exactly what changed and note any caveats.

If the project uses multiple emulator commands with different flags, the script should support forwarding those arguments correctly.
If needed, place the script in a sensible repo location like `scripts/firebase-emulators.sh`.
