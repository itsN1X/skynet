local fish = require "fish"
local socket = require "socket"
local json = require "cjson"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local urllib = require "http.url"

local _M = {}

local function response(id, ...)
	local ok, err = httpd.write_response(sockethelper.writefunc(id), ...)
	if not ok then
		-- if err == sockethelper.socket_error , that means socket closed.
		fish.error(string.format("fd = %d, %s", id, err))
	end
end

function _M.listen(port)
	local id = socket.listen("0.0.0.0", port)
	socket.start(id , function(id, addr)
			socket.start(id)
		-- limit request body size to 8192 (you can pass nil to unlimit)
		local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(id), 8192)
		if code then
			if code ~= 200 then
				response(id, code)
			else
				local path, query = urllib.parse(url)
				local args
				if method == "GET" then
					if query then
						args = urllib.parse_query(query)
					end
				else
					local content_type = header["content-type"]
					local l,r = content_type:match "(.*)/(.*)"
					if r == "json" then
						args = json.decode(body)
					elseif r == "x-www-form-urlencoded" then
						args = urllib.parse_query(body)
					else
						assert(false,content_type)
					end
				end
				local cmd = path:sub(2)
				local err,ret = xpcall(fish.dispatch_message,debug.traceback,0,cmd,args)
				if not err then
					fish.error(ret)
				end
				response(id, code, json.encode(ret))
			end
		else
			if url == sockethelper.socket_error then
				fish.error("socket closed")
			else
				fish.error(url)
			end
		end
		socket.close(id)
	end)
end

return _M