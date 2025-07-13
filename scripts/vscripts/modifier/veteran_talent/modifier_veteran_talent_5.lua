modifier_veteran_talent_5=class({})
LinkLuaModifier("modifier_veteran_talent_5_buff", "modifier/veteran_talent/modifier_veteran_talent_5.lua", LUA_MODIFIER_MOTION_NONE )
function modifier_veteran_talent_5:IsHidden()
    return false
end
function modifier_veteran_talent_5:IsPurgable()
    return false
end
function modifier_veteran_talent_5:IsPurgeException()
    return false
end
function modifier_veteran_talent_5:AllowIllusionDuplicate()
    return false
end

function modifier_veteran_talent_5:RemoveOnDeath()
    return false
end

function modifier_veteran_talent_5:GetTexture()
    return "t_5"
end
function modifier_veteran_talent_5:DeclareFunctions()
    return
    {
       MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,	   
	   MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	   MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_veteran_talent_5:GetModifierSpellAmplify_Percentage()
        return 12*self:GetStackCount()
end

function modifier_veteran_talent_5:GetModifierPercentageCasttime()
        return self.cast_time
end


function modifier_veteran_talent_5:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self.parent  then 
		return 
	end
	
	if self:GetStackCount() >= 2 and keys.ability~=nil then

		if keys.ability:IsItem() and keys.ability:GetName()~="item_imba_refreshstone" and keys.unit:GetCooldownReduction() > 0.49 then
			--if self:GetStackCount() >= 3  and keys.ability:GetName()~="item_imba_refreshstone" then
				local cooldown_remaining = keys.ability:GetCooldownTimeRemaining()
				if cooldown_remaining < 5 then	
					return
				end
				keys.ability:EndCooldown()
				if cooldown_remaining*0.75 > 5 then
					keys.ability:StartCooldown( cooldown_remaining*0.75)
					else
					keys.ability:StartCooldown(5)
				end
			--end					
				else	
			if self:GetStackCount() >= 3 then 
				if  not keys.ability:IsToggle()  and keys.ability:GetCooldown(keys.ability:GetLevel())>1 and keys.ability:GetName()~="imba_tiny_tree_grab" then 
					if  self.cast_first == nil then
						self.cast_first = keys.ability
						else
							if RollPseudoRandomPercentage(self.chance,0,self.parent) and self.cast_first ~= keys.ability then
							self.cast_first:EndCooldown()
							end	
						self.cast_first = keys.ability
					end
				end	
				end
			end
		end
end

function modifier_veteran_talent_5:OnCreated()
	self.parent = self:GetParent()	
	self.cast_time = 0
	self.chance = 35
	self.cast_first = nil
end
function modifier_veteran_talent_5:OnRefresh()
	if IsServer() then
		if self:GetStackCount()>=1 then
			self.cast_time = 100
		end	
	end
end

