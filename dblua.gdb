define lbt
	set $index = 0
	set $p = L.ci
	while ($p != 0)
		set $tt = ($p.func.tt_ & 0x3f)
		if ($tt == 0x06)
			printf "%d lua function:\t",$index
			output $p.func.value_.gc.cl.l.p
			printf "\t"
			set $proto = $p.func.value_.gc.cl.l.p
			set $source = $proto.sp.source.tsv
			set $filename = (char*)(&($proto.sp.source.tsv) + 1)
			set $lineno = $proto.sp.lineinfo[$p.u.l.savedpc-$proto.sp.code-1]
			printf "%s:%d\n",$filename,$lineno
		end
		if ($tt == 0x16)
			printf "%d light c function:\t",$index
			output $p.func.value_.f
			printf "\n"
		end
		if ($tt == 0x26)
			printf "%d c closure:\t",$index
			output $p.func.value_.f
			printf "\n"
		end
		set $index = $index + 1
		set $p = $p.previous
	end
end

set $stack

define lf
	set $index = 0
	set $p = L.ci
	while ($p != 0)
		if $arg0 == $index 
			set $tt = ($p.func.tt_ & 0x3f)
			if ($tt == 0x06)
				set $stack = $p
				set $proto = $p.func.value_.gc.cl.l.p
				set $source = $proto.sp.source.tsv
				set $filename = (char*)(&($proto.sp.source.tsv) + 1)
				set $lineno = $proto.sp.lineinfo[$p.u.l.savedpc-$proto.sp.code-1]
				output $p.func.value_.gc.cl.l.p
				printf "%s:%d\n",$filename,$lineno
			end
			if ($tt == 0x16)
				output $p.func.value_.f
				printf "\n"
				printf "Can't debug light c function\n"
			end
			if ($tt == 0x26)
				output $p.func.value_.f
				printf "\n"
				printf "Can't debug c closure\n"
			end
		end

		set $index = $index + 1
		set $p = $p.previous
	end
end



define llocal
	set $p = $stack
	set $tt = ($p.func.tt_ & 0x3f)
	if ($tt == 0x06)
		set $stack = $p
		set $proto = $p.func.value_.gc.cl.l.p
		set $source = $proto.sp.source.tsv
		set $filename = (char*)(&($proto.sp.source.tsv) + 1)
		set $lineno = $proto.sp.lineinfo[$p.u.l.savedpc-$proto.sp.code-1]
		#output $p.func.value_.gc.cl.l.p
		#printf "%s:%d\n",$filename,$lineno
		set $sizevar = $proto.sp.sizelocvars
		set $indexvar = 0
		while ($indexvar < $sizevar)
			
			set $numparams = $proto.sp.numparams
			set $pos = $p.func+$indexvar+1
			printf "%s\n", (char*)(&($proto.sp.locvars[$indexvar].varname.tsv) + 1)
			print $pos
			set $localtt_ = ($pos.tt_ & 0x3f)

			if ($localtt_ == 0x05)
				print "table"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else 
			if ($localtt_ == 0x00)
				print "nil"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x01)
				print "bool"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x02)
				print "lightuserdata"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x03)
				print "number"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x04)
				print "string"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x05)
				print "table"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x06)
				print "Lua closure"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x16)
				print "light C function"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x26)
				print "C closure"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x07)
				print "userdata"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			if ($localtt_ == 0x08)
				print "thread"
				set $indexvar = $indexvar + 1
				printf "-------------------------------\n"
			else
			set $indexvar = $indexvar + 1
			print $localtt_
			printf "-------------------------------\n"
			end

			
		end
		
		#output $proto.sp.locvars[0].varname.tsv
	end	
end