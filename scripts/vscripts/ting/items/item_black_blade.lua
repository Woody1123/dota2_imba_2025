item_imba_black_blade = class({})
LinkLuaModifier("modifier_imba_blcak_blade_passive", "ting/items/item_black_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_black_blade_buff1", "ting/items/item_black_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_black_blade_buff2", "ting/items/item_black_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_black_blade_buff3", "ting/items/item_black_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_black_blade_debuff", "ting/items/item_black_blade", LUA_MODIFIER_MOTION_NONE)
function item_imba_black_blade:GetIntrinsicModifierName()
    return "modifier_imba_blcak_blade_passive"
end

function item_imba_black_blade:GetCastRange()
	if IsServer() then
		return 800+self:GetCaster():Script_GetAttackRange()-self:GetCaster():GetBaseAttackRange()
	end
end

function item_imba_black_blade:OnSpellStart()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
--[[
    local mod = target:FindAllModifiers()
    for _, m in pairs(mod) do
        print(tostring(m:GetName()))
    end]]
    EmitSoundOn("DOTA_Item.EtherealBlade.Activate", caster)
    local projectile = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "particles/items_fx/ethereal_blade.vpcf",
        iMoveSpeed = 2500,
        vSourceLoc = caster:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,
    }
    TG_CreateProjectile({ id = 1, team = caster:GetTeamNumber(), owner = caster, p = projectile })


end

function item_imba_black_blade:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    caster:TG_IS_ProjectilesValue(function()
        target = nil
    end)
    if target  then

        if target:TriggerSpellAbsorb(self) then
            return nil
        end
		
        target:EmitSound("DOTA_Item.EtherealBlade.Target")
        target:AddNewModifier(caster, self, "modifier_item_imba_black_blade_buff1", { duration = duration })
		if not target:IsMagicImmune() then
			if Is_Chinese_TG(caster, target)  then
				target:AddNewModifier(caster, self, "modifier_item_imba_black_blade_buff2", { duration = duration })
			else
				target:AddNewModifier_RS(caster, self, "modifier_item_imba_black_blade_buff3", { duration = duration })
				local maxStatValue=max(target:GetPrimaryStatValue(),caster:GetPrimaryStatValue())
				local damageTable = {
					attacker = caster,
					ability = self,
					damage_type = DAMAGE_TYPE_MAGICAL,
					victim = target,
					damage = maxStatValue* self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage_base"),
				}
				ApplyDamage(damageTable)
			end
		end
    end
end
modifier_item_imba_black_blade_buff1 = class({})
function modifier_item_imba_black_blade_buff1:IsDebuff()
    return not Is_Chinese_TG(self.caster, self.parent)
end
function modifier_item_imba_black_blade_buff1:IsHidden()
    return false
end
function modifier_item_imba_black_blade_buff1:IsPurgable()
    return true
end
function modifier_item_imba_black_blade_buff1:GetTexture()
    return "item_black_blade"
end
function modifier_item_imba_black_blade_buff1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end
function modifier_item_imba_black_blade_buff1:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_item_imba_black_blade_buff1:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_item_imba_black_blade_buff1:StatusEffectPriority()
    return 16
end
function modifier_item_imba_black_blade_buff1:OnCreated()
    if self:GetAbility() ~= nil then
        self.ability = self:GetAbility()
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.magic_nerf = self:GetAbility():GetSpecialValueFor("magic_nerf") * -1
    end
end

function modifier_item_imba_black_blade_buff1:OnDestroy()
    self.magic_nerf = nil
end
function modifier_item_imba_black_blade_buff1:GetModifierMagicalResistanceBonus()
    return self.magic_nerf
end

modifier_item_imba_black_blade_buff2 = class({})
function modifier_item_imba_black_blade_buff2:IsDebuff()
    return false
end
function modifier_item_imba_black_blade_buff2:IsHidden()
    return false
end
function modifier_item_imba_black_blade_buff2:IsPurgable()
    return true
end
function modifier_item_imba_black_blade_buff2:GetTexture()
    return "item_black_blade"
end
function modifier_item_imba_black_blade_buff2:CheckState()
    return
    {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
end

modifier_item_imba_black_blade_buff3 = class({})
function modifier_item_imba_black_blade_buff3:IsDebuff()
    return true
end
function modifier_item_imba_black_blade_buff3:IsHidden()
    return false
end
function modifier_item_imba_black_blade_buff3:IsPurgable()
    return true
end
function modifier_item_imba_black_blade_buff3:GetTexture()
    return "item_black_blade"
end
function modifier_item_imba_black_blade_buff3:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end
function modifier_item_imba_black_blade_buff3:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end
function modifier_item_imba_black_blade_buff3:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_item_imba_black_blade_buff3:CheckState()
    return
    {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = false,
    }
end
function modifier_item_imba_black_blade_buff3:OnCreated()
    if self:GetAbility() ~= nil then
        self.slow = self:GetAbility():GetSpecialValueFor("slow") * -1
    end
end
modifier_imba_blcak_blade_passive = class({})
LinkLuaModifier("modifier_item_imba_black_blade_debuff", "ting/items/item_black_blade", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_blcak_blade_passive:IsDebuff()
    return false
end
function modifier_imba_blcak_blade_passive:IsHidden()
    return true
end
function modifier_imba_blcak_blade_passive:IsPurgable()
    return false
end
function modifier_imba_blcak_blade_passive:IsPurgeException()
    return false
end
function modifier_imba_blcak_blade_passive:OnCreated()
    if self:GetAbility() ~= nil then
        self.ab = self:GetAbility()
        self.parent = self:GetParent()
        self.asp = self.ab:GetSpecialValueFor("asp")
        self.int = self.ab:GetSpecialValueFor("int")
       -- self.agi = self.ab:GetSpecialValueFor("agi")
        self.stat = self.ab:GetSpecialValueFor("damage_pa")
        self.speed = self.ab:GetSpecialValueFor("project_speed_bonus")
        self.duration = self.ab:GetSpecialValueFor("duration_pa")
       -- self.str = self.ab:GetSpecialValueFor("str")
        self.Armor = self.ab:GetSpecialValueFor("Armor")
        self.spell_amp = self.ab:GetSpecialValueFor("spell_amp")
		self.cd_dot = self.ab:GetSpecialValueFor("cd_dot")
     --   self.spell_lifesteal_amp = self.ab:GetSpecialValueFor("spell_lifesteal_amp")
    --    self.allmana = self.ab:GetSpecialValueFor("allmana")
        self.miss = false
        self.damageTable = {
            attacker = self.parent,
            ability = self.ab,
            damage_type = DAMAGE_TYPE_MAGICAL,
        }

			self.cd = false

    end
end
function modifier_imba_blcak_blade_passive:OnIntervalThink()
		self.cd = false
end	
function modifier_imba_blcak_blade_passive:DeclareFunctions()
    return {
      --  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --力量
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --护甲
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --技能增强
     --   MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET, --治疗增强
     --   MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE, --魔法恢复增强
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
       -- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        --MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_imba_blcak_blade_passive:GetModifierProjectileName()
    return "particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_base_attack_retro_tormented.vpcf"
end
--[[
function modifier_imba_blcak_blade_passive:OnAttackStart(keys)
    if not IsServer() then
        return
    end
    if keys.attacker == self.parent then
        self.miss = true
    end
end]]

function modifier_imba_blcak_blade_passive:OnAttackLanded(keys)
    if IsServer() then
        if keys.attacker == self.parent and not keys.target:IsBuilding() and keys.target:IsHero() and not keys.target:IsOther() then
           -- if self.miss then
               -- self.miss = false
                self.damageTable.victim = keys.target
                self.damageTable.damage = self.parent:GetIntellect(false) * self.stat
                ApplyDamage(self.damageTable)
                SendOverheadEventMessage(keys.target, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, keys.target, self.damageTable.damage, keys.target)
				if self.cd == false then
					keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_imba_black_blade_debuff", { duration = self.duration })
					self.cd = true
					self:StartIntervalThink(self.cd_dot)
				end
          --  end
        end
    end
end


function modifier_imba_blcak_blade_passive:GetModifierProjectileSpeedBonus()
    return self.speed
end

function modifier_imba_blcak_blade_passive:GetModifierAttackSpeedBonus_Constant()
    return self.asp
end
function modifier_imba_blcak_blade_passive:GetModifierBonusStats_Strength()
    return self.str
end
function modifier_imba_blcak_blade_passive:GetModifierBonusStats_Intellect()
    return self.int
end
function modifier_imba_blcak_blade_passive:GetModifierBonusStats_Agility()
    return self.agi
end
function modifier_imba_blcak_blade_passive:GetModifierPhysicalArmorBonus()
    return self.Armor
end
function modifier_imba_blcak_blade_passive:GetModifierSpellAmplify_Percentage()
    return self.spell_amp
end
function modifier_imba_blcak_blade_passive:GetModifierHealAmplify_PercentageTarget()
    return self.spell_lifesteal_amp
end
function modifier_imba_blcak_blade_passive:GetModifierMPRegenAmplify_Percentage()
    return self.allmana end

function modifier_imba_blcak_blade_passive:OnDestroy()
    self.asp = nil
    self.int = nil
    self.agi = nil
    self.speed = nil
    self.duration = nil
    self.ab = nil
    self.str = nil
    self.Armor = nil
    self.spell_amp = nil
    self.spell_lifesteal_amp = nil
    self.allmana = nil
end

modifier_item_imba_black_blade_debuff = class({})
function modifier_item_imba_black_blade_debuff:IsDebuff()
    return true
end
function modifier_item_imba_black_blade_debuff:IsHidden()
    return false
end
function modifier_item_imba_black_blade_debuff:IsPurgable()
    return false
end
function modifier_item_imba_black_blade_debuff:IsPurgeException()
    return false
end
function modifier_item_imba_black_blade_debuff:GetTexture()
    return "item_black_blade"
end
function modifier_item_imba_black_blade_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_item_imba_black_blade_debuff:OnCreated()
    if self:GetAbility() ~= nil then
        self.ability = self:GetAbility()
		self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.magic_nerf_pa = self:GetAbility():GetSpecialValueFor("magic_nerf_pa") * -1
		self.magic_nerf_ex = self:GetAbility():GetSpecialValueFor("magic_nerf_ex") * -1
		self.magic_dmg_dot = self:GetAbility():GetSpecialValueFor("magic_dmg_dot")
    end
	if IsServer() then	
	      self.damageTable = {
            attacker = self.caster,
			victim = self.parent,
            ability = self.ability,
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
		 
		self:StartIntervalThink(0.2)
		self.t = 0.2
	end
end
function modifier_item_imba_black_blade_debuff:OnIntervalThink()
	if IsServer() then
		self.parent:RemoveModifierByName("modifier_item_witch_blade_slow")
		self.t = self.t + 0.2
		if self.t-1 == 0 then
			self.t = 0
			self.damageTable.damage = self.magic_dmg_dot*self.caster:GetIntellect(false)
			SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self.parent, self.damageTable.damage, self.parent)
			ApplyDamage(self.damageTable)
		end		
	end
end
function modifier_item_imba_black_blade_debuff:OnDestroy()
    self.magic_nerf_pa = nil
    self.magic_nerf_ex = nil
end
function modifier_item_imba_black_blade_debuff:GetModifierMagicalResistanceBonus()
    return self.parent:IsMagicImmune() and self.magic_nerf_ex or self.magic_nerf_pa
end
