
--[[
item_imba_blink = class({})

LinkLuaModifier("modifier_imba_blink_disable", "items/item_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blink_break_motion", "items/item_blink", LUA_MODIFIER_MOTION_NONE)

function item_imba_blink:GetIntrinsicModifierName() return "modifier_imba_blink_disable" end

function item_imba_blink:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local max_distance = self:GetSpecialValueFor("max_blink_range") + caster:GetCastRangeBonus()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	if (caster:GetAbsOrigin() - pos):Length2D() > max_distance then
		pos = caster:GetAbsOrigin() + direction * max_distance
	end
	local pos0 = caster:GetAbsOrigin()
	local color
	if caster.blinkcolor then
		color = caster.blinkcolor
	else
		-- Blueish, just a little brighter
		color = Vector(0, 20, 255)
	end
	-- Creating the particle & sound at the start-location
	if HeroItems:UnitHasItem(caster, "earthshaker_arcana") then
		local blink_pfx = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start_v2.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(blink_pfx, 0, pos0)
		ParticleManager:ReleaseParticleIndex(blink_pfx)
		caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
		ProjectileManager:ProjectileDodge(caster)
		local blink_pfx2 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end_v2.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(blink_pfx2)
	else
		local blink_pfx = ParticleManager:CreateParticle("particles/item/blink/blink_dagger_start_imba.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(blink_pfx, 0, pos0)
		ParticleManager:SetParticleControl(blink_pfx, 15, color )
		ParticleManager:ReleaseParticleIndex(blink_pfx)
		caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
		ProjectileManager:ProjectileDodge(caster)
		local blink_pfx2 = ParticleManager:CreateParticle("particles/item/blink/blink_dagger_imbaend.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(blink_pfx2, 15, color )
		ParticleManager:ReleaseParticleIndex(blink_pfx2)
	end
	FindClearSpaceForUnit(caster, pos, true)
	caster:StartGesture(ACT_DOTA_BLINK_DAGGER_END)
	caster:AddNewModifier(caster, self, "modifier_imba_blink_break_motion", {duration = FrameTime()})
end
]]
item_imba_blink_boots = class({})
LinkLuaModifier("modifier_imba_blink_disable", "items/item_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blink_break_motion", "items/item_blink", LUA_MODIFIER_MOTION_NONE)

function item_imba_blink_boots:GetCastRange()
	if IsServer() then
		return 0
	else
		return self:GetSpecialValueFor("max_blink_range")
	end
end

function item_imba_blink_boots:GetIntrinsicModifierName() return "modifier_imba_blink_disable" end

function item_imba_blink_boots:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local cpos=caster:GetAbsOrigin()
	local direction = (pos - cpos):Normalized()
	local max_distance = self:GetSpecialValueFor("max_blink_range") + caster:GetCastRangeBonus() + self:GetSpecialValueFor("max_extra_tooltip")
	if (cpos - pos):Length2D() > max_distance then
		pos = cpos + direction * max_distance
	end
	local extra_distance = math.max(0, (pos - cpos):Length2D() - (self:GetSpecialValueFor("max_blink_range") + caster:GetCastRangeBonus()))
	local extra_cd = (self:GetCooldown(-1) + (extra_distance / self:GetSpecialValueFor("max_extra_tooltip")) * self:GetSpecialValueFor("max_extra_cooldown")) * caster:GetCooldownReduction()
	self:EndCooldown()
	self:StartCooldown(extra_cd)
	--local pos0 = cpos
	local color
	if caster.blinkcolor then
		color = caster.blinkcolor
	else
		-- Blueish, just a little brighter
		color = Vector(0, 20, 255)
	end
		local blink_pfx = ParticleManager:CreateParticle("particles/econ/events/fall_2021/blink_dagger_fall_2021_start_lvl2.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(blink_pfx, 0, cpos)
		ParticleManager:SetParticleControl(blink_pfx, 1, cpos )
		ParticleManager:ReleaseParticleIndex(blink_pfx)
		caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
		ProjectileManager:ProjectileDodge(caster)
		FindClearSpaceForUnit(caster, pos, true)
		local blink_pfx2 = ParticleManager:CreateParticle("particles/econ/events/fall_2021/blink_dagger_fall_2021_end_lvl2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(blink_pfx2, 0, cpos )
		ParticleManager:ReleaseParticleIndex(blink_pfx2)

	--[[local steamid = tonumber(tostring(PlayerResource:GetSteamID(caster:GetPlayerOwnerID())))
	if steamid==nil then
		return
	end
	for i=1,#STEAMID,1 do
		if STEAMID[i]==steamid then
			local P = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/wr_taunt_kiss_heart.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(P)

		end
	end]]
	caster:StartGesture(ACT_DOTA_BLINK_DAGGER_END)
	caster:InterruptMotionControllers(false)
end

modifier_imba_blink_disable = class({})

function modifier_imba_blink_disable:IsDebuff()				return false end
function modifier_imba_blink_disable:IsHidden() 			return true end
function modifier_imba_blink_disable:IsPurgable() 			return false end
function modifier_imba_blink_disable:IsPurgeException() 	return false end
--function modifier_imba_blink_disable:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_blink_disable:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_blink_disable:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE} end
function modifier_imba_blink_disable:GetModifierMoveSpeedBonus_Special_Boots() return self.bonus_movement_speed end
function modifier_imba_blink_disable:OnTakeDamage(keys)
	if IsServer() and keys.unit == self:GetParent() and IsEnemy(keys.unit, keys.attacker) and IsHeroDamage(keys.attacker, keys.damage) then
		if self:GetAbility():GetCooldownTimeRemaining() < self.blink_damage_cooldown then
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(self.blink_damage_cooldown)
		end
	end
end


function modifier_imba_blink_disable:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.bonus_movement_speed =	self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.blink_damage_cooldown = self:GetAbility():GetSpecialValueFor("blink_damage_cooldown")
end



modifier_imba_blink_break_motion = class({})

function modifier_imba_blink_break_motion:IsHidden() return true end
function modifier_imba_blink_break_motion:IsMotionController() return true end
function modifier_imba_blink_break_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_imba_blink_break_motion:IsStunDebuff() return true end
function modifier_imba_blink_break_motion:OnCreated()
	if IsServer() then
		self:CheckMotionControllers()
		self:Destroy()
	end
end