#!/usr/bin/env python3
import json
import re
import sys

# High-risk patterns to strictly deny
DENIED_PATTERNS = [
    (r"\brm\s+-[rR]f\s+/\s*$", "Destructive root deletion blocked"),
    (r"\brm\s+-[rR]f\s+/\*", "Destructive root deletion blocked"),
    (r"\brm\s+-[rR]f\s+~\s*$", "Destructive home directory deletion blocked"),
    (r"\brm\s+-[rR]f\s+~/\*", "Destructive home directory deletion blocked"),
    (r":\(\)\s*\{\s*:\s*\|\s*:\s*&\s*\}\s*;\s*:", "Fork bomb blocked"),
    (r"\bsudo\b", "Sudo execution blocked in automated commands"),
]

# Patterns that require explicit interactive confirmation
ASK_PATTERNS = [
    (r"\bgit\s+push\b", "Git push requires interactive user confirmation"),
    (r"\bdrop\s+database\b", "Database drop requires user confirmation"),
    (r"\btruncate\s+table\b", "Table truncate requires user confirmation"),
]


def evaluate_command(command_line: str):
    cmd = command_line.strip()

    for pattern, reason in DENIED_PATTERNS:
        if re.search(pattern, cmd, re.IGNORECASE):
            return {"decision": "deny", "reason": reason}

    for pattern, reason in ASK_PATTERNS:
        if re.search(pattern, cmd, re.IGNORECASE):
            return {"decision": "force_ask", "reason": reason}

    return {"decision": "allow"}


def main():
    try:
        raw_input = sys.stdin.read()
        if not raw_input:
            print(json.dumps({"decision": "allow"}))
            return

        payload = json.loads(raw_input)
        tool_call = payload.get("toolCall", {})
        args = tool_call.get("args", {})
        command_line = args.get("CommandLine", "")

        result = evaluate_command(command_line)
        print(json.dumps(result))
    except Exception as e:
        # Fallback safely without crashing the agent
        print(json.dumps({"decision": "allow", "reason": f"Hook error fallback: {str(e)}"}))


if __name__ == "__main__":
    main()
