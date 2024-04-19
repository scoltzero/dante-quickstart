#!/bin/bash

# 请求用户输入容器名称和外部端口
echo "Please enter the container name:"
read CONTAINER_NAME
echo "Please enter the external port to be used (internal is 1080):"
read EXTERNAL_PORT

# 定义使用的Docker镜像名称
IMAGE_NAME="wernight/dante"

# 创建Docker容器
docker run -d -p ${EXTERNAL_PORT}:1080 --name ${CONTAINER_NAME} ${IMAGE_NAME}

# 确保容器已经运行起来
sleep 5

# 修改/etc/sockd.conf中的第66行和第177行
docker exec ${CONTAINER_NAME} sed -i -e '66s/socksmethod: username none/socksmethod: username/' -e '177s/#socksmethod: username/socksmethod: username/' /etc/sockd.conf

# 更改sockd用户的密码
echo "Please enter a new password for the 'sockd' user:"
read -s NEW_PASSWORD
echo -e "$NEW_PASSWORD\n$NEW_PASSWORD" | docker exec -i ${CONTAINER_NAME} passwd sockd

# 输出修改后的第66行和第177行确认更改，并输出创建成功的信息
echo "Modifications applied to sockd.conf:"
docker exec ${CONTAINER_NAME} sed -n -e '66p' -e '177p' /etc/sockd.conf
echo "Container '${CONTAINER_NAME}' and user setup successfully!"
