#!/bin/bash

source components/common.sh

COMPONENT=dispatch

Print "Installing GoLang"
 yum install golang -y &>>$LOG_FILE
 StatCheck $?

APP_SETUP

Print "Intilization of dispatch service"
 go mod init dispatch &>>$LOG_FILE
 go get &>>$LOG_FILE
 go build &>>$LOG_FILE
 StatCheck $?




# Update the systemd file and configure the dispatch service in systemd