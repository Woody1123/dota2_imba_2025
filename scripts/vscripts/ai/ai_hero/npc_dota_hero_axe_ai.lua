if npc_dota_hero_axe_ai == nil then
	npc_dota_hero_axe_ai = ({})
end

function npc_dota_hero_axe_ai:IsHidden() return false end
function npc_dota_hero_axe_ai:IsDebuff() return false end
function npc_dota_hero_axe_ai:IsPurgable() 		return false end
function npc_dota_hero_axe_ai:IsPurgeException() 	return false end
function npc_dota_hero_axe_ai:RemoveOnDeath() 	return false end
function npc_dota_hero_axe_ai:OnCreated()
	self.parent = self:GetParent()
	self.hero_lv = 7
	self.unit_table = {}
	self.item_table = {"item_imba_blink_boots","item_bkb","item_imba_aegis_heart","item_imba_blade_mail","item_imba_orb","item_imba_greatwyrm_plate"}
	self.veteran_talent_table = {"modifier_veteran_talent_1","modifier_veteran_talent_5"}
	self.ability_table = {""}
	self.talent_table = {
		"special_bonus_axe_1",
		"special_bonus_axe_2",
		"special_bonus_axe_3",
		"special_bonus_axe_4",
		"special_bonus_axe_5",
		"special_bonus_axe_6",
		"special_bonus_axe_7",
		"special_bonus_axe_8",		
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
		self.ability_1 = self.parent:FindAbilityByName("berserkers_call")
		self.ability_2 = self.parent:FindAbilityByName("battle_hunger")	
		self.ability_3 = self.parent:FindAbilityByName("culling_blade")	
		self.ability_4 = self.parent:FindAbilityByName("counter_helix")
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
		self.attacker_target = nil
		self.team = self.parent:GetTeam()
	end
end

function npc_dota_hero_axe_ai:think()
	if IsServer() then
		--等级相关数据
			
		
		--
		--物品
		self.blink = self.parent:GetItemInSlot(0)
		self.bkb = self.parent:GetItemInSlot(1)
		self.heart = self.parent:GetItemInSlot(2)
		self.blade_mail = self.parent:GetItemInSlot(3)
		self.orb = self.parent:GetItemInSlot(4)
		self.great_plate = self.parent:GetItemInSlot(5)
		
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
			if dis < 700 then   
				table.insert(table_ab_1,enemy)
				if dis<320 then
					table.insert(table_ab_2,enemy)
					if dis<250 and enemy:GetHealth()< (self.parent:GetMaxHealth()*0.05+350) then
						table.insert(table_ab_3,enemy)
					end
				end
			end
		end		
		--AI_USE_ITEM(self.unit_table)
		if self.parent.stat == 1 then
			self:use_combo(self.parent)
		end
		if not self.parent.combo  then
			self:use_ability(self.parent,table_ab_1,table_ab_2,table_ab_3)
			self:use_item(self.parent,table_ab_1,table_ab_2,table_ab_3)
		end
	end	
end

function npc_dota_hero_axe_ai:use_combo(hero)
	if not IsServer() then return end
	if self.blink and self.ability_1 then
		if self.blink:IsCooldownReady() and self.ability_1:IsCooldownReady() and self:GetParent():GetMana() > 200 then 
			self.parent.combo = true
			local combo_start = 0
			local combo_end	= 3
			for _,enemy in pairs (self.unit_table[2]) do
				if enemy then
				Timers:CreateTimer(0, function()
					if combo_start == 0 then
						self.parent:CastAbilityOnPosition(enemy:GetAbsOrigin(),self.blink,self.id)	
						if self.heart then
							self.heart:StartCooldown(3)
						end
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

function npc_dota_hero_axe_ai:use_item(hero,table_ab_1,table_ab_2,table_ab_3)
	if IsServer() then
			if self.bkb and self.bkb:IsCooldownReady() then
				hero:CastAbilityNoTarget(self.bkb,self.id)
			end
			if self.heart and self.heart:IsCooldownReady() and #table_ab_2 >0 and self.parent:GetMana()>250 then
				hero:CastAbilityNoTarget(self.heart,self.id)
			end
			if self.blade_mail and self.blade_mail:IsCooldownReady() and #table_ab_1 >0 and self.parent:GetMana()>50 then
				hero:CastAbilityNoTarget(self.blade_mail,self.id)
			end
			if self.orb and self.orb:IsCooldownReady() and #table_ab_1>0 then
				hero:CastAbilityOnTarget(self.parent,self.orb,self.id)
			end
			if self.great_plate and self.great_plate:IsCooldownReady() and #table_ab_1>0 then
				hero:CastAbilityNoTarget(self.great_plate,self.id)
			end

		
		if self.parent.stat == 4 and self.parent:GetMana() >100 then
			if self.blink and self.blink:IsCooldownReady() and self.parent.pos == nil  then
				self.parent:CastAbilityOnPosition(self.parent:GetTeam() == 2 and GOODGUYS_HOME or BADGUYS_HOME,self.blink,self.id)	
			end
		end
	end
	
end

function npc_dota_hero_axe_ai:use_ability(hero,table_ab_1,table_ab_2,table_ab_3)
	if not IsServer() then return end		
		if self.ability_1 and self.ability_1:IsCooldownReady() and #table_ab_2 > 0 and self.parent:GetMana() >120 and self.stat~=2 then
			hero:CastAbilityNoTarget(self.ability_1,self.id)
		end
		
		if self.ability_2 and self.ability_2:IsCooldownReady() and #table_ab_1 > 0  and self.parent:GetMana() >80 then
			hero:CastAbilityOnTarget(table_ab_1[RandomInt(1,#table_ab_1)],self.ability_2,self.id)
		end
		if self.ability_3 and self.ability_3:IsCooldownReady() and #table_ab_3 > 0 and self.parent:GetMana() >250 then
			hero:CastAbilityOnTarget(table_ab_3[1],self.ability_3,self.id)
		end
end


--[[
function npc_dota_hero_axe_ai:learn_ability(lv)
	for _,ab in pairs(self.ability_table) do
		if ab then
			ab:SetLevel(lv)
		end
	end
end

function npc_dota_hero_axe_ai:add_item(lv)
	if lv <= 6 then
	self.parent:AddItemByName(self.item_table[lv])	
	end
	if lv == 7 then
		
	end
end

function npc_dota_hero_axe_ai:leart_talent(lv)   
	for i = (lv-1)*4+1, lv*4 do
		self.parent:AddNewModifier(self.parent,nil,self.talent_table[i],{})
	end
end

function npc_dota_hero_axe_ai:learn_veteran_talent(lv)
			sel.parent:RemoveModifierByName(self.veteran_talent_table[lv])
			local modifier = self.parent:AddNewModifier(self.parent,self,self.veteran_talent_table[lv],{duration = -1})
				if modifier then
					modifier:SetStackCount(tonumber(tb[i]))
					self.parent:AddNewModifier(self.parent,nil,self.veteran_talent_table[lv],{duration = -1})
					self.parent:CalculateStatBonus(true)
				end
end]]