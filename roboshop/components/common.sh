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

APP_USER=roboshop

#FUNCTION
NODEJS(){
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
  curl -f -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
  StatCheck $?

  Print "Cleanup old content"
  rm -rf /home/$APP_USER/$COMPONENT &>>$LOG_FILE
  StatCheck $?

  Print "extract app content"
  cd /home/$APP_USER &>>$LOG_FILE && unzip -o /tmp/$COMPONENT.zip &>>$LOG_FILE
  mv $COMPONENT-main $COMPONENT &>>$LOG_FILE
  StatCheck $?

  Print "Installing npm content"
  cd /home/roboshop/$COMPONENT &>>$LOG_FILE && npm install &>>$LOG_FILE
  StatCheck $?


  Print "Fixing the permissions"
  chown -R $APP_USER:$APP_USER /home/$APP_USER
  StatCheck $?

  Print "Setup systemd file"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APP_USER/$COMPONENT/systemd.service &>>$LOG_FILE
  sed -i -e 's/REDIS_ENDPOINT/user.roboshop.internal/' /home/$APP_USER/$COMPONENT/systemd.service &>>$LOG_FILE
  sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APP_USER/$COMPONENT/systemd.service &>>$LOG_FILE
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/$APP_USER/$COMPONENT/systemd.service &>>$LOG_FILE
  sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/$APP_USER/$COMPONENT/systemd.service &>>$LOG_FILE
  mv /home/$APP_USER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG_FILE
  StatCheck $?

  Print "Restart $COMPONENT service"
  systemctl daemon-reload &>>$LOG_FILE && systemctl start $COMPONENT &>>$LOG_FILE && systemctl enable $COMPONENT &>>$LOG_FILE
  StatCheck $?
}
