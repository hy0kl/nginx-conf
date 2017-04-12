server {
    listen       80;
    server_name  youth.cc;

    charset utf-8;
    root /home/work/dev/app/youth/public;

    access_log  logs/youth.app.access.log  main;

    location / {
        index  index.html index.htm index.php;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    # 不记录 favicon.ico 错误日志
    location ~ (favicon.ico){
        log_not_found off;
        expires 100d;
        access_log off;
        break;
    }

    # 静态文件设置过期时间
    location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
        expires 100d;
        break;
    }

    # 静态文件代理
    location ~ /static/ {
        rewrite "^/static/(.*)$" /static/$1 break;
    }

    location ~ /chart.php {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_param  SCRIPT_FILENAME   /home/work/rd/analyze/chart.php;
        include        fastcgi_params;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #location ~ \.php$ {
    # 其他请求一律单一入口处理
    location ~ / {
        rewrite "^(.*)$" /index.php  break;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
