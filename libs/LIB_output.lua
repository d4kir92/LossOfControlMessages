-- LIB Output

function LOCmsg(str)
	print("|c0000ffff" .. "[" .. "|cff8888ff" .. LOCname .. "|c0000ffff" .. "] " .. str)
end

function LOCdeb(str)
	if LOCDEBUG then
		print("[DEB] " .. str)
	end
end

function pTab(tab)
	print("pTab", tab)
	for i, v in pairs(tab) do
		if type(v) == "table" then
			pTab(v)
		else
			print(i, v)
		end
	end
	print("----------------------------------")
end
