if IsClient() then
    	print("初始Activate···············")
--[[	
	C_DOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
		if(not self or self:IsNull() == true) then
			return 0
		end
		local caster = self:GetCaster()
		if(not caster or caster:IsNull() == true) then
			return 0
		end
		return caster:GetCastRangeBonus()
	end
	 
	C_DOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
		if(not self or self:IsNull() == true) then
			return 0
		end
		local caster = self:GetCaster()
		if(not caster or caster:IsNull() == true) then
			return 0
		end
		return caster:GetCastRangeBonus()
	end
	 
	-- Override from addon_game_mode.lua (paste this code into it)
	CDOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
		if(not self or self:IsNull() == true) then
			return 0
		end
		local caster = self:GetCaster()
		if(not caster or caster:IsNull() == true) then
			return 0
		end
		return caster:GetCastRangeBonus()
	end
	 
	CDOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
		if(not self or self:IsNull() == true) then
			return 0
		end
		local caster = self:GetCaster()
		if(not caster or caster:IsNull() == true) then
			return 0
		end
		return caster:GetCastRangeBonus()
	end]]
end
--[[
if IsServer() then
        if CDOTA_Ability_Lua.GetCastRangeBonus_Engine == nil then
                CDOTA_Ability_Lua.GetCastRangeBonus_Engine = CDOTA_Ability_Lua.GetCastRangeBonus
        end
        function CDOTA_Ability_Lua:GetCastRangeBonus(h)
                return CDOTA_Ability_Lua.GetCastRangeBonus_Engine(self, h)
        end
else
        if C_DOTA_Ability_Lua.GetCastRangeBonus_Engine == nil then
                C_DOTA_Ability_Lua.GetCastRangeBonus_Engine = C_DOTA_Ability_Lua.GetCastRangeBonus
        end
        function C_DOTA_Ability_Lua:GetCastRangeBonus(h)
                return C_DOTA_Ability_Lua.GetCastRangeBonus_Engine(self, h)
        end
end]]
