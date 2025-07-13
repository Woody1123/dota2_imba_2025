---------------------------------
-- 	Death Prophet Witchcraft   --
---------------------------------
--被动提升死亡先知移速
--被动提升其他技能IMBA效果

imba_death_prophet_witchcraft = class({})
LinkLuaModifier("modifier_imba_death_prophet_witchcraft", "mb/hero_death_prophet/death_prophet_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_prophet_witchcraft_scepter", "mb/hero_death_prophet/death_prophet_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)

function imba_death_prophet_witchcraft:IsTalentAbility() return true end
function imba_death_prophet_witchcraft:OnHeroLevelUp()
	if self:GetLevel() <= 0 then 
		self:SetLevel(1)
	end
end
function imba_death_prophet_witchcraft:GetIntrinsicModifierName() return "modifier_imba_death_prophet_witchcraft" end

modifier_imba_death_prophet_witchcraft = class({})
function modifier_imba_death_prophet_witchcraft:IsPurgable() 				return false end
function modifier_imba_death_prophet_witchcraft:IsPurgeException() 			return false end
function modifier_imba_death_prophet_witchcraft:IsHidden()					return true end
function modifier_imba_death_prophet_witchcraft:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,MODIFIER_EVENT_ON_TAKEDAMAGE}
	return funcs
end
function modifier_imba_death_prophet_witchcraft:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") * self:GetCaster():GetLevel()
end

function modifier_imba_death_prophet_witchcraft:GetModifierPercentageManacostStacking()
	return self:GetAbility():GetSpecialValueFor("mana_cost_adjust") * self:GetCaster():GetLevel()
end

--function modifier_imba_death_prophet_witchcraft:OnTakeDamage(keys)
--	if not IsServer() then
--		return
--	end
--	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then 
--		return 
--	end
--	if keys.inflictor then
--		--只有DP自身技能可以触发
--		if (keys.inflictor:GetAbilityName() == "imba_death_prophet_carrion_swarm") or (keys.inflictor:GetAbilityName() == "imba_death_prophet_silence") or (keys.inflictor:GetAbilityName() == "imba_death_prophet_spirit_siphon") then 
--			--print("abi inflictor ---",keys.inflictor:GetAbilityName(),keys.unit:GetName())
--			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_death_prophet_witchcraft_scepter", {}) 
--			self:GetParent():PerformAttack(keys.unit, false, true, true, true, false, false, false)
--			self:GetParent():RemoveModifierByName("modifier_imba_death_prophet_witchcraft_scepter")
--		end
--	end
--end
--
--modifier_imba_death_prophet_witchcraft_scepter = class({})
--function modifier_imba_death_prophet_witchcraft_scepter:IsDebuff()      return false end
--function modifier_imba_death_prophet_witchcraft_scepter:IsHidden()      return true end
--function modifier_imba_death_prophet_witchcraft_scepter:IsPurgable()    return false end
--function modifier_imba_death_prophet_witchcraft_scepter:IsPurgeException()  return false end
--function modifier_imba_death_prophet_witchcraft_scepter:DeclareFunctions() return  {MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE} end
--function modifier_imba_death_prophet_witchcraft_scepter:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
--function modifier_imba_death_prophet_witchcraft_scepter:GetModifierOverrideAttackDamage() return self:GetParent():GetLevel() * 10 end