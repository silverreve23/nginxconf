server {
    listen 80;
    listen [::]:80;

    root /home/sbk/Documents/web/${file}/public;

    index index.php index.html index.htm index.nginx-debian.html;

    server_name ${file}.io;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
