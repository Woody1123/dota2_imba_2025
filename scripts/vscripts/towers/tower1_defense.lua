
tower1_def= class({})
LinkLuaModifier("modifier_tower1_def", "towers/tower1_defense.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower1_def_arua", "towers/tower1_defense.lua", LUA_MODIFIER_MOTION_NONE)

function tower1_def:GetIntrinsicModifierName()
    return "modifier_tower1_def"
end


modifier_tower1_def = class({})


function modifier_tower1_def:IsHidden()
    return false
end

function modifier_tower1_def:IsPurgable()
    return false
end

function modifier_tower1_def:IsPurgeException()
    return false
end
function modifier_tower1_def:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,			
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
    }
end
function modifier_tower1_def:GetModifierProcAttack_BonusDamage_Pure() return self.pure end
function modifier_tower1_def:CheckState() 			return {[MODIFIER_STATE_CANNOT_MISS] = true,} end


function modifier_tower1_def:OnCreated()
    if not IsServer() then
        return
    end
	self.base_armor = 2400
	self.pure = 400
	self.min_armor = 55
	self:StartIntervalThink(30)
	-- self:GetParent():SetPhysicalArmorBaseValue(self.base_armor)
end
function modifier_tower1_def:OnIntervalThink() 
	if IsServer() then
		self.base_armor = self.base_armor - 60  
		self.pure = math.max(self.pure - 10,250)
		-- self:GetParent():SetPhysicalArmorBaseValue(math.max(self.base_armor,self.min_armor))
		
		local heros = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
        false)
		
        if #heros>0 then
            for _, hero in pairs(heros) do
                hero:Heal( 30*0.01*hero:GetMaxHealth(), self:GetParent() )
                SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,100, nil)
            end
        end
	end
end
--[[
function modifier_tower1_def:GetModifierPhysical_ConstantBlock()
	return 30 --self.block
end]]

function modifier_tower1_def:GetModifierPhysicalArmorBonus()
	return 10
end
--[[
function modifier_tower1_def:GetModifierMagicalResistanceBonus()
	return self.mag
end]]

function modifier_tower1_def:IsAura()
    return true
end
function modifier_tower1_def:GetTexture()
    return "tower1_def"
end

function modifier_tower1_def:GetModifierAura()
    return "modifier_tower1_def_arua"
end

function modifier_tower1_def:GetAuraRadius()
    return 1500
end

function modifier_tower1_def:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_tower1_def:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tower1_def:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

modifier_tower1_def_arua= class({})

function modifier_tower1_def_arua:IsHidden()
    return false
end


function modifier_tower1_def_arua:IsPurgable()
    return false
end


function modifier_tower1_def_arua:IsPurgeException()
    return false
end
function modifier_tower1_def_arua:GetTexture()
    return "tower1_def"
end

function modifier_tower1_def_arua:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
		
    }
end

function modifier_tower1_def_arua:GetModifierMagicalResistanceBonus()
    return 20
end


function modifier_tower1_def_arua:GetModifierPhysicalArmorBonus()
    return 12
end

function modifier_tower1_def_arua:GetModifierHealthBonus()
    return 600
end
