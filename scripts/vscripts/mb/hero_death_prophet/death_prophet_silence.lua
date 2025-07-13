---------------------------------
--    Death Prophet Silence    --
---------------------------------
--魔法治疗 时间内目标受到法术伤害的10%将治疗死亡先知

imba_death_prophet_silence = class({})
LinkLuaModifier("modifier_imba_death_prophet_silence", "mb/hero_death_prophet/death_prophet_silence.lua", LUA_MODIFIER_MOTION_NONE)

function imba_death_prophet_silence:IsHiddenWhenStolen() 	return false end
function imba_death_prophet_silence:IsRefreshable() 		return true  end
function imba_death_prophet_silence:IsStealable() 			return true  end
function imba_death_prophet_silence:IsNetherWardStealable()	return true  end
function imba_death_prophet_silence:GetAOERadius() return self:GetSpecialValueFor("radius") end
function imba_death_prophet_silence:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
end
function imba_death_prophet_silence:OnSpellStart()
	--音效
	self:GetCaster():EmitSound("Hero_DeathProphet.Silence")
	--特效
	--particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_ti9.vpcf
	--particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf
	local pfx = ParticleManager:CreateParticle("particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_ti9.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), 0, 1))
	ParticleManager:ReleaseParticleIndex(pfx)
	--范围沉默
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCursorPosition(),
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	local spirit_siphon_abi = self:GetCaster():FindAbilityByName("imba_death_prophet_spirit_siphon")

	for _, enemy in pairs(enemies) do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)

		enemy:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_death_prophet_silence", {duration = self:GetDuration()}):SetDuration(self:GetDuration() * (1 - enemy:GetStatusResistance()), true)
		--IMBA Add imba_death_prophet_spirit_siphon
		if spirit_siphon_abi and spirit_siphon_abi:GetLevel() > 0 and enemy:IsHero() then 
			self:GetCaster():AddNewModifier_RS(self:GetCaster(), spirit_siphon_abi, "modifier_imba_death_prophet_spirit_siphon", {target = enemy:entindex(), duration = self:GetDuration() / 2})
		end
	end
end

modifier_imba_death_prophet_silence = class({})
--particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9.vpcf
--particles/generic_gameplay/generic_silenced.vpcf
function modifier_imba_death_prophet_silence:GetHeroEffectName()   return "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9.vpcf" end
function modifier_imba_death_prophet_silence:GetEffectName() 	   return "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf" end
function modifier_imba_death_prophet_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_death_prophet_silence:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end

function modifier_imba_death_prophet_silence:OnCreated()
	--if IsServer() then
	--	self.pfx = ParticleManager:CreateParticle("particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	--	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetOrigin())
	--end
end

function modifier_imba_death_prophet_silence:OnDestroy()
	--if IsServer() then
	--	if self.pfx and self.pfx ~= nil then
	--		print("death_prophet pfx",self.pfx)
	--		ParticleManager:ReleaseParticleIndex(self.pfx)
	--		ParticleManager:DestroyParticle(self.pfx,true)
	--	end
	--end
end

function modifier_imba_death_prophet_silence:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_death_prophet_silence:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return
	end
	if keys.inflictor then
		--受到法术伤害的5% 治疗死亡先知
		local silence_heal_pct = self:GetAbility():GetSpecialValueFor("silence_heal_pct")
		if self:GetCaster():HasModifier("modifier_imba_death_prophet_witchcraft") then 
			local witchcraft_abi = self:GetCaster():FindAbilityByName("imba_death_prophet_witchcraft")
			if witchcraft_abi then 
				silence_heal_pct = silence_heal_pct + witchcraft_abi:GetSpecialValueFor("silence_heal_pct") * self:GetCaster():GetLevel()
			end
		end
		--print("healing Prophet!!! inflictor Name +++ ",keys.inflictor:GetName(),silence_heal_pct , keys.damage * silence_heal_pct / 100 )
		self:GetCaster():Heal(keys.damage * silence_heal_pct / 100, self:GetAbility())
	end
end