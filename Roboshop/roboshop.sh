#!/bin/bash

if [ ! -e components/$1.sh ]; then
echo "component does not exist"
fi



bash components/$1.sh
