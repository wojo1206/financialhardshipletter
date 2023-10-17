#!/bin/bash

PS3='Please enter your choice: '
options=("Validate AWS cloud formation file" "Option 2" "Option 3" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Validate AWS cloud formation file")
            aws cloudformation validate-template --template-body file://aws/template.yaml
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
