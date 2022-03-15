#!/bin/bash

## Conditions
## if forms
# 1.simple if
# syntax if ["expression"]
# then
# commands
# fi

if [ 1 -eq 1 ]
then
echo "Hello"
fi
##expressions are important
#string tests
# operators: ==, !=, -z
# number tests
# operators: -eq, -ne, -lt, -le, -gt, -ge
# file tests
# operators: https://tldp.org/LDP/abs/html/fto.html
# -e--- to check file exists or not



a=naren
if [ "$a" == naren ]; then
  echo "Botha are equal"
fi

if [ "$b" != naren ]; then
  echo "Both are not equal"
fi

if [ -z "$b" ]; then
  echo b variable is empty
fi

# 2.if else
# syntax
# if [ expression ]; then
# commands
# else
# commands
# fi

a=naren
if [ "$a" == naren ]; then
  echo "Botha are equal"
else
  echo "Both are not equal"
fi


# 3.else if
# if [ expression1 ]; then
# commands
# elif [ expression2 ]; then
# commands
# elif [ expression3 ]: then
# commands
# else
# commands
# fi

echo -e "\e[31mConditions practice\e[0m"
id=0
if [ "$id -eq 0" ]; then
  echo -e "\e[32m installed successfully \e[0m"
  else
    echo -e "\e[32m installation failure \e[0m"
    exit
    fi


