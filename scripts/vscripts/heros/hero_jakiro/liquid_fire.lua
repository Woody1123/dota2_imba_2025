liquid_fire = class({})

LinkLuaModifier("modifier_imba_liquid_fire_passive", "heros/hero_jakiro/liquid_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_liquid_fire_debuff", "heros/hero_jakiro/liquid_fire", LUA_MODIFIER_MOTION_NONE)

function liquid_fire:IsHiddenWhenStolen() 		return false end
function liquid_fire:IsRefreshable() 			return true end
function liquid_fire:IsStealable() 				return true end
function liquid_fire:GetCastRange()		
	if IsServer() then
		return self:GetSpecialValueFor("cast_range")+self:GetCaster():Script_GetAttackRange()-600
	end
end
function liquid_fire:GetIntrinsicModifierName() return "modifier_imba_liquid_fire_passive" end
function liquid_fire:AllowIllusionDuplicate()
    return false
end

function liquid_fire:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local speed =  1200
	local info =
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf",
		iMoveSpeed = speed,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)

end

function liquid_fire:OnProjectileHit(target, location)

	if not target or target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()
	local flag = DOTA_UNIT_TARGET_FLAG_NONE
	if self:GetSpecialValueFor("talent_3") == 1 then
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	target:EmitSound("Hero_Jakiro.LiquidFire")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("aoe_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		flag, 
		FIND_ANY_ORDER,
		false)
		for _, enemy in pairs(enemies) do
			if enemy:IsAlive() then
				enemy:AddNewModifier(caster,self,"modifier_imba_liquid_fire_debuff",{duration = self:GetSpecialValueFor("duration")})
			end
		end
		caster:PerformAttack(target, true, true, true, false, false, false, false)
end

modifier_imba_liquid_fire_debuff = class({})

function modifier_imba_liquid_fire_debuff:IsDebuff()			return true end
function modifier_imba_liquid_fire_debuff:IsHidden() 			return false end
function modifier_imba_liquid_fire_debuff:IsPurgable() 		return true end
function modifier_imba_liquid_fire_debuff:IsPurgeException() 	return true end
function modifier_imba_liquid_fire_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_liquid_fire_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_liquid_fire_debuff:GetModifierMoveSpeedBonus_Percentage() return self.msp end
function modifier_imba_liquid_fire_debuff:GetModifierAttackSpeedBonus_Constant() return self.asp end
function modifier_imba_liquid_fire_debuff:OnCreated()
	if self:GetAbility() == nil then return end
	self.asp = self:GetAbility():GetSpecialValueFor("asp")*-1
	self.msp = self:GetAbility():GetSpecialValueFor("msp")*-1
	if IsServer() then
		self.ab = self:GetAbility()
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		self.damage = self.ab:GetSpecialValueFor("damage")+self.ab:GetSpecialValueFor("damage_per")*self.parent:GetMaxHealth()*0.01
		if self.parent:IsBuilding() then
			self.damage = self.damage*0.1
		end
		self.damageTable = {
							victim =self.parent,
							attacker = self.caster,
							damage = self.damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		self:StartIntervalThink(1)
	end
end

function modifier_imba_liquid_fire_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end
	ApplyDamage(self.damageTable)
end


modifier_imba_liquid_fire_passive = class({})

function modifier_imba_liquid_fire_passive:IsDebuff()			return false end
function modifier_imba_liquid_fire_passive:IsHidden() 		return true end
function modifier_imba_liquid_fire_passive:IsPurgable() 		return false end
function modifier_imba_liquid_fire_passive:IsPurgeException() return false end
function modifier_imba_liquid_fire_passive:AllowIllusionDuplicate()
    return false
end
function modifier_imba_liquid_fire_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_liquid_fire_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsMagicImmune() or not IsEnemy(keys.target, keys.attacker) or keys.target:IsOther() or keys.target:IsCourier() or not keys.target:IsAlive() or self:GetParent():IsIllusion() then
		return
	end
	if keys.target:IsMagicImmune() and self:GetAbility():GetSpecialValueFor("talent_3")~=1 then return end
	if self:GetAbility():IsCooldownReady() then 
	local info =
	{
		Target = keys.target,
		Source = keys.attacker,
		Ability = self:GetAbility(),
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf",
		iMoveSpeed = 6000,
		vSourceLoc = keys.attacker:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
		self:GetAbility():UseResources(true,true,true,true)
	end
end
