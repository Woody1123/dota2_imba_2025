player = class({})


--第一次出生
function player:First_Player_Spawned(npc)

	--------------------------------------- 基础配置 -------------------------------------

	local id = npc:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(id)
	local hero_name = npc:GetName()
	if npc:IS_TrueHero_TG() and npc.IS_FirstSpawned == nil then
		npc.IS_FirstSpawned = true
		local num = id + 1
		CDOTA_PlayerResource.TG_HERO[num] = npc
		CDOTA_PlayerResource.TG_HERO[num].HERO_TALENT = {}
		CDOTA_PlayerResource.TG_HERO[num].PID = {}
		CDOTA_PlayerResource.TG_HERO[num].TALENT_NAME = nil
		local steamId = PlayerResource:GetSteamID(id)
		for steamId1,chance in pairs(GameRules.BanId) do
			if  tostring(steamId) == tostring(steamId1) then
				self:Ban_Player(npc,id)
				break
			end
		end
		
		network:LoadData(id)
		custom_events:OpenUI(id)
		if GameRules:IsCheatMode() then
			GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
			PlayerResource:SetCustomBuybackCost(id, 1)
			PlayerResource:SetCustomBuybackCooldown(id, 1)
		end
		if not AI_MODE then
			Timers:CreateTimer({
				useGameTime = false,
				endTime = SPAWN_TIME,
				callback = function()
					if hero_name == "npc_dota_hero_invoker" then
						npc:AddNewModifier(npc, nil, "modifier_invoker_up", {})
					end
					if hero_name == "npc_dota_hero_witch_doctor" then
						npc:AddNewModifier(npc, nil, "modifier_witch_doctor_up", {})
					end
					if hero_name == "npc_dota_hero_morphling" then
						npc:AddNewModifier(npc, nil, "modifier_morphling", {})
					end
					if PlayerResource:HasRandomed(id) then
						PlayerResource:ModifyGold(id, 600, true, DOTA_ModifyGold_Unspecified)
					end
					local tp = npc:GetItemInSlot(DOTA_ITEM_TP_SCROLL)
					if tp then
						tp:EndCooldown()
					end
					npc:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)
					npc:AddNewModifier(npc, nil, "modifier_player", {})
					npc:AddItemByName("item_magic_wand")
					--npc:AddItemByName("item_rd_book")
				end
			})
		
		Timers:CreateTimer({
			useGameTime = false,
			endTime = 7,
			callback = function()
				if IsInTable(npc,AI_HERO)  then return end
				--if CDOTA_PlayerResource.TG_HERO[num].des_ward~=nil  and CDOTA_PlayerResource.TG_HERO[num].des_ward>Veteran_WARD then
				npc:AddItemByName("item_ward_sentry")
				npc:AddItemByName("item_ward_observer")
				local pogo = npc:AddItemByName("item_pogo_stick")
				pogo.owner = npc:GetPlayerID()
				--end
			end
		}) 
		end
		
		local heroW = HeroWearable[hero_name]
		if heroW ~= nil then
			npc.HEROW = heroW
			npc.WearablesTable = {}  
			if ms ~= nil then 
				npc:SetOriginalModel(ms.model)
				npc:SetModel(ms.model)
			end
			if ws ~= nil then
				for b = 1, TableLength(ws) do
					local n = tostring(b)
					if ws[n] ~= nil then
						local ent = wearable:ChangeHeroClothing({
							type = "prop_ragdoll",
							name = ws[n],
							npc = npc
						})
						table.insert(npc.WearablesTable, ent)
					end
				end
			end
			if pp ~= nil then
				npc:SetRangedProjectileName(pp.proj)
			end
			npc:NotifyWearablesOfModelChange(true)
			npc:AddNewModifier(npc, nil, "modifier_hero_wearable", {})
		end
		
		
		--初始化老将天赋的表
		--
		 local tb = {0,0,0,0,0,0} --table(天赋1 天赋2 天赋3等级  未使用点数 )
		 CustomNetTables:SetTableValue("veteran_talent", tostring(id),{["tb"] = tb})
		 
		 CustomNetTables:SetTableValue("extra_item", tostring(id), {["extra_1"] = "life_stealer_empty_1",["extra_2"]="life_stealer_empty_1"})
		 self:Player_Spawned(npc)
		
		Timers:CreateTimer(10, function()
				Notifications:Bottom(id, {text ="首次游玩请点击游戏界面左上角帮助按钮", duration = 10,style={color="red", ["font-size"]="70px", border="10px solid blue"}})
			return nil
		end)

	end
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


--玩家每次出生
function player:Player_Spawned(npc)
	
	local id = npc:GetPlayerOwnerID()

	--------------------------------------- 每次重生 ---------------------------------------------------------------
	if npc:IS_TrueHero_TG() and PlayerResource:IsValidPlayer(id) then

		Timers:CreateTimer({
			useGameTime = false,
			endTime = 1,
			callback = function()
				local i = 0
				while true do
					local AB = npc:GetAbilityByIndex(i)
					if not AB then
						break
					end

					local AB_NAME = AB:GetAbilityName()
					local AB_LV = AB:GetLevel()

					-- 初始化等级为0的技能
					if AB_LV == 0 then
						if AB.Set_InitialUpgrade and type(AB.Set_InitialUpgrade) == "function" then
							local TABLE = AB:Set_InitialUpgrade()
							if TABLE then
								AB:SetLevel(TABLE.LV or 1)
								AB:UseResources(TABLE.MANA or false, false, TABLE.GOLD or false, TABLE.CD or false)
							end
						end
					end

					-- 处理天赋modifier
					if i >= 9 and AB_LV > 0 and string.find(AB_NAME, "special_bonus") then
						local modifier_name = "modifier_" .. AB_NAME
						local name = npc:GetName()
						if string.find(AB_NAME, "special_bonus_custom_value") then
							name = "custom_value_talent"
						end

						if TableContainsKey(HeroTalent, name) then
							local T = HeroTalent[name]
							if T then
								for k, v in pairs(T) do
									if k == AB_NAME then
										if not npc:HasModifier(modifier_name) then
											npc:AddNewModifier(npc, AB, modifier_name, {})
										end
										if v then
											for _, v2 in pairs(v) do
												if v2 and v2.modifier_name and not npc:HasModifier(v2.modifier_name) then
													npc:AddNewModifier(npc, AB, v2.modifier_name, v2.talent_table or {})
												end
											end
										end
									end
								end
							end
						end
					end

					i = i + 1
				end
			end
		})



		----------------------------------------------------------------------------------------------------------------

	end


end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function player:Ban_Player(hero,id) 
	if not hero:HasModifier("modifier_gnm") then
		local name=PlayerResource:GetPlayerName(id)
		hero:AddNewModifier(hero, nil, "modifier_gnm", {})
		CustomUI:DynamicHud_Create(id,"BAN_ID","file://{resources}/layout/custom_game/net.xml",nil)
		Timers:CreateTimer(7, function()
			Notifications:TopToAll({text = name.."-".."因为恶意辱骂或者干扰游戏-被封禁", duration = 5.0, style = {["font-size"] = "40px", color = "#ffffff"}})
			return nil
		end)
	end
end