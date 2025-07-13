modifier_veteran_talent_2=class({})
LinkLuaModifier("modifier_veteran_talent_2_buff", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2_evasion", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2_buff_dmg", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2_buff_1", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2_buff_2", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2_buff_3", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_2_buff_4", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
function modifier_veteran_talent_2:IsHidden()
    return false
end
function modifier_veteran_talent_2:IsPurgable()
    return false
end
function modifier_veteran_talent_2:IsPurgeException()
    return false
end
function modifier_veteran_talent_2:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_2:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_2:GetTexture()
    return "t_2"
end
function modifier_veteran_talent_2:DeclareFunctions()
    return
    {
       --MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	   --MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, 
	   MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	   --MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	   MODIFIER_EVENT_ON_ATTACK_LANDED,
	   MODIFIER_PROPERTY_EVASION_CONSTANT,
	   MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	   --MODIFIER_PROPERTY_SLOW_RESISTANCE,
    }
end
function modifier_veteran_talent_2:GetModifierEvasion_Constant()
    return self:GetStackCount() >=2 and 30 or 0
end
function modifier_veteran_talent_2:GetModifierStatusResistanceStacking()
    return self:GetStackCount()*12
end
--[[
function modifier_veteran_talent_2:GetModifierSlowResistance()
    return 100--self:GetStackCount()*15
end]]
--[[
function modifier_veteran_talent_2:GetModifierProjectileSpeedBonus()
    return self:GetStackCount() >=1 and 1000 or 0
end
]]

function modifier_veteran_talent_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self.parent or self:GetStackCount()<3 then 
		return 
	end
	
	if keys.ability~=nil and not keys.ability:IsToggle() and  keys.ability:IsItem() then 
		local name = keys.ability:GetAbilityName()
		if name == "item_bkb" or name == "item_four_knives" then
			keys.unit:RemoveModifierByName("modifier_black_king_bar_immune")
			keys.unit:RemoveModifierByName("modifier_item_bkb_buff")
			keys.unit:AddNewModifier(keys.unit,nil,"modifier_veteran_talent_2_buff",{duration = 10})
			keys.unit:AddNewModifier(keys.unit,nil,"modifier_veteran_talent_2_buff",{duration = 10})
		end	
	end
end


function modifier_veteran_talent_2:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if  not tg.attacker:IsBuilding() and tg.target == self.parent  and self:GetStackCount()>=2 then
		--print("9961")
		local chance = self.parent:GetEvasion()*100
		--print('nmsl:'..chance)
		if self.parent:IsAlive() then
			if RollPseudoRandomPercentage(chance,0,self.parent) then

				self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_2_evasion",{duration = 1})						
			end
			self.cd = false
			self:StartIntervalThink(0.2)
		end
	end
end


--[[
function modifier_veteran_talent_2:GetModifierBaseAttack_BonusDamage()
		local damage = 60*self:GetStackCount()
		if self.ismelee then
			damage = damage+self.parent:GetPrimaryStatValue()*self.up
			return damage
		end
        return damage
end]]

--[[
function modifier_veteran_talent_2:GetModifierAttackSpeedBonus_Constant()
        return self:GetStackCount()>=1 and 80 or 0
end]]
--[[
function modifier_veteran_talent_2:OnRefresh()
	if IsServer() then
		if self:GetStackCount()>=2 then
				local pri = self.parent:GetPrimaryAttribute()
				if pri == 0 then
					self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_2_buff_1",{duration = -1})
				end
				if pri == 1 then
					self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_2_buff_2",{duration = -1})
				end
				if pri == 2 then
					self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_2_buff_3",{duration = -1})
				end
				if pri == 3 then
					self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_2_buff_4",{duration = -1})
				end
			else
			self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_1")
			self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_2")
			self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_3")
			self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_4")
		end
	end
end
]]
function modifier_veteran_talent_2:OnDestroy()
      if IsServer() then
			self.parent:SetPrimaryAttribute(self.primary)
			self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_dmg")
			--self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_1")
			--self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_2")
			--self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_3")
			--self.parent:RemoveModifierByName("modifier_veteran_talent_2_buff_4")
	  end
end
--[[
function modifier_veteran_talent_2:GetModifierBaseDamageOutgoing_Percentage() 
	return self:GetStackCount()>=10 and 30 or 0
end
]]

function modifier_veteran_talent_2:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.primary = self.parent:GetPrimaryAttribute()
		self.parent:SetPrimaryAttribute(3)
		print(self.primary)
		if self.primary == 3 then
			self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_2_buff_dmg",{duration = -1})
		end
		--self.ismelee = self.parent:GetBaseAttackRange()<= 300 and true or false
		--self.up = self.parent:GetPrimaryAttribute() == 3 and 0.12 or 0.4
	end
end


modifier_veteran_talent_2_evasion = class({})
function modifier_veteran_talent_2_evasion:IsHidden()
    return false
end

function modifier_veteran_talent_2_evasion:IsPurgable()
    return false
end
function modifier_veteran_talent_2_evasion:IsPurgeException()
    return false
end

function modifier_veteran_talent_2_evasion:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end

function modifier_veteran_talent_2_evasion:GetModifierAvoidDamage(tg)
	if RollPseudoRandomPercentage(self.evasion,0,self.parent) then
		return 1
	else
		return 0
	end
end

function modifier_veteran_talent_2_evasion:OnCreated()
	self.parent = self:GetParent()
    if not IsServer() then return end
	self.evasion = self:GetParent():GetEvasion()*50
end

function modifier_veteran_talent_2_evasion:OnRefresh()
    if not IsServer() then return end
	self:OnRefresh()
end


modifier_veteran_talent_2_buff=class({})


function modifier_veteran_talent_2_buff:IsHidden()
    return false
end

function modifier_veteran_talent_2_buff:IsPurgable()
    return false
end

function modifier_veteran_talent_2_buff:IsPurgeException()
    return false
end

function modifier_veteran_talent_2_buff:GetTexture()
    return "item_black_king_bar"
end

function modifier_veteran_talent_2_buff:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_veteran_talent_2_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_veteran_talent_2_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
		--[MODIFIER_STATE_DEBUFF_IMMUNE] = true,
    }
end

function modifier_veteran_talent_2_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE,
		--MODIFIER_PROPERTY_DODGE_PROJECTILE,
	}
end

function modifier_veteran_talent_2_buff:GetModifierMagicalResistanceBonus()
    return 60
end

function modifier_veteran_talent_2_buff:GetModifierModelScale()
    return 70
end
--[[
function modifier_veteran_talent_2_buff:GetModifierDodgeProjectile()
    if RollPseudoRandomPercentage(25,0,self.parent) then
        return 1
    else
        return 0
    end
end]]
modifier_veteran_talent_2_buff_dmg=class({})

function modifier_veteran_talent_2_buff_dmg:IsHidden()
    return true
end
function modifier_veteran_talent_2_buff_dmg:IsPurgable()
    return false
end
function modifier_veteran_talent_2_buff_dmg:IsPurgeException()
    return false
end
function modifier_veteran_talent_2_buff_dmg:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_2_buff_dmg:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_2_buff_dmg:GetTexture()
    return "t_2"
end
function modifier_veteran_talent_2_buff_dmg:DeclareFunctions()
	return 
	{
	 MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	 }
end

function modifier_veteran_talent_2_buff_dmg:GetModifierBaseDamageOutgoing_Percentage() 
	return 35 
end


modifier_veteran_talent_2_buff_1=class({})

function modifier_veteran_talent_2_buff_1:IsHidden()
    return true
end
function modifier_veteran_talent_2_buff_1:IsPurgable()
    return false
end
function modifier_veteran_talent_2_buff_1:IsPurgeException()
    return false
end
function modifier_veteran_talent_2_buff_1:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_2_buff_1:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_2_buff_1:GetTexture()
    return "t_2"
end
function modifier_veteran_talent_2_buff_1:DeclareFunctions()
	return 
	{
	  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	 }
end

function modifier_veteran_talent_2_buff_1:GetModifierBonusStats_Strength() return self.str*self.parent:GetLevel() end
function modifier_veteran_talent_2_buff_1:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.str = 5.0 -self.parent:GetStrengthGain()
	end
end

modifier_veteran_talent_2_buff_2=class({})

function modifier_veteran_talent_2_buff_2:IsHidden()
    return true
end
function modifier_veteran_talent_2_buff_2:IsPurgable()
    return false
end
function modifier_veteran_talent_2_buff_2:IsPurgeException()
    return false
end
function modifier_veteran_talent_2_buff_2:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_2_buff_2:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_2_buff_2:GetTexture()
    return "t_4"
end
function modifier_veteran_talent_2_buff_2:DeclareFunctions()
	return 
	{
	  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	 }
end

function modifier_veteran_talent_2_buff_2:GetModifierBonusStats_Agility() return self.agi*self.parent:GetLevel() end

function modifier_veteran_talent_2_buff_2:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.agi = 5.0 - self.parent:GetAgilityGain()
	end
end
modifier_veteran_talent_2_buff_3=class({})

function modifier_veteran_talent_2_buff_3:IsHidden()
    return true
end
function modifier_veteran_talent_2_buff_3:IsPurgable()
    return false
end
function modifier_veteran_talent_2_buff_3:IsPurgeException()
    return false
end
function modifier_veteran_talent_2_buff_3:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_2_buff_3:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_2_buff_3:GetTexture()
    return "t_2"
end
function modifier_veteran_talent_2_buff_3:DeclareFunctions()
	return 
	{
	  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	 }
end
function modifier_veteran_talent_2_buff_3:GetModifierBonusStats_Intellect() return self.int*self.parent:GetLevel() end
function modifier_veteran_talent_2_buff_3:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.int = 5.0 - self.parent:GetIntellectGain()
	end
end
modifier_veteran_talent_2_buff_4=class({})

function modifier_veteran_talent_2_buff_4:IsHidden()
    return true
end
function modifier_veteran_talent_2_buff_4:IsPurgable()
    return false
end
function modifier_veteran_talent_2_buff_4:IsPurgeException()
    return false
end
function modifier_veteran_talent_2_buff_4:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_2_buff_4:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_2_buff_4:GetTexture()
    return "t_2"
end
function modifier_veteran_talent_2_buff_4:DeclareFunctions()
	return 
	{
	  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	 }
end
function modifier_veteran_talent_2_buff_4:GetModifierBonusStats_Intellect() return self.int*self.parent:GetLevel() end
function modifier_veteran_talent_2_buff_4:GetModifierBonusStats_Agility() return self.agi*self.parent:GetLevel() end
function modifier_veteran_talent_2_buff_4:GetModifierBonusStats_Strength() return self.str*self.parent:GetLevel() end
function modifier_veteran_talent_2_buff_4:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.int = math.max(3-self.parent:GetIntellectGain(),0)
		self.agi = math.max(3-self.parent:GetAgilityGain(),0)
		self.str = math.max(3-self.parent:GetStrengthGain(),0)
	end
end
