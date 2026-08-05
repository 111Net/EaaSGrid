
#!/bin/bash


DOMAIN=$1


certbot --nginx -d $DOMAIN


