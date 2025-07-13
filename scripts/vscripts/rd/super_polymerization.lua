super_polymerization=class({})
LinkLuaModifier("modifier_super_polymerization", "rd/super_polymerization.lua", LUA_MODIFIER_MOTION_NONE)
function super_polymerization:IsHiddenWhenStolen() 
    return false 
end

function super_polymerization:IsStealable() 
    return true 
end


function super_polymerization:IsRefreshable() 			
    return true 
end

function super_polymerization:Precache( context )
	PrecacheResource( "model", "models/creeps/darkreef/gaoler/darkreef_gaoler.vmdl", context )
	PrecacheResource( "particle", "particles/heros/jugg/jugg_dog.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", context )
end

function super_polymerization:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if not target:IsRealHero() or target==caster  then
		return UF_FAIL_CUSTOM
	end
end

function super_polymerization:GetCustomCastErrorTarget(target) 
        return "无法对其使用" 
end

function super_polymerization:OnSpellStart()
    local cur_tar=self:GetCursorTarget()
    local caster=self:GetCaster()

    if Is_Chinese_TG(caster,cur_tar) and self:GetAutoCastState() then
        cur_tar=self:GetCaster()
        caster=self:GetCursorTarget()
    end

    EmitSoundOn("TG.aaice", caster)
    local p1 = ParticleManager:CreateParticle("particles/heros/jugg/jugg_dog.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(p1, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)
    caster:AddNewModifier(self:GetCaster(), self, "modifier_super_polymerization",
    {
        duration=self:GetSpecialValueFor("dur"),
        agi=cur_tar:GetAgility(),
        str=cur_tar:GetStrength(),
        int=cur_tar:GetIntellect(false),
        hp=cur_tar:GetMaxHealth(),
        ar=cur_tar:GetPhysicalArmorValue(false),
        sp=cur_tar:GetMoveSpeedModifier(cur_tar:GetBaseMoveSpeed(), true),
        mana=cur_tar:GetMaxMana(),
    })
end

modifier_super_polymerization=class({})

function modifier_super_polymerization:IsPurgable() 			
    return false 
end

function modifier_super_polymerization:IsPurgeException() 	
    return false 
end

function modifier_super_polymerization:IsHidden()				
    return false 
end

function modifier_super_polymerization:OnCreated(tg)
    if not IsServer() then return end
    print("我被创建了",self.agi,tg.agi)
    if self.agi==nil then
        self.agi=tg.agi
        self.str=tg.str
        self.int=tg.int
        self.hp=tg.hp
        self.ar=tg.ar
        self.sp=tg.sp
        self.mana=tg.mana
    else
        self.agi=tg.agi+self.agi
        self.str=tg.str+self.str
        self.int=tg.int+self.int
        self.hp=tg.hp+self.hp
        self.ar=tg.ar+self.ar
        self.sp=tg.sp+self.sp
        self.mana=tg.mana+self.mana
    end
    local p2 = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( p2, false, false, 20, false, false )


end

function modifier_super_polymerization:OnRefresh(tg)
    if not IsServer() then return end
    self:OnCreated(tg)
end

function modifier_super_polymerization:CheckState() 
    return 
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    } 
end


function modifier_super_polymerization:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS
    } 
end

function modifier_super_polymerization:GetModifierModelChange() 
    return "models/creeps/darkreef/gaoler/darkreef_gaoler.vmdl"
end

function modifier_super_polymerization:GetModifierModelScale() 
    return 50
end

function modifier_super_polymerization:GetModifierBonusStats_Intellect() 
    return self.int
end

function modifier_super_polymerization:GetModifierBonusStats_Agility() 
    return self.agi
end

function modifier_super_polymerization:GetModifierBonusStats_Strength() 
    return self.str
end

function modifier_super_polymerization:GetModifierHealthBonus() 
    return self.hp
end 

function modifier_super_polymerization:GetModifierMoveSpeedBonus_Constant() 
    return self.sp
end 

function modifier_super_polymerization:GetModifierPhysicalArmorBonus() 
    return self.ar
end 

function modifier_super_polymerization:GetModifierManaBonus() 
    return self.mana
end 