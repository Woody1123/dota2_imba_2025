TIMERS_VERSION = "1.05-enhanced"
TIMERS_THINK = 0.01

if Timers == nil then
  Timers = {}
  setmetatable(Timers, {
    __call = function(t, ...)
      return t:CreateTimer(...)
    end
  })
end

function Timers:start()
  Timers = self
  self.timers = {}

  local ent = SpawnEntityFromTableSynchronous("info_target", { targetname = "timers_lua_thinker" })
  if not ent then
    print("[Timers] ❌ Failed to spawn thinker entity!")
    return
  end

  ent:SetThink("Think", self, "timers", TIMERS_THINK)
  print("[Timers] ✅ Timers started with think interval: " .. TIMERS_THINK)
end

function Timers:Think()
  local now = GameRules:GetGameTime()

  for k, v in pairs(Timers.timers) do
    local bUseGameTime = (v.useGameTime ~= false)
    local bOldStyle = (v.useOldStyle == true)

    local currentTime = bUseGameTime and GameRules:GetGameTime() or Time()
    v.endTime = v.endTime or currentTime

    if currentTime >= v.endTime then
      Timers.timers[k] = nil
      Timers.runningTimer = k
      Timers.removeSelf = false

      local status, nextCall
      if v.callback then
        if v.context then
          status, nextCall = xpcall(
                  function() return v.callback(v.context, v) end,
                  function(msg) return msg .. "\n" .. debug.traceback() .. "\n" end
          )
        else
          status, nextCall = xpcall(
                  function() return v.callback(v) end,
                  function(msg) return msg .. "\n" .. debug.traceback() .. "\n" end
          )
        end
      else
        status, nextCall = false, "[Timers] ❌ Missing callback in timer: " .. k
      end

      Timers.runningTimer = nil

      if status then
        if nextCall and not Timers.removeSelf then
          if bOldStyle then
            v.endTime = currentTime + nextCall - now
          else
            v.endTime = currentTime + nextCall
          end
          Timers.timers[k] = v
        end
      else
        Timers:HandleEventError("Timer", k, nextCall)
      end
    end
  end

  return TIMERS_THINK
end

function Timers:HandleEventError(name, event, err)
  print("[" .. tostring(name or "unknown") .. "] ⚠️ Error in '" .. tostring(event) .. "':\n" .. tostring(err))
  if not self.errorHandled then
    self.errorHandled = true
  end
end

function Timers:CreateTimer(name, args, context)
  if type(name) == "function" then
    if args ~= nil then
      context = args
    end
    args = { callback = name }
    name = DoUniqueString("timer")
  elseif type(name) == "table" then
    args = name
    name = DoUniqueString("timer")
  elseif type(name) == "number" then
    args = { endTime = name, callback = args }
    name = DoUniqueString("timer")
  end

  if not args.callback then
    print("[Timers] ⚠️ Invalid timer: " .. name)
    return
  end

  local now = args.useGameTime == false and Time() or GameRules:GetGameTime()
  if args.endTime == nil then
    args.endTime = now
  elseif not args.useOldStyle then
    args.endTime = now + args.endTime
  end

  args.context = context
  Timers.timers[name] = args

  return name
end

function Timers:RemoveTimer(name)
  Timers.timers[name] = nil
  if Timers.runningTimer == name then
    Timers.removeSelf = true
  end
end

function Timers:RemoveTimers(killAll)
  local preserved = {}
  Timers.removeSelf = true
  if not killAll then
    for k, v in pairs(Timers.timers) do
      if v.persist then
        preserved[k] = v
      end
    end
  end
  Timers.timers = preserved
end

-- Auto-start once loaded
if not Timers.timers then Timers:start() end

GameRules.Timers = Timers
