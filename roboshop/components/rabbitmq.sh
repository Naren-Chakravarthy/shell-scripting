#!/bin/bash

source components/common.sh

Print "Installing Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG_FILE
StatCheck $?

Print "Setup YUM repositories for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
StatCheck $?

Print "Install RabbitMQ"
yum install rabbitmq-server -y &>>$LOG_FILE
StatCheck $?

Print "Start RabbitMQ"
systemctl enable rabbitmq-server &>>$LOG_FILE && systemctl start rabbitmq-server &>>$LOG_FILE
StatCheck $?




#RabbitMQ comes with a default username / password as `guest`/`guest`. But this user cannot be used to connect. Hence we need to create one user for the application.

#1. Create application user


# rabbitmqctl add_user roboshop roboshop123
# rabbitmqctl set_user_tags roboshop administrator
# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


#Ref link : [https://www.rabbitmq.com/rabbitmqctl.8.html#User_Management](https://www.rabbitmq.com/rabbitmqctl.8.html#User_Management)

