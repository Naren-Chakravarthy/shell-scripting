#!/bin/bash
StatCheck() {
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\n-----------------$1-------------------" &>>$LOG_FILE
  echo -e "\e[36m "$1" \e[0m"
}
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo You should run your script as a root or sudo user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

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
StatCheck $?


Print "Restarting the nginx"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE
StatCheck $?

