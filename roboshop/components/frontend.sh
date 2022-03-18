#!/bin/bash

source components/common.sh

Print "installing nginx"
yum install nginx -y &>>$LOG_FILE
StatCheck $?


Print "Starting the nginx"
systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE
StatCheck $?


Print "Downloading the nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatCheck $?


Print "Cleanup old nginx content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/


Print "Extracting and Archive"
unzip /tmp/frontend.zip &>>$LOG_FILE && mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE
StatCheck $?


Print "Update Roboshop Configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
StatCheck $?


Print "Restarting the nginx"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE
StatCheck $?

