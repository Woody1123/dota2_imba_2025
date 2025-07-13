rain_of_destiny=class({})
LinkLuaModifier("modifier_rain_of_destiny_buff", "heros/hero_oracle/rain_of_destiny.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rain_of_destiny_buff2", "heros/hero_oracle/rain_of_destiny.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_purifying_flames_buff", "heros/hero_oracle/purifying_flames.lua", LUA_MODIFIER_MOTION_NONE)
function rain_of_destiny:IsHiddenWhenStolen()
    return false
end

function rain_of_destiny:IsStealable()
    return false
end

function rain_of_destiny:IsRefreshable()
    return true
end

function rain_of_destiny:GetAOERadius()
    return self:GetSpecialValueFor("radius")+self:GetCaster():GetCastRangeBonus()/3
end

function rain_of_destiny:OnSpellStart()
    CreateModifierThinker(self:GetCaster(), self, "modifier_rain_of_destiny_buff", {duration=self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end


modifier_rain_of_destiny_buff=class({})

function modifier_rain_of_destiny_buff:IsHidden()
    return true
end

function modifier_rain_of_destiny_buff:IsPurgable()
    return false
end

function modifier_rain_of_destiny_buff:IsPurgeException()
    return false
end
function modifier_rain_of_destiny_buff:IsAura() return true end
function modifier_rain_of_destiny_buff:GetAuraDuration() return 0.1 end
function modifier_rain_of_destiny_buff:GetModifierAura() return "modifier_rain_of_destiny_buff2" end
function modifier_rain_of_destiny_buff:GetAuraRadius() return self.rd end
function modifier_rain_of_destiny_buff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_rain_of_destiny_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY+DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_rain_of_destiny_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_rain_of_destiny_buff:OnCreated(tg)
    if not IsServer() then
    return
    end
    if self:GetAbility() == nil or not self:GetCaster():HasAbility("purifying_flames") then return end

    self.rd=self:GetAbility():GetSpecialValueFor( "radius" )+self:GetCaster():GetCastRangeBonus()/3



    self.pf_ability=self:GetCaster():FindAbilityByName("purifying_flames")
    self.pf_dur =self.pf_ability:GetSpecialValueFor("dur")
    --self.pf_dur=3

    self.tick_rate= 2--self:GetAbility():GetSpecialValueFor( "tick_rate" )
    self.POS=self:GetParent():GetAbsOrigin()


    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0,  self.POS)
    ParticleManager:SetParticleControl(fx, 1, Vector(self.rd,1,1))
    ParticleManager:SetParticleControl(fx, 2, Vector(self:GetRemainingTime(),1,1))
    self:AddParticle(fx, false, false, -1, false, false)
    self:OnIntervalThink()
    self:StartIntervalThink(self.tick_rate)
end

function modifier_rain_of_destiny_buff:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self.POS,
        nil,
        self.rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,
        false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if not IsEnemy(hero,self:GetCaster())  then
                    hero:AddNewModifier(self:GetCaster(), self.pf_ability, "modifier_purifying_flames_buff", {duration=self.pf_dur})
                elseif (not hero:HasModifier("modifier_purifying_flames_buff")) and not hero:IsMagicImmune() then
                    hero:AddNewModifier(self:GetCaster(), self.pf_ability, "modifier_purifying_flames_buff", {duration=2.2})
                end
            end
        end
end

function modifier_rain_of_destiny_buff:OnDestroy()
    self.rd=nil
    self.POS=nil
    self:StartIntervalThink(-1)
end


modifier_rain_of_destiny_buff2=class({})
function modifier_rain_of_destiny_buff2:IsHidden()
    return false
end

function modifier_rain_of_destiny_buff2:IsPurgable()
    return false
end

function modifier_rain_of_destiny_buff2:IsDebuff()
    if self.caster:GetTeamNumber()==self.parent:GetTeamNumber() then
        return  false
    else
         return true
    end
end

function modifier_rain_of_destiny_buff2:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.heal_amp=self:GetAbility():GetSpecialValueFor("heal_amp")
end


function modifier_rain_of_destiny_buff2:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,}
end

function modifier_rain_of_destiny_buff2:IsPurgeException()
    return false
end


function modifier_rain_of_destiny_buff2:GetModifierHealAmplify_PercentageTarget()
    if self:GetCaster():GetTeamNumber()==self.parent:GetTeamNumber() then
            return -self.heal_amp
        else
            return self.heal_amp
        end
end

function modifier_rain_of_destiny_buff2:GetModifierHPRegenAmplify_Percentage()
    if self:GetCaster():GetTeamNumber()==self.parent:GetTeamNumber() then
            return -self.heal_amp
        else
            return self.heal_amp
        end
end