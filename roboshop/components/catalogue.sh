#!/bin/bash

source components/common.sh

Print "Configure Yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
StatCheck $?

Print"Installing NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
StatCheck $?


