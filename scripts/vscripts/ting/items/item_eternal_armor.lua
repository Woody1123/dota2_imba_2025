item_eternal_armor = class({})
LinkLuaModifier("modifier_eternal_armor_passive", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eternal_armor_buff", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eternal_armor_debuff", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)

function item_eternal_armor:GetIntrinsicModifierName() return "modifier_eternal_armor_passive" end
function item_eternal_armor:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsHero() then return end
	caster:EmitSound("DOTA_Item.Pipe.Activate")
	caster:AddNewModifier(caster,self,"modifier_eternal_armor_buff",{duration = self:GetSpecialValueFor("duration")})
end

modifier_eternal_armor_passive = class({})
LinkLuaModifier("modifier_eternal_armor_buff", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eternal_armor_cd", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
function modifier_eternal_armor_passive:IsDebuff()			return false end
function modifier_eternal_armor_passive:IsHidden() 			return true end
function modifier_eternal_armor_passive:IsPurgable() 		return false end
function modifier_eternal_armor_passive:IsPurgeException() 	return false end
function modifier_eternal_armor_passive:DeclareFunctions() return {	
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}end
function modifier_eternal_armor_passive:OnCreated() 
	if self:GetAbility() == nil then return end
	self.ability = self:GetAbility()
	self.cd_passive = self.ability:GetSpecialValueFor("cd_passive")
	self.cd = true
	self.magic_resistance = self.ability:GetSpecialValueFor("magic_resistance")
	self.armor = self.ability:GetSpecialValueFor("armor")
	self.int = self.ability:GetSpecialValueFor("int")
	self.dam_atr = self.ability:GetSpecialValueFor("dam_atr")*0.01
end
function modifier_eternal_armor_passive:GetModifierBonusStats_Intellect() 
	return self.int
end
function modifier_eternal_armor_passive:GetModifierMagicalResistanceBonus() 
	return self.magic_resistance
end
function modifier_eternal_armor_passive:GetModifierPhysicalArmorBonus() 
	return self.armor
end

function modifier_eternal_armor_passive:OnIntervalThink()
	if not IsServer() then return end
	self.cd = true
end
function modifier_eternal_armor_passive:OnAttackLanded(keys)
    if IsServer() then
        if keys.target == self:GetParent() and keys.attacker:IsHero() and self.cd and not keys.attacker:IsMagicImmune() then
					local damage = self:GetParent():GetPrimaryStatValue()*self.dam_atr		
					if self:GetParent():GetPrimaryAttribute() == 3 then
						damage = self:GetParent():GetStrength()*self.dam_atr
					end
					keys.attacker:SetHealth(math.max(keys.attacker:GetHealth()-damage,2))
					keys.attacker:Script_ReduceMana(damage*0.5,self:GetAbility())
					self:GetParent():GiveMana(damage*0.25)
					self:GetParent():Heal(damage*0.5,self:GetAbility())			
					self.cd = false
					self:StartIntervalThink(self.cd_passive)
        end
    end
end


modifier_eternal_armor_buff = class({})
function modifier_eternal_armor_buff:IsDebuff()			return false end
function modifier_eternal_armor_buff:IsHidden() 			return false end
function modifier_eternal_armor_buff:IsPurgable() 			return false end
function modifier_eternal_armor_buff:RemoveOnDeath()		return false end
function modifier_eternal_armor_buff:IsPurgeException() 	return false end
function modifier_eternal_armor_buff:GetTexture()			return "item_eternal_armor" end
function modifier_eternal_armor_buff:OnCreated()
	if self:GetAbility() == nil then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.dam_atr = self.ability:GetSpecialValueFor("dam_atr")*0.01
	if IsServer() then	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_spirit_ground_projection.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, true, false, -1, false, false)	
	self:StartIntervalThink(1)
	end	
end

function modifier_eternal_armor_buff:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius(self.parent:GetTeam(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(self.parent, self.ability, "modifier_eternal_armor_debuff", {duration = 1.2})
			local damage = self.parent:GetPrimaryStatValue()*self.dam_atr		
			if self:GetParent():GetPrimaryAttribute() == 3 then
					damage = self:GetParent():GetStrength()*self.dam_atr
			end
			enemy:SetHealth(math.max(enemy:GetHealth()-damage,2))
			enemy:Script_ReduceMana(damage*0.5,self:GetAbility())
			self.parent:GiveMana(damage*0.5)
			self.parent:Heal(damage,self.ability)	
		end
	end
end
modifier_eternal_armor_debuff=class({})


function modifier_eternal_armor_debuff:IsDebuff()
     return true
end

function modifier_eternal_armor_debuff:IsHidden()
     return false
end

function modifier_eternal_armor_debuff:IsPurgable()
     return false
end

function modifier_eternal_armor_debuff:IsPurgeException()
     return false
end

function modifier_eternal_armor_debuff:GetTexture()
     return "item_eternal_armor"
end

function modifier_eternal_armor_debuff:RemoveOnDeath()
     return true
end

function modifier_eternal_armor_debuff:GetEffectName() return "particles/items2_fx/veil_of_discord_debuff.vpcf" end
function modifier_eternal_armor_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_eternal_armor_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_eternal_armor_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -40
end

function modifier_eternal_armor_debuff:GetModifierAttackSpeedBonus_Constant()
    return  -150
end