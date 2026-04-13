---------------------------
-- CONFIGURATION STATION --
---------------------------

local spamCounterReset = 5 -- How many seconds until the persons spam counter resets
if SERVER then
	local blockedTerms = {
		-- Insert blocked terms here as an array of strings.
	}

	local allowedTerms = {
		"I love Synergy!",
		"Naval is my favorite battalion.",
		"Coruscant Guard do gods work.",
		"The staff here are amazing!",
		"Robb is pog!",
		"Trad more like chad."
	}

-----------------------------------
-- LEAVING CONFIGURATION STATION --
-----------------------------------

	util.AddNetworkString("L_BlockTerm") -- Add NW String
	hook.Add("PlayerSay", "L_FilterChat", function(ply, txt) -- add Hook
		for k,v in pairs(blockedTerms) do  -- Check their msg against the list of bad words
			if string.find(txt:lower(), v) then -- find it!
				net.Start("L_BlockTerm") -- tell the client to send themselves a msg
				net.Send(ply) -- send the msg

				return allowedTerms[math.random(1, #allowedTerms)] -- make their msg ~Nice~
			end
		end
		
	end)
end

if CLIENT then 
	net.Receive("L_BlockTerm", function(len, ply) -- recieve server msg
		chat.AddText(Color(120,120,255), ply, "[Synergy] ", Color(255,120,120), "Your message has been blocked, it contains a term that violates the chat filter.") -- send the perpetrator a msg
		timer.Simple(spamCounterReset, function() LocalPlayer():SetNWInt("spamBadWord", 0) end) -- reset spam counter after 5 seconds
		local spamCounter = LocalPlayer():GetNWInt("spamBadWord", 0) -- variable
		if spamCounter >= 2 then -- if they meet threshold
			LocalPlayer():ConCommand("disconnect") -- have them disconnect themselves xD
		else
			LocalPlayer():SetNWInt("spamBadWord", spamCounter+1) -- add the violation to their counter
		end
	end)
end
