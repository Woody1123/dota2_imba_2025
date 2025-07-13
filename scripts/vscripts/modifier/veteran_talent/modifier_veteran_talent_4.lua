modifier_veteran_talent_4=class({})
LinkLuaModifier("modifier_veteran_talent_4_buff", "modifier/veteran_talent/modifier_veteran_talent_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_4_buff_2", "modifier/veteran_talent/modifier_veteran_talent_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_veteran_talent_4_buff_3", "modifier/veteran_talent/modifier_veteran_talent_4.lua", LUA_MODIFIER_MOTION_NONE )
function modifier_veteran_talent_4:IsHidden()
    return false
end
function modifier_veteran_talent_4:IsPurgable()
    return false
end
function modifier_veteran_talent_4:IsPurgeException()
    return false
end
function modifier_veteran_talent_4:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_4:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_4:GetTexture()
    return "t_4"
end
function modifier_veteran_talent_4:DeclareFunctions()
    return
    {
	   MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	   MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_veteran_talent_4:GetModifierMoveSpeedBonus_Percentage()
        return (self:GetStackCount()>=1 and self:GetParent():IsInvisible()) and 30 or 0
end

function modifier_veteran_talent_4:OnCreated()
	self.parent = self:GetParent()	
end

function modifier_veteran_talent_4:OnRefresh()
	if IsServer() then
		if self:GetStackCount()>=2 then
			self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_4_buff_2",{duration = -1})
			else
			self.parent:RemoveModifierByName("modifier_veteran_talent_4_buff_2")
		end
		if self:GetStackCount()>=1 then
			self:StartIntervalThink(3)
		end
	end
end

function modifier_veteran_talent_4:OnIntervalThink()
	if IsServer() then
		self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_4_buff",{duration = 3,dam = self:GetStackCount()})
	end
end


function modifier_veteran_talent_4:OnDeath(tg)
    if not IsServer() or tg.attacker:IsIllusion() then
        return
    end
    if tg.attacker == self:GetParent() and tg.unit:IsHero() and self:GetStackCount()>=3 then
		self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_4_buff_3",{duration = 2.2})
		self.parent:RemoveModifierByName("modifier_imba_rapier_magic_debuff")
    end
end

modifier_veteran_talent_4_buff_2=class({})

function modifier_veteran_talent_4_buff_2:IsHidden()
    return true
end
function modifier_veteran_talent_4_buff_2:IsPurgable()
    return false
end
function modifier_veteran_talent_4_buff_2:IsPurgeException()
    return false
end
function modifier_veteran_talent_4_buff_2:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_4_buff_2:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_4_buff_2:GetTexture()
    return "t_4"
end
function modifier_veteran_talent_4_buff_2:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
       MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	 }
end
function modifier_veteran_talent_4_buff_2:GetModifierMoveSpeed_Limit()
    return  99999
end

function modifier_veteran_talent_4_buff_2:GetModifierIgnoreMovespeedLimit()
    return	1
end
function modifier_veteran_talent_4_buff_2:GetPriority()
    return	MODIFIER_PRIORITY_SUPER_ULTRA
end

modifier_veteran_talent_4_buff=class({})

function modifier_veteran_talent_4_buff:IsHidden()
    return false
end
function modifier_veteran_talent_4_buff:IsPurgable()
    return false
end
function modifier_veteran_talent_4_buff:IsPurgeException()
    return false
end
function modifier_veteran_talent_4_buff:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_4_buff:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_4_buff:GetTexture()
    return "t_4"
end
function modifier_veteran_talent_4_buff:OnCreated(keys)
	if IsServer() then
		self.parent = self:GetParent()
		self.dam = keys.dam
		self:OnRefresh()
	end
end

function modifier_veteran_talent_4_buff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	 }
end

function modifier_veteran_talent_4_buff:GetModifierMoveSpeedBonus_Constant()
	if IsServer() then
        return self.dam*20
	end
end

function modifier_veteran_talent_4_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent then 
		self.num = self.num - 1
		--print(self.num)
		if self.num == 0 then 
			self:Destroy()
		end
	end	
end

function modifier_veteran_talent_4_buff:GetModifierPreAttack_BonusDamage()	
	return self:GetStackCount()
end
function modifier_veteran_talent_4_buff:OnRefresh()
	local max_dam = 300 
	if self.dam then
		if self.dam == 2 then
			max_dam = 600
		end
		if self.dam == 3 then
			max_dam = 900
		end
		local dam =  math.min(self.parent:GetMoveSpeedModifier(self.parent:GetBaseMoveSpeed(),true)*self.dam*0.5,max_dam)
		self.num = 3
		if self:GetParent():IsRangedAttacker() then
			dam = dam/2
			self.num = 6
		end
		self:SetStackCount(dam)
	end
end

modifier_veteran_talent_4_buff_3=class({})

function modifier_veteran_talent_4_buff_3:IsHidden()
    return false
end
function modifier_veteran_talent_4_buff_3:IsPurgable()
    return false
end
function modifier_veteran_talent_4_buff_3:IsPurgeException()
    return false
end
function modifier_veteran_talent_4_buff_3:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_4_buff_3:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_4_buff_3:GetTexture()
    return "t_4"
end
function modifier_veteran_talent_4_buff_3:DeclareFunctions() 	return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end

function modifier_veteran_talent_4_buff_3:GetEffectName() 
		return "particles/generic_hero_status/status_invisibility_start.vpcf" 
end
function modifier_veteran_talent_4_buff_3:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_veteran_talent_4_buff_3:GetModifierInvisibilityLevel() return 1 end
function modifier_veteran_talent_4_buff_3:CheckState()
		return {
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}
end