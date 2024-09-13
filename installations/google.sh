#!/bin/bash

set -eou pipefail

# Define components in an array where each component is:
# name|check_command|install_command

export components=(
  "Google Cloud SDK|\
    brew list --cask | grep -q 'google-cloud-sdk'|\
    brew install --cask google-cloud-sdk"

  "pip|\
    python3 -m pip --version|\
    brew install python"

  "NumPy|\
    python3 -c 'import numpy'|\
    python3 -m pip install numpy"
)
