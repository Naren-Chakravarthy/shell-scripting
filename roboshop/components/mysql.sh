#!/bin/bash

source components/common.sh

Print "Setup MySQL Repo"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatCheck $?

Print "Install MySQL"
yum install mysql-community-server -y &>>$LOG_FILE
StatCheck $?

Print "Start MySQL"
systemctl enable mysqld &>>$LOG_FILE && systemctl start mysqld &>>$LOG_FILE
StatCheck $?

echo 'show databases' | mysql -uroot -pRoboshop@1 &>>$LOG_FILE
if [ "$?" -ne 0 ]; then
Print "Change default root password"
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1');" >/tmp/rootpass.sql
DEFAULT_ROOT_PASSWORD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}') &>>$LOG_FILE
mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql
StatCheck $?
fi

echo show plugins | mysql -uroot -pRoboshop@1 2>>$LOG_FILE | grep validate_password
if [ "$?" -eq 0 ]; then
Print "Uninstall password validate plugin"
echo 'uninstall plugin validate_password;' >>/tmp/pass-validate.sql
mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql
StatCheck $?
fi


#Now a default root password will be generated and given in the log file
# grep temp /var/log/mysqld.log


#1. Next, We need to change the default root password in order to start using the database service. Use password `RoboShop@1` or any other as per your choice. Rest of the options you can choose `No`


# mysql_secure_installation


#You can check the new password working or not using the following command in MySQL

#First lets connect to MySQL
# mysql -uroot -pRoboShop@1


#Once after login to MySQL prompt then run this SQL Command.

#> uninstall plugin validate_password;

## **Setup Needed for Application.**


# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"


#Load the schema for Services.


# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql
