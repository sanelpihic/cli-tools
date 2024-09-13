#!/bin/bash

# Source the color variables from shared/colors.sh
# shellcheck source=/dev/null
source "./shared/colors.sh"

# Define the list of scripts to run
scripts=(
  "installations/homebrew.sh"
  "installations/google.sh"
  "shellconfig/update_shell_config.sh"
)

# Array to hold components that need to be installed
missing_components=()

# Function to check and validate components
validate_component() {
  local name=$1      # Name of the component
  local check_cmd=$2 # Command to check if the component is installed

  if eval "$check_cmd" &>/dev/null; then
    echo -e "${GREEN}$name${NO_COLOR} is already installed."
    return 0 # Return success
  else
    echo -e "${YELLOW}$name${NO_COLOR} is missing."
    return 1 # Return failure
  fi
}

# Function to install components
install_component() {
  local name=$1        # Name of the component
  local check_cmd=$2   # Command to check if the component is installed
  local install_cmd=$3 # Command to install the component

  if ! eval "$check_cmd" &>/dev/null; then
    echo -e "Installing ${YELLOW}$name${NO_COLOR}..."
    eval "$install_cmd"
    echo -e "${GREEN}$name${NO_COLOR} installed!"
  else
    echo -e "${GREEN}$name${NO_COLOR} is already installed."
  fi
}

# Function to run validation for a script
run_validation() {
  local script_name=$1

  if [ -f "$script_name" ]; then
    echo "Running validation for $script_name..."
    # shellcheck source=/dev/null
    source "$script_name"

    # Loop through all defined components in the script
    # shellcheck disable=SC2154
    for component in "${components[@]}"; do
      name=$(echo "$component" | cut -d '|' -f 1)
      check_cmd=$(echo "$component" | cut -d '|' -f 2)

      # Validate the component and collect missing ones
      if ! validate_component "$name" "$check_cmd"; then
        missing_components+=("$component")
      fi
    done

  else
    echo "Error: $script_name not found!"
    exit 1
  fi
}

# Function to install missing components after validation
install_missing_components() {
  for component in "${missing_components[@]}"; do
    name=$(echo "$component" | cut -d '|' -f 1)
    check_cmd=$(echo "$component" | cut -d '|' -f 2)
    install_cmd=$(echo "$component" | cut -d '|' -f 3)

    # Install the component
    install_component "$name" "$check_cmd" "$install_cmd"
  done
}

# Iterate through each script and validate
echo "Validating all components..."
for script in "${scripts[@]}"; do
  run_validation "$script"
done

# Check if there are any missing components
if [ ${#missing_components[@]} -eq 0 ]; then
  echo -e "${GREEN}All components are in order!${NO_COLOR}"
else
  # List missing components
  echo -e "${YELLOW}The following components are missing:${NO_COLOR}"
  for component in "${missing_components[@]}"; do
    name=$(echo "$component" | cut -d '|' -f 1)
    echo -e "${YELLOW}- $name${NO_COLOR}"
  done

  # Ask the user if they want to proceed with installation
  read -r -p "Would you like to install the missing components? (Y/N): " response
  if [[ "$response" == "Y" || "$response" == "y" ]]; then
    install_missing_components
  else
    echo "Installation skipped."
  fi
fi

echo "Script complete!"
