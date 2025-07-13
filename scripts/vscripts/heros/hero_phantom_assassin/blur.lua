blur=class({})
LinkLuaModifier("modifier_blur_buff", "heros/hero_phantom_assassin/blur.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_blur_pa", "heros/hero_phantom_assassin/blur.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_blur_kill", "heros/hero_phantom_assassin/blur.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_blur_kill_cd", "heros/hero_phantom_assassin/blur.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_blur_v", "heros/hero_phantom_assassin/blur.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_blur_att", "heros/hero_phantom_assassin/blur.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function blur:IsHiddenWhenStolen()
    return false
end

function blur:IsStealable()
    return true
end

function blur:IsRefreshable()
    return true
end

function blur:OnSpellStart()
	local caster=self:GetCaster()
    caster:EmitSound("Hero_PhantomAssassin.Blur")
    local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(p1)
	if not caster:HasModifier("modifier_blur_kill_cd") then
		caster:AddNewModifier(caster, self, "modifier_blur_kill", {duration = self:GetSpecialValueFor("duration")})
	end
    if caster:TG_HasTalent("special_bonus_phantom_assassin_6") then
        caster:AddNewModifier(caster, self, "modifier_invulnerable", {duration = 0.4})
    end
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("true_cd_active"))
end


function blur:GetIntrinsicModifierName()
    return "modifier_blur_pa"
end
modifier_blur_pa=class({})

function modifier_blur_pa:IsDebuff()
	return false
end

function modifier_blur_pa:IsHidden()
	return true
end

function modifier_blur_pa:IsPurgable()
	return false
end

function modifier_blur_pa:IsPurgeException()
	return false
end


function modifier_blur_pa:OnCreated()
    if self:GetAbility() == nil  then
        return
    end
    self.bonus_evasion=self:GetAbility():GetSpecialValueFor("bonus_evasion")
    self.radius=self:GetAbility():GetSpecialValueFor("radius")
    if not IsServer() then
        return
    end
    if not self:GetParent():IsIllusion() then
    self:StartIntervalThink(1)
end
end

function modifier_blur_pa:OnRefresh()
    self.bonus_evasion=self:GetAbility():GetSpecialValueFor("bonus_evasion")
    self.radius=self:GetAbility():GetSpecialValueFor("radius")
end


function modifier_blur_pa:OnIntervalThink()
    if self:GetParent():IsIllusion() then
        return
    end
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        self:GetParent(),
        self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            --DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
            FIND_ANY_ORDER,
          false )
    if heros~=nil and #heros > 0 then
        for _,hero in pairs(heros) do
            if hero:IsRealHero() or hero:IsNeutralUnitType() or hero:IsBoss() or hero:IsBuilding() or  hero == CDOTA_PlayerResource.ROSHAN then
                if  self:GetParent():HasModifier("modifier_blur_buff") then
                    self:GetParent():RemoveModifierByName("modifier_blur_buff")
                end
                return
            end
        end
    end
    if not self:GetParent():HasModifier("modifier_blur_buff") then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_blur_buff", {})
    end
end

function modifier_blur_pa:OnAttackLanded(keys) 
    if keys.target == CDOTA_PlayerResource.ROSHAN then 
        if  self:GetParent():HasModifier("modifier_blur_buff") then
            self:GetParent():RemoveModifierByName("modifier_blur_buff")
        end
        -- if  self:GetParent():HasModifier("modifier_blur_pa") then
        --     self:GetParent():RemoveModifierByName("modifier_blur_pa")
        -- end
    end
end

function modifier_blur_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_blur_pa:GetModifierEvasion_Constant()
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    return self.bonus_evasion + self:GetCaster():TG_GetTalentValue("special_bonus_phantom_assassin_5")
end

function modifier_blur_pa:IsPassive()
	return true
end

modifier_blur_buff=class({})

function modifier_blur_buff:IsDebuff()
	return false
end

function modifier_blur_buff:IsHidden()
	return false
end

function modifier_blur_buff:IsPurgable()
	return false
end

function modifier_blur_buff:IsPurgeException()
	return false
end

function modifier_blur_buff:GetEffectName()
    return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
end

function modifier_blur_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_blur_buff:OnCreated()
	if self:GetAbility() == nil then return end
    if not IsServer() then
        return
    end
    local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(p1)
    local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(p2, false, false, 20, false, false)
end

function modifier_blur_buff:OnRefresh()
    self:OnCreated()
end

function modifier_blur_buff:CheckState()
	return
	{
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	}
end
modifier_blur_kill_cd=class({})

function modifier_blur_kill_cd:IsDebuff()
	return false
end

function modifier_blur_kill_cd:IsHidden()
	return false
end

function modifier_blur_kill_cd:IsPurgable()
	return false
end

function modifier_blur_kill_cd:IsPurgeException()
	return false
end
function modifier_blur_kill_cd:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

modifier_blur_kill=class({})

function modifier_blur_kill:IsDebuff()
	return false
end

function modifier_blur_kill:IsHidden()
	return false
end

function modifier_blur_kill:IsPurgable()
	return false
end

function modifier_blur_kill:IsPurgeException()
	return false
end

function modifier_blur_kill:OnCreated()
	if self:GetAbility() == nil then return end
    self.MAX_KILL=nil
    self.MAX_HERO=nil
    self.vdur=self:GetAbility():GetSpecialValueFor("vdur")
	self.true_cd_kill = self:GetAbility():GetSpecialValueFor("true_cd_kill")
    if not IsServer() then
        return
    end
    local id=self:GetParent():GetPlayerOwnerID()
    for i=1, #CDOTA_PlayerResource.TG_HERO do
        if CDOTA_PlayerResource.TG_HERO[i] then
            local hero = CDOTA_PlayerResource.TG_HERO[i]
            if hero~= nil then
                if not Is_Chinese_TG(hero,self:GetParent()) then
                    local kill=hero:GetKills()
                    if self.MAX_KILL==nil then
                        self.MAX_KILL=kill
                        self.MAX_HERO=hero
                    elseif self.MAX_KILL < kill then
                        self.MAX_KILL = kill
                        self.MAX_HERO=hero
                    end
                end
		    end
		end
    end
    if (self.MAX_HERO~=nil and self.MAX_HERO:IsAlive()) and (self.MAX_KILL~=nil and self.MAX_KILL>0) then
        self.MAX_HERO:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_blur_v", {duration=self.vdur})
        Notifications:Top(id,{hero=self.MAX_HERO:GetName(), duration=3,imagestyle="portrait"})
        Notifications:Top(id, {text="被你标记", duration=6, style={color="#F0FFFF"}})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_blur_kill_cd", {duration = self.true_cd_kill})
    else
        Notifications:Top(id, {text="没有搜寻到目标", duration=3, style={color="#F0FFFF"}})
		self:Destroy()
    end
end

function modifier_blur_kill:OnRefresh()
    self:OnCreated()
end


function modifier_blur_kill:OnDestroy()
    self.vdur=nil
    self.MAX_KILL=nil
    self.MAX_HERO=nil
end

function modifier_blur_kill:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_HERO_KILLED,
    }
end

function modifier_blur_kill:OnHeroKilled(tg)
    if not IsServer() then
        return
    end
    if  tg.attacker == self:GetParent()  then
        if self.MAX_HERO~=nil and tg.target==self.MAX_HERO then
            TG_Modifier_Num_ADD(self:GetParent(),"modifier_blur_att",self.MAX_KILL,self.MAX_KILL)
			self:GetParent():RemoveModifierByName("modifier_blur_kill_cd")
			self:Destroy()
        end
	end
end

modifier_blur_v=class({})

function modifier_blur_v:IsDebuff()
	return true
end

function modifier_blur_v:IsHidden()
	return false
end

function modifier_blur_v:IsPurgable()
	return false
end

function modifier_blur_v:IsPurgeException()
	return false
end

function modifier_blur_v:GetEffectName()
    return "particles/tgp/pa/base_overhead_kill.vpcf"
end

function modifier_blur_v:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_blur_v:CheckState()
	return
	{
        [MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end

modifier_blur_att=class({})

function modifier_blur_att:IsDebuff()
	return false
end

function modifier_blur_att:IsHidden()
	return false
end

function modifier_blur_att:IsPurgable()
	return false
end

function modifier_blur_att:IsPurgeException()
	return false
end

function modifier_blur_att:IsPermanent()
	return true
end

function modifier_blur_att:GetTexture()
	return "modifier_blur_att"
end

function modifier_blur_att:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end

function modifier_blur_att:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_blur_att:GetModifierPreAttack_BonusDamage(tg)
    return   self:GetStackCount()
end