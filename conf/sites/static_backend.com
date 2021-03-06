server {
    listen       8080;
    server_name  static.com;

    root html;
    #access_log  logs/dev.access.log  main;
    access_log  logs/static.access.log  dev;

    #error_page  404              /404.html;

    location / {
        try_files $uri $uri/  /indexx.php?$args;
        index index.php index.html index.htm;
    }
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;

    location = /50x.html {
        root   html;
    }


    # 静态文件设置过期时间
    location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
        expires max;
        break;
    }

    # 不记录 favicon.ico 错误日志
    location ~ (favicon.ico){
        log_not_found off;
        expires 100d;
        access_log off;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}


    location ~ /\.ht {
        deny  all;
    }

    location ~ /\.git {
        deny  all;
    }

    location ~ /\.svn {
        deny  all;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        include        fastcgi_params;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_index  index.php;
        include        fastcgi_params;
    }
}
