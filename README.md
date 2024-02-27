# Question: 
Write a shell script to change the values in a file(i.e sig.conf) according to the input passed to the script. The script should ask for all four inputs from the user & also validate the input.
Below are the details of input. In full bracket options are given, you have to restrict the user pass single value for each input from the provided options in the full bracket.
Input:-
1) Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]
2) Scale [MID/HIGH/LOW]
3) View [Auction/Bid]
4) Count [single digit number]
Explanation of a conf file line.
<view> ; <scale> ; <component name> ; ETL ; vdopia-etl= <count>
Note:- vdopiasample stands for Auction & vdopiasample-bid is for Bid
The script should change the values in the file according to the input provided. At a time only one line of the conf file should be altered.

# Answer
```bash
#!/bin/bash
```
# Function to validate user input for component name
```bash
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
```
# Function to validate user input for scale
```bash
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
```
# Function to validate user input for view
```bash
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
```
# Function to validate user input for count
```bash
validate_count() {
    local count=$1
    if [[ $count =~ ^[0-9]$ ]]; then
        return 0
    else
        return 1
    fi
}
```
# Function to update the configuration file
```bash
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
for ((i=1; i<=3; i++)); do
    echo "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: "
    read component
    if validate_component "$component"; then
        break
    elif [[ $i -eq 3 ]]; then
        echo "Error: Max attempts reached for component name. Exiting."
        exit 1
    else
        echo "Invalid component name. Please choose from INGESTOR, JOINER, WRANGLER, or VALIDATOR."
    fi
done

for ((i=1; i<=3; i++)); do
    echo "Enter Scale [MID/HIGH/LOW]: "
    read scale
    if validate_scale "$scale"; then
        break
    elif [[ $i -eq 3 ]]; then
        echo "Error: Max attempts reached for scale. Exiting."
        exit 1
    else
        echo "Invalid scale. Please choose from MID, HIGH, or LOW."
    fi
done

for ((i=1; i<=3; i++)); do
    echo "Enter View [Auction/Bid]: "
    read view
    if validate_view "$view"; then
        break
    elif [[ $i -eq 3 ]]; then
        echo "Error: Max attempts reached for view. Exiting."
        exit 1
    else
        echo "Invalid view. Please choose from Auction or Bid."
    fi
done

for ((i=1; i<=3; i++)); do
    echo "Enter Count [single digit]: "
    read count
    if validate_count "$count"; then
        break
    elif [[ $i -eq 3 ]]; then
        echo "Error: Max attempts reached for count. Exiting."
        exit 1
    else
        echo "Invalid count. Please enter a single digit."
    fi
done

update_conf_file "$view" "$scale" "$component" "$count"
echo "Conf file updated successfully."
```
