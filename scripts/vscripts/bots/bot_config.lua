bot_config = class({})

local heros=
{
      "npc_dota_hero_tiny",
      "npc_dota_hero_dragon_knight",
      --"npc_dota_hero_dazzle",
    --  "npc_dota_hero_lina",
    -- "npc_dota_hero_windrunner",

}

local heros2=
{
      "npc_dota_hero_bane",
      "npc_dota_hero_jakiro",
     -- "npc_dota_hero_oracle",
     -- "npc_dota_hero_skywrath_mage",
     -- "npc_dota_hero_riki",
     -- "npc_dota_hero_crystal_maiden",
     -- "npc_dota_hero_drow_ranger",
     -- "npc_dota_hero_zuus",
     -- "npc_dota_hero_sand_king",
	--"npc_dota_hero_earthshaker",
}

local pos=
{
      "top","mid","bot"
}

function bot_config:Start()
      for a=1,#heros do
			Timers:CreateTimer(a*10, function()
				 Tutorial:AddBot(heros[a],"mid", "unfair", true)
					return nil
				end)
      end
      for a=1,#heros2 do
	  			Timers:CreateTimer(a*10, function()
				 Tutorial:AddBot(heros2[a],"mid", "unfair", false)
					return nil
				end)
           
      end
      local mode = GameRules:GetGameModeEntity()
	mode:SetBotsMaxPushTier(11)
	mode:SetBotsAlwaysPushWithHuman(true)
	mode:SetBotsInLateGame(false)
	mode:SetBotThinkingEnabled(true)
	Tutorial:StartTutorialMode()
end


function bot_config:Upgrade()
      Timers:CreateTimer("bot", {
		useGameTime = false,
		endTime = 0,
		callback = function()

                 if GameRules.AICount>5 then
                        local mode = GameRules:GetGameModeEntity()
                  	mode:SetBotsMaxPushTier(11)
                        mode:SetBotsAlwaysPushWithHuman(true)
                        mode:SetBotsInLateGame(true)
                        Timers:RemoveTimer("bot")
				return nil
			end

			GetAllHero(function(hero)
				if IsValidEntity(hero) and  PlayerResource:IsFakeClient(hero:GetPlayerOwnerID()) then
							local abilityT=GameRules.AIITEM[hero:GetName()]
							if  abilityT then
								hero:AddItemByName(abilityT[tostring(GameRules.AICount)])
								hero:AddNewModifier(hero, nil, "modifier_abandon", {})
							end
				end
			end)

			GameRules.AICount=GameRules.AICount+1

			return 180
	end})
end