-- 04 8 2020 by MysticBug---
----------------------------
----------------------------
---------------------------------
-- Death Prophet Carrion Swarm --
---------------------------------
CreateTalents("npc_dota_hero_death_prophet", "mb/hero_death_prophet/death_prophet_carrion_swarm.lua")


imba_death_prophet_carrion_swarm = class({})

function imba_death_prophet_carrion_swarm:IsHiddenWhenStolen() 		return false end
function imba_death_prophet_carrion_swarm:IsRefreshable() 			return true  end
function imba_death_prophet_carrion_swarm:IsStealable() 			return true  end
function imba_death_prophet_carrion_swarm:IsNetherWardStealable()	return true  end
function imba_death_prophet_carrion_swarm:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
end
function imba_death_prophet_carrion_swarm:GetCooldown(nLevel)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_unique_death_prophet_2") then 
		return self.BaseClass.GetCooldown( self, nLevel)
	else
		return self.BaseClass.GetCooldown( self, nLevel) - caster:TG_GetTalentValue("special_bonus_imba_death_prophet_2")
	end
end
function imba_death_prophet_carrion_swarm:OnSpellStart()
	local caster          = self:GetCaster()
	local pos             = self:GetCursorPosition()
	local direction       = (pos - caster:GetAbsOrigin()):Normalized()
	local dis=(pos- caster:GetAbsOrigin()):Length2D()
	if dis<=0 then
		direction=caster:GetForwardVector()
	end
	direction.z           = 0
	local distance        = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
	--particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf
	--particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf  immoral
	--particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm_symbol_model.vpcf
	local pfx_name        = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf"
	local sound_name      = "Hero_DeathProphet.CarrionSwarm.Particle"
	local sound_name_cast = "Hero_DeathProphet.CarrionSwarm"
	local info = 
	{
		Ability = self,
		EffectName = pfx_name,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("start_radius"),
		fEndRadius = self:GetSpecialValueFor("end_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = direction * self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
		ExtraData = { swarm_split = 1,direction_x = direction.x, direction_y = direction.y}
	}
	ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name_cast, caster)
end

function imba_death_prophet_carrion_swarm:OnProjectileHit_ExtraData(target, location, keys)
	--分裂开
	--0 not split
	--1 split 
	--2 spirit_swarm pro 
	if keys.swarm_split == 1 and not target then 
		-- KV
		local caster          = self:GetCaster()
		local distance        = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
		local swarm_count     = self:GetSpecialValueFor("swarm_count")
		local direction       = Vector(keys.direction_x, keys.direction_y, 0)
		--particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf
		--particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf  immoral
		local pfx_name        = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf"
		local sound_name      = "Hero_DeathProphet.CarrionSwarm.Particle"
		local sound_name_cast = "Hero_DeathProphet.CarrionSwarm"
		for i = 1, swarm_count do
			local swarm_split_direction = (RotatePosition(location, QAngle(0, (-1) * 100 / 2 + (i - 1) * 100 / (swarm_count - 1) , 0),  location + direction * distance) - location):Normalized()
			local info = 
			{
				Ability = self,
				EffectName = pfx_name,
				vSpawnOrigin = location,
				fDistance = distance,
				fStartRadius = self:GetSpecialValueFor("start_radius"),
				fEndRadius = self:GetSpecialValueFor("end_radius"),
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = false,
				vVelocity = swarm_split_direction * self:GetSpecialValueFor("speed"),
				bProvidesVision = false,
				ExtraData = { swarm_split = 2,direction_x = direction.x, direction_y = direction.y}
			}
			ProjectileManager:CreateLinearProjectile(info)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name_cast, caster)
		end	
	end
	--击中
	if target and target:IsAlive() then
		local swam_damage = self:GetAbilityDamage()
		if keys.swarm_split == 2 then 
			swam_damage = self:GetAbilityDamage() / 2
		end
		local done_damage = ApplyDamage(
						{
							victim 			= target,
							damage 			= swam_damage,
							damage_type		= self:GetAbilityDamageType(),
							damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
							attacker 		= self:GetCaster(),
							ability 		= self
						}
					)
		local swarm_heal_pct = self:GetSpecialValueFor("swarm_heal_pct")
		if self:GetCaster():HasModifier("modifier_imba_death_prophet_witchcraft") then 
			local witchcraft_abi = self:GetCaster():FindAbilityByName("imba_death_prophet_witchcraft")
			if witchcraft_abi then 
				swarm_heal_pct = swarm_heal_pct + witchcraft_abi:GetSpecialValueFor("swarm_heal_pct") * self:GetCaster():GetLevel()
			end
		end
		--print("healing Prophet!!! inflictor Name   Swarm",swarm_heal_pct , self:GetAbilityDamage() * swarm_heal_pct / 100 )
		--造成伤害的5% 治疗死亡先知
		self:GetCaster():Heal(done_damage * swarm_heal_pct / 100, self)
		--Hero_DeathProphet.CarrionSwarm.Damage
		EmitSoundOn("Hero_DeathProphet.CarrionSwarm.Damage", target )
	end
end