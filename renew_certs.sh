domain="-d hust.co \
        -d feis.co"
dir=/root/www/letsencrypt
email="--email phenixzhong@gmail.com"
letsencrypt certonly --webroot -w ${dir}  ${email} --agree-tos ${domain} --force-renew

cp -f /etc/letsencrypt/live/hust.co/fullchain.pem /root/www/ssl/
cp -f /etc/letsencrypt/live/hust.co/privkey.pem /root/www/ssl/
rm /root/www/ssl/sct/*
/root/tools/ct-submit/ct-submit ct.googleapis.com/aviator </root/www/ssl/fullchain.pem >/root/www/ssl/sct/aviator.sct

nginx -s reload
