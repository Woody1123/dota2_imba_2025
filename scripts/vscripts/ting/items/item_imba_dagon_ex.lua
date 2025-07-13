
LinkLuaModifier("modifier_imba_dagon_passive", "ting/items/item_imba_dagon_ex.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_dagon_passive = class({})

function modifier_imba_dagon_passive:IsDebuff()			return false end
function modifier_imba_dagon_passive:IsHidden() 		return true end
function modifier_imba_dagon_passive:IsPurgable() 		return false end
function modifier_imba_dagon_passive:IsPurgeException() return false end
function modifier_imba_dagon_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_dagon_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_dagon_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end

function modifier_imba_dagon_passive:OnCreated( )
	if self:GetAbility() == nil  then
		return
	end
	self.ab = self:GetAbility()
	self.amp = self:GetAbility():GetSpecialValueFor("amp")
	self.int = self:GetAbility():GetSpecialValueFor("int")

end


function modifier_imba_dagon_passive:GetModifierBonusStats_Intellect() return self.int end
function modifier_imba_dagon_passive:GetModifierSpellAmplify_Percentage() return self.amp end

local function IMBA_Dagon_Main_Target(iItemLevel, strPfxName, fDamage, hCaster, hTarget, hAbility)
	hCaster:EmitSound("DOTA_Item.Dagon.Activate")
	hTarget:EmitSound("DOTA_Item.Dagon5.Target")
	local pfx = ParticleManager:CreateParticle(strPfxName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 2, Vector(iItemLevel, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	ApplyDamage({victim = hTarget, attacker = hCaster, damage_type = DAMAGE_TYPE_MAGICAL, damage = fDamage, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = hAbility})
end

local function IMBA_Dagon_Bounce_Target(iItemLevel, strPfxName, fDamage, hCaster, hTarget, hAbility, fBDamage, iBRange, iBDecay)
	local damage = fBDamage
	local units = {}
	table.insert(units, hTarget)
	for i, aunit in pairs(units) do
		local units1 = FindUnitsInRadius(hCaster:GetTeamNumber(), aunit:GetAbsOrigin(), nil, iBRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _, unit1 in pairs(units1) do
			local no_yet = true
			for _, unit in pairs(units) do
				if unit == unit1 or unit1 == hCaster then
					no_yet = false
					break
				end
			end
			if no_yet then
				table.insert(units, unit1)
				break
			end
		end
	end
	for i=1, #units - 1 do
		local pfx = ParticleManager:CreateParticle(strPfxName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i]:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, units[i+1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i+1]:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 2, Vector(iItemLevel, 0, 0))
		ParticleManager:ReleaseParticleIndex(pfx)
		
		units[i+1]:AddNewModifier(hCaster,hAbility,"modifier_imba_dagon_debuff",{duration=hAbility:GetSpecialValueFor("duration")})
		ApplyDamage({victim = units[i+1], attacker = hCaster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = hAbility})
		damage = damage * (1 - iBDecay / 100)
		units[i+1]:EmitSound("DOTA_Item.Dagon5.Target")
	end
end

item_imba_dagon = class({})
LinkLuaModifier("modifier_imba_dagon_debuff", "ting/items/item_imba_dagon_ex.lua", LUA_MODIFIER_MOTION_NONE)
function item_imba_dagon:GetIntrinsicModifierName() return "modifier_imba_dagon_passive" end

function item_imba_dagon:Precache( context )
	PrecacheResource( "particle", "particles/items_fx/dagon.vpcf", context )
end

function item_imba_dagon:OnSpellStart()
	if not self:GetCursorTarget():TG_TriggerSpellAbsorb(self) then
		IMBA_Dagon_Main_Target(1, "particles/items_fx/dagon.vpcf", self:GetSpecialValueFor("damage"), self:GetCaster(), self:GetCursorTarget(), self)
	end
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if target:IsIllusion() and not target:HasModifier("modifier_illusions_mirror_image") then
        local pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:ReleaseParticleIndex(pfx)
		target:Kill(self, caster)
		return
    end
end





item_imba_dagon_ex = class({})

function item_imba_dagon_ex:GetIntrinsicModifierName() return "modifier_imba_dagon_passive" end

function item_imba_dagon_ex:Precache( context )
	PrecacheResource( "particle", "particles/item/dagon/dagon_green.vpcf", context )
end

function item_imba_dagon_ex:OnSpellStart()
	if not self:GetCursorTarget():TG_TriggerSpellAbsorb(self) then
		local atr = self:GetCaster():GetStrength()+self:GetCaster():GetAgility()+self:GetCaster():GetIntellect(false)
		local charge = math.max(self:GetCurrentAbilityCharges(),1)
		local damage = self:GetSpecialValueFor("damage")*self:GetCaster():GetLevel() + atr*self:GetSpecialValueFor("damage_atr")
			damage = damage*(1+charge*0.1)
		local bounce_decay = self:GetSpecialValueFor("bounce_decay")
		self:SetCurrentCharges(0) 
		IMBA_Dagon_Main_Target(10, "particles/item/dagon/dagon_green.vpcf", damage, self:GetCaster(), self:GetCursorTarget(), self)		
		self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_imba_dagon_debuff",{duration=self:GetSpecialValueFor("duration")})
		IMBA_Dagon_Bounce_Target(10, "particles/item/dagon/dagon_green.vpcf", 0, self:GetCaster(), self:GetCursorTarget(), self, damage*(1-bounce_decay/100), self:GetSpecialValueFor("bounce_range"), bounce_decay)
	end
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if target:IsIllusion() and not target:HasModifier("modifier_illusions_mirror_image") then
        local pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:ReleaseParticleIndex(pfx)
		target:Kill(self, caster)
		return
    end
end

modifier_imba_dagon_debuff = class({})
function modifier_imba_dagon_debuff:IsDebuff() return false end
function modifier_imba_dagon_debuff:IsHidden() return true end
function modifier_imba_dagon_debuff:IsPurgable() return false end
function modifier_imba_dagon_debuff:IsPurgeException() return false end
function modifier_imba_dagon_debuff:IsPurgeException() return false end


function modifier_imba_dagon_debuff:GetEffectName() return "particles/items2_fx/veil_of_discord_debuff.vpcf" end
function modifier_imba_dagon_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_dagon_debuff:OnCreated()
	if self:GetAbility() == nil then return end
	self.mag = self:GetAbility():GetSpecialValueFor("magic_armor_nerf")
end
function modifier_imba_dagon_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end


function modifier_imba_dagon_debuff:GetModifierMagicalResistanceBonus()
	return -self.mag
end
