item_diffusal_blade_witchcraft=class({})
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_pa", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_debuff", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_debuff3", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)

function item_diffusal_blade_witchcraft:GetIntrinsicModifierName()
    return "modifier_item_diffusal_blade_witchcraft_pa"
end

function item_diffusal_blade_witchcraft:GetAOERadius()
    return 300
end


function item_diffusal_blade_witchcraft:OnSpellStart()
	local caster = self:GetCaster()
    local target_pos = self:GetCursorPosition()
    local gold =self:GetSpecialValueFor("gold")
        caster:EmitSound( "DOTA_Item.DiffusalBlade.Activate" )
        EmitSoundOnLocationWithCaster( target_pos, "DOTA_Item.DiffusalBlade.Target", caster )
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            target_pos,
            nil,
            self:GetSpecialValueFor( "rd" ),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,
            false)
            if heros~=nil and #heros>0 then
                for _, hero in pairs(heros) do
                    if not hero:HasModifier("modifier_illusions_mirror_image") and (hero:IsIllusion() or (hero:IsCreature() and not hero:IsConsideredHero())) then
                        hero:Kill(self, caster)
                    end
					hero:Purge(true, false, false, false, false)
                    if not hero:IsMagicImmune() then
                        local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
                        ParticleManager:ReleaseParticleIndex(pfx)
                        hero:AddNewModifier(caster, self, "modifier_item_diffusal_blade_witchcraft_debuff", {duration=self:GetSpecialValueFor( "duration" )})
                    end
                end
            end
end

modifier_item_diffusal_blade_witchcraft_pa=class({})

function modifier_item_diffusal_blade_witchcraft_pa:IsHidden()
    return true
end

function modifier_item_diffusal_blade_witchcraft_pa:IsPurgable()
    return false
end

function modifier_item_diffusal_blade_witchcraft_pa:IsPurgeException()
    return false
end

function modifier_item_diffusal_blade_witchcraft_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
    }
end
function modifier_item_diffusal_blade_witchcraft_pa:GetOverrideAttackMagical()
	return 1
end


function modifier_item_diffusal_blade_witchcraft_pa:OnCreated()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
  self.mana_base=self.ability:GetSpecialValueFor("mana_base")
  self.mana_per=self.ability:GetSpecialValueFor("mana_per")*0.01
  self.int=self.ability:GetSpecialValueFor( "int" )
  self.agi=self.ability:GetSpecialValueFor( "agi" )
  self.asp=self.ability:GetSpecialValueFor( "asp" )
  self.attch=self.ability:GetSpecialValueFor( "attch" )

end
function modifier_item_diffusal_blade_witchcraft_pa:OnIntervalThink()
    if not IsServer() then
        return
    end
end

function modifier_item_diffusal_blade_witchcraft_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if (tg.attacker:IsBuilding() or tg.attacker:IsIllusion()) then
        return
    end
    if tg.attacker == self.parent and tg.target:IS_TrueHero_TG() and not tg.target:IsMagicImmune() then
		--if RollPseudoRandomPercentage(self.attch,0,self.parent) and self.cd == true then
				--tg.target:Purge(true, false, false, false, false)

		--end
        local mana=math.max((tg.target:GetMaxMana()*self.mana_per+self.mana_base),0)
        tg.target:Script_ReduceMana(mana,self:GetAbility())
    end
end

function modifier_item_diffusal_blade_witchcraft_pa:GetModifierBonusStats_Intellect()
    return self.int
end

function modifier_item_diffusal_blade_witchcraft_pa:GetModifierBonusStats_Agility()
    return self.agi
end
function modifier_item_diffusal_blade_witchcraft_pa:GetModifierAttackSpeedBonus_Constant()
    return self.asp
end



modifier_item_diffusal_blade_witchcraft_debuff=class({})
function modifier_item_diffusal_blade_witchcraft_debuff:GetTexture()
    return "item_diffusal_blade_witchcraft"
end
function modifier_item_diffusal_blade_witchcraft_debuff:IsDebuff()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff:IsHidden()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff:IsPurgable()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff:IsPurgeException()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_diffusal_blade_witchcraft_debuff:GetEffectName()
    return "particles/tgp/items/diffusal_blade/bloodstone_heal_change.vpcf"
end



function modifier_item_diffusal_blade_witchcraft_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_SILENCED] = true,
    }
end

function modifier_item_diffusal_blade_witchcraft_debuff:OnCreated()
    if self:GetAbility() == nil  then
		return
	end
	self.ab = self:GetAbility()
    self.sp=0-self.ab:GetSpecialValueFor("sp")
	self.dur = self.ab:GetSpecialValueFor("duration")
	if IsServer() then
		self:StartIntervalThink(1)
		self:GetParent():Purge(true, false, false, false, false)
	end
end
function modifier_item_diffusal_blade_witchcraft_debuff:OnIntervalThink()
    if not IsServer() then
        return
    end
	self:GetParent():Purge(true, false, false, false, false)
end

function modifier_item_diffusal_blade_witchcraft_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_diffusal_blade_witchcraft_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end

function modifier_item_diffusal_blade_witchcraft_debuff:OnDestroy()
	if IsServer() then
		if self:GetRemainingTime() >= 1 then
			self:GetParent():AddNewModifier_RS(self:GetCaster(),self.ab,"modifier_item_diffusal_blade_witchcraft_debuff",{duration = self.dur/2})
		end
	end
end