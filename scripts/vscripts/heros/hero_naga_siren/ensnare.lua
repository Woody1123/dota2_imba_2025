CreateTalents("npc_dota_hero_naga_siren", "heros/hero_naga_siren/ensnare.lua")
ensnare = class({})
LinkLuaModifier("modifier_ensnare_buff", "heros/hero_naga_siren/ensnare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ensnare_debuff", "heros/hero_naga_siren/ensnare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ensnare_debuff_m", "heros/hero_naga_siren/ensnare.lua", LUA_MODIFIER_MOTION_NONE)
function ensnare:IsHiddenWhenStolen()
    return false
end

function ensnare:IsStealable()
    return true
end
function ensnare:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if (caster:GetTeamNumber() == target:GetTeamNumber()) or (target:IsMagicImmune() and not self:GetCaster():HasScepter()) or  target:IsBuilding() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end



function ensnare:IsRefreshable()
    return true
end

function ensnare:OnSpellStart(scepter)
    local caster = self:GetCaster()
    local caster_team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local target = self:GetCursorTarget()
    if caster:TG_HasTalent("special_bonus_naga_siren_7") and not scepter then
        local radius=self:GetCaster():TG_GetTalentValue("special_bonus_naga_siren_7")
        local targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

        for _, unit in pairs(targets) do
            local P = {
                Ability = self,
                EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
                iMoveSpeed = self:GetSpecialValueFor( "net_speed" ),
                Source =caster,
                Target = unit,
                bDrawsOnMinimap = false,
                bDodgeable = true,
                bIsAttack = false,
                bProvidesVision = true,
                bReplaceExisting = false,
                iVisionTeamNumber =caster_team,
                iVisionRadius = 300,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            }
            TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
        end
    else
        local P = {
                Ability = self,
                EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
                iMoveSpeed = self:GetSpecialValueFor( "net_speed" ),
                Source =caster,
                Target = target,
                bDrawsOnMinimap = false,
                bDodgeable = true,
                bIsAttack = false,
                bProvidesVision = true,
                bReplaceExisting = false,
                iVisionTeamNumber =caster_team,
                iVisionRadius = 300,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            }
            TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
    end
    caster:EmitSound("Hero_NagaSiren.Ensnare.Cast")
end



function ensnare:OnProjectileHit_ExtraData( target, location,kv)
	local caster=self:GetCaster()
	TG_IS_ProjectilesValue1(caster,function()
		target=nil
    end)
	if target == nil  then
		return
	end
    if target:IsMagicImmune() and not self:GetCaster():HasScepter() then
        return
    end
    if  target:TG_TriggerSpellAbsorb(self)  then
        return
    end
    target:AddNewModifier_RS(caster, self, "modifier_ensnare_debuff", {duration=self:GetSpecialValueFor( "duration" )})
    if caster:TG_HasTalent("special_bonus_naga_siren_3") then
        target:AddNewModifier_RS(caster, self, "modifier_ensnare_debuff_m", {duration=self:GetSpecialValueFor( "duration" )})
    end
    --if caster:TG_HasTalent("special_bonus_naga_siren_7") then
    --    target:AddNewModifier_RS(caster, self, "modifier_item_imba_atos_roo_shackle", {duration=self:GetSpecialValueFor( "duration" )})
    --end
	return true
end

modifier_ensnare_debuff=class({})

function modifier_ensnare_debuff:IsDebuff()
	return true
end

function modifier_ensnare_debuff:IsHidden()
	return false
end

function modifier_ensnare_debuff:IsPurgable()
    if self.caster:TG_HasTalent("special_bonus_naga_siren_5") then
        return false
    else
        return true
    end
end

function modifier_ensnare_debuff:IsPurgeException()
	--if self.caster:TG_HasTalent("special_bonus_naga_siren_5") then
    --    return false
    --else
    --    return true
    --end
    return true
end

function modifier_ensnare_debuff:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
	if self:GetAbility() == nil then return end
    self.dam=self:GetAbility():GetSpecialValueFor( "dam" )
    if not IsServer() then
        return
    end
    local pos=self:GetParent():GetAbsOrigin()
    local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_siren/siren_net.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent() )
    ParticleManager:SetParticleControl( fx, 0, pos )
    for num=18,22 do
        ParticleManager:SetParticleControl( fx, num, pos )
    end
    self:AddParticle(fx, false, false, -1, false, false)
    if (pos.z<1 or self:GetParent():HasModifier("modifier_rip_tide_buff2"))  and not self:GetParent():HasFlyMovementCapability() then
        self:StartIntervalThink(1)
    end

end

function modifier_ensnare_debuff:OnIntervalThink()
    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage =  self.dam,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
        ability = self:GetAbility(),
    }
    ApplyDamage( damage )
end

function modifier_ensnare_debuff:OnDestroy()
    self.dam=nil
end

function modifier_ensnare_debuff:CheckState()
	return
	{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_TETHERED] = true,
	}
end

modifier_ensnare_debuff_m=class({})

function modifier_ensnare_debuff_m:IsDebuff()
	return true
end

function modifier_ensnare_debuff_m:IsHidden()
	return false
end

function modifier_ensnare_debuff_m:IsPurgable()
	if self.caster:TG_HasTalent("special_bonus_naga_siren_5") then
        return false
    else
        return true
    end
end

function modifier_ensnare_debuff_m:IsPurgeException()
	--if self.caster:TG_HasTalent("special_bonus_naga_siren_5") then
    --    return false
    --else
    --    return true
    --end
    return true
end

function modifier_ensnare_debuff_m:OnCreated()
    --print("已被创建")
    self.caster = self:GetCaster()
	--self.speed = self:GetAbility():GetSpecialValueFor("speed")
    if self.caster:TG_HasTalent("special_bonus_naga_siren_3")==nil then
        return
    end
    self.speed=self.caster:TG_GetTalentValue("special_bonus_naga_siren_3")
	self.parent = self:GetParent()

	if self:GetAbility() == nil then return end
    --self.dam=self:GetAbility():GetSpecialValueFor( "dam" )
    if not IsServer() then
        return
    end
    self:StartIntervalThink(FrameTime())


end

function modifier_ensnare_debuff_m:OnIntervalThink()
	if (self.parent:GetOrigin() - self.caster:GetOrigin()):Length2D() <= 128 then  return end
    local pos=self.parent:GetAbsOrigin()
    --if  pos.z<1 or self.parent:HasModifier("modifier_rip_tide_buff2") then
    local target_position = self.parent:GetAbsOrigin()
    local center_vector = self:GetCaster():GetAbsOrigin() - target_position
    local pull_distance = center_vector:Normalized() * self.speed*FrameTime()
    FindClearSpaceForUnit(self.parent, target_position + pull_distance, false)
    --end
	if not self.parent:HasModifier("modifier_ensnare_debuff_m") then self:StartIntervalThink(-1) self:Destroy() return end
end


--function modifier_ensnare_debuff_m:OnDestroy()
--    return
--end


function modifier_ensnare_debuff_m:CheckState()
	return
	{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_TETHERED] = true,
	}
end