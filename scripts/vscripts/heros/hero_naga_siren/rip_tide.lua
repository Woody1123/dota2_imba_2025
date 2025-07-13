rip_tide=class({})
LinkLuaModifier("modifier_rip_tide_pa", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rip_tide_debuff", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rip_tide_buff", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rip_tide_buff2", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rip_tide_charge", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)


function rip_tide:IsHiddenWhenStolen()
    return false
end

function rip_tide:IsStealable()
    return true
end

function rip_tide:IsRefreshable()
    return true
end

function rip_tide:GetIntrinsicModifierName()
    return "modifier_rip_tide_pa"
end

function rip_tide:OnSpellStart()
    CreateModifierThinker(self:GetCaster(), self, "modifier_rip_tide_buff", {duration=self:GetSpecialValueFor("duration")}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

modifier_rip_tide_pa=class({})

function modifier_rip_tide_pa:IsDebuff()
    return false
end

function modifier_rip_tide_pa:IsHidden()
    return true
end

function modifier_rip_tide_pa:IsPurgable()
    return false
end

function modifier_rip_tide_pa:IsPurgeException()
    return false
end

function modifier_rip_tide_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_rip_tide_pa:OnCreated()
	if self:GetAbility() == nil then return end
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.maxCount= self:GetAbility():GetSpecialValueFor("max_count")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")+self:GetCaster():GetCastRangeBonus()
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.duration2 = self:GetAbility():GetSpecialValueFor("dur")
end

function modifier_rip_tide_pa:OnRefresh()
    self:OnDestroy()
    self:OnCreated()
end

function modifier_rip_tide_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	--if tg.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
	--	return
    --end
    local parent = self:GetParent()
    if not (tg.attacker:HasAbility("rip_tide") and IsEnemy(tg.attacker,tg.target))or IsEnemy(tg.attacker,parent) or parent:PassivesDisabled()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end

	local passive = self:GetAbility()
    local buff = parent:AddNewModifier(parent, passive, "modifier_rip_tide_charge", {})
    if parent:TG_HasTalent("special_bonus_naga_siren_6") then
        local pos=tg.target:GetAbsOrigin()
        if  pos.z<1 or tg.target:HasModifier("modifier_rip_tide_buff2") then
            buff:IncrementStackCount()
        end
    end

    if buff:GetStackCount() >= (self.maxCount-1) then
        self:GetParent():EmitSound("Hero_NagaSiren.Riptide.Cast")
        --CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_rip_tide_buff", {duration=self.duration2}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
        local p= ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        ParticleManager:SetParticleControl(p,0,  self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(p,1,  Vector(self.radius,self.radius,self.radius))
        ParticleManager:SetParticleControl(p,3,  Vector(1,1,1))
        ParticleManager:ReleaseParticleIndex(p)
        local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if hero:IsAlive() and not hero:IsMagicImmune() then
                    hero:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_rip_tide_debuff", {duration= self.duration})
                    local damageTable = {
                        victim = hero,
                        attacker = self:GetParent(),
                        damage =  self.damage,
                        damage_type =DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility(),
                        }
                        ApplyDamage(damageTable)
                end
            end
        end
        buff:Destroy()
    else
		--增加计数
		buff:IncrementStackCount()

    end




    --if buff:GetStackCount()>=self.maxCount then
    --    self:GetParent():EmitSound("Hero_NagaSiren.Riptide.Cast")
    --    --CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_rip_tide_buff", {duration=self.duration2}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
    --    local p= ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    --    ParticleManager:SetParticleControl(p,0,  self:GetParent():GetAbsOrigin())
    --    ParticleManager:SetParticleControl(p,1,  Vector(self.radius,self.radius,self.radius))
    --    ParticleManager:SetParticleControl(p,3,  Vector(1,1,1))
    --    ParticleManager:ReleaseParticleIndex(p)
    --    local heros = FindUnitsInRadius(
    --        self:GetParent():GetTeamNumber(),
    --        tg.target:GetAbsOrigin(),
    --        nil,
    --        self.radius,
    --        DOTA_UNIT_TARGET_TEAM_ENEMY,
    --        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --        DOTA_UNIT_TARGET_FLAG_NONE,
    --        FIND_ANY_ORDER,false)
    --    if #heros>0 then
    --        for _, hero in pairs(heros) do
    --            if hero:IsAlive() and not hero:IsMagicImmune() then
    --                hero:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_rip_tide_debuff", {duration= self.duration})
    --                local damageTable = {
    --                    victim = hero,
    --                    attacker = self:GetParent(),
    --                    damage =  self.damage,
    --                    damage_type =DAMAGE_TYPE_MAGICAL,
    --                    ability = self:GetAbility(),
    --                    }
    --                    ApplyDamage(damageTable)
    --            end
    --        end
    --    end
    --    self:SetStackCount(0)
    --else
    --    self:IncrementStackCount()
    --end


    --if RollPseudoRandomPercentage(  self.chance,0,self:GetParent()) then
    --    self:GetParent():EmitSound("Hero_NagaSiren.Riptide.Cast")
    --    CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_rip_tide_buff", {duration=self.duration2}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
    --    local p= ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    --    ParticleManager:SetParticleControl(p,0,  self:GetParent():GetAbsOrigin())
    --    ParticleManager:SetParticleControl(p,1,  Vector(self.radius,self.radius,self.radius))
    --    ParticleManager:SetParticleControl(p,3,  Vector(1,1,1))
    --    ParticleManager:ReleaseParticleIndex(p)
    --    local type=DAMAGE_TYPE_MAGICAL
    --    if self:GetParent():IsIllusion() and self:GetParent():HasModifier("modifier_illusions_mirror_image")  then
    --        type=DAMAGE_TYPE_PHYSICAL
    --    end
    --    local heros = FindUnitsInRadius(
    --        self:GetParent():GetTeamNumber(),
    --        tg.target:GetAbsOrigin(),
    --        nil,
    --        self.radius,
    --        DOTA_UNIT_TARGET_TEAM_ENEMY,
    --        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    --        DOTA_UNIT_TARGET_FLAG_NONE,
    --        FIND_ANY_ORDER,false)
    --    if #heros>0 then
    --        for _, hero in pairs(heros) do
    --            if hero:IsAlive() and not hero:IsMagicImmune() then
    --                hero:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_rip_tide_debuff", {duration= self.duration})
    --                local damageTable = {
    --                    victim = hero,
    --                    attacker = self:GetParent(),
    --                    damage =  self.damage,
    --                    damage_type =type,
    --                    ability = self:GetAbility(),
    --                    }
    --                    ApplyDamage(damageTable)
    --            end
    --        end
    --    end
    --end
end

modifier_rip_tide_charge = class({})
function modifier_rip_tide_charge:IsHidden()			return false end
function modifier_rip_tide_charge:IsDebuff() 			return false end
function modifier_rip_tide_charge:IsPurgable() 		return false end
function modifier_rip_tide_charge:IsPurgeException()	return false end


modifier_rip_tide_debuff=class({})

function modifier_rip_tide_debuff:IsDebuff()
    return true
end

function modifier_rip_tide_debuff:IsHidden()
    return false
end

function modifier_rip_tide_debuff:IsPurgable()
    return true
end

function modifier_rip_tide_debuff:IsPurgeException()
    return true
end

function modifier_rip_tide_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_rip_tide_debuff:GetEffectName()
    return "particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf"
end


function modifier_rip_tide_debuff:OnCreated()
    if self:GetAbility() == nil then return end
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_rip_tide_debuff:OnRefresh()
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_rip_tide_debuff:OnDestroy()
    self.armor_reduction = nil
end

function modifier_rip_tide_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_rip_tide_debuff:GetModifierPhysicalArmorBonus()
    local armor_reduction=self.armor_reduction
    if self:GetCaster():TG_HasTalent("special_bonus_naga_siren_8") then
        armor_reduction=2*self.armor_reduction
    end
   return armor_reduction
end


modifier_rip_tide_buff=class({})

function modifier_rip_tide_buff:IsHidden()
    return true
end

function modifier_rip_tide_buff:IsPurgable()
    return false
end

function modifier_rip_tide_buff:IsPurgeException()
    return false
end
function modifier_rip_tide_buff:IsAura() return true end
function modifier_rip_tide_buff:GetAuraDuration() return 0.1 end
function modifier_rip_tide_buff:GetModifierAura() return "modifier_rip_tide_buff2" end
function modifier_rip_tide_buff:GetAuraRadius() return self.rd end
function modifier_rip_tide_buff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_rip_tide_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY+DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_rip_tide_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_rip_tide_buff:OnCreated(tg)
    if self:GetAbility() == nil then return end
    self.rd=self:GetAbility():GetSpecialValueFor( "rd" )
    if not IsServer() then
    return
    end
    self.rd=self.rd+self:GetCaster():GetCastRangeBonus()
    --由海妖之歌创建时传入范围
    if tg.radius~=nil then
        self.rd=tg.radius+self:GetCaster():GetCastRangeBonus()
    end
    self.POS=self:GetParent():GetAbsOrigin()
    local fx = ParticleManager:CreateParticle("particles/heros/naga_siren/naga_siren_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0,  self.POS)
    ParticleManager:SetParticleControl(fx, 1, Vector(self.rd,1,1))
    ParticleManager:SetParticleControl(fx, 2, Vector(self:GetRemainingTime(),1,1))
    self:AddParticle(fx, false, false, -1, false, false)
    --self:StartIntervalThink(1)
    end

--function modifier_rip_tide_buff:OnIntervalThink()
--    local heros = FindUnitsInRadius(
--        self:GetParent():GetTeamNumber(),
--        self.POS,
--        nil,
--        self.rd,
--        DOTA_UNIT_TARGET_TEAM_ENEMY,
--        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
--        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
--        FIND_CLOSEST,
--        false)
--        if #heros>0 then
--            for _, hero in pairs(heros) do
--                    hero:AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_rip_tide_buff2", {duration=1.1})
--            end
--        end
--end

function modifier_rip_tide_buff:OnDestroy()
    self.rd=nil
    self.POS=nil
end

modifier_rip_tide_buff2=class({})
function modifier_rip_tide_buff2:IsHidden()
    return false
end

function modifier_rip_tide_buff2:IsPurgable()
    return false
end

function modifier_rip_tide_buff2:IsDebuff()
    if self.caster:GetTeamNumber()==self.parent:GetTeamNumber() then
        return  false
    else
         return true
    end
end

function modifier_rip_tide_buff2:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.magical=self.caster:FindAbilityByName("rip_tide"):GetSpecialValueFor("magical_reduction")
    --self.magical=self:GetAbility():GetSpecialValueFor("magical_reduction")
end


function modifier_rip_tide_buff2:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end
function modifier_rip_tide_buff2:IsPurgeException()
    return false
end

function modifier_rip_tide_buff2:GetModifierMagicalResistanceBonus()
    local magical=self.magical
    if self:GetCaster():TG_HasTalent("special_bonus_naga_siren_8") then
        magical=2*self.magical
    end
    if self:GetCaster():GetTeamNumber()==self.parent:GetTeamNumber() then
            return -magical
        else
            return magical
        end
end