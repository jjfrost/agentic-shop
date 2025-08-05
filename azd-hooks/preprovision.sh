# Exit on error
set -e

# Function to prompt and read input for Azure Container Apps deployment
check_for_deployment() {
    local input
    while true; do
        read -rp "Do you want to deploy Azure Container Apps? (y/n): " input
        # input="${input,,}"  # Convert to lowercase
        input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

        case "$input" in
            y|yes)
                DEPLOY_APPS=true
                azd env set "DEPLOY_AZURE_CONTAINERAPPS" $DEPLOY_APPS
                break
                ;;
            n|no)
                DEPLOY_APPS=false
                azd env set "DEPLOY_AZURE_CONTAINERAPPS" $DEPLOY_APPS
                break
                ;;
            *)
                echo "Invalid input. Please enter 'y', 'yes', 'n', or 'no'."
                ;;
        esac
    done
}

# Call the function
check_for_deployment

if [ "$DEPLOY_APPS" = "false" ]; then
    # Run azd auth login --check-status and capture the output
    userOutput=$(azd auth login --check-status)

    # Extract the first email address found in the output
    # In case some users may have multiple Entra ID principals associated to their logged in account.
    # It takes the string of the return text of the command and
    # extracts the first email address it finds in the string.

    email="$(printf '%s\n' "$userOutput" \
    | grep --color=never -Eo '[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}' \
    | head -n1)"

    if echo "$email" | grep --color=never -Eq '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'; then
        export AZURE_PRINCIPAL_NAME="$email"

        echo "Extracted email: $AZURE_PRINCIPAL_NAME"

        # Persist into azd environment
        azd env set "AZURE_PRINCIPAL_NAME" "$AZURE_PRINCIPAL_NAME"

        echo "User Principal Name Set: $AZURE_PRINCIPAL_NAME"
    else
        echo "ERROR: No email address found in azd auth output." >&2
        exit 1
    fi
fi
