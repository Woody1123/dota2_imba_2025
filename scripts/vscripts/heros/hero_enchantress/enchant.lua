enchant= class({})
LinkLuaModifier("modifier_enchant_buff", "heros/hero_enchantress/enchant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchant_debuff", "heros/hero_enchantress/enchant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_heavens_halberd_v2_debuff", "items/item_heavens_halberd_v2.lua", LUA_MODIFIER_MOTION_NONE)
function enchant:IsHiddenWhenStolen()
    return false
end

function enchant:IsStealable()
    return true
end


function enchant:IsRefreshable()
    return true
end

function enchant:CastFilterResultTarget(target)
	if (not target:IsNeutralUnitType()  and not target:IsHero()) or  target:IsIllusion()  then
		return UF_FAIL_CUSTOM
	end
end

function enchant:GetCustomCastErrorTarget(target)
    return "只能对野怪，英雄使用"
end

function enchant:OnSpellStart()
	local caster = self:GetCaster()
    local target= self:GetCursorTarget()
    local dur=self:GetSpecialValueFor("dur")
    local unit=target
    caster:EmitSound("Hero_Enchantress.EnchantCreep")
    if target:IS_TrueHero_TG() then
        if  target:TG_TriggerSpellAbsorb(self)   then
            return
        end
        target:AddNewModifier_RS(caster, self, "modifier_enchant_debuff", {duration=self:GetSpecialValueFor("durhero")})
    elseif target:IsNeutralUnitType()  and not target:IsBoss() and not target:IsAncient() then
        for a=0,2 do
            unit=CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
            unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
            unit:AddNewModifier(caster, self, "modifier_kill", {duration = dur})
            unit:AddNewModifier(caster, self, "modifier_enchant_buff", {duration=dur})
			unit:AddNewModifier(caster, self, "modifier_unit_remove", {duration=dur})
        end
    end
end

modifier_enchant_buff=class({})


function modifier_enchant_buff:IsPurgable()
    return false
end

function modifier_enchant_buff:IsPurgeException()
    return false
end

function modifier_enchant_buff:IsHidden()
    return false
end

function modifier_enchant_buff:OnCreated()
	if self:GetAbility() == nil then return end
    self.ATT=self:GetAbility():GetSpecialValueFor("att")*self:GetCaster():GetLevel()
    self.AR=self:GetAbility():GetSpecialValueFor("ar")
	if not IsServer() then
		return
    end

    self:GetParent():Interrupt()
    self:GetParent():Stop()
end


function modifier_enchant_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_enchant_buff:GetModifierPhysicalArmorBonus()
    return  self.AR
end

function modifier_enchant_buff:GetModifierPreAttack_BonusDamage()
	return self.ATT
end


function modifier_enchant_buff:CheckState()
	return
	 {
		   [MODIFIER_STATE_DOMINATED] = true,
	}
end


modifier_enchant_debuff=class({})
function modifier_enchant_debuff:IsHidden()
    return false
end

function modifier_enchant_debuff:IsPurgable()
    return not self:GetCaster():TG_HasTalent("special_bonus_enchantress_6")
end

function modifier_enchant_debuff:IsPurgeException()
    return  not self:GetCaster():TG_HasTalent("special_bonus_enchantress_6")
end


function modifier_enchant_debuff:GetEffectName()
    return "particles/units/heroes/hero_enchantress/enchantress_enchant_slow.vpcf"
end

function modifier_enchant_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_enchant_debuff:CheckState()
	return { [MODIFIER_STATE_ATTACK_ALLIES] = true,
}
end
function modifier_enchant_debuff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		}
end
function modifier_enchant_debuff:OnCreated()
	if self:GetAbility()~=nil then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
	end
end
function modifier_enchant_debuff:OnAttackStart( params )
	if not IsServer() then
		return
	end
	if params.attacker==self.parent and params.target==self.caster then 	
		local hit = false
		local heros = FindUnitsInRadius(
			self.parent:GetTeamNumber(),
			self.parent:GetAbsOrigin(),
			nil,
			700, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_CLOSEST,false)
		if #heros>0 then
			for _, hero in pairs(heros) do
				if hero~=self.parent  then  
						self.parent:MoveToTargetToAttack(hero)
						hit = true
						break
					end
			end
		end
		if not hit then
			self.parent:AddNewModifier(self.caster,self:GetAbility(),"modifier_item_heavens_halberd_v2_debuff",{duration = 0.5})
		end
	end
end

