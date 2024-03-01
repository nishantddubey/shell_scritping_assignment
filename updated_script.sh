#!/bin/bash

# Function to validate user input for component name
validate_component() {
    local component=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    case $component in
        ingestor|joiner|wrangler|validator)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to validate user input for scale
validate_scale() {
    local scale=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    case $scale in
        mid|high|low)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to validate user input for view
validate_view() {
    local view=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    case $view in
        auction|bid)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to validate user input for count
validate_count() {
    local count=$1
    if [[ $count =~ ^[0-9]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to update the configuration file
update_conf_file() {
    local view=$1
    local scale=$2
    local component=$3
    local count=$4

    local view_keyword="vdopiasample"
    if [[ "${view,,}" == "bid" ]]; then
        view_keyword="vdopiasample-bid"
    fi

    # Construct the configuration line with variable values
    local config_line="$view_keyword ; $scale ; $component ; ETL ; vdopia-etl= $count"

    # Append the configuration line to the end of the file
    echo "$config_line" > sig.conf

    # Check if the echo command succeeded
    if [ $? -eq 0 ]; then
        echo "Conf line appended successfully."
    else
        echo "Error: Failed to append conf line."
        exit 1
    fi
}

# Main script starts here
while getopts ":c:s:v:n:" opt; do
    case $opt in
        c)
            component=$OPTARG
            ;;
        s)
            scale=$OPTARG
            ;;
        v)
            view=$OPTARG
            ;;
        n)
            count=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Validate component name
if ! validate_component "$component"; then
    echo "Error: Invalid component name. Please choose from INGESTOR, JOINER, WRANGLER, or VALIDATOR."
    exit 1
fi

# Validate scale
if ! validate_scale "$scale"; then
    echo "Error: Invalid scale. Please choose from MID, HIGH, or LOW."
    exit 1
fi

# Validate view
if ! validate_view "$view"; then
    echo "Error: Invalid view. Please choose from Auction or Bid."
    exit 1
fi

# Validate count
if ! validate_count "$count"; then
    echo "Error: Invalid count. Please enter a single digit."
    exit 1
fi

update_conf_file "$view" "$scale" "$component" "$count"
echo "Conf file updated successfully."
