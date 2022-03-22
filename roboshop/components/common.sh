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

APP_SETUP() {
  Print "Adding Application user"
    id $APP_USER &>>$LOG_FILE
    if [ "$?" -ne 0 ]; then
    useradd $APP_USER &>>$LOG_FILE
    fi
    StatCheck $?

   Print "Downloading the app content"
    curl -f -s -L -o /tmp/$COMPONENT.zip "https://github.com/$APP_USER-devops-project/$COMPONENT/archive/main.zip" &>>$LOG_FILE
    StatCheck $?

    Print "Cleanup old content"
    rm -rf /home/$APP_USER/$COMPONENT &>>$LOG_FILE
    StatCheck $?

    Print "extract app content"
    cd /home/$APP_USER &>>$LOG_FILE && unzip -o /tmp/$COMPONENT.zip &>>$LOG_FILE && mv $COMPONENT-main $COMPONENT &>>$LOG_FILE
    cd /home/$APP_USER/$COMPONENT &>>$LOG_FILE
    StatCheck $?
}

SERVICE_SETUP() {

    Print "Fixing the permissions"
    chown -R $APP_USER:$APP_USER /home/$APP_USER
    StatCheck $?

    Print "Setup systemd file"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
           -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
           -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
           -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
           -e 's/CARTENDPOINT/cart.roboshop.internal/' \
           -e 's/DBHOST/mysql.roboshop.internal/' \
           -e 's/CARTHOST/cart.roboshop.internal/' \
           -e 's/USERHOST/user.roboshop.internal/' \
           -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
            /home/$APP_USER/$COMPONENT/systemd.service &>>$LOG_FILE && mv /home/$APP_USER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG_FILE
    StatCheck $?

    Print "Restart $COMPONENT service"
    systemctl daemon-reload &>>$LOG_FILE && systemctl start $COMPONENT &>>$LOG_FILE && systemctl enable $COMPONENT &>>$LOG_FILE
    StatCheck $?
}
#FUNCTION
NODEJS(){
  Print "Configure Yum repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
  StatCheck $?


  Print "Installing NodeJS"
  yum install nodejs gcc-c++ -y &>>$LOG_FILE
  StatCheck $?

  APP_SETUP

  Print "Installing npm content"
  npm install &>>$LOG_FILE
  StatCheck $?

  SERVICE_SETUP
}

MAVEN() {

  Print "Install maven"
  yum install maven -y &>>$LOG_FILE
  StatCheck $?

  APP_SETUP

  Print "maven packaging"
  cd /home/$APP_USER/$COMPONENT &>>$LOG_FILE && mvn clean package &>>$LOG_FILE && mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
  StatCheck $?

  SERVICE_SETUP
}

PYTHON() {

Print "Installing Python"
yum install python36 gcc python3-devel -y &>>$LOG_FILE
StatCheck $?

APP_SETUP

Print "Install python dependencies"
cd /home/$APP_USER/$COMPONENT &>>$LOG_FILE && pip3 install -r requirements.txt &>>$LOG_FILE
StatCheck $?

SERVICE_SETUP
}










