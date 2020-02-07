apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update

apt-get install certbot python-certbot-nginx

apt-get install python3-certbot-dns-cloudflare
