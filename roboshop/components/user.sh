#!/bin/bash

source components/common.sh

Print "Setup Yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
StatusCheck $?


Print "Installing NodeJS "
yum install nodejs gcc-c++ -y &>>$LOG_FILE
StatusCheck $?

Print "Adding Application user"
id $APP_USER &>>$LOG_FILE
if [ "$?" -ne 0 ]; then
useradd $APP_USER &>>$LOG_FILE
fi
StatusCheck $?

Print "Downloading the app content"
curl -f -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
StatusCheck $?

Print "Cleanup old content"
rm -rf /home/$APP_USER/user &>>$LOG_FILE
StatusCheck $?

Print "extract app content"
cd /home/$APP_USER &>>$LODG_FILE && unzip /tmp/user.zip &>>$LOG_FILE && mv user-main user &>>$LOG_FILE
StatusCheck $?

Print "Installing npm content"
cd /home/roboshop/user &>>$LOG_FILE && npm install &>>$LOG_FILE
StatusCheck $?


Print "Fixing the permissions"
chown -R $APP_USER:$APP_USER /home/$APP_USER
StatCheck $?

Print "Setup systemd file"
sed -i -e 's/REDIS_ENDPOINT/user.roboshop.internal/' /home/$APP_USER/user/systemd.service &>>$LOG_FILE
sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APP_USER/mongodb/systemd.service &>>$LOG_FILE


#1. Update SystemD service file,
#   Update `REDIS_ENDPOINT` with Redis Server IP

#  Update `MONGO_ENDPOINT` with MongoDB Server IP
# mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
# systemctl daemon-reload
# systemctl start user
# systemctl enable user
