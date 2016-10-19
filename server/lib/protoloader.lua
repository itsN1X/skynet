local protobuf = require "protobuf"
local util = require "util"

function loadall(dir)
	local pb_files = {}

	util.find_dir_files(pb_files,dir,"pb",true,false)

	for i,file in pairs(pb_files) do
		if string.find(file, "Common.pb") ~= nil then
			print(file)
			protobuf.register_file(file)
			table.remove(pb_files, i)
			break
		end
	end

	for i,file in pairs(pb_files) do
		if string.find(file, "PPack.pb") ~= nil then
			print(file)
			protobuf.register_file(file)
			table.remove(pb_files, i)
			break
		end
	end

	for i,file in pairs(pb_files) do
		print(file)
		protobuf.register_file(file)	
	end
end

return loadall
