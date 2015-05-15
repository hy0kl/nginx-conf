server {
    listen 80;
    server_name another.com;
    access_log  logs/another.access.log main;

    #server_name_in_redirect off;

    location / {
        index index.html index.php;

        if (!-e $request_filename) {
            rewrite ^/(.*)  /index.php last;
        }
    }

    location ~* ^/status/update_user_status {
        return 403;
    }

    location ~* /conf/ {
        return 404;
    }

    location ~* /application/ {
        return 404;
    }

    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME   $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

}

