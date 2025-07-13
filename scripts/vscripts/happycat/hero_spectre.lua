--2022 11 14 happycat 
 CreateTalents("npc_dota_hero_spectre", "happycat/hero_spectre")


haunt = class({})
LinkLuaModifier("modifier_imba_haunt", "happycat/hero_spectre", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_haunt_debuff", "happycat/hero_spectre", LUA_MODIFIER_MOTION_NONE)
function haunt:GetCustomCastErrorTarget(target)
	if not target:IsHero() then
		return "无法释放"
	end
	if not IsEnemy(target, self:GetCaster()) then
		return "无法释放"
	end	
end
function haunt:CastFilterResultTarget(target)
	if IsServer() then

		if not target:IsHero() then
			return UF_FAIL_CUSTOM
		end
		if not IsEnemy(target, self:GetCaster()) then
			return UF_FAIL_CUSTOM
		end			
	end
end
function haunt:GetCastPoint()
	if	IsServer()  then 
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_haunt") then
			return 0.1
		else
			return 0.3
		end
	end		 
end
function haunt:GetBehavior()
	if not self:GetCaster():HasModifier("modifier_imba_haunt") then  
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end
function haunt:GetManaCost(a) 
	if self:GetCaster():HasModifier("modifier_imba_haunt") then  
		return 0	
	end
	return 200 
end
function haunt:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_haunt") then  
		return  "spectre_reality"	
	end
	return "spectre_haunt"
end
function haunt:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:HasScepter() then 
		return (cooldown - self:GetSpecialValueFor("sce_cd"))
	end
	return cooldown
end

function haunt:OnUpgrade()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("spectre_reality")
	ability:SetLevel(1)
end

function haunt:IsHiddenWhenStolen() 		return true end
function haunt:IsStealable() 			return false end
function haunt:OnSpellStart()

	if not self:GetCaster():FindModifierByName("modifier_imba_haunt") then
		local duration = self:GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_3")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_haunt", {duration = duration})	
		local enemy = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			self:GetCaster():GetAbsOrigin(), 
			nil, 
			40000, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false)
		for i=1, #enemy do
			Timers:CreateTimer(FrameTime()*i*2, function()
				enemy[i]:AddNewModifier(self:GetCaster(), self, "modifier_imba_haunt_debuff", {duration = duration})
				return nil
			end)		
		end
		Timers:CreateTimer(FrameTime()*2, function()
			self:EndCooldown()
			return nil
		end)
	else
		local pos = self:GetCursorPosition()
		local target = nil
		local enemy = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			pos, 
			nil, 
			40000, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
		    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_CLOSEST, 
			false)
		if #enemy < 1 then
			Notifications:Bottom(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), {text="没有找到视野内的敌人", duration=1.5, style={color="#FF0000", ["font-size"]="40px"}})
			self:EndCooldown()
			self:StartCooldown(0.2)
		end	 	
		for i=1, #enemy do
			target = enemy[i]
			if target then
				FindClearSpaceForUnit(self:GetCaster(), target:GetAbsOrigin(), false)
				Timers:CreateTimer(FrameTime()*2, function()
					FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
				return nil
				end)
				self:GetCaster():MoveToTargetToAttack(target)
				EmitSoundOn("Hero_Spectre.Reality",target )
				self:EndCooldown()
				self:StartCooldown(1)				
				break
			end							
		end		 
	end				
end
modifier_imba_haunt = class({})

function modifier_imba_haunt:IsDebuff()				return false end
function modifier_imba_haunt:IsHidden() 			return false end
function modifier_imba_haunt:IsPurgable() 			return false end
function modifier_imba_haunt:IsPurgeException() 	return false end
function modifier_imba_haunt:GetTexture() return "spectre_haunt" end
function modifier_imba_haunt:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.agility = self.ability:GetSpecialValueFor("agility")
	if IsServer() then
		EmitSoundOn("Hero_Spectre.Haunt", self:GetParent())
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetCaster():GetAbsOrigin())		

	end	
end
function modifier_imba_haunt:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * self:GetCaster():GetCooldownReduction()) - self:GetElapsedTime())					
	end
end
modifier_imba_haunt_debuff = class({})

function modifier_imba_haunt_debuff:IsDebuff()				return true end
function modifier_imba_haunt_debuff:IsHidden() 			return false end
function modifier_imba_haunt_debuff:IsPurgable() 			return false end
function modifier_imba_haunt_debuff:IsPurgeException() 	return false end
function modifier_imba_haunt_debuff:CheckState()	
	return {[MODIFIER_STATE_INVISIBLE] = false } 
end
function modifier_imba_haunt_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_haunt_debuff:GetModifierProvidesFOWVision()
	return 1
end
function modifier_imba_haunt_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
   	} 
end
function modifier_imba_haunt_debuff:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	if IsServer() then
		self.pfx = ParticleManager:CreateParticleForPlayer("particles/econ/items/spectre/spectre_arcana/spectre_arcana_debut_screen_border.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
		ParticleManager:SetParticleControl(self.pfx, 0, Vector(0, 0, 0))
		self:AddParticle(self.pfx, true, false, 15, false, false)	
	end	
end
function modifier_imba_haunt_debuff:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end			
	end
end