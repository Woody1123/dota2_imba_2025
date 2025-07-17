modifier_veteran_talent_3=class({})
LinkLuaModifier("modifier_veteran_talent_3_buff", "modifier/veteran_talent/modifier_veteran_talent_3.lua", LUA_MODIFIER_MOTION_NONE )

function modifier_veteran_talent_3:IsHidden()
    return false
end
function modifier_veteran_talent_3:IsPurgable()
    return false
end
function modifier_veteran_talent_3:IsPurgeException()
    return false
end
function modifier_veteran_talent_3:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_talent_3:RemoveOnDeath()
    return false
end
function modifier_veteran_talent_3:GetTexture()
    return "t_3"
end
function modifier_veteran_talent_3:DeclareFunctions()
    return
    {
      -- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	  -- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    }
end

function modifier_veteran_talent_3:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self.parent  and not tg.target:IsBuilding() and not self.parent:IsInvisible() and tg.target:IsHero() then
		local chance = 13--self:GetParent():IsRangedAttacker() and 10 or 13
		if RollPseudoRandomPercentage(self:GetStackCount()*chance,0,self.parent) and self.cd and tg.target:IsAlive() then
			if self:GetStackCount()>=2 and tg.target:IsAlive() then
				tg.attacker:AddNewModifier(tg.target,nil,"modifier_veteran_talent_3_buff",{duration = 0.12,level = self:GetStackCount()})
				tg.target:AddNewModifier(self.parent,nil,"modifier_imba_stunned",{duration = tg.target:IsMagicImmune() and 0 or 0.1})
			end
			self.cd = false
			
			--Timers:CreateTimer(0.07, function()
			--异步攻击，否则一起木大木大会BOOM
			if  tg.target:IsAlive() and tg.attacker:IsAlive() then
				self.parent:PerformAttack(tg.target, true, true, true, false, false, false, true)
			end
		--end)
			self:StartIntervalThink(0.1)
		end
	end
end

--[[
function modifier_veteran_talent_3:GetModifierProcAttack_BonusDamage_Magical()
	if IsServer() then
        return self:GetStackCount()>=1 and self.parent:GetPrimaryStatValue() or 0
	end
end
function modifier_veteran_talent_3:GetModifierProcAttack_BonusDamage_Pure(keys) 
	if IsServer() then
			
		return --(not keys.target:IsBuilding() and  self:GetStackCount()>=2 )  and self.parent:GetPrimaryStatValue() or 0
	end
end]]
--[[
function modifier_veteran_talent_3:GetModifierProjectileSpeedBonus()
    return self:GetStackCount() >=1 and 1000 or 0
end]]
function modifier_veteran_talent_3:GetModifierAttackSpeedBonus_Constant()
        return self:GetStackCount() >=1 and 120
end

function modifier_veteran_talent_3:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.cd = true
	end
end

function modifier_veteran_talent_3:OnIntervalThink()
	if IsServer() then
		self.cd = true
		self:StartIntervalThink(-1)
	end
end




--[[
function modifier_veteran_talent_3:OnRefresh()
	if IsServer() then
		if self:GetStackCount()>=3 then
			self.parent:AddNewModifier(self.parent,nil,"modifier_veteran_talent_3_buff",{duration = -1})
				else
			self.parent:RemoveModifierByName("modifier_veteran_talent_3_buff")
		end
	end
end
]]

modifier_veteran_talent_3_buff=class({})

function modifier_veteran_talent_3_buff:IsHidden()
    return true
end

function modifier_veteran_talent_3_buff:IsPurgable()
    return false
end

function modifier_veteran_talent_3_buff:IsPurgeException()
    return false
end

function modifier_veteran_talent_3_buff:IsDebuff() 
    return false
end


function modifier_veteran_talent_3_buff:GetTexture()
    return "t_3"
end

function modifier_veteran_talent_3_buff:DeclareFunctions()
	return 
	{
	   MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	   MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	 }
end

function modifier_veteran_talent_3_buff:OnCreated(keys)
	if IsServer() then
		self.level = keys.level
		local hp_check = (self:GetCaster():GetHealth()-self:GetParent():GetMaxHealth())>=0 
		local dam_max = 99999--(self.level == 3 and hp_check)and 999999 or 600
		local dam = math.min(self:GetCaster():GetMaxHealth()*0.05,dam_max)
		self.dam_phy = (self.level == 3  and not self:GetCaster():IsMagicImmune()) and dam*0.65 or dam
		self.dam_pure = (self.level == 3 and not self:GetCaster():IsMagicImmune()) and dam*0.35 or 0
		if self:GetCaster():GetUnitName() == "npc_dota_imba_boss" then
			self.dam_phy  = 200
			self.dam_pure = 100
		end
	end
end
function modifier_veteran_talent_3_buff:GetModifierPreAttack_BonusDamage() return self.dam_phy end
function modifier_veteran_talent_3_buff:GetModifierProcAttack_BonusDamage_Pure() return self.dam_pure end



