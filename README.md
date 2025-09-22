# Agent Guard Accelerator

Demonstrates proper use of [CyberArk Agent Guard](https://github.com/cyberark/agent-guard) for managing secrets as ephemeral environment variables.

## Key Features Demonstrated

### Ephemeral Environment Variables
- **Scoped Availability**: Environment variables exist only within specified code blocks (via decorator or 'with' statement)
- **Automatic Cleanup**: Variables are automatically removed after block execution
- **Memory Protection**: Sensitive data is cleared from memory
- **Zero Persistence**: No environment pollution or data leakage

### Security Benefits
- **Reduced Attack Surface**: Minimizes time sensitive data exists in environment
- **Process Isolation**: Variables don't leak between function calls
- **Audit Trail**: Clear tracking of when and where variables are used
- **Compliance**: Helps meet security compliance requirements

## Dependencies

- uv or poetry package manager
- Python 3.10 or later
- git and GitHub account

## To run

- ./1-run-demo.sh

## Description

The 1-run-demo.sh script:

- clones the Agent Guard repo
- creates a virtual environment with required packages
- runs the filevars.py demo which shows environment variables exist only during the execution of the myFunc() function.
<br>

The enviroment variable names and values are dynamically retrieved from the .env file. You can change those values as needed. ALL values in the .env file will be retrieved and instantiated, but only for the scope annotated by the @EnvironmentVariablesManager.set_env_vars() decorator.
