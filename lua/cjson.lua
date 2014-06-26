-- Module instantiation
local cjson = require "cjson"
local cjson2 = cjson.new()
local cjson_safe = require "cjson.safe"

local json = {}; 
json['key'] = 'value';
json[0] = '这是一个key为0的元素';

ngx.print(cjson.encode(json));
