modifier_illusion_moon_shard_buff = class({})

function modifier_illusion_moon_shard_buff:IsBuff()				
    return true 
end

function modifier_illusion_moon_shard_buff:IsPurgable() 			
    return false 
end

function modifier_illusion_moon_shard_buff:IsPurgeException() 	
    return true 
end

function modifier_illusion_moon_shard_buff:IsHidden()				
    return true 
end



function modifier_illusion_moon_shard_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end

function modifier_illusion_moon_shard_buff:GetModifierAttackSpeedBonus_Constant()
    return 180
end
function modifier_illusion_moon_shard_buff:GetModifierAttackRangeBonus()
    return self.range
end


function modifier_illusion_moon_shard_buff:OnCreated()
	if not IsServer() then return end

    self.range = self:GetCaster():Script_GetAttackRange() - self:GetParent():Script_GetAttackRange()

end