# get all the python files as a list
py_files=$(find ./src -type f -name "*.py")
issues_found="false"
printf "\nChecking for Errors and Warnings in the Code.........\n"

for file in $py_files; do
    if [ $(basename $file) != "__init__.py" ]; then
        # pylint results
        printf "\n\n------------------------------------------------------------------"
        printf "\nPylint Checking..................$(basename $file)"
        result=$(poetry run pylint $file)
        if [ ! -z "$result" ]; then
            issues_found="true"
            printf "\nIssues...........................\e[41mFound\e[0m"
            printf "\n------------------------------------------------------------------"
            printf "\n$result"
            printf "\n------------------------------------------------------------------"
        else
            printf "\nIssues...........................\e[42mNot Found\e[0m"
            printf "\n------------------------------------------------------------------"
        fi
        # flake8 results
        printf "\n\n------------------------------------------------------------------"
        printf "\nFlake8 Checking..................$(basename $file)"
        result=$(poetry run flake8 $file --show-source)
        if [ ! -z "$result" ]; then
            issues_found="true"
            printf "\nIssues...........................\e[41mFound\e[0m"
            printf "\n------------------------------------------------------------------"
            printf "\n$result"
        else
            printf "\nIssues...........................\e[42mNot Found\e[0m"
            printf "\n------------------------------------------------------------------"
        fi
        # black results
        printf "\n\n------------------------------------------------------------------"
        printf "\nBlack Checking..................$(basename $file)"
        printf "\n------------------------------------------------------------------\n"
        result=$(poetry run black --check $file)
        printf "\n------------------------------------------------------------------\n\n"
    fi
done

if [ "$issues_found" = "true" ]; then
    printf "\nIssues Found in your code...\nPlease format your code based on the above suggestions given..."
    exit 1
fi
