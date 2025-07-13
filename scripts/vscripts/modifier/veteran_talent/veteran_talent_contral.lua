veteran_talent_contral=class({})
LinkLuaModifier("modifier_veteran_talent_1", "modifier/veteran_talent/modifier_veteran_talent_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_3", "modifier/veteran_talent/modifier_veteran_talent_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_4", "modifier/veteran_talent/modifier_veteran_talent_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_5", "modifier/veteran_talent/modifier_veteran_talent_5.lua", LUA_MODIFIER_MOTION_NONE )
function veteran_talent_contral:Sure_point(npc,tb)
	local veteran_talent_table = {"modifier_veteran_talent_1","modifier_veteran_talent_2","modifier_veteran_talent_3","modifier_veteran_talent_4","modifier_veteran_talent_5"}
	for i = 1,#tb-1  do
		if tonumber(tb[i])~= 0 then
			--print(tb[i])
			--local modfier = npc:FindModifierByName(veteran_talent_table[i])
			npc:RemoveModifierByName(veteran_talent_table[i])
			local modifier = npc:AddNewModifier(npc,self,veteran_talent_table[i],{duration = -1})
				if modifier then
					modifier:SetStackCount(tonumber(tb[i]))
					npc:AddNewModifier(npc,self,veteran_talent_table[i],{duration = -1})
					npc:CalculateStatBonus(true)
				end
			else
			npc:RemoveModifierByName(veteran_talent_table[i])		
		end
	end
end

function veteran_talent_contral:OnHero_lvlup(npc)
	
	local id = npc:GetPlayerID()
	local PL = PlayerResource:GetPlayer(id)
	if npc:GetLevel()>10 and npc:GetLevel()%10 == 0 then
		local tb = CustomNetTables:GetTableValue("veteran_talent", tostring(id)).tb
		local t2 = {}
		local length = 0
		for _,v in pairs(tb) do
			length = length + 1
			table.insert(t2,tb[tostring(length)])
		end
		t2[length] = t2[length] + 1		
		CustomNetTables:SetTableValue("veteran_talent", tostring(id), {["tb"] = t2})
		CustomGameEventManager:Send_ServerToPlayer(PL,"buy_talent_point_success",{})
	end
end
