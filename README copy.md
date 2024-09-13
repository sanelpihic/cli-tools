# CLI Tools

This repository contains shell scripts to help developers/DevOps configure their local development environments. 

The scripts automate the installation of necessary tools like Homebrew, Google Cloud SDK, and NumPy, and configures environment variables for Google Cloud IAP tunnels.

## Available Scripts

### `cli-setup.sh`
This script runs all the necessary setup scripts in sequence to install tools and configure your environment.
#### This script will only install what is missing, and will also prompt you before it does that!

#### What it does:
- Installs Homebrew (if not already installed).
- Installs Google Cloud SDK, pip and NumPy.
- Updates your shell files (`.bashrc` and `.zshrc`) for Google Cloud IAP tunneling support.

## Usage:

Run the following command in the repository root:

```bash
./cli-setup.sh
```

The output will show you what is missing, press Y to allow it to install missing commponents.

## How to add new components

`cli-setup.sh` is the caller script.

It will call on the other sub-scripts included in this array:
```bash
scripts=(
  "installations/homebrew.sh"
  "installations/google.sh"
  "shellconfig/update_shell_config.sh"
)
```

The sub-scripts declare our components and should only be structured in this way:

```bash
# Define components in an array where each component is:
# name|check_command|install_command

export components=(
  "Homebrew|\
    command -v brew|\
    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
)

# "Homebrew" is the name of the component.
# "command -v brew" checks if the Homebrew package manager is installed.
# "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" installs Homebrew by running the official installation script if it isn't already installed.
```
- name: Represents the name or identifier of the component (e.g., “Homebrew”).
- check_command: The command that checks if the component is already installed or available on the system (e.g., command -v brew checks if the brew command exists).
- install_command: The command used to install the component if it’s not already present (e.g., the Homebrew installation command executed via a shell script).

### Adding a new component

If the new component is related to any of the existing components inside one of the existing sub-scripts (e.g. it's part of the google cloud toolset), then you can extend the list of components inside that sub-script.

If the new component(s) can be categorized in a new sub-script, create a new sub-script and then add it to the list of scripts inside `cli-setup.sh`.