#!/bin/bash

source components/common.sh

Print "Configure Yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
StatCheck $?

Print"Installing NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
StatCheck $?

Print"Add application user"
useradd $APP_USER &>>$LOG_FILE
StatCheck $?

Print "Download app Component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
StatCheck $?

Print"Cleanup old content"
rm -rf /home/roboshop/catalogue &>>$LOG_FILE
StatCheck $?

Print "Extract app Content"
cd /home/roboshop &>>$LOG_FILE && unzip -o /tmp/catalogue.zip &>>$LOG_FILE && mv catalogue-main catalogue &>>$LOG_FILE
StatCheck $?

Print "Install app Dependencies"
cd /home/roboshop/catalogue &>>$LOG_FILE && npm install &>>$LOG_FILE
StatCheck $?
