#!/bin/bash

set -eou pipefail

# Define components in an array where each component is:
# name|check_command|install_command

export components=(
  "Homebrew|\
    command -v brew|\
    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
)
