server {
    listen       80;
    server_name  dev.cc;

    root /home/work/nginx/html;
    access_log  logs/dev.access.log  main;


    location / {
        index index.php index.html index.htm;

        # 对 IE 进行限速
        if ($http_user_agent ~ "MSIE") {
            limit_rate 1k;
        }
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    # 静态文件代理
    location ~ /static/ {
        rewrite "^/static/(.*)$" /static/$1 break;
    }

    # 不记录 favicon.ico 错误日志
    location ~ (favicon.ico){
        log_not_found off;
        expires 100d;
        access_log off;
    }

    # 静态文件设置过期时间
    location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
        expires max;
        break;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        include        fastcgi_params;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_param  SCRIPT_FILENAME  $document_root/$fastcgi_script_name;
        fastcgi_index  index.php;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}