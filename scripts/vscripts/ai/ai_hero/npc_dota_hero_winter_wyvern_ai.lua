if npc_dota_hero_winter_wyvern_ai == nil then
	npc_dota_hero_winter_wyvern_ai = ({})
end

function npc_dota_hero_winter_wyvern_ai:IsHidden() return false end
function npc_dota_hero_winter_wyvern_ai:IsDebuff() return false end
function npc_dota_hero_winter_wyvern_ai:IsPurgable() 		return false end
function npc_dota_hero_winter_wyvern_ai:IsPurgeException() 	return false end
function npc_dota_hero_winter_wyvern_ai:RemoveOnDeath() 	return false end
function npc_dota_hero_winter_wyvern_ai:OnCreated()
	self.parent = self:GetParent()
	self.hero_lv = 7
	self.unit_table = {}
	self.item_table = {"item_premium_power_treads","item_imba_gungnir","item_bkb","item_imba_thirst","item_revenants_brooch","item_skadi_v2"}
	self.veteran_talent_table = {"modifier_veteran_talent_3","modifier_veteran_talent_2"}
	self.ability_table = {""}
	
	self.talent_table = {
		"special_bonus_winter_wyvern_1",
		"special_bonus_winter_wyvern_2",
		"special_bonus_winter_wyvern_3",
		"special_bonus_winter_wyvern_4",
		"special_bonus_winter_wyvern_5",
		"special_bonus_winter_wyvern_6",
		"special_bonus_winter_wyvern_7",
		"special_bonus_winter_wyvern_8",			
	}
	if self.parent.stat == nil then
		self.action_lv = 10	--行动优先级 经过数次行动才能消掉,单指跑路
		self.parent.stat = 1 --当前行动状态 1，进攻 2.走路 3.跑路 4.头也不回的跑路
	end
	
	if IsServer() then
		self.home_pos = (self.parent:GetTeam()==2 and Vector(-6000,-6000,256) or Vector(6000,6000,256))
		self.hero_lv = self.parent:GetLevel()
		self.parent.combo = false
		self.parent.move = false
		self.ability_1 = self.parent:FindAbilityByName("arctic_burn")
		self.ability_2 = self.parent:FindAbilityByName("splinter_blast")	
		self.ability_3 = self.parent:FindAbilityByName("cold_embrace")	
		self.ability_4 = self.parent:FindAbilityByName("winters_curse")
		self.ability_table = {self.ability_1,self.ability_2,self.ability_3,self.ability_4}
		for i = 0,16 do
			local item = self.parent:GetItemInSlot(i)
			if item~=nil then
				item:Destroy()
			end	
		end
		--self.parent:AddItemByName("item_imba_blink_boots")
		--self.parent:AddItemByName("item_bkb")
		--self.parent:AddItemByName("item_imba_aegis_heart")
		--self.parent:AddItemByName("item_imba_blade_mail")
		--self.parent:AddItemByName("item_imba_orb")
		--self.parent:AddItemByName("item_imba_greatwyrm_plate")

		self.id = self.parent:GetPlayerOwnerID()
		if self.parent.lv == nil then
			self.parent.lv = 1
		end	
		
		self.team = self.parent:GetTeam()
	end
end

function npc_dota_hero_winter_wyvern_ai:think()
	if IsServer() then
		--等级相关数据
			
		
		--
		--物品
		self.gung = self.parent:GetItemInSlot(1)
		self.bkb = self.parent:GetItemInSlot(2)
		self.stan = self.parent:GetItemInSlot(3)
		self.brooch = self.parent:GetItemInSlot(4)
		self.skd = self.parent:GetItemInSlot(5)
		
		self.unit_table = AI_CHECK_SITUATION(self.parent)
		if self.action_lv > 1 and self.parent.stat == 4 then
			if self.parent:GetHealth()/self.parent:GetMaxHealth() > 0.6 then
				self.action_lv =  self.action_lv - 1
				if self.parent:GetHealth()/self.parent:GetMaxHealth() > 0.8 then
					self.action_lv = 0 
					self:think()
				end
			end
			else
			
			AI_MOVEABOUT(self.parent,self.unit_table[3],50,nil)
			
		end
				
		--AI_USE_ITEM(self.unit_table)
		--[[
		if self.parent.stat == 1 then
			self:use_combo(self.parent)
		end]]
		
		local table_ab_1 = {}
		local table_ab_2 = {}
		local table_ab_3 = {}
			for _,enemy in pairs (self.unit_table[2]) do
				if not enemy then return end
				local dis = TG_Distance(enemy:GetAbsOrigin(),self.parent:GetAbsOrigin())
				if dis < 800 then   
					table.insert(table_ab_1,enemy)
					if dis<500 then
						--print(enemy:GetName())
						table.insert(table_ab_2,enemy)
					end
				end
			end
			for _,friend in pairs (self.unit_table[1]) do
				if friend  then
					local dis = TG_Distance(friend:GetAbsOrigin(),self.parent:GetAbsOrigin())
					if dis < 400 and friend:GetHealth()/friend:GetMaxHealth()<0.5 then   
						table.insert(table_ab_3,friend)
					end
				end				
			end
			if not self.parent.combo  then
				self:use_ability(self.parent,table_ab_1,table_ab_2,table_ab_3)
				self:use_item(self.parent,table_ab_1,table_ab_2)
			end
		end	
		
		
	
end
--[[
function npc_dota_hero_winter_wyvern_ai:use_combo(hero)
	if not IsServer() then return end
	if self.bkb and self.ability_1 then
		if self.blink:IsCooldownReady() and self.ability_1:IsCooldownReady() and self:GetParent():GetMana() > 470 then 
			local combo_start = 0
			local combo_end	= 3
			for _,enemy in pairs (self.unit_table[2]) do
				if enemy and enemy:then
				Timers:CreateTimer(0, function()
					if combo_start == 0 then
						self.parent:CastAbilityOnPosition(enemy:GetAbsOrigin(),self.blink,self.id)	
					end	
					if combo_start == 1 then
						if self.bkb then
						hero:CastAbilityNoTarget(self.bkb,self.id)
						end
					end
					if combo_start == 2 then
						if self.blade_mail then
						hero:CastAbilityNoTarget(self.blade_mail,self.id)
						end
					end
					if combo_start == 3 then
						hero:CastAbilityNoTarget(self.ability_1,self.id)
					end
					combo_start = combo_start + 1
					if combo_start == 6 then 
						self.parent.combo = false
						return nil 
					end
				return 0.03
				end)
					break
				end
			end
		end
	end	
end
]]
function npc_dota_hero_winter_wyvern_ai:use_item(hero,table_ab_1,table_ab_2)
	if IsServer() then
		if hero.stat ~= 2 then
			if self.bkb and self.bkb:IsCooldownReady() and #table_ab_2 > 0 then
				hero:CastAbilityNoTarget(self.bkb,self.id)
			end
			if self.stan and self.stan:IsCooldownReady() and #table_ab_1 > 0 
				and self.parent:GetHealth()/self.parent:GetMaxHealth()<0.4 and self.stat == 1 then
				hero:CastAbilityNoTarget(self.stan,self.id)
			end
			if self.skd and self.skd:IsCooldownReady() and #table_ab_2 > 0 then
				hero:CastAbilityNoTarget(self.skd,self.id)
			end
			if self.gung and self.gung:IsCooldownReady() and self:GetParent():GetMana() > 150 and #table_ab_2 > 0 then 
				hero:CastAbilityOnTarget(table_ab_2[1],self.gung,self.id)
			end
			if self.brooch and self.brooch:IsCooldownReady() and self:GetParent():GetMana() > 250 and #table_ab_1 > 0 then 
				hero:CastAbilityNoTarget(self.brooch,self.id)
			end
		end
	end
end
--100 150 80 350
function npc_dota_hero_winter_wyvern_ai:use_ability(hero,table_ab_1,table_ab_2,table_ab_3)
	if not IsServer() then return end
		
	if self.parent:GetMana() > 100 and self.ability_1 and self.ability_1:GetToggleState() == false and self.parent.stat == 1  and #table_ab_1 >0 then
		self.ability_1:ToggleAbility()
	end
	if self.parent:GetMana() > 150 and self.ability_2 and self.ability_2:IsCooldownReady() and #table_ab_1 > 0 then
		hero:CastAbilityOnTarget(table_ab_1[#table_ab_1],self.ability_2,self.id)
	end
	if self.parent:GetMana() > 80 and self.ability_3 and self.ability_3:IsCooldownReady() and #table_ab_3 > 0 then
		hero:CastAbilityOnTarget(table_ab_3[1],self.ability_3,self.id)
	end
	if self.parent:GetMana() > 350 and self.ability_4 and self.ability_4:IsCooldownReady() and #table_ab_2 > 0 then
		hero:CastAbilityOnTarget(table_ab_2[#table_ab_2],self.ability_4,self.id)
	end
end


--[[
function npc_dota_hero_winter_wyvern_ai:learn_ability(lv)
	for _,ab in pairs(self.ability_table) do
		if ab then
			ab:SetLevel(lv)
		end
	end
end

function npc_dota_hero_winter_wyvern_ai:add_item(lv)
	if lv <= 6 then
	self.parent:AddItemByName(self.item_table[lv])	
	end
	if lv == 7 then
		
	end
end

function npc_dota_hero_winter_wyvern_ai:leart_talent(lv)   
	for i = (lv-1)*4+1, lv*4 do
		self.parent:AddNewModifier(self.parent,nil,self.talent_table[i],{})
	end
end

function npc_dota_hero_winter_wyvern_ai:learn_veteran_talent(lv)
			sel.parent:RemoveModifierByName(self.veteran_talent_table[lv])
			local modifier = self.parent:AddNewModifier(self.parent,self,self.veteran_talent_table[lv],{duration = -1})
				if modifier then
					modifier:SetStackCount(tonumber(tb[i]))
					self.parent:AddNewModifier(self.parent,nil,self.veteran_talent_table[lv],{duration = -1})
					self.parent:CalculateStatBonus(true)
				end
end]]