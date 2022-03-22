#!/bin/bash
a=10
while [ $a -gt 0  ]; do
  echo iteration -$a
  a=$(($a-1))
done

for names in naren chakri geetha; do
  echo name is $names

done