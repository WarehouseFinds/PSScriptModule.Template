### Automated Maintenance Workflows

Keep your repository clean with automated maintenance:

- **Artifact Cleanup**: Automatically removes artifacts older than 2 days (configurable)
- **Workflow Run Cleanup**: Removes old workflow runs to keep history manageable
- Configurable retention period (default: 2 days)
- Configurable minimum runs to keep (default: 2)
- Separate cleanup for pull requests, pushes, and scheduled runs
- Runs daily at midnight via cron schedule
- Can be triggered manually with custom parameters