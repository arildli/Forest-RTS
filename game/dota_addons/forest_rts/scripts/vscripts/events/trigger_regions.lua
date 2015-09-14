

function GoldRegion1(trigger)
	-- Adds 120 gold to the entering player
	local goldAmount = 120
	local player = trigger.activator
	local playerID = player:GetPlayerID()
	local unit = player:GetAssignedHero()
	local unitName = unit:GetUnitName()
	PlayerResource:SetGold(player, PlayerResource:GetGold(player)+goldAmount, false)

	--[[ Fires an event that will trigger a function in SimpleRTS.lua.
		 Both 'pid' and 'gold' can be read from there.]]
	--FireGameEvent('resource_gold_found', {
	--	pid=playerID,
	--	heroname=unitName,
	--	gold=goldAmount
	--})
end



function GoldRegionTest(trigger)
	local goldAmount = 1000
	local player = trigger.activator
	PlayerResource:SetGold(player, PlayerResource:GetGold(player)+goldAmount, false)
end



function BombRegion1(trigger)
	local unit = trigger.activator
	--Say(unit, "Sweet, sweet gold!", true)
	--local soundPath = "weapons/hero/techies/remote_mine01.wav"
	--EmitSoundOn(soundPath, unit)
	unit:ForceKill(true)
end
