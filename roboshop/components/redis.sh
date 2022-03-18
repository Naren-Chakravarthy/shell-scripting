#!/bin/bash

source components/redis.sh


Print "Configuring Yum repos"
curl -f -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
StatCheck $?

Print "Installing Redis"
yum install redis -y &>>$LOG_FILE
StatCheck $?

Print "Update redis listen IP address"
if [ -e /etc/redis.conf ]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
fi
if [ -e /etc/redis/redis.conf ]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
fi
StatCheck $?

Print "Starting Redis Database"
systemctl enable redis &>>$LOG_FILE && systemctl start redis &>>$LOG_FILE
StatCheck $?


