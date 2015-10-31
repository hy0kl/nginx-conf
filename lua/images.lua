-- 公共方法 {{{
-- 写入文件
local function writefile(filename, info)
    local wfile=io.open(filename, "w") --写入文件(w覆盖)
    assert(wfile)  --打开时验证是否出错
    wfile:write(info)  --写入传入的内容
    wfile:close()  --调用结束后记得关闭
end

-- 检测路径是否目录
local function is_dir(sPath)
    if type(sPath) ~= "string" then return false end

    local response = os.execute( "cd " .. sPath )
    if response == 0 then
        return true
    end
    return false
end

-- 检测文件是否存在
local file_exists = function(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

local debug = function(key, value)
    ngx.print(key .. ': ' .. value);
    ngx.exit(200);
end
-- }}}

local image_size   = ngx.var.image_size;
local originalUri  = ngx.var.uri;
local originalFile = ngx.var.original;

-- check original file
if not file_exists(originalFile) then
    -- 原始文件不存在,缩略图也不存在
    -- debug('originalFile', originalFile);
    ngx.exit(404);
end

-- 创建缩略图
local image_size_conf = {"80x80", "800x600", "40x40", "60x60"};
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- debug('originalFile', originalFile);
-- debug('des_file', ngx.var.file);

if table.contains(image_size_conf, image_size) then
    -- check image dir
    if not is_dir(ngx.var.image_dir) then
        os.execute("mkdir -p " .. ngx.var.image_dir)
    end

    local command = "gm convert " .. originalFile  .. " -thumbnail " .. image_size .. " -background gray -gravity center -extent " .. image_size .. " " .. ngx.var.file;
    os.execute(command);
end;

if file_exists(ngx.var.file) then
    --ngx.req.set_uri(ngx.var.uri, true);  
    ngx.exec(ngx.var.uri)
else
    ngx.exit(404)
end

