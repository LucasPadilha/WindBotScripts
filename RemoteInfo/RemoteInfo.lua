init start
	
	--										--
	--		Remote Info for WindBot			--
	--		Author: Rukasu					--
	--		Created on 26/05/2014			--
	--		Script Version: 1.1.0			--
	--										--
	--		if you have any suggestions		--
	--		or if you found any bug		 	--
	--		contact me at WindBot forums	--
	--										--


	local safelist = { "Character Name 1", "Character Name 2", "Character Name 3..." } -- Insert as many names as you want.
	local commands = { "!info", "!supply", "!profit"} -- change to any word you want or just leave as it is.	

	------------------------------------------------------------------
	-- DON'T TOUCH ANYTHING BELOW UNLESS YOU KNOW WHAT YOU'RE DOING --
	------------------------------------------------------------------

	local info = { 
				function() return "Level: ".. $level end,
				function() return "Balance: " .. num($balance) end,
				function() return "Stamina: ".. time($stamina) end,
				function() return "Played time: ".. time(math.floor($charactertime / 1000)) end,
				function() return "Exp/h: ".. num($exphour) end,
				function() return "Time to next level: " .. time(timetolevel()) end
			} -- Thanks Leonardo

	local drop_profit, supply_waste = 0, 0

	local old_type = getsetting('Settings/TypeWaitTime')
	local old_press = getsetting('Settings/PressWaitTime')

init end

auto(100)
foreach newmessage m do	
	if m.type == MSG_PVT then
		
		-- set type/press wait time --
		setsetting('Settings/TypeWaitTime', '10 to 20 ms')
		setsetting('Settings/PressWaitTime', '10 to 20 ms')	

		-- general info --
		for i = 1, #safelist do
			if m.content:lower() == commands[1]:lower() and (m.sender == safelist[i] and maround(7) == 0) then
				for c = 1, #info do
					say("Local Chat", string.format("*%s* %s", m.sender, info[c]()))
				end
			end
		end

		-- supplies used --
		-- kinda useless command tho --
		for i = 1, #safelist do
			if m.content:lower() == commands[2]:lower() and (m.sender == safelist[i] and maround(7) == 0) then
				foreach supplyitem n do
					say("Local Chat", string.format("*%s* %s: %s. %s: %s gps", m.sender, n.name .. " used", n.amountused, "Total spent", num(n.buyprice * n.amountused)))
				end
			end
		end

		-- profit --
		for i = 1, #safelist do
			if m.content:lower() == commands[3]:lower() and (m.sender == safelist[i] and maround(7) == 0) then
				drop_profit = 0
				supply_waste = 0
				foreach lootingitem drops do
					drop_profit = drops.sellprice * drops.amountlooted + drop_profit
				end
				foreach supplyitem supply do
					supply_waste = supply.buyprice * supply.amountused + supply_waste
				end
					say("Local Chat", string.format("*%s* %s: %s gps", m.sender, "Total profit", num(drop_profit - supply_waste)))	
			end
		end

		-- go back to the original type/press wait time --
		setsetting('Settings/PressWaitTime', old_press)	
		setsetting('Settings/TypeWaitTime', old_type)
	end
end
