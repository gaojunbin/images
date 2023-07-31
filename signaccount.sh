sudo curl -sS https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker -v
docker-compose -v

sudo systemctl restart docker
cd
mkdir vnc
cd vnc
cat > docker-compose.yml <<EOF
version: '3'

services:
    ubuntu-xfce-vnc:
        container_name: xfce
        image: junbingao/ubuntu-vnc:latest
        shm_size: "6gb"  # 防止高分辨率下Chromium崩溃,如果内存足够也可以加大一点点
        ports:
            - 5900:5900   # TigerVNC的服务端口（保证端口是没被占用的，冒号右边的端口不能改，左边的可以改）
            - 80:6080   # noVNC的服务端口，注意事项同上
        environment: 
            - VNC_PASSWD=1    # 改成你自己想要的密码
            - GEOMETRY=1280x720      # 屏幕分辨率，800×600/1024×768诸如此类的可自己调整
            - DEPTH=16               # 颜色位数16/24/32可用，越高画面越细腻，但网络不好的也会更卡
        restart: unless-stopped
EOF

docker-compose up -d
