ngx.print('<meta http-equiv="content-type" content="text/html;charset=utf-8">\n')
ngx.print('<h1> 这个是 h1 </h1>\n')

ngx.print('<pre>');

ngx.say("Hello World.\n")
ngx.print("just test");

local url = ngx.var.uri
ngx.say('<br>', url, '<br/>')
ngx.print('这次访问的header头是: ', ngx.req.raw_header())

ngx.print('请求方式: ', ngx.req.get_method(), '<br/>\n');

local args = ngx.req.get_uri_args()
for key, val in pairs(args) do
    if type(val) == "table" then
        ngx.say(key, ": ", table.concat(val, ", "))
    else
        ngx.say(key, ": ", val)
    end
end

ngx.print('</pre>');
