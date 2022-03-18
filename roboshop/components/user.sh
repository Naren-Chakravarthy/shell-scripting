#!/bin/bash


# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
# yum install nodejs gcc-c++ -y
```

#1. Let's now set up the User application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

#So to run the User service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

#```bash
# useradd roboshop
```

#1. So let's switch to the `roboshop` user and run the following commands.

```bash
$ curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/user.zip
$ mv user-main user
$ cd /home/roboshop/user
$ npm install
```

1. Update SystemD service file,

    Update `REDIS_ENDPOINT` with Redis Server IP

    Update `MONGO_ENDPOINT` with MongoDB Server IP

2. Now, lets set up the service with systemctl.

```bash
# mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
# systemctl daemon-reload
# systemctl start user
# systemctl enable user
```