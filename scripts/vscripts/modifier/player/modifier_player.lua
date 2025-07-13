modifier_player=class({})
CreateTalents("custom_value_talent", "modifier/player/modifier_player.lua")


function modifier_player:IsHidden()
    return false
end

function modifier_player:IsPurgable()
    return false
end

function modifier_player:IsPurgeException()
    return false
end

function modifier_player:RemoveOnDeath()
    return false
end

function modifier_player:IsPermanent()
    return true
end

function modifier_player:AllowIllusionDuplicate()
    return false
end

function modifier_player:GetTexture()
    return "jugg_dog"
end



function modifier_player:OnCreated()
    self.parent=self:GetParent()
    self.name=self.parent:GetName()
	self.health = 1000 
	self.armor = 15
	self.mag = 25
	self.ab_point = 0
	self.cri = 0
	self.ex_dam = 35
	self.msp = 0
	self.damagetab = {}
    self.N={}
    self.NS={}
    if IsServer() then
		if self.parent:IsRangedAttacker() then
			self.health = 1000
			self.armor = 15
			self.mag = 25
			self.ex_dam = 20
			self.msp = 0
		end
		
		self.parent:SetBaseDamageMin(self.parent:GetBaseDamageMin()+self.ex_dam)
		self.parent:SetBaseDamageMax(self.parent:GetBaseDamageMax()+self.ex_dam)
        self.parent.original_team=self.parent:GetTeamNumber()
        self.pos=self.parent.original_team == DOTA_TEAM_GOODGUYS and GOOD_POS or BAD_POS
        self.id=self.parent:GetPlayerOwnerID()
        self.PL=PlayerResource:GetPlayer(self.id)
		self.damagetab.attacker = self.parent
		self.damagetab.damage_type = DAMAGE_TYPE_PHYSICAL 
		self.damagetab.ability = nil
		 --self.parent:AddExperience(4000, DOTA_ModifyXP_Unspecified, false, false)
        --[[if self.parent:IS_TrueHero_TG() and not PlayerResource:IsFakeClient(self.id) then
            self:StartIntervalThink(3)
        end]]
		
	--self.parent:AddNewModifier(self.parent,self,"modifier_seasonal_party_hat",{duration =-1})
	end
end
--[[
function modifier_player:OnIntervalThink()
    for a=5,15 do
        local item=self.parent:GetItemInSlot(a)
        if item~=nil and item:IsNeutralDrop() then
            if a>=9 then
                table.insert (self.NS,item)
            else
                table.insert (self.N,item)
            end
        end
    end
    if self.N~=nil and (#self.N + #self.NS)>1 then
        for b=1,#self.N do
            self.parent:DropItemAtPositionImmediate(self.parent:FindItemInInventory(self.N[b]:GetName()),self.pos)
        end
    end
    if self.NS~=nil and #self.NS>1 then
        Notifications:Bottom(PlayerResource:GetPlayer(self.id), {text="请将多余的中立物品送回否则你将被封禁", duration=3, style={color="yellow", ["font-size"]="40px"}})
    end
    self.N={}
    self.NS={}
end]]

--[[
function modifier_player:CheckState()
    if self.parent:HasModifier("modifier_fountain_aura_buff") and self.id and (IsServer() and  PlayerResource:GetConnectionState(self.id) == DOTA_CONNECTION_STATE_ABANDONED) then
        return
        {
            [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        }
    else
        return {}
    end
end
]]

function modifier_player:DeclareFunctions()
    return
    {
        --MODIFIER_EVENT_ON_ABILITY_EXECUTED,
       -- MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		--MODIFIER_PROPERTY_EXP_RATE_BOOST,
        MODIFIER_EVENT_ON_TELEPORTED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        -- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_player:GetModifierPercentageExpRateBoost()
	return 40
end

function modifier_player:GetModifierExtraHealthBonus()
	return self.health
end

function modifier_player:GetModifierPhysicalArmorBonus()
    return self.armor
end

function modifier_player:GetModifierMagicalResistanceBonus()
	return self.mag ---self:GetParent():GetIntellect(false)/5
end
function modifier_player:GetModifierMoveSpeedBonus_Constant()
	return self.msp
end


--[[
function modifier_player:GetModifierPercentageRespawnTime() 
	return 0.5
end
function modifier_player:GetModifierStatusResistanceStacking()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			return 20 
		end
    return 50
	end
end]]

-- --国庆疯狂开始
-- function modifier_player:GetModifierStatusResistanceStacking()
    
--     	return 70
-- end

-- function modifier_player:GetModifierPercentageCooldown()
 
--         return 70

-- end

-- function modifier_player:GetModifierConstantManaRegen()
--         return 100
-- end

-- --国庆疯狂结束

--function modifier_player:GetModifierHealthBonus() return 100 end
--[[
function modifier_player:OnAttackLanded(tg)
   if IsServer() then
        if tg.attacker==self.parent  then
            local name=tg.target:GetUnitName()
            if name=="npc_dota_observer_wards" or name=="npc_dota_sentry_wards" then
                if CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward~=nil then
                    CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward=CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward+1
                end
                if tg.target and  tg.target:GetTeamNumber()~=self.parent:GetTeamNumber() then
                    PlayerResource:ModifyGold(self.id,40,false,DOTA_ModifyGold_WardKill)                   
                end
                tg.target:Destroy()
            end
			if self.cri > 0 then
				if tg.target and tg.attacker:IsAlive() and not tg.target:IsBuilding() then
					if tg.damage > self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * 1.5 then 
						self.damagetab.damage = tg.damage*self.cri*0.01
						self.damagetab.victim = tg.target

						ApplyDamage( self.damagetab )
						SendOverheadEventMessage(tg.attacker, OVERHEAD_ALERT_CRITICAL, tg.target, self.damagetab.damage, nil)
							
					end
				end
			end
        end
   end
end]]
--[[
function modifier_player:OnAbilityExecuted(tg)
    if IsServer() then
            if tg.unit==self.parent  and not self.parent:IsIllusion() then
                local name=tg.ability:GetName()
                    if  tg.ability:IsItem() and (name=="item_ward_observer" or name=="item_ward_dispenser" or name=="item_ward_sentry")  then
                            if CDOTA_PlayerResource.TG_HERO[self.id + 1].use_ward~=nil then
                                CDOTA_PlayerResource.TG_HERO[self.id + 1].use_ward=CDOTA_PlayerResource.TG_HERO[self.id + 1].use_ward+1
                            end
                    end
            end
    end
 end
]]

function modifier_player:OnDeath(tg)
    if IsServer() then
         if tg.attacker==self.parent and tg.unit:IsRealHero() and not self.parent:IsIllusion() then
            local level1=self.parent:GetLevel()
            local level2=tg.unit:GetLevel()
            if level1 and level2 and level2>level1 then
                    local lv=level2-level1
                    self.parent:AddExperience(lv*500, DOTA_ModifyXP_Unspecified, false, false)
                    PlayerResource:ModifyGold(self.id,lv*100 ,false,DOTA_ModifyGold_Unspecified)
            end
         end
		 if tg.unit == self:GetParent() and not tg.reincarnate then
			tg.unit:RemoveModifierByName("modifier_truesight_f")
		end
         if tg.unit==self.parent and not self.parent:IsIllusion() and tg.attacker:IsRealHero() then
            		if tg.unit:GetLevel()<tg.attacker:GetLevel() then
							local gold = math.max((tg.attacker:GetLevel() - tg.unit:GetLevel())*100,200)
							local exper = math.max(tg.unit:GetLevel()*20,200)
                            PlayerResource:ModifyGold(self.id,gold, false, DOTA_ModifyGold_Unspecified)
                            tg.unit:AddExperience(exper, DOTA_ModifyXP_Unspecified, false, false)
                    else
                            local gold = math.max((tg.attacker:GetLevel() - tg.unit:GetLevel())*100,200)
							local exper = math.max(tg.unit:GetLevel()*20,200)
                            PlayerResource:ModifyGold(self.id,gold, false, DOTA_ModifyGold_Unspecified)
                            tg.unit:AddExperience(exper, DOTA_ModifyXP_Unspecified, false, false)
                    end
					
                    if PlayerResource:GetConnectionState(self.id) == DOTA_CONNECTION_STATE_ABANDONED then
                            self.parent:SetMinimumGoldBounty(0)
                            self.parent:SetMaximumGoldBounty(0)
                            self.parent:SetCustomDeathXP(0)
                    end
					self.ab_point = self.parent:GetAbilityPoints()
					self.parent:SetAbilityPoints(0)
        end
    end
end
 
function modifier_player:OnRespawn(tg)
	if IsServer() then
        if tg.unit==self.parent and tg.unit:IsRealHero() and not self.parent:IsIllusion() then
			self.parent:SetAbilityPoints(self.parent:GetAbilityPoints() + self.ab_point)
		end
	end
end

function modifier_player:OnTeleported(tg)
	if IsServer() then
        if tg.unit==self.parent and tg.unit:IsRealHero() and not self.parent:IsIllusion() then
			self.tp_cd = 10
			if self.parent:HasItemInInventory("item_travel_boots") then
				self.tp_cd = 10
			end
			if self.parent:HasItemInInventory("item_travel_boots_2") then
				self.tp_cd = 5
			end
			Timers:CreateTimer(0.1, function()
				local tp = self.parent:GetItemInSlot(DOTA_ITEM_TP_SCROLL)
				if tp ~= nil then
						if tp:GetName()~="item_refresher" and tp:GetName()~="item_recipe_imba_refreshstone" then
							tp:EndCooldown()
							tp:StartCooldown(self.tp_cd)
						end
					return nil
				end
			end)
		end
	end
end
