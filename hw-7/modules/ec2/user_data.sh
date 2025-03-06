#!/bin/bash

echo "1 - $(date) test" >> /home/ubuntu/tmp.log

echo 'export PS1="\n\e[0;33m\e[4m\w : \u@\H : \d \t\e[24m \e[m\e[0;91m\n"' >> ~/.bashrc
echo 'trap "tput sgr0"  DEBUG' >> ~/.bashrc

sudo apt update
sudo apt install -y mc dnsutils git
sudo apt install -y nginx certbot python3-certbot-nginx 

# certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/selfsigned.key \
  -out /etc/ssl/certs/selfsigned.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=$PUBLIC_DNS"

# nginx
echo '${nginx_config}' | sudo tee /etc/nginx/sites-available/default > /dev/null
PUBLIC_IP=$(curl -s ident.me)
PUBLIC_DNS=$(nslookup $PUBLIC_IP | awk '/name = / {print $4}' | sed 's/\.$//')
sudo sed -i "s|^\s*server_name .*|    server_name $PUBLIC_DNS;|" /etc/nginx/sites-available/default
echo "2 - $(date) PUBLIC_DNS: $PUBLIC_DNS" >> /home/ubuntu/tmp.log
sudo systemctl restart nginx

# connect to mysql
echo export MYSQL_USER=admin > /etc/profile.d/mysql_env.sh
echo export MYSQL_PASSWORD=${mysql_password} >> /etc/profile.d/mysql_env.sh
echo export MYSQL_DB=${mysql_db} >> /etc/profile.d/mysql_env.sh
echo export MYSQL_HOST= >> /etc/profile.d/mysql_env.sh
echo export FLASK_CONFIG=${flask_config} >> /etc/profile.d/mysql_env.sh
sudo chmod +x /etc/profile.d/mysql_env.sh
RDS_HOST=$(echo "${rds_endpoint}" | cut -d':' -f1)
sudo sed -i "s|^export MYSQL_HOST=.*|export MYSQL_HOST=$RDS_HOST|" /etc/profile.d/mysql_env.sh

echo "3 - $(date) END_POINT: ${rds_endpoint}" >> /home/ubuntu/tmp.log
echo "4 - $(date) RDS_HOST: $RDS_HOST" >> /home/ubuntu/tmp.log

# flask
sudo apt install -y python3-pip default-libmysqlclient-dev build-essential pkg-config python3-venv
git clone https://github.com/saaverdo/flask-alb-app -b alb
cd flask-alb-app
sudo python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
source /etc/profile.d/mysql_env.sh
gunicorn -b 0.0.0.0 app:app &