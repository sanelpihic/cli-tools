#!/bin/bash

set -eou pipefail

# Define components in an array where each component is:
# name|check_command|install_command

export components=(
  "CLOUDSDK_PYTHON_SITEPACKAGES in .bashrc|\
    grep -q 'CLOUDSDK_PYTHON_SITEPACKAGES=1' ~/.bashrc|\
    echo -e '\n# Added by cli-tools for gcloud tunnels\nexport CLOUDSDK_PYTHON_SITEPACKAGES=1' >> ~/.bashrc"

  "CLOUDSDK_PYTHON_SITEPACKAGES in .zshrc|\
    grep -q 'CLOUDSDK_PYTHON_SITEPACKAGES=1' ~/.zshrc|\
    echo -e '\n# Added by cli-tools for gcloud tunnels\nexport CLOUDSDK_PYTHON_SITEPACKAGES=1' >> ~/.zshrc"
)
