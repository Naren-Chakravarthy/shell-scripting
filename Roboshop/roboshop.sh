#!/bin/bash

if [  -e components/$1.sh ]; then
echo -e "\e[32m component exist \e[0m"
else
echo -e "\e[31m component not exist \e[0m"
exit
fi



bash components/$1.sh