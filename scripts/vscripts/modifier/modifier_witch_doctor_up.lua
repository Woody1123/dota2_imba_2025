modifier_witch_doctor_up=class({})
LinkLuaModifier("modifier_witch_doctor_death_ward_up", "modifier/modifier_witch_doctor_up.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_witch_doctor_death_ward_up_caster", "modifier/modifier_witch_doctor_up.lua", LUA_MODIFIER_MOTION_NONE )
function modifier_witch_doctor_up:IsHidden() 			
    return true 
end

function modifier_witch_doctor_up:IsPurgable() 			
    return false 
end

function modifier_witch_doctor_up:IsPurgeException() 	
    return false 
end

function modifier_witch_doctor_up:IsPermanent() 	
    return true 
end

function modifier_witch_doctor_up:AllowIllusionDuplicate() 	
    return false 
end

function modifier_witch_doctor_up:GetTexture() 	
	return "witch_doctor" 
end

function modifier_witch_doctor_up:DeclareFunctions() 
    return 
    {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    } 
end



function modifier_witch_doctor_up:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
	--self.cast = true	
end


function modifier_witch_doctor_up:OnAbilityFullyCast(tg) 	
    if IsServer() then   
        if tg.unit == self.parent then
		--print("123")
		--if self.cast == false then return end 
            local name=tg.ability:GetName()
            if name=="witch_doctor_paralyzing_cask" then 
                local target = tg.ability:GetCursorTarget() or nil 
				if target ~=nil  then
					--tg.unit:CastAbilityOnTarget(target,tg.ability,tg.unit:GetPlayerOwnerID())
					
							Timers:CreateTimer(0.6, function()
								tg.unit:SetCursorCastTarget(target)
								tg.ability:OnSpellStart()	
						return nil
						end)
				end
            end
        end
		if tg.unit == self.parent then
			local name=tg.ability:GetName()
			local pos = nil
			local dur = 0
            if name=="witch_doctor_death_ward" then
				pos = tg.ability:GetCursorPosition()
				dur = 8.5
			end
			if name=="witch_doctor_voodoo_switcheroo" then
				pos = tg.unit:GetAbsOrigin()
				dur = 3.5
			end
			if pos~=nil then
				local unit = FindUnitsInRadius(tg.unit:GetTeamNumber(), pos, nil, 150, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
				for _,u in pairs(unit) do
					if u:GetName() == "npc_dota_witch_doctor_death_ward" then
						u:AddNewModifier(tg.unit,tg.ability,"modifier_witch_doctor_death_ward_up",{duration = dur})
					end					
				end			
			end
		end 
	end
end

modifier_witch_doctor_death_ward_up=class({})

function modifier_witch_doctor_death_ward_up:IsHidden() 			
    return true 
end

function modifier_witch_doctor_death_ward_up:IsPurgable() 			
    return false 
end

function modifier_witch_doctor_death_ward_up:IsPurgeException() 	
    return false 
end

function modifier_witch_doctor_death_ward_up:IsPermanent() 	
    return true 
end

function modifier_witch_doctor_death_ward_up:AllowIllusionDuplicate() 	
    return false 
end
function modifier_witch_doctor_death_ward_up:CheckState()
    return {
	[MODIFIER_STATE_CANNOT_MISS] = true,
	}
end
function modifier_witch_doctor_death_ward_up:DeclareFunctions() 
    return 
    {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    } 
end
function modifier_witch_doctor_death_ward_up:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():GetLevel()
end

function modifier_witch_doctor_death_ward_up:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
end
function modifier_witch_doctor_death_ward_up:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent and keys.unit:IsAlive() then
		keys.unit:AddNewModifier(self.caster,nil,"modifier_witch_doctor_death_ward_up_caster",{duration = 1})
		self.caster:PerformAttack(keys.unit, true, true, true, false, false, false, true)
	end
end


modifier_witch_doctor_death_ward_up_caster=class({})

function modifier_witch_doctor_death_ward_up_caster:IsHidden() 			
    return true 
end

function modifier_witch_doctor_death_ward_up_caster:IsPurgable() 			
    return false 
end

function modifier_witch_doctor_death_ward_up_caster:IsPurgeException() 	
    return false 
end

function modifier_witch_doctor_death_ward_up_caster:IsPermanent() 	
    return true 
end

function modifier_witch_doctor_death_ward_up_caster:AllowIllusionDuplicate() 	
    return false 
end

function modifier_witch_doctor_death_ward_up_caster:DeclareFunctions() 
    return 
    {
		MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
    } 
end

function modifier_witch_doctor_death_ward_up_caster:GetModifierNoVisionOfAttacker() 	
    return 1 
end