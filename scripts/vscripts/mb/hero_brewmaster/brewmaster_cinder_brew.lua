-- 02 27 by MysticBug-------
----------------------------
----------------------------

--brewmaster_cinder_brew   余烬佳酿 (新代替醉酒云雾技能)
--将烈酒洒向一片区域，使敌方单位移动变慢，受到技能伤害后还将燃烧。点燃时持续时间增加%extra_duration%秒。
--imba 自残：受影响的敌人几率攻击自己

imba_brewmaster_cinder_brew = class({})

LinkLuaModifier("modifier_imba_cinder_brew_thinker","mb/hero_brewmaster/brewmaster_cinder_brew.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cinder_brew_debuff","mb/hero_brewmaster/brewmaster_cinder_brew.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cinder_brew_burned","mb/hero_brewmaster/brewmaster_cinder_brew.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_cinder_brew:IsHiddenWhenStolen()	return false end
function imba_brewmaster_cinder_brew:IsRefreshable()		return true end
function imba_brewmaster_cinder_brew:IsStealable()			return true end
function imba_brewmaster_cinder_brew:IsNetherWardStealable() return false end

function imba_brewmaster_cinder_brew:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	--弹道音效 sounds/weapons/hero/brewmaster/drunken_haze_cast.vsnd
	--目标音效 sounds/weapons/hero/brewmaster/drunken_haze_target.vsnd
	local brew_particle = "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast_projectile.vpcf"
	print(1+self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100)
	print(self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_3"))
	local duration = self:GetSpecialValueFor("duration")*(1+ self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100)
	local radius = self:GetSpecialValueFor("radius")
	local brew_sound = "Hero_Brewmaster.CinderBrew.Cast"
	--Hero_Brewmaster.Brawler.Crit  Hero_Brewmaster.PrimalSplit.Spawn
	--Hero_Brewmaster.Drunken_Haze.Cast

	EmitSoundOnLocationWithCaster(target_point, brew_sound, caster)
	
	local thinker = CreateModifierThinker(
		caster, 
		self, 
		"modifier_imba_cinder_brew_thinker", 
		{
			duration = duration,
			target_x = target_point.x,
			target_y = target_point.y,
			target_z = target_point.z
		}, 
			target_point, 
			caster:GetTeamNumber(), 
			false
		)

	--弹道特效
	local pfx_tgt = ParticleManager:CreateParticle(brew_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_tgt, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_tgt, 1, target_point)
	ParticleManager:ReleaseParticleIndex(pfx_tgt)
end

--AOE 监测
modifier_imba_cinder_brew_thinker = class({})

function modifier_imba_cinder_brew_thinker:OnCreated(kv)
	if IsServer() then
		self.target_x       = kv.target_x
		self.target_y       = kv.target_y
		self.target_z       = kv.target_z

		local ability       = self:GetAbility()
		local caster        = self:GetCaster()
		local pos           = Vector(self.target_x,self.target_y,self.target_z)
		local brew_particle = "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast.vpcf"

		--BOOM特效
		local pfx = ParticleManager:CreateParticle(brew_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 1, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		-- Find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _, enemy in pairs(enemies) do
			--减速和自残判断
			if not enemy:IsMagicImmune() then 
				enemy:AddNewModifier_RS(
					enemy, 
					ability, 
					"modifier_imba_cinder_brew_debuff", 
					{duration = ability:GetSpecialValueFor("duration")*(1+ self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100)}
				)
				enemy:EmitSound("Hero_Brewmaster.CinderBrew.Target")
			end
		end
	end
end

function modifier_imba_cinder_brew_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
end

--减速、自残、点燃判断
modifier_imba_cinder_brew_debuff = class({})

function modifier_imba_cinder_brew_debuff:IsDebuff()			return true end
function modifier_imba_cinder_brew_debuff:IsHidden() 			return false end
function modifier_imba_cinder_brew_debuff:IsPurgable() 			return true end
function modifier_imba_cinder_brew_debuff:IsPurgeException() 	return true end
function modifier_imba_cinder_brew_debuff:GetEffectName() return "particles/status_fx/status_effect_brewmaster_cinder_brew.vpcf" end
function modifier_imba_cinder_brew_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_cinder_brew_debuff:ShouldUseOverheadOffset() return true end
function modifier_imba_cinder_brew_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_cinder_brew_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow")) end

--自残几率  目标被缴械可以避免
function modifier_imba_cinder_brew_debuff:OnAttackLanded( keys )
	if not IsServer() then
		return 
	end
	local ability    = self:GetAbility()
	local caster     = self:GetCaster()
	local enemy_self = self:GetParent()

	if keys.attacker ~= enemy_self or keys.target:IsIllusion() or not keys.target:IsAlive() then
		return
	end

	if PseudoRandom:RollPseudoRandom(ability, ability:GetSpecialValueFor("self_mutilating_chance")) then
		if not enemy_self:IsInvisible() and not enemy_self:IsInvulnerable() and not enemy_self:IsOutOfGame() then
			enemy_self:PerformAttack(enemy_self, false, true, true, true, false, false, true)
			--自残特效
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_self_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy_self)
			ParticleManager:SetParticleControl(pfx, 0, enemy_self:GetOrigin())
			ParticleManager:SetParticleControl(pfx, 1, enemy_self:GetOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			--自残音效
			enemy_self:EmitSound("Hero_Brewmaster.CinderBrew.SelfAttack")
		end
	end
end

--受伤害点燃持续时间延长
function modifier_imba_cinder_brew_debuff:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return 
	end
	local ability        = self:GetAbility()
	local caster         = self:GetCaster()
	local enemy_self     = self:GetParent()
	local extra_duration = ability:GetSpecialValueFor("extra_duration")
	if caster:TG_HasTalent("special_bonus_imba_brewmaster_3") then 
		extra_duration = math.floor(ability:GetSpecialValueFor("extra_duration") *(1+ caster:TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100))
	end

	if IsServer() then
		--受伤害点燃持续时间延长
		if not enemy_self:HasModifier("modifier_imba_cinder_brew_burned") then		 
			enemy_self:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_cinder_brew_burned", 
				{duration = self:GetDuration() + extra_duration }
			)
			--延长修饰器持续时间
			self:SetDuration(self:GetDuration() + extra_duration,true)
		end
	end
end

--持续燃烧魔法伤害
modifier_imba_cinder_brew_burned = class({})

function modifier_imba_cinder_brew_burned:IsDebuff()			return true end
function modifier_imba_cinder_brew_burned:IsHidden() 			return false end
function modifier_imba_cinder_brew_burned:IsPurgable() 			return true end
function modifier_imba_cinder_brew_burned:IsPurgeException() 	return true end
function modifier_imba_cinder_brew_burned:GetEffectName() 		return "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf" end
function modifier_imba_cinder_brew_burned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_cinder_brew_burned:OnCreated(kv)
	if IsServer() then
	local total_damage = self:GetAbility():GetSpecialValueFor("total_damage")
	if self:GetCaster():TG_HasTalent("special_bonus_imba_brewmaster_3") then 
		total_damage = math.floor(self:GetAbility():GetSpecialValueFor("total_damage") * (1+self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100))
	end
	self.dps = total_damage / self:GetDuration()
	-----------------------------------------------
    -- 灼烧音效
    self:GetParent():EmitSound("Hero_Brewmaster.CinderBrew.Creep")
    -----------------------------------------------
	self:StartIntervalThink(1)
	end
end

function modifier_imba_cinder_brew_burned:OnIntervalThink(kv)
	--if not IsServer() then return end
	local ability    = self:GetAbility()
	local caster     = self:GetCaster()
	local enemy_self = self:GetParent()
	local damageTable = {
					victim = enemy_self,
					attacker = caster,
					damage = self.dps,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional. 火焰伤害
					ability = self:GetAbility(), --Optional.
					}
	ApplyDamage(damageTable)
end