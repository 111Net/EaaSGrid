
#!/bin/bash


apt update


apt install -y nginx certbot python3-certbot-nginx


certbot --nginx \
-d xaasgrid.example.com


