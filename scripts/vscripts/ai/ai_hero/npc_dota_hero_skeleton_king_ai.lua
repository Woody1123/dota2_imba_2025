if npc_dota_hero_skeleton_king_ai == nil then
	npc_dota_hero_skeleton_king_ai = ({})
end

function npc_dota_hero_skeleton_king_ai:IsHidden() return false end
function npc_dota_hero_skeleton_king_ai:IsDebuff() return false end
function npc_dota_hero_skeleton_king_ai:IsPurgable() 		return false end
function npc_dota_hero_skeleton_king_ai:IsPurgeException() 	return false end
function npc_dota_hero_skeleton_king_ai:RemoveOnDeath() 	return false end
function npc_dota_hero_skeleton_king_ai:OnCreated()
	self.parent = self:GetParent()
	self.hero_lv = 7
	self.unit_table = {}
	self.item_table = {"item_premium_power_treads","item_imba_harpoon","item_bkb","item_siege","item_greater_crit2","item_skadi_v2"}
	self.veteran_talent_table = {"modifier_veteran_talent_2","modifier_veteran_talent_1"}
	self.ability_table = {""}
	
	self.talent_table = {
		"special_bonus_skeleton_king_1",
		"special_bonus_skeleton_king_2",
		"special_bonus_skeleton_king_3",
		"special_bonus_skeleton_king_4",
		"special_bonus_skeleton_king_5",
		"special_bonus_skeleton_king_6",
		"special_bonus_skeleton_king_7",
		"special_bonus_skeleton_king_8",
			
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
		self.ability_1 = self.parent:FindAbilityByName("hellfire_blast")
		self.ability_2 = self.parent:FindAbilityByName("vampiric_aura")	
		self.ability_3 = self.parent:FindAbilityByName("mortal_strike")	
		self.ability_4 = self.parent:FindAbilityByName("reincarnation")
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
			self.parent.lv = 3
		end	
		
		self.team = self.parent:GetTeam()
	end
end

function npc_dota_hero_skeleton_king_ai:think()
	if IsServer() then
		--等级相关数据
			
		
		--
		--物品
		self.harpoon = self.parent:GetItemInSlot(1)
		self.bkb = self.parent:GetItemInSlot(2)
		self.siege = self.parent:GetItemInSlot(3)
		self.paokui = self.parent:GetItemInSlot(4)
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
			for _,enemy in pairs (self.unit_table[2]) do
				if not enemy then return end
				local dis = TG_Distance(enemy:GetAbsOrigin(),self.parent:GetAbsOrigin())
				if dis < 600 then   
					table.insert(table_ab_1,enemy)
					if dis<400 then
						--print(enemy:GetName())
						table.insert(table_ab_2,enemy)
					end
				end
			end
			
			if not self.parent.combo  then
				self:use_ability(self.parent,table_ab_1,table_ab_2)
				self:use_item(self.parent,table_ab_1,table_ab_2)
			end
		end	
		
		
	
end
--[[
function npc_dota_hero_skeleton_king_ai:use_combo(hero)
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
function npc_dota_hero_skeleton_king_ai:use_item(hero,table_ab_1,table_ab_2)
	if IsServer() then
		if hero.stat ~= 2 then
			if self.bkb and self.bkb:IsCooldownReady() and #table_ab_2 > 0 then
				hero:CastAbilityNoTarget(self.bkb,self.id)
			end
			if self.siege and self.siege:IsCooldownReady() and #table_ab_1 > 0 then
				hero:CastAbilityNoTarget(self.siege,self.id)
			end
			if self.skd and self.skd:IsCooldownReady() and #table_ab_2 > 0 then
				hero:CastAbilityNoTarget(self.skd,self.id)
			end
			if self.harpoon and self.harpoon:IsCooldownReady() and self:GetParent():GetMana() > 150 and #table_ab_1 > 0 then 
				hero:CastAbilityOnTarget(table_ab_1[#table_ab_1],self.harpoon,self.id)
			end
		end
	end
end

function npc_dota_hero_skeleton_king_ai:use_ability(hero,table_ab_1,table_ab_2)
	if not IsServer() then return end
		
	if self.parent:GetMana() > 140 and self.ability_1 and self.ability_1:IsCooldownReady() and #table_ab_1 > 0 then
		hero:CastAbilityOnTarget(table_ab_1[#table_ab_1],self.ability_1,self.id)
	end
	if self.parent:GetMana() > 200 and self.ability_2 and self.ability_2:IsCooldownReady() and #table_ab_2 > 0 then
		hero:CastAbilityNoTarget(self.ability_2,self.id)
	end
end


--[[
function npc_dota_hero_skeleton_king_ai:learn_ability(lv)
	for _,ab in pairs(self.ability_table) do
		if ab then
			ab:SetLevel(lv)
		end
	end
end

function npc_dota_hero_skeleton_king_ai:add_item(lv)
	if lv <= 6 then
	self.parent:AddItemByName(self.item_table[lv])	
	end
	if lv == 7 then
		
	end
end

function npc_dota_hero_skeleton_king_ai:leart_talent(lv)   
	for i = (lv-1)*4+1, lv*4 do
		self.parent:AddNewModifier(self.parent,nil,self.talent_table[i],{})
	end
end

function npc_dota_hero_skeleton_king_ai:learn_veteran_talent(lv)
			sel.parent:RemoveModifierByName(self.veteran_talent_table[lv])
			local modifier = self.parent:AddNewModifier(self.parent,self,self.veteran_talent_table[lv],{duration = -1})
				if modifier then
					modifier:SetStackCount(tonumber(tb[i]))
					self.parent:AddNewModifier(self.parent,nil,self.veteran_talent_table[lv],{duration = -1})
					self.parent:CalculateStatBonus(true)
				end
end]]