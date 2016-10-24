local profile = require "profile"

local _client_flow = {}
local _time_consuming = {}

local _profile_coroutine = {}

local export = {}

local function report_time_cosuming(print)
	local list = {}
	for method,info in pairs(_time_consuming) do
		local avg = info.total / info.count
		table.insert(list,{method = method,avg = avg,max = info.max,count = info.count})
	end
	table.sort(list,function (l,r)
		return l.avg > r.avg
	end)
	local logs = {}
	table.insert(logs,"\r\n")
	table.insert(logs,string.format("-------------------------------------time cosuming-------------------------------------"))
	table.insert(logs,string.format("%-25s%-25s%-25s%-25s","method","AVG(ms)","AVG-MAX(ms)","count"))
	for _,info in pairs(list) do
		table.insert(logs,string.format("%-25s%-25f%-25f%-25d",info.method,info.avg*1000,info.max*1000,info.count))
	end
	table.insert(logs,string.format("-------------------------------------------*-------------------------------------------"))
	print(table.concat(logs,"\r\n"))
end

local function report_flow(print)
	local list = {}
	for method,info in pairs(_client_flow) do
		local avg = info.size / info.cnt
		table.insert(list,{method = method,size = info.size,avg = avg,count = info.cnt})
	end
	table.sort(list,function (l,r)
		return l.size > r.size
	end)
	local logs = {}
	table.insert(logs,"\r\n")
	table.insert(logs,string.format("-------------------------------------client flow-------------------------------------"))
	table.insert(logs,string.format("%-25s%-25s%-25s%-25s","method","size(kb)","AVG(kb)","count"))
	for _,info in pairs(list) do
		table.insert(logs,string.format("%-25s%-25d%-25d%-25d",info.method,math.modf(info.size/1024),math.modf(info.avg/1024),info.count))
	end
	table.insert(logs,string.format("-------------------------------------------*-------------------------------------------"))
	print(table.concat(logs,"\r\n"))
end


function export.collect_message(method,size)
	local flow_info = _client_flow[method]
	if flow_info == nil then
		_client_flow[method] = {size = 0,cnt = 0}
		flow_info = _client_flow[method]
	end
	flow_info.size = flow_info.size + size
	flow_info.cnt = flow_info.cnt + 1
	if size >= 5 * 1024 then
		report_flow(print)
	end
end

function export.func_start()
	local running_co = coroutine.running()
	if _profile_coroutine[running_co] == nil then
		profile.start()
		_profile_coroutine[running_co] = true
	end
end

function export.func_over(method)
	local running_co = coroutine.running()
	if _profile_coroutine[running_co] == nil then
		return
	end

	_profile_coroutine[running_co] = nil
	local ti = profile.stop()
	local record = _time_consuming[method]
	if record == nil then
		record = {}
		_time_consuming[method] = record
	end
	record.count = (record.count or 0) + 1
	record.total = (record.total or 0) + ti
	if record.max == nil or record.max < ti then
		record.max = ti
	end

	if ti * 1000 >= 10 then
		report_time_cosuming(print)
	end
end

function export.report(print)
	report_time_cosuming(print)
	report_flow(print)
end

return export