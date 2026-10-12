## Local Environment & User Preferences

### Development Environment Context
- This machine runs local **PostgreSQL** and **Redis** services. Treat them as local development environments, NOT production servers.

### Communication & Reporting Style
- **Be Short but Useful** in all reports, summaries, and responses. Avoid unnecessary fluff.

### Project Conventions
- **Consistency & DRY**: Always inspect existing project files to identify and follow existing architectural patterns, naming schemes, and code style.
- Record any newly discovered conventions or corrected mistakes into project memory / notes for continuity.

### Destructive Action Guardrails
Always ask for explicit user confirmation before executing potentially destructive actions unless specifically requested by the user:
- Deleting or overwriting critical files or tables.
- Running destructive database migrations or seed scripts that drop/reset data.
- Force-pushing (`git push -f`) or hard-resetting branches.
- Killing active background services.
