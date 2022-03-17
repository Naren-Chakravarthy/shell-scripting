#!/bin/bash

source components/common.sh

Print "Setup mongodb repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
StatCheck $?

Print "Installing mongodb"
yum install -y mongodb-org &>>$LOG_FILE
StatCheck $?

Print "Starting the mongodb"
systemctl enable mongod &>>$LOG_FILE && systemctl start mongod &>>$LOG_FILE
StatCheck $?

Print "Update mongodb listen IP Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

Print "Restarting the mongodb"
systemctl restart mongod &>>$LOG_FILE
StatCheck $?


Print "Downloading the schema and load it"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatCheck $?





