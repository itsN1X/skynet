local time_c = require "time.core"

local time = {}


--arg1:unix时间戳1
--arg2:unix时间戳2
--arg3:区分两天的分割点秒数
--return:以分割点秒数判断是否同一天
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

--arg1:unix时间戳1
--arg2:unix时间戳2
--arg3:区分两周的分割点秒数
--return:以分割点秒数判断是否同一周
function time.same_week(ti1,ti2,sep)
	if sep == nil or sep == 0 then
		return same_week(ti1,ti2)
	end
	assert(sep >= 0 and sep < 604800)

	return same_week(ti1 - sep,ti2 - sep)
end


--arg1:unix时间戳
--return:这周0点的unix时间戳
function time.this_week_midnight(now)
	local val = time.next_week_midnight(now)
	return val -7*24*3600
end

--arg1:unix时间戳
--return:下周0点的unix时间戳
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

--arg1:unix时间戳
--arg2:当天已过秒数
--return:当天已过秒数的unix时间戳
function time.next_time(now, sep)
	local day_begin_sec = time_c.time_to_daysec(now)
	if day_begin_sec < sep then
		return sep - day_begin_sec
	end
	return 24*3600 - day_begin_sec + sep
end

--arg1:unix时间戳
--return:传入时间的当天开始时间戳
function time.today_begin(ti)
	local day_begin_sec = time_c.time_to_daysec(ti)
	local today_start = ti - day_begin_sec
	return today_start
end

--arg1:当天unix时间戳
--arg2:时
--arg3:分
--arg4:秒
--return:某天x时x分x秒的unix时间戳
function time.day_time(ti,hour,min,sec)
	local day_begin_sec = time.today_begin(ti)
	return day_begin_sec + hour * 3600 + min * 60 + (sec or 0)
end

--arg1:当天时间戳
--arg2:xx:xx(时:分)
--return:当天几时几分的unix时间戳
function time.anti_format_daytime(ti,ftime)
	local str_hour,str_min = string.match(ftime,"(%d+):(%d+)")
    local hour = tonumber(str_hour)
    local min = tonumber(str_min)
    return time.day_time(ti,hour,min,0)
end

--arg1:格式化的时间2016-11-2 13:41:00
--return:unix时间戳
function time.anti_format_time(str)
	local year,mon,day,hour,min,sec = string.match(str,"(.*)-(.*)-(.*) (.*):(.*):(.*)")
	local time = {
		year = year,
		month = mon,
		day = day,
		hour = hour,
		min = min,
		sec = sec,
	}
	return os.time(time)
end

--arg1:unix时间戳
--return:{year = ,mon=,day=,hour=,min=,sec=}
function time.time_to_date(ti)
	local r = time_c.time_to_date(ti)
	r.year = r.year + 1900
	return r
end

return time