ra_ward = class({})
LinkLuaModifier("modifier_ra_ward_buff", "ting/random_ab/ra_ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ra_ward_buff2", "ting/random_ab/ra_ward", LUA_MODIFIER_MOTION_NONE)
function ra_ward:GetIntrinsicModifierName() return "modifier_ra_ward_buff" end


--
modifier_ra_ward_buff=class({})

function modifier_ra_ward_buff:IsPurgable() 			
    return false
end
function modifier_ra_ward_buff:IsPurgeException()	
    return false
end
function modifier_ra_ward_buff:IsHidden()				
    return true 
end

function modifier_ra_ward_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_ra_ward_buff:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then 
		return 
	end
	if keys.ability and (keys.ability:GetAbilityName() == "item_ward_observer" or keys.ability:GetAbilityName() == "item_ward_dispenser")then   

		local pos = keys.ability:GetCursorPosition() or keys.unit:GetAbsOrigin()
		local id = keys.unit:GetPlayerOwnerID()
		local team =keys.unit:GetTeamNumber()
		local targets = FindUnitsInRadius(
		team,
		pos,
		nil,
		30,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_OTHER,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
        false)

        for _, target in pairs(targets) do
            local name=target:GetName()
            if name~=nil and name=="npc_dota_ward_base" then
                if CDOTA_PlayerResource.TG_HERO[id + 1].des_ward then
                        CDOTA_PlayerResource.TG_HERO[id + 1].des_ward=CDOTA_PlayerResource.TG_HERO[id+ 1].des_ward+1
                end
                target:Kill( nil, keys.unit )
            end
        end

	end
end

function modifier_ra_ward_buff:OnCreated(keys)
	if self:GetAbility() == nil then return end
	
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()


	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(60)
	end	
	
end

function modifier_ra_ward_buff:OnIntervalThink()
	if not IsServer() then return end
	local heroes = FindUnitsInRadius(self.parent:GetTeam(), self.parent:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
			if not hero:HasModifier("modifier_ra_ward_buff2") then
				hero:AddNewModifier(self.parent,self.ab,"modifier_ra_ward_buff2",{duration = -1})	
			end
        end
end

--

modifier_ra_ward_buff2=class({})

function modifier_ra_ward_buff2:IsPurgable() 			
    return false
end
function modifier_ra_ward_buff2:IsPurgeException()	
    return false
end
function modifier_ra_ward_buff2:RemoveOnDeath()	
    return false
end
function modifier_ra_ward_buff2:IsHidden()		
    return true
end
function modifier_ra_ward_buff2:DeclareFunctions() return {MODIFIER_PROPERTY_BONUS_NIGHT_VISION} end

function modifier_ra_ward_buff2:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	
	if IsServer() then
		self:SetStackCount(1800 - self:GetParent():GetBaseNightTimeVisionRange())		
	end	
end

function modifier_ra_ward_buff2:GetBonusNightVision()
	if self.parent:HasModifier("modifier_lunar_blessing") then
		return 0
	end
	return self:GetStackCount()
end
