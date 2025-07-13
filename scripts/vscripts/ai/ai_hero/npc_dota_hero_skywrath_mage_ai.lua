if npc_dota_hero_skywrath_mage_ai == nil then
	npc_dota_hero_skywrath_mage_ai = ({})
end

function npc_dota_hero_skywrath_mage_ai:IsHidden() return false end
function npc_dota_hero_skywrath_mage_ai:IsDebuff() return false end
function npc_dota_hero_skywrath_mage_ai:IsPurgable() 		return false end
function npc_dota_hero_skywrath_mage_ai:IsPurgeException() 	return false end
function npc_dota_hero_skywrath_mage_ai:RemoveOnDeath() 	return false end
function npc_dota_hero_skywrath_mage_ai:OnCreated()
	self.parent = self:GetParent()
	self.hero_lv = 7
	self.unit_table = {}
	self.item_table = {"item_three_knives","item_octarine_core_v2","item_imba_refreshstone","item_sheepstick_v2","item_red_cape","item_veil_of_evil"}
	self.veteran_talent_table = {"modifier_veteran_talent_1","modifier_veteran_talent_5"}
	self.ability_table = {""}
	self.talent_table = {
		"special_bonus_custom_value_all15",
		"special_bonus_custom_value_msp30",
		"special_bonus_oldsky_15r",
		"special_bonus_oldsky_15l",
		"special_bonus_custom_value_ap20",
		"special_bonus_custom_value_castrange150",
		"special_bonus_oldsky_25r",
		"special_bonus_oldsky_25l",		
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
		self.ability_1 = self.parent:FindAbilityByName("oldsky_abolt")
		self.ability_2 = self.parent:FindAbilityByName("oldsky_cshot")	
		self.ability_3 = self.parent:FindAbilityByName("oldsky_aseal")	
		self.ability_4 = self.parent:FindAbilityByName("oldsky_mflare")
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
		self.attacker_target = nil
		self.team = self.parent:GetTeam()
	end
end

function npc_dota_hero_skywrath_mage_ai:think()
	if IsServer() then
		--等级相关数据
			
		
		--
		--物品
		self.refresh = self.parent:GetItemInSlot(2)
		self.sheep = self.parent:GetItemInSlot(3)
		self.red = self.parent:GetItemInSlot(4)
		
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
		local table_ab_1 = {}
		local table_ab_2 = {}
		local table_ab_3 = {}
		for _,enemy in pairs (self.unit_table[2]) do
			local dis = TG_Distance(enemy:GetAbsOrigin(),self.parent:GetAbsOrigin())
			if dis < 1000 then   
				table.insert(table_ab_1,enemy)
				if dis<650 then
					table.insert(table_ab_2,enemy)
				end
			end
		end		
		for _,friend in pairs (self.unit_table[1]) do
			if friend and friedn~=self.parent then
				local dis = TG_Distance(friend:GetAbsOrigin(),self.parent:GetAbsOrigin())
				if dis < 600 then   
					table.insert(table_ab_3,friend)
				end
			end
		end	
		--AI_USE_ITEM(self.unit_table)
		if self.parent.stat == 1 then
			self:use_combo(self.parent,table_ab_2)
		end
		if not self.parent.combo  then
			self:use_ability(self.parent,table_ab_1,table_ab_2,table_ab_3)
			self:use_item(self.parent,table_ab_1,table_ab_2,table_ab_3)
		end
	end	
end

function npc_dota_hero_skywrath_mage_ai:use_combo(hero,table_ab_2)
	if not IsServer() then return end
	if self.ability_3 and self.ability_4 and self.sheep then
		if self.ability_3:IsCooldownReady() and self.ability_4:IsCooldownReady() and self.sheep:IsCooldownReady() and self:GetParent():GetMana() > 1100 then 
			self.parent.combo = true
			local combo_start = 0
			local combo_end	= 3
			local tar = table_ab_2[#table_ab_2]
			if tar then 
				Timers:CreateTimer(0, function()
					if combo_start == 0 then
						self.parent:CastAbilityOnTarget(tar,self.sheep ,self.id)	
					end	
					if combo_start == 1 then
						if self.bkb then
						self.parent:CastAbilityOnTarget(tar,self.ability_3 ,self.id)	
						end
					end
					if combo_start == 2 then
						if self.blade_mail then
						self.parent:CastAbilityOnPosition(tar:GetAbsOrigin(),self.ability_4,self.id)	
						end
					end
					combo_start = combo_start + 1
					if combo_start == 5 then 
						self.parent.combo = false
						return nil 
					end
				return 0.1
				end)
			end
		end
	end	
end

function npc_dota_hero_skywrath_mage_ai:use_item(hero,table_ab_1,table_ab_2,table_ab_3)
	if IsServer() then
			if self.red and self.red:IsCooldownReady() and #table_ab_3 >1 and self.parent:GetMana()>150 then
				hero:CastAbilityOnTarget(table_ab_3[2],self.red,self.id)
			end
			if self.sheep  and self.sheep :IsCooldownReady() and #table_ab_2>0 and self.parent:GetMana()>250 then
				hero:CastAbilityOnTarget(table_ab_2[1],self.sheep ,self.id)
			end
	end
end

function npc_dota_hero_skywrath_mage_ai:use_ability(hero,table_ab_1,table_ab_2,table_ab_3)
	if not IsServer() then return end		
	
		if self.ability_3 and self.ability_3:IsCooldownReady() and #table_ab_2 > 0 and self.parent:GetMana() >110 and self.stat~=2 then
			hero:CastAbilityOnTarget(table_ab_2[#table_ab_2],self.ability_3,self.id)
		end		
		if self.ability_2 and self.ability_2:IsCooldownReady() and #table_ab_1 > 0  and self.parent:GetMana() >95 then
			hero:CastAbilityNoTarget(self.ability_2,self.id)
		end
		if self.ability_1 and self.ability_1:IsCooldownReady() and #table_ab_2 > 0 and self.parent:GetMana() >120 then
			hero:CastAbilityOnTarget(table_ab_2[#table_ab_2],self.ability_1,self.id)
		end
		if self.ability_4 and self.ability_4:IsCooldownReady() and #table_ab_2 > 0 and self.parent:GetMana() >700 then
			hero:CastAbilityOnPosition(table_ab_2[#table_ab_2]:GetAbsOrigin(),self.ability_4,self.id)	
		end	
end


--[[
function npc_dota_hero_skywrath_mage_ai:learn_ability(lv)
	for _,ab in pairs(self.ability_table) do
		if ab then
			ab:SetLevel(lv)
		end
	end
end

function npc_dota_hero_skywrath_mage_ai:add_item(lv)
	if lv <= 6 then
	self.parent:AddItemByName(self.item_table[lv])	
	end
	if lv == 7 then
		
	end
end

function npc_dota_hero_skywrath_mage_ai:leart_talent(lv)   
	for i = (lv-1)*4+1, lv*4 do
		self.parent:AddNewModifier(self.parent,nil,self.talent_table[i],{})
	end
end

function npc_dota_hero_skywrath_mage_ai:learn_veteran_talent(lv)
			sel.parent:RemoveModifierByName(self.veteran_talent_table[lv])
			local modifier = self.parent:AddNewModifier(self.parent,self,self.veteran_talent_table[lv],{duration = -1})
				if modifier then
					modifier:SetStackCount(tonumber(tb[i]))
					self.parent:AddNewModifier(self.parent,nil,self.veteran_talent_table[lv],{duration = -1})
					self.parent:CalculateStatBonus(true)
				end
end]]