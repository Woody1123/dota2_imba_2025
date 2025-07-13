double_edge=class({})
LinkLuaModifier("modifier_double_edge_buff", "heros/hero_centaur/double_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_double_edge_debuff", "heros/hero_centaur/double_edge.lua", LUA_MODIFIER_MOTION_NONE)

function double_edge:IsHiddenWhenStolen() 
    return false 
end

function double_edge:IsStealable() 
    return true 
end

function double_edge:IsRefreshable() 			
    return true 
end

function double_edge:GetCooldown(iLevel)
    local cd=self.BaseClass.GetCooldown(self,iLevel)
    if  self:GetCaster():Has_Aghanims_Shard() then 
        return cd-1
    else 
        return cd
    end
end

function double_edge:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local radius=self:GetSpecialValueFor( "radius" )
    local rg=self:GetSpecialValueFor( "rg" )+caster:TG_GetTalentValue("special_bonus_centaur_2")+caster:GetCastRangeBonus()
    local rd=self:GetSpecialValueFor( "rd" )
    local sp=self:GetSpecialValueFor( "sp" )
    self.caster=self:GetCaster()
    EmitSoundOn("Hero_Centaur.DoubleEdge.TI9", caster)
        local Projectile = 
        {
        Ability = self,
        EffectName = "particles/heros/centaur/centaur_axe.vpcf",
        vSpawnOrigin = caster_pos,
        fDistance = rg,
        fStartRadius = rd,
        fEndRadius =rd,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity =caster:GetForwardVector()*sp,
        bProvidesVision = false,
        }                
        ProjectileManager:CreateLinearProjectile(Projectile)
end



function double_edge:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
    TG_IS_ProjectilesValue1(caster,function()
        target=nil
    end)
	if target==nil then
		return
	end
    if target:IsAlive() and  not target:IsMagicImmune() then
        if target:IsHero() and self.caster:Has_Aghanims_Shard() then
            self.caster:AddNewModifier( self.caster, self, "modifier_double_edge_buff", {duration =  self:GetSpecialValueFor("str_duration")})
            target:AddNewModifier( self.caster, self, "modifier_double_edge_debuff", {duration =  self:GetSpecialValueFor("slow_duration")})
        end
        local edge_damage=self:GetSpecialValueFor( "edge_damage" )
        local strength_damage=self:GetSpecialValueFor( "strength_damage" )+caster:TG_GetTalentValue("special_bonus_centaur_8")
        local damageTable =
        {
            victim = target,
            attacker = caster,
            damage =edge_damage+math.floor(caster:GetStrength())*strength_damage*0.01,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
        }
        ApplyDamage(damageTable)
        local POS=target:GetAbsOrigin()
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_CUSTOMORIGIN, target)
        ParticleManager:SetParticleControlEnt(fx, 0, target, PATTACH_POINT, "attach_hitloc", POS, true)
        ParticleManager:SetParticleControlEnt(fx, 1, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(fx, 2, POS)
        ParticleManager:ReleaseParticleIndex(fx)
        EmitSoundOn("Hero_Centaur.DoubleEdge.TI9", target)
    end 
end

modifier_double_edge_buff=class({})

function modifier_double_edge_buff:IsPurgable()
    return false
end

function modifier_double_edge_buff:IsPurgeException()
    return false
end

function modifier_double_edge_buff:IsHidden()
    return false
end

function modifier_double_edge_buff:IsDebuff()
    return false
end
function modifier_double_edge_buff:DeclareFunctions()
return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_double_edge_buff:OnTooltip() return self:GetAbility():GetSpecialValueFor("str")*self:GetStackCount()  end


function modifier_double_edge_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(1)
    self:GetParent():ModifyHealth(self:GetParent():GetHealth()+20*self:GetAbility():GetSpecialValueFor("str"),self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
end


function modifier_double_edge_buff:OnRefresh()
    if not IsServer() then
        return
    end
    if self:GetStackCount()<self:GetAbility():GetSpecialValueFor("max_count") then
        self:SetStackCount(self:GetStackCount()+1)
    else
        self:GetParent():ModifyHealth(self:GetParent():GetHealth()+20*self:GetAbility():GetSpecialValueFor("str"),self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
    end
end


function modifier_double_edge_buff:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("str")*self:GetStackCount()
end


modifier_double_edge_debuff=class({})

function modifier_double_edge_debuff:IsPurgable()
    return true
end

function modifier_double_edge_debuff:IsPurgeException()
    return true
end

function modifier_double_edge_debuff:IsHidden()
    return false
end

function modifier_double_edge_debuff:IsDebuff()
    return true
end

function modifier_double_edge_debuff:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end

function modifier_double_edge_debuff:GetModifierMoveSpeedBonus_Percentage() return -self:GetAbility():GetSpecialValueFor("move_slow") end