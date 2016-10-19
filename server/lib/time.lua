local time_c = require "time.core"

local time = setmetatable({},{__index = time_c})

--sep是秒数，指定某一天以某一个时间点做分割点
function time.same_day(ti1,ti2,sep)
	if sep == nil or sep == 0 then
		return time_c.same_day(ti1,ti2)
	end
	assert(sep >= 1 and sep < 86400)
	return time_c.same_day(ti1 - sep,ti2 - sep) 
end


local function same_week(ti1,ti2)
	local nweek_midnight 
	if ti1 < ti2 then
		nweek_midnight = time.next_week_midnight(ti1)
	else
		nweek_midnight = time.next_week_midnight(ti2)
	end

	if ti1 < ti2 then
		if ti1 < nweek_midnight and ti2 >= nweek_midnight then
			return false
		end
	else
		if ti1 >= nweek_midnight and ti2 < nweek_midnight then
			return false
		end
	end
	return true
end

--sep是秒数,范围1~604800,就是一个星期的秒数，指定某一天以某一个时间点做分割点
function time.same_week(ti1,ti2,sep)
	if sep == nil or sep == 0 then
		return same_week(ti1,ti2)
	end
	assert(sep >= 0 and sep < 604800)

	return same_week(ti1 - sep,ti2 - sep)
end

--获取这周的开始时间戳
function time.this_week_midnight(now)
	local val = time.next_week_midnight(now)
	return val -7*24*3600
end

--获取下周的开始时间戳
function time.next_week_midnight(now)
	local midnight = time_c.next_midnight(now)
	local day = time_c.time_to_wday(midnight)

	if day == 1 then
		return midnight
	end

	if day == 0 then
		day = 7
	end
	return midnight + (8-day) * 24 * 3600
end

--获取下一个时间点的时间戳
function time.next_time(now, sep)
	local day_begin_sec = time_c.time_to_daysec(now)
	if day_begin_sec < sep then
		return sep - day_begin_sec
	end
	return 24*3600 - day_begin_sec + sep
end

--获取传入时间的当天开始时间戳
function time.today_begin(ti)
	local day_begin_sec = time_c.time_to_daysec(ti)
	local today_start = ti - day_begin_sec
	return today_start
end

--获取传入时间的当天X时X分X秒的时间戳
function time.day_time(ti,hour,min,sec)
	local day_begin_sec = time.today_begin(ti)
	return day_begin_sec + hour * 3600 + min * 60 + (sec or 0)
end

return time