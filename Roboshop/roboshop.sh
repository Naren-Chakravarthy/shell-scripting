#!/bin/bash

if [  -e components/$1.sh ]; then
echo "component frontend exist"
exit
fi



bash components/$1.sh
