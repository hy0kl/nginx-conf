server {
    listen       80;
    server_name  luadev.cc;

    location /echo {
        set $test "abc";
        echo $document_root$test;
    }

    location /images {
        default_type "text/html";
        #content_by_lua 'ngx.say("hit images.")';
        #echo $document_root;

        # uri: /images/thb2/e12/e1200cb72f778bdad4210814463e6e86.png/220x246
        if ($uri ~ "/images/([a-zA-Z0-9]+)/([a-zA-Z0-9]+)/([a-zA-Z0-9.]+)/([a-zA-Z0-9]+)") {
            echo "$uri <br />$1 $2 $3 $4 $5";
        }
    }

    # test lua
    location /lua {
        default_type 'text/plain';
        content_by_lua 'ngx.say("hello world")';
    }

    # GET /recur?num=5
    location /recur {
        # MIME type determined by default_type:
        default_type 'text/plain';

        content_by_lua '
           local num = tonumber(ngx.var.arg_num) or 0

           if num > 50 then
               ngx.say("num too big")
               return
           end

           ngx.say("num is: ", num)

           if num > 0 then
               res = ngx.location.capture("/recur?num=" .. tostring(num - 1))
               ngx.print("status=", res.status, " ")
               ngx.print("body=", res.body)
           else
               ngx.say("end")
           end
           ';
    }

    location /mixed {
        default_type "text/html";

        #rewrite_by_lua_file /path/to/rewrite.lua;
        #access_by_lua_file /path/to/access.lua;
        content_by_lua_file lua/content.lua;
    }

    location /lua-cjson {
        default_type "application/x-javascript";
        content_by_lua_file lua/cjson.lua;
    }
}
