
modifier_dlnec_haura_nec = class({})
LinkLuaModifier( "modifier_dlnec_haura_nec_heal", "dl/dlnec/dlnec_haura/modifier_dlnec_haura_nec", LUA_MODIFIER_MOTION_NONE )
function modifier_dlnec_haura_nec:IsHidden() return true end
function modifier_dlnec_haura_nec:IsPurgable() return false end
function modifier_dlnec_haura_nec:IsPurgeException() return false end
--function modifier_dlnec_haura_nec:AllowIllusionDuplicate() return false end --幻象不继承，未生效，依旧继承光环

function modifier_dlnec_haura_nec:DeclareFunctions()    --击杀回复血量蓝量部分
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_dlnec_haura_nec:OnDeath(params)
    if not IsServer() then return end
    if params.attacker~=self:GetParent() then return end    --不是本人那没事了
	if not params.unit then return end	--可能能防报错吧我也不知道随手一加
	if not params.attacker then return end	--可能能防报错吧我也不知道随手一加
	if self:GetParent():PassivesDisabled() then return end  --被破坏那没事了
	--if params.unit:IsBuilding() then return end           --是建筑那没事了
	--if params.unit:IsMagicImmune() then return end        --魔免单位那没事了
    if params.attacker:IsIllusion() then return end --分身能继承吗？不能，可能出BUG

    local caster = self:GetParent()
    local target = params.unit
    local ability = self:GetAbility()
    local hpgain_hero = ability:GetSpecialValueFor("haura_hpmpgain_hero")
    local mpgain_hero = ability:GetSpecialValueFor("haura_hpmpgain_hero")
    local hpgain_hero_percent = ability:GetSpecialValueFor("haura_hpmpgain_hero_percent")
    local mpgain_hero_percent = ability:GetSpecialValueFor("haura_hpmpgain_hero_percent")
    local hpgain_creep = ability:GetSpecialValueFor("haura_hpmpgain_creep")
    local mpgain_creep = ability:GetSpecialValueFor("haura_hpmpgain_creep")
    local hpgain_creep_percent = ability:GetSpecialValueFor("haura_hpmpgain_creep_percent")
    local mpgain_creep_percent = ability:GetSpecialValueFor("haura_hpmpgain_creep_percent")
    local maxhp = caster:GetMaxHealth()
    local maxmp = caster:GetMaxMana()
	if target:IsHero() or target:IsBuilding() then
		caster:AddNewModifier(caster,self:GetAbility(),"modifier_dlnec_haura_nec_heal",{duration = 6,stack = mpgain_hero_percent})
		else
		caster:AddNewModifier(caster,self:GetAbility(),"modifier_dlnec_haura_nec_heal",{duration = 6,stack = 1})
	end
	--[[
    if target:IsHero() or target:IsBuilding() then
        local heal_hero = hpgain_hero + maxhp*hpgain_hero_percent/100
        caster:Heal(heal_hero, ability)
        local bumo_hero = mpgain_hero + maxmp*mpgain_hero_percent/100
        caster:GiveMana(bumo_hero)
    else
        local heal_creep = hpgain_creep + maxhp*hpgain_creep_percent/100
        caster:Heal(heal_creep, ability)
        local bumo_creep = mpgain_creep + maxmp*mpgain_creep_percent/100
        caster:GiveMana(bumo_creep)
    end]]
end

function modifier_dlnec_haura_nec:RemoveOnDeath() return self:GetParent():IsIllusion() end      --生命流失部分
function modifier_dlnec_haura_nec:IsAura() return true end
function modifier_dlnec_haura_nec:GetAuraDuration() return 1 end
function modifier_dlnec_haura_nec:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("haura_radius") end
function modifier_dlnec_haura_nec:GetModifierAura() return "modifier_dlnec_haura_target" end
function modifier_dlnec_haura_nec:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_dlnec_haura_nec:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_dlnec_haura_nec:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_dlnec_haura_nec_heal = class({})

function modifier_dlnec_haura_nec_heal:IsHidden() return true end
function modifier_dlnec_haura_nec_heal:IsPurgable() return false end
function modifier_dlnec_haura_nec_heal:IsPurgeException() return false end
function modifier_dlnec_haura_nec_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_dlnec_haura_nec_heal:DeclareFunctions()    --击杀回复血量蓝量部分
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
function modifier_dlnec_haura_nec_heal:GetModifierConstantManaRegen() return self:GetStackCount()*self.mp end
function modifier_dlnec_haura_nec_heal:GetModifierConstantHealthRegen() return self:GetStackCount()*self.hp end
function modifier_dlnec_haura_nec_heal:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.per = self:GetAbility():GetSpecialValueFor("haura_hpmpgain_creep_percent")
	self.hp = self:GetParent():GetMaxHealth()*self.per*0.01
	self.mp = self:GetParent():GetMaxMana()*self.per*0.01
	if keys.stack ~=nil then
		self:SetStackCount(keys.stack)
		else
		self:SetStackCount(1)
	end
end