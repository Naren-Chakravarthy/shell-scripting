#!/bin/bash

source components/common.sh

Print "Configure Yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
StatCheck $?


Print "Installing NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
StatCheck $?

Print "Adding Application user"
id $APP_USER &>>$LOG_FILE
if [ "$?" -ne 0 ]; then
useradd $APP_USER &>>$LOG_FILE
fi
StatCheck $?

Print "Downloading the app content"
curl -f -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
StatCheck $?

Print "Cleanup old content"
rm -rf /home/$APP_USER/user &>>$LOG_FILE
StatCheck $?

Print "extract app content"
cd /home/$APP_USER &>>$LOG_FILE && unzip /tmp/user.zip &>>$LOG_FILE && mv user-main user &>>$LOG_FILE
StatCheck $?

Print "Installing npm content"
cd /home/roboshop/user &>>$LOG_FILE && npm install &>>$LOG_FILE
StatCheck $?


Print "Fixing the permissions"
chown -R $APP_USER:$APP_USER /home/$APP_USER
StatCheck $?

Print "Setup systemd file"
sed -i -e 's/REDIS_ENDPOINT/user.roboshop.internal/' /home/$APP_USER/user/systemd.service &>>$LOG_FILE
sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APP_USER/user/systemd.service &>>$LOG_FILE
mv /home/$APP_USER/user/systemd.service /etc/systemd/system/user.service &>>$LOG_FILE
StatCheck $?

Print "Restart user service"
systemctl daemon-reload &>>$LOG_FILE && systemctl start user &>>$LOG_FILE && systemctl enable user &>>$LOG_FILE
StatCheck $?


