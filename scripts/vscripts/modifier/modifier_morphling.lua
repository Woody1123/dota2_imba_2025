modifier_morphling=class({})
LinkLuaModifier("modifier_morphling_flag", "modifier/modifier_morphling.lua", LUA_MODIFIER_MOTION_NONE )
function modifier_morphling:IsHidden() 			
    return true 
end

function modifier_morphling:IsPurgable() 			
    return false 
end

function modifier_morphling:IsPurgeException() 	
    return false 
end

function modifier_morphling:IsPermanent() 	
    return true 
end

function modifier_morphling:AllowIllusionDuplicate() 	
    return false 
end

function modifier_morphling:GetTexture() 	
	return "witch_doctor" 
end

function modifier_morphling:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    } 
end

function modifier_morphling:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
	if IsServer() then
		self.count = 0
	end
end
function modifier_morphling:OnIntervalThink()
		if IsServer() then
			self.count = 0
			self:StartIntervalThink(-1)
		end
end
function modifier_morphling:OnAbilityFullyCast(tg) 	
    if IsServer() then   
        if tg.unit == self.parent then
		--print("123")
		--if self.cast == false then return end 
            local name=tg.ability:GetName()
            if name=="imba_morphling_morph_replicate" then 
				if tg.unit:HasModifier("modifier_morphling_flag") then
					self.count = self.count + 1
					if self.count > 5 then
						tg.unit:RemoveModifierByName("modifier_imba_morphling_replicate_caster")
						tg.unit:RemoveModifierByName("modifier_imba_morphling_replicate_buff")
					end
					else
					tg.unit:AddNewModifier(tg.unit,nil,"modifier_morphling_flag",{duration = 3})
					self.count = self.count + 1
					self:StartIntervalThink(3)
				end

            end
        end

	end
end
modifier_morphling_flag=class({})
function modifier_morphling_flag:IsHidden() 			
    return true 
end

function modifier_morphling_flag:IsPurgable() 			
    return false 
end

function modifier_morphling_flag:IsPurgeException() 	
    return false 
end
