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

a=naren
if [ "$a" == naren ]; then
  echo "Botha are equal"
fi

if [ "$a" != naren ]; then
  echo "Both are not equal"
fi

if [ -z "$b" ]; then
  echo b variable is empty
fi

# 2.if else
# syntax if
# else if
