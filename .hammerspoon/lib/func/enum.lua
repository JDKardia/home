local enum = function(tbl)
	local length = #tbl
	for i = 1, length do
		local v = tbl[i]
		tbl[v] = i
	end

	return tbl
end

return enum
