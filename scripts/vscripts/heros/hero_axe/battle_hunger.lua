battle_hunger=class({})
LinkLuaModifier("modifier_battle_hunger_debuff", "heros/hero_axe/battle_hunger.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_battle_hunger_buff", "heros/hero_axe/battle_hunger.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_battle_hunger_debuff1", "heros/hero_axe/battle_hunger.lua", LUA_MODIFIER_MOTION_NONE)
function battle_hunger:IsHiddenWhenStolen()return false
end
function battle_hunger:IsRefreshable()return true
end
function battle_hunger:IsStealable()return true
end
function battle_hunger:OnSpellStart(tar)
    local curtar=tar or self:GetCursorTarget()
    self.caster=self.caster or self:GetCaster()
	if curtar:TG_TriggerSpellAbsorb(self) then
		return
	end
    EmitSoundOn("Hero_Axe.Battle_Hunger",  self.caster)
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_battle_hunger_cast.vpcf", PATTACH_OVERHEAD_FOLLOW  , self.caster)
    ParticleManager:ReleaseParticleIndex(particle)
	if curtar:GetUnitName() == "npc_dota_imba_miniboss" then
		curtar:AddNewModifier(self.caster, self, "modifier_battle_hunger_debuff", {duration= 12 })
		else
		curtar:AddNewModifier(self.caster, self, "modifier_battle_hunger_debuff", { })
	end
    if self.caster:TG_HasTalent("special_bonus_axe_4") then
        curtar:AddNewModifier(self.caster, self, "modifier_battle_hunger_debuff1", {duration=6 })
    end
    if self.caster:TG_HasTalent("special_bonus_axe_5") then
            curtar:Purge(true, false, false, false, false)
    end
	
end

modifier_battle_hunger_debuff=class({})
function modifier_battle_hunger_debuff:IsDebuff()return true
end
function modifier_battle_hunger_debuff:IsPurgable()return true
end
function modifier_battle_hunger_debuff:IsPurgeException()  return true
end
function modifier_battle_hunger_debuff:GetEffectName()return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
end
function modifier_battle_hunger_debuff:GetEffectAttachType()return PATTACH_OVERHEAD_FOLLOW
end
function modifier_battle_hunger_debuff:ShouldUseOverheadOffset()return true
end
function modifier_battle_hunger_debuff:RemoveOnDeath()return true
end
function modifier_battle_hunger_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_battle_hunger_debuff:OnCreated()
	if self:GetAbility() == nil then return end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    self.arm_res=self:GetAbility():GetSpecialValueFor("armor_res")
    self.damageTable=
    {
        attacker = self.caster,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability =  self.ability,
        victim = self.parent,
	}
    if not self.ability then
            return
    end
        self.dmg=self.ability:GetSpecialValueFor("dmg")
        self.slow=self.ability:GetSpecialValueFor("slow")
    if IsServer() then
        --if self.caster:HasScepter() then
        self.caster:AddNewModifier( self.caster, self.ability, "modifier_battle_hunger_buff", { })
        --end
        self:StartIntervalThink(1)
    end
end

--function modifier_battle_hunger_debuff:OnRefresh()
--    self:OnCreated()
--end
function modifier_battle_hunger_debuff:OnDestroy()
    if not IsServer() then
        return
    end
    if self.caster:HasModifier("modifier_battle_hunger_buff") then
        local buff=self.caster:FindModifierByName("modifier_battle_hunger_buff")
        if buff:GetStackCount()>0 then
            buff:SetStackCount(buff:GetStackCount()-1)
        end
    end
end


function modifier_battle_hunger_debuff:OnIntervalThink()
    self.damageTable.damage = self.parent:GetHealth()*0.01+self:GetCaster():GetPhysicalArmorValue(false)*(self.caster:TG_HasTalent("special_bonus_axe_8")  and 2 or 1)*self.arm_res
    ApplyDamage(self.damageTable)
end

function modifier_battle_hunger_debuff:GetModifierMoveSpeedBonus_Percentage(tg)
    return 0-self.slow
end
function modifier_battle_hunger_debuff:GetModifierIncomingDamage_Percentage(tg)
      if IsServer() then
            if tg.attacker==self.caster and tg.target==self.parent then
                  return self.dmg
            end
            return 0
      end
end

function modifier_battle_hunger_debuff:GetModifierPhysicalArmorBonus()
    if self.caster:Has_Aghanims_Shard() then
        return -self.ability:GetSpecialValueFor("armor")
    else
        return 0
    end

end

function modifier_battle_hunger_debuff:OnDeath(tg)
    if not IsServer() then
		return
    end
      if tg.attacker==self.parent then
            self:SetDuration(0, true)
      end
end

--function modifier_battle_hunger_debuff:GetModifierStatusResistanceStacking()
--    if self.caster:TG_HasTalent("special_bonus_axe_3") then
--            return -10
--    end
--    return 0
--end


modifier_battle_hunger_debuff1=class({})
function modifier_battle_hunger_debuff1:IsPurgable()
    return false
end
function modifier_battle_hunger_debuff1:IsPurgeException()
    return false
end
function modifier_battle_hunger_debuff1:IsHidden()
    return true
end
function modifier_battle_hunger_debuff1:IsDebuff()
    return true
end
function modifier_battle_hunger_debuff1:CheckState()
	return
	{
        [MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end


modifier_battle_hunger_buff=class({})
function modifier_battle_hunger_buff:IsDebuff()return true
end
function modifier_battle_hunger_buff:IsPurgable()return false
end
function modifier_battle_hunger_buff:IsPurgeException()return false
end
function modifier_battle_hunger_buff:IsDebuff()return false
end
function modifier_battle_hunger_buff:RemoveOnDeath()return false
end
function modifier_battle_hunger_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_battle_hunger_buff:OnTooltip()
    if self:GetCaster():HasScepter() then
        return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("armor")
    else
        return 0
    end
end

function modifier_battle_hunger_buff:OnCreated()
	if self:GetAbility() == nil then return end
        if IsServer() then
            self:SetStackCount(1)
        end
end

function modifier_battle_hunger_buff:OnRefresh()
    if IsServer() then
        self:IncrementStackCount()
    end
end

function modifier_battle_hunger_buff:GetModifierPhysicalArmorBonus()
    if self:GetCaster():HasScepter() then
        return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("armor")
    else
        return 0
    end
end