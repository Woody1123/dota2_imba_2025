counter_helix = class({})

LinkLuaModifier("modifier_counter_helix_ch", "heros/hero_axe/counter_helix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_counter_helix_turn", "heros/hero_axe/counter_helix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_counter_helix_cd", "heros/hero_axe/counter_helix.lua", LUA_MODIFIER_MOTION_NONE)

--LinkLuaModifier("modifier_counter_helix_debuff", "heros/hero_axe/counter_helix.lua", LUA_MODIFIER_MOTION_NONE)

function counter_helix:IsHiddenWhenStolen()return false
end
function counter_helix:IsStealable() return true
end
function counter_helix:GetIntrinsicModifierName()
    return "modifier_counter_helix_ch"
end
function counter_helix:GetCastRange()
    return self:GetSpecialValueFor("radius")+self:GetCaster():GetStrength()
end
function counter_helix:OnSpellStart()
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_axe_6") then
		if not caster:HasModifier("modifier_counter_helix_cd") then
			local mod = caster:AddNewModifier(caster,self,"modifier_counter_helix_turn",{duration = 30})
			   if mod then
				mod:SetStackCount(15)
				local cd = self:GetSpecialValueFor("cd")*caster:GetCooldownReduction()
				
				caster:AddNewModifier(caster,self,"modifier_counter_helix_cd",{duration = cd})
			   end
			   
		else
			local mod = caster:FindModifierByName("modifier_counter_helix_cd") 
			if mod then
				local cd = math.ceil(mod:GetRemainingTime())
				Notifications:Bottom(caster:GetPlayerOwnerID(), {text ="还有"..cd.."秒cd", duration = 1})
			end
		end	
	end
end


modifier_counter_helix_ch =  class({})
function modifier_counter_helix_ch:IsPassive()return true
end
function modifier_counter_helix_ch:IsPurgable()return false
end
function modifier_counter_helix_ch:IsPurgeException()return false
end
function modifier_counter_helix_ch:IsHidden()return true
end
function modifier_counter_helix_ch:AllowIllusionDuplicate()return false
end
function modifier_counter_helix_ch:OnCreated()
	if self:GetAbility() == nil then return end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    self.duration=self.ability:GetSpecialValueFor("duration")
	self.count = 0
    self.damageTable=
    {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PURE,
        ability =  self.ability,
	}
        self.chance= self.ability:GetSpecialValueFor("chance")
        self.dam=self.ability:GetSpecialValueFor("dam")
        self.dam_max_hp=self.ability:GetSpecialValueFor("dam_max_hp")
        self.radius=self.ability:GetSpecialValueFor("radius")
        self.asch=self.ability:GetSpecialValueFor("asch")
        --if IsServer() then
        --        self:StartIntervalThink(3.5)
        --end
end
function modifier_counter_helix_ch:OnRefresh()
    self:OnCreated()
end
function modifier_counter_helix_ch:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

--[[
function modifier_counter_helix_ch:GetModifierIncomingDamage_Percentage(tg)
    if tg.attacker:HasModifier("modifier_counter_helix_debuff") and tg.damage_category==1 then
        return -self:GetAbility():GetSpecialValueFor("dam_reduce")*tg.attacker:GetModifierStackCount("modifier_counter_helix_debuff", self:GetCaster())
    end
    return 0
end
]]

function modifier_counter_helix_ch:OnAttackLanded(tg)
        if not IsServer() then
                return
        end
    if tg.target==self.parent and not self.parent:PassivesDisabled() and self.parent:IsAlive() and not self.parent:IsIllusion() and not tg.attacker:IsBuilding() then
                --if PseudoRandom:RollPseudoRandom(self.ability, (self.parent:TG_HasTalent("special_bonus_axe_8") and self.parent:GetHealth()<self.parent:GetMaxHealth()*0.15 ) and 25 or self.chance) then
        if PseudoRandom:RollPseudoRandom(self.ability, self.ability:GetSpecialValueFor("chance")) then
			if self.ability:IsCooldownReady() then
				self:TurnAround(self.parent)
				self.ability:UseResources(true,true,true,true)
				else				
				self.parent:AddNewModifier(self.parent,self.ability,"modifier_counter_helix_turn",{duration = 30})
			end
           -- self:TurnAround(self.parent)
		   else
		   if self.ability:IsCooldownReady() then
		        self.count = self.count + 1
				if self.count == 4 then
					self.parent:AddNewModifier(self.parent,self.ability,"modifier_counter_helix_turn",{duration = 30})
					self.count = 0
				end
		   end
        end
    end
	--[[
    if tg.target==self.parent and self.parent:TG_HasTalent("special_bonus_axe_6") and PseudoRandom:RollPseudoRandom(self.ability, self.asch) and not tg.attacker:IsBuilding() then
                self:TurnAround(tg.attacker)
    end]]
end
function modifier_counter_helix_ch:TurnAround(caster)
                if caster==self.parent then
                   caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
                end
				
                EmitSoundOn("Hero_Axe.CounterHelix_Blood_Chaser",caster)
                local cpos=caster:GetAbsOrigin()
                local str=self.radius+caster:GetStrength()
                local fx = ParticleManager:CreateParticle("particles/tgp/axe/axe_ch_m.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster)
                ParticleManager:SetParticleControl(fx,0,cpos)
                ParticleManager:SetParticleControl(fx,1,Vector(str,0,0))
                ParticleManager:ReleaseParticleIndex(fx)
                local dam=self.dam +caster:GetMaxHealth()* self.dam_max_hp *0.01+caster:GetPhysicalArmorValue(true)
                local units=FindUnitsInRadius(self.team,cpos,nil,str, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
                if #units>0 then
                    for _,target in pairs(units) do
                            if target~=caster then
                                    self.damageTable.victim = target
                                    self.damageTable.damage = dam
                                    ApplyDamage(self.damageTable)
									--[[
                                if self.parent:Has_Aghanims_Shard() and target:IsHero() then
                                    target:AddNewModifier_RS(self.parent, self.ability, "modifier_counter_helix_debuff", {duration=self.duration})
                                end]]
                            end
                    end
                end
                self.ability:UseResources(false,  false,false, true)
end

--function modifier_counter_helix_ch:OnIntervalThink()
--        if self.parent and IsValidEntity(self.parent) and self.parent:IsAlive() and  not self.parent:IsIllusion() and self.parent:TG_HasTalent("special_bonus_axe_6") then
--                self:TurnAround(self.parent)
--        end
--end
modifier_counter_helix_cd = class({})

function modifier_counter_helix_cd:IsDebuff()			return true end
function modifier_counter_helix_cd:IsHidden() 			return false end
function modifier_counter_helix_cd:IsPurgable() 		return false end
function modifier_counter_helix_cd:IsPurgeException() 	return false end
function modifier_counter_helix_cd:RemoveOnDeath() 		return false end
modifier_counter_helix_turn = class({})

function modifier_counter_helix_turn:IsDebuff()			return false end
function modifier_counter_helix_turn:IsHidden() 			return false end
function modifier_counter_helix_turn:IsPurgable() 		return false end
function modifier_counter_helix_turn:IsPurgeException() 	return false end
function modifier_counter_helix_turn:RemoveOnDeath() 		return true end
function modifier_counter_helix_turn:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
end
function modifier_counter_helix_turn:GetModifierIncomingDamage_Percentage()
	return self.dam_in
end

function modifier_counter_helix_turn:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		self.dam_in = self:GetCaster():TG_GetTalentValue("special_bonus_axe_1")*-1
		self:SetStackCount(0)
		self:OnRefresh()
		self:StartIntervalThink(0.3)
		self:OnIntervalThink()
	end
end

function modifier_counter_helix_turn:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end

function modifier_counter_helix_turn:OnIntervalThink()
	if not IsServer() then return end
	local ab = self:GetAbility()

		if ab and ab:IsCooldownReady() then
		local mod = self:GetParent():FindModifierByName("modifier_counter_helix_ch")
		if mod and self:GetStackCount() > 0 then
			mod:TurnAround(self:GetCaster())
			ab:UseResources(true,true,true,true)
			self:SetStackCount(self:GetStackCount() - 1)
			if self:GetStackCount() <= 0 then
				self:Destroy()
			end
		end
	end
end



--[[
modifier_counter_helix_debuff=class({})

function modifier_counter_helix_debuff:IsHidden()
    return false
end

function modifier_counter_helix_debuff:IsPurgable()
    return true
end

function modifier_counter_helix_debuff:IsPurgeException()
    return true
end

function modifier_counter_helix_debuff:RemoveOnDeath()
    return true
end

function modifier_counter_helix_debuff:OnCreated()
	if self:GetAbility() == nil then return end
    self.max_count=self:GetAbility():GetSpecialValueFor("max_count")
    self.dam_reduce=self:GetAbility():GetSpecialValueFor("dam_reduce")
    if IsServer() then
        self:SetStackCount(1)
    end
end
function modifier_counter_helix_debuff:OnRefresh()
    if self:GetStackCount()<self.max_count then
        self:IncrementStackCount()
    end
end
function modifier_counter_helix_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_counter_helix_debuff:OnTooltip() return -self.dam_reduce*self:GetStackCount()  end]]