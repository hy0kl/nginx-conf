server {
    listen       9090;
    server_name  luadev.cc;


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
