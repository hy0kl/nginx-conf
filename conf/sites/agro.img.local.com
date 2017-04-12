server {
    listen       80;
    server_name  agro.img.local.com;
    root         html/agrovips/public;
    index index.html index.htm index.php;

    access_log logs/img.access.log;
    error_log  logs/img.error.log;


    location /images {
        # 如果访问的是图片,直接返回
        if (-e $request_filename) {
            rewrite "^/images/(.*)$" /images/$1 break;
        }

        #default_type "text/html";
        #default_type "image/jpeg";

        #echo $uri;
        # uri: /images/thb2/e12/e1200cb72f778bdad4210814463e6e86.png/220x246
        if ($uri ~ "/images/([a-zA-Z0-9]+)/([a-zA-Z0-9]+)/([a-zA-Z0-9.]+)/([a-zA-Z0-9]+)") {
            #echo "$uri <br />$1 $2 $3 $4 $5";
            set $image_path "$document_root/images";
            set $thumb_image_subdir "$1/$2/$4";
            set $image_dir  "$image_path/$thumb_image_subdir";
            set $image_name "$3";
            set $image_size "$4";
            set $image_type "$2";
            set $file "$image_path/$thumb_image_subdir/$image_name";
            set $original   "$image_path/$1/$2/$3";
            set $rewrite_uri "/thumb/$thumb_image_subdir/$image_name";
        #}

        #if (!-f $file) {
            # 关闭lua代码缓存，方便调试lua脚本
            #content_by_lua "ngx.say('hit images');ngx.exit(404)";
            #lua_code_cache off;
            #content_by_lua_file "lua/images.lua";
            rewrite_by_lua_file "lua/images.lua";
        }
    }

    location /thumb {
        rewrite "^/thumb/(.*)$" /images/$1 break;
    }

    ## 不记录 favicon.ico 错误日志
    location ~ (favicon.ico){
        log_not_found off;
        expires 100d;
        access_log off;
    }
}

