#!/bin/bash
echo -e "\e[36m Installing nginx \e[0m "
yum install nginx -y


echo -e "\e[36m Starting the nginx \e[0m "
systemctl enable nginx
systemctl start nginx


echo -e "\e[36m Downloading the nginx content \e[0m "
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"


echo -e "\e[36m Cleanup old nginx content and extract new downloaded archive \e[0m "
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf


echo -e "\e[36m Restarting the nginx \e[0m "
systemctl restart nginx
systemctl enable nginx

