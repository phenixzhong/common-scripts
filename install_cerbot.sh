apt-get update
apt-get install software-properties-common -y
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update

apt-get install certbot python-certbot-nginx -y

apt-get install python3-certbot-dns-cloudflare -y
