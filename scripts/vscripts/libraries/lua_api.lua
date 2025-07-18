---@class Global
---为某个队伍添加临时视野
---@param nTeamID number
---@param vLocation Vector
---@param flRadius number
---@param flDuration number
---@param bObstructedVision boolean
---@return number
function AddFOWViewer(nTeamID, vLocation, flRadius, flDuration, bObstructedVision) end

---Returns the number of degrees difference between two yaw angles返回两个偏航角之间的度差数
---@param float_1 number
---@param float_2 number
---@return number
function AngleDiff(float_1, float_2) end

---Generate a vector given a QAngles
---@param QAngle_1 QAngle
---@return Vector
function AnglesToVector(QAngle_1) end

---AppendToLogFile is deprecated. Print to the console for logging instead.
---@param string_1 string
---@param string_2 string
---@return void
function AppendToLogFile(string_1, string_2) end

---对一个单位造成伤害，输入tDamageTable: victim, attacker, damage, damage_type, damage_flags, ability
---@param tDamageTable { victim: CDOTA_BaseNPC, attacker: CDOTA_BaseNPC, damage: float, damage_type: int, damage_flags: int, ability: CDOTABaseAbility }
---@return number
function ApplyDamage(tDamageTable) end

---(vector,float) constructs a quaternion representing a rotation by angle around the specified vector axis
---@param Vector_1 Vector
---@param float_2 number
---@return Quaternion
function AxisAngleToQuaternion(Vector_1, float_2) end

---Compute the closest point on the OBB of an entity.
---@param handle_1 CBaseEntity
---@param Vector_2 Vector
---@return Vector
function CalcClosestPointOnEntityOBB(handle_1, Vector_2) end

---计算两个实体间的OBB包围盒距离
---@param handle_1 CBaseEntity
---@param handle_2 CBaseEntity
---@return number
function CalcDistanceBetweenEntityOBB(handle_1, handle_2) end

---
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@return number
function CalcDistanceToLineSegment2D(Vector_1, Vector_2, Vector_3) end

---Create all I/O events for a particular entity
---@param ehandle_1 ehandle
---@return void
function CancelEntityIOEvents(ehandle_1) end

---CenterCameraOnUnit( nPlayerId, hUnit ): Centers each players` camera on a unit.
---@param iPlayerID number
---@param hUnit CDOTA_BaseNPC
---@return void
function CenterCameraOnUnit(iPlayerID, hUnit) end

---( teamNumber )
---@param int_1 number
---@return void
function ClearTeamCustomHealthbarColor(int_1) end

---(hInflictor, hAttacker, flDamage) - Allocate a damageinfo object, used as an argument to TakeDamage(). Call DestroyDamageInfo( hInfo ) to free the object.
---@param handle_1 handle
---@param handle_2 handle
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param float_5 number
---@param int_6 number
---@return handle
function CreateDamageInfo(handle_1, handle_2, Vector_3, Vector_4, float_5, int_6) end

---Pass table - Inputs: entity, effect
---@param handle_1 handle
---@return boolean
function CreateEffect(handle_1) end

---Create an HTTP request.
---@param string_1 string
---@param string_2 string
---@return handle
function CreateHTTPRequest(string_1, string_2) end

---Create an HTTP request.
---@param string_1 string
---@param string_2 string
---@return handle
function CreateHTTPRequestScriptVM(string_1, string_2) end

---Creates a DOTA hero by its dota_npc_units.txt name and sets it as the given player`s controlled hero
---@param string_1 string
---@param handle_2 handle
---@return handle
function CreateHeroForPlayer(string_1, handle_2) end

---使用传入的数据创建属于传入单位的英雄幻象。 ( hOwner, hHeroToCopy, hModiiferKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace ) 可选参数：outgoing_damage, incoming_damage, bounty_base, bounty_growth, outgoing_damage_structure, outgoing_damage_roshan
---@param hOwner handle
---@param hHeroToCopy handle
---@param hModiiferKeys handle
---@param nNumIllusions number
---@param nPadding number
---@param bScramblePosition boolean
---@param bFindClearSpace boolean
---@return table
function CreateIllusions(hOwner, hHeroToCopy, hModiiferKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace) end

---创建一个物品
---@param sItemName string
---@param hOwner handle
---@param hOwner handle
---@return handle
function CreateItem(sItemName, hOwner, hOwner) end

---Create a physical item at a given location, can start in air (but doesn`t clear a space)
---@param Vector_1 Vector
---@param handle_2 handle
---@return handle
function CreateItemOnPositionForLaunch(Vector_1, handle_2) end

---Create a physical item at a given location
---@param Vector_1 Vector
---@param handle_2 handle
---@return handle
function CreateItemOnPositionSync(Vector_1, handle_2) end

---Create a modifier not associated with an NPC. ( hCaster, hAbility, modifierName, paramTable, vOrigin, nTeamNumber, bPhantomBlocker ) thinker实体并不会自动销毁
---@param hCaster handle
---@param hAbility handle
---@param sModifierName string
---@param tParamTable handle
---@param vPosition Vector
---@param iTeamNumber number
---@param bPhantomBlocker boolean
---@return CDOTA_BaseNPC
function CreateModifierThinker(hCaster, hAbility, sModifierName, tParamTable, vPosition, iTeamNumber, bPhantomBlocker) end

---Create a rune of the specified type (vLocation, iRuneType).
---@param Vector_1 Vector
---@param int_2 number
---@return handle
function CreateRune(Vector_1, int_2) end

---Create a scene entity to play the specified scene.
---@param string_1 string
---@return handle
function CreateSceneEntity(string_1) end

---Create a temporary tree, uses a default tree model. (vLocation, flDuration).
---@param Vector_1 Vector
---@param float_2 number
---@return handle
function CreateTempTree(Vector_1, float_2) end

---Create a temporary tree, specifying the tree model name. (vLocation, flDuration, szModelName).
---@param Vector_1 Vector
---@param float_2 number
---@param string_3 string
---@return handle
function CreateTempTreeWithModel(Vector_1, float_2, string_3) end

---CreateTrigger( vecMin, vecMax ) : Creates and returns an AABB trigger
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@return handle
function CreateTrigger(Vector_1, Vector_2, Vector_3) end

---CreateTriggerRadiusApproximate( vecOrigin, flRadius ) : Creates and returns an AABB trigger thats bigger than the radius provided
---@param Vector_1 Vector
---@param float_2 number
---@return handle
function CreateTriggerRadiusApproximate(Vector_1, float_2) end

---( iSeed ) - Creates a separate random number stream.
---@param int_1 number
---@return handle
function CreateUniformRandomStream(int_1) end

---创建一个单位
---@param sUnitName string
---@param vLocation Vector
---@param bFindClearSpace boolean
---@param hNpcOwner handle
---@param hUnitOwner handle
---@param iTeamNumber number
---@return CDOTA_BaseNPC
function CreateUnitByName(sUnitName, vLocation, bFindClearSpace, hNpcOwner, hUnitOwner, iTeamNumber) end

---Creates a DOTA unit by its dota_npc_units.txt name
---@param string_1 string
---@param Vector_2 Vector
---@param bool_3 boolean
---@param handle_4 handle
---@param handle_5 handle
---@param int_6 number
---@param handle_7 handle
---@return number
function CreateUnitByNameAsync(string_1, Vector_2, bool_3, handle_4, handle_5, int_6, handle_7) end

---Creates a DOTA unit by its dota_npc_units.txt name from a table of entity key values and a position to spawn at.
---@param handle_1 handle
---@param Vector_2 Vector
---@return handle
function CreateUnitFromTable(handle_1, Vector_2) end

---(vector,vector) cross product between two vectors
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return Vector
function CrossVectors(Vector_1, Vector_2) end

---在指定位置生成一个加载一个地形(.vmap)。bTriggerCompletion为true时，需要手动ManuallyTriggerSpawnGroupCompletion来完成地形加载。vPosition必须是64的倍数，否则创建失败。函数返回一个SpawnGroup。可以通过UnloadSpawnGroupByHandle(hSpawnGroup)卸载地图。
---@param sMapName string
---@param vPosition Vector
---@param bTriggerCompletion boolean
---@param hReady handle
---@param hComplete handle
---@param handle_6 handle
---@return number
function DOTA_SpawnMapAtPosition(sMapName, vPosition, bTriggerCompletion, hReady, hComplete, handle_6) end

---Breaks in the debugger
---@return void
function DebugBreak() end

---Creates a test unit controllable by the specified player.
---@param handle_1 handle
---@param string_2 string
---@param int_3 number
---@param bool_4 boolean
---@param handle_5 handle
---@return number
function DebugCreateUnit(handle_1, string_2, int_3, bool_4, handle_5) end

---Draw a debug overlay box (origin, mins, maxs, forward, r, g, b, a, duration )
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param float_8 number
---@return void
function DebugDrawBox(Vector_1, Vector_2, Vector_3, int_4, int_5, int_6, int_7, float_8) end

---Draw a debug forward box (cent, min, max, forward, vRgb, a, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Vector_5 Vector
---@param float_6 number
---@param float_7 number
---@return void
function DebugDrawBoxDirection(Vector_1, Vector_2, Vector_3, Vector_4, Vector_5, float_6, float_7) end

---Draw a debug circle (center, vRgb, a, rad, ztest, duration)
---@param vCenter Vector
---@param vRGB Vector
---@param iAlpha number
---@param flRadius number
---@param bZtest boolean
---@param flDuration number
---@return void
function DebugDrawCircle(vCenter, vRGB, iAlpha, flRadius, bZtest, flDuration) end

---Try to clear all the debug overlay info
---@return void
function DebugDrawClear() end

---Draw a debug overlay line (origin, target, r, g, b, ztest, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param bool_6 boolean
---@param float_7 number
---@return void
function DebugDrawLine(Vector_1, Vector_2, int_3, int_4, int_5, bool_6, float_7) end

---Draw a debug line using color vec (start, end, vRgb, a, ztest, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param bool_4 boolean
---@param float_5 number
---@return void
function DebugDrawLine_vCol(Vector_1, Vector_2, Vector_3, bool_4, float_5) end

---Draw text with a line offset (x, y, lineOffset, text, r, g, b, a, duration)
---@param float_1 number
---@param float_2 number
---@param int_3 number
---@param string_4 string
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param float_9 number
---@return void
function DebugDrawScreenTextLine(float_1, float_2, int_3, string_4, int_5, int_6, int_7, int_8, float_9) end

---Draw a debug sphere (center, vRgb, a, rad, ztest, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@param float_4 number
---@param bool_5 boolean
---@param float_6 number
---@return void
function DebugDrawSphere(Vector_1, Vector_2, float_3, float_4, bool_5, float_6) end

---Draw text in 3d (origin, text, bViewCheck, duration)
---@param Vector_1 Vector
---@param string_2 string
---@param bool_3 boolean
---@param float_4 number
---@return void
function DebugDrawText(Vector_1, string_2, bool_3, float_4) end

---Draw pretty debug text (x, y, lineOffset, text, r, g, b, a, duration, font, size, bBold)
---@param float_1 number
---@param float_2 number
---@param int_3 number
---@param string_4 string
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param float_9 number
---@param string_10 string
---@param int_11 number
---@param bool_12 boolean
---@return void
function DebugScreenTextPretty(float_1, float_2, int_3, string_4, int_5, int_6, int_7, int_8, float_9, string_10, int_11, bool_12) end

---Print out a class/array/instance/table to the console
---@param table undefined
---@param prefix undefined
---@return void
function DeepPrint(table, prefix) end

---打印表
---@param table undefined
---@param prefix undefined
---@param chaseMetaTables undefined
---@return void
--function DeepPrintTable(table, prefix, chaseMetaTables) end
function DeepPrintTable(table) end
-- -Convert a class/array/instance/table to a string
-- -@param table undefined
-- -@param prefix undefined
-- -@return void
function DeepToString(table, prefix) end

---Free a damageinfo object that was created with CreateDamageInfo().
---@param handle_1 handle
---@return void
function DestroyDamageInfo(handle_1) end

---Kick a specific player from the game
---@param int_1 number
---@param bool_2 boolean
---@return void
function DisconnectClient(int_1, bool_2) end

---(hAttacker, hTarget, hAbility, fDamage, fRadius, effectName)
---@param handle_1 handle
---@param handle_2 handle
---@param handle_3 handle
---@param float_4 number
---@param float_5 number
---@param float_6 number
---@param float_7 number
---@param string_8 string
---@return number
function DoCleaveAttack(handle_1, handle_2, handle_3, float_4, float_5, float_6, float_7, string_8) end

---#EntFire:Generate and entity i/o event
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param float_4 number
---@param handle_5 handle
---@param handle_6 handle
---@return void
function DoEntFire(string_1, string_2, string_3, float_4, handle_5, handle_6) end

---#EntFireByHandle:Generate and entity i/o event
---@param handle_1 handle
---@param string_2 string
---@param string_3 string
---@param float_4 number
---@param handle_5 handle
---@param handle_6 handle
---@return void
function DoEntFireByInstanceHandle(handle_1, string_2, string_3, float_4, handle_5, handle_6) end

---Execute a script (internal)
---@param string_1 string
---@param handle_2 handle
---@return boolean
function DoIncludeScript(string_1, handle_2) end

---#ScriptAssert:Asserts the passed in value. Prints out a message and brings up the assert dialog.
---@param bool_1 boolean
---@param string_2 string
---@return void
function DoScriptAssert(bool_1, string_2) end

---#UniqueString:Generate a string guaranteed to be unique across the life of the script VM, with an optional root string. Useful for adding data to tables when not sure what keys are already in use in that table.
---@param string_1 string
---@return string
function DoUniqueString(string_1) end

---
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return number
function DotProduct(Vector_1, Vector_2) end

---Drop a neutral item for the team of the hero at the given tier.
---@param string_1 string
---@param Vector_2 Vector
---@param handle_3 handle
---@param int_4 number
---@param bool_5 boolean
---@return handle
function DropNeutralItemAtPositionForHero(string_1, Vector_2, handle_3, int_4, bool_5) end

---A function to re-lookup a function by name every time.
---@param table table
---@param sFuncName string
---@return void
function Dynamic_Wrap(table, sFuncName) end

---Emit an announcer sound for all players.
---@param string_1 string
---@return void
function EmitAnnouncerSound(string_1) end

---Emit an announcer sound for a player.
---@param string_1 string
---@param int_2 number
---@return void
function EmitAnnouncerSoundForPlayer(string_1, int_2) end

---Emit an announcer sound for a team.
---@param string_1 string
---@param int_2 number
---@return void
function EmitAnnouncerSoundForTeam(string_1, int_2) end

---Emit an announcer sound for a team at a specific location.
---@param string_1 string
---@param int_2 number
---@param Vector_3 Vector
---@return void
function EmitAnnouncerSoundForTeamOnLocation(string_1, int_2, Vector_3) end

---Play named sound for all players
---@param string_1 string
---@return void
function EmitGlobalSound(string_1) end

---Play named sound on Entity
---@param string_1 string
---@param handle_2 handle
---@return void
function EmitSoundOn(string_1, handle_2) end

---Play named sound only on the client for the passed in player
---@param string_1 string
---@param handle_2 handle
---@return void
function EmitSoundOnClient(string_1, handle_2) end

---Emit a sound on an entity for only a specific player
---@param string_1 string
---@param handle_2 handle
---@param int_3 number
---@return void
function EmitSoundOnEntityForPlayer(string_1, handle_2, int_3) end

---Emit a sound on a location from a unit, only for players allied with that unit (vLocation, soundName, hCaster
---@param Vector_1 Vector
---@param string_2 string
---@param handle_3 handle
---@return void
function EmitSoundOnLocationForAllies(Vector_1, string_2, handle_3) end

---Emit a sound on a location for only a specific player
---@param string_1 string
---@param Vector_2 Vector
---@param int_3 number
---@return void
function EmitSoundOnLocationForPlayer(string_1, Vector_2, int_3) end

---单位在指定位置播放音效。(vLocation, soundName, hCaster).
---@param vLocation Vector
---@param sSoundName string
---@param hUnit handle
---@return void
function EmitSoundOnLocationWithCaster(vLocation, sSoundName, hUnit) end

---Turn an entity index integer to an HScript representing that entity`s script instance.
---@param int_1 number
---@return CDOTA_BaseNPC
function EntIndexToHScript(int_1) end

---Issue an order from a script table
---@param handle_1 handle
---@return void
function ExecuteOrderFromTable(handle_1) end

---Smooth curve decreasing slower as it approaches zero
---@param float_1 number
---@param float_2 number
---@param float_3 number
---@return number
function ExponentialDecay(float_1, float_2, float_3) end

---Finds a clear random position around a given target unit, using the target unit`s padded collision radius.
---@param handle_1 handle
---@param handle_2 handle
---@param int_3 number
---@return boolean
function FindClearRandomPositionAroundUnit(handle_1, handle_2, int_3) end

---把一个单位放在没有占用的位置。
---@param hUnit handle
---@param vLocation Vector
---@param bInterruptMotion boolean
---@return boolean
function FindClearSpaceForUnit(hUnit, vLocation, bInterruptMotion) end

---为给定的团队找到一个刷出点。
---@param int_1 number
---@return handle
function FindSpawnEntityForTeam(int_1) end

---找出与给定标记相交的单位。
---@param iTeamNumber number
---@param vStart Vector
---@param vEnd Vector
---@param hCacheUnit handle
---@param flRadius number
---@param iTeamFilter number
---@param iTypeFilter number
---@param iFlagFilter number
---@return table
function FindUnitsInLine(iTeamNumber, vStart, vEnd, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter) end

---查找给定半径内带有给定标志的单位。
---@param iTeamNumber number
---@param vPosition Vector
---@param hCacheUnit handle
---@param flRadius number
---@param iTeamFilter number
---@param iTypeFilter number
---@param iFlagFilter number
---@param iFindOrder number
---@param bCanGrowCache boolean
---@return CDOTA_BaseNPC[]
function FindUnitsInRadius(iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iFindOrder, bCanGrowCache) end

---Fire Entity`s Action Input w/no data
---@param ehandle_1 ehandle
---@param string_2 string
---@return void
function FireEntityIOInputNameOnly(ehandle_1, string_2) end

---Fire Entity`s Action Input with passed String - you own the memory
---@param ehandle_1 ehandle
---@param string_2 string
---@param string_3 string
---@return void
function FireEntityIOInputString(ehandle_1, string_2, string_3) end

---Fire Entity`s Action Input with passed Vector - you own the memory
---@param ehandle_1 ehandle
---@param string_2 string
---@param Vector_3 Vector
---@return void
function FireEntityIOInputVec(ehandle_1, string_2, Vector_3) end

---Fire a game event.
---@param string_1 string
---@param handle_2 handle
---@return void
function FireGameEvent(string_1, handle_2) end

---Fire a game event without broadcasting to the client.
---@param string_1 string
---@param handle_2 handle
---@return void
function FireGameEventLocal(string_1, handle_2) end

---Get the time spent on the server in the last frame
---@return number
function FrameTime() end

---Get ability data by ability name.
---@param string_1 string
---@return table
function GetAbilityKeyValuesByName(string_1) end

---Gets the ability texture name for an ability
---@param string_1 string
---@return string
function GetAbilityTextureNameForAbility(string_1) end

---Returns the currently active spawn group handle
---@return number
function GetActiveSpawnGroupHandle() end

---( version )
---@param string_1 string
---@return string
function GetDedicatedServerKey(string_1) end

---( version )
---@param string_1 string
---@return string
function GetDedicatedServerKeyV2(string_1) end

---Get the enity index for a tree id specified as the entindex_target of a DOTA_UNIT_ORDER_CAST_TARGET_TREE.
---@param unsigned_1 unsigned
---@return unknown
function GetEntityIndexForTreeId(unsigned_1) end

---Returns the engines current frame count
---@return number
function GetFrameCount() end

---
---@param Vector_1 Vector
---@param handle_2 handle
---@return number
function GetGroundHeight(Vector_1, handle_2) end

---Returns the supplied position moved to the ground. Second parameter is an NPC for measuring movement collision hull offset.
---@param Vector_1 Vector
---@param handle_2 handle
---@return Vector
function GetGroundPosition(Vector_1, handle_2) end

---Get the cost of an item by name.
---@param string_1 string
---@return number
function GetItemCost(string_1) end

---
---@param int_1 number
---@param int_2 number
---@return number
function GetItemDefOwnedCount(int_1, int_2) end

---
---@param int_1 number
---@param int_2 number
---@return number
function GetItemDefQuantity(int_1, int_2) end

---Get the local player on a listen server.
---@return handle
function GetListenServerHost() end

---( )
---@return table
function GetLobbyEventGameDetails() end

---Get the local player ID.
---@return number
function GetLocalPlayerID() end

---Get the local player team.
---@param int_1 number
---@return number
function GetLocalPlayerTeam(int_1) end

---Get the name of the map.
---@return string
function GetMapName() end

---Get the longest delay for all events attached to an output
---@param ehandle_1 ehandle
---@param string_2 string
---@return number
function GetMaxOutputDelay(ehandle_1, string_2) end

---Get Angular Velocity for VPHYS or normal object. Returns a vector of the axis of rotation, multiplied by the degrees of rotation per second.
---@param handle_1 handle
---@return Vector
function GetPhysAngularVelocity(handle_1) end

---Get Velocity for VPHYS or normal object
---@param handle_1 handle
---@return Vector
function GetPhysVelocity(handle_1) end

---Given the item tier and the team, roll for the name of a valid neutral item drop, considering previous drops and consumables.
---@param int_1 number
---@param int_2 number
---@return string
function GetPotentialNeutralItemDrop(int_1, int_2) end

---Get the current real world date
---@return string
function GetSystemDate() end

---Get the current real world time
---@return string
function GetSystemTime() end

---Get system time in milliseconds
---@return double
function GetSystemTimeMS() end

---
---@param int_1 number
---@param int_2 number
---@param int_3 number
---@param Vector_4 Vector
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@return Vector
function GetTargetAOELocation(int_1, int_2, int_3, Vector_4, int_5, int_6, int_7) end

---
---@param int_1 number
---@param int_2 number
---@param int_3 number
---@param Vector_4 Vector
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@return Vector
function GetTargetLinearLocation(int_1, int_2, int_3, Vector_4, int_5, int_6, int_7) end

---( int teamID )
---@param int_1 number
---@return number
function GetTeamHeroKills(int_1) end

---( int teamID )
---@param int_1 number
---@return string
function GetTeamName(int_1) end

---Given and entity index of a tree, get the tree id for use for use with with unit orders.
---@param int_1 number
---@return number
function GetTreeIdForEntityIndex(int_1) end

---Get unit data by ability name.
---@param string_1 string
---@return table
function GetUnitKeyValuesByName(string_1) end

---Gets the world`s maximum X position.
---@return number
function GetWorldMaxX() end

---Gets the world`s maximum Y position.
---@return number
function GetWorldMaxY() end

---Gets the world`s minimum X position.
---@return number
function GetWorldMinX() end

---Gets the world`s minimum Y position.
---@return number
function GetWorldMinY() end

---Get amount of XP required to reach the next level.
---@param int_1 number
---@return number
function GetXPNeededToReachNextLevel(int_1) end

---最大限度地提高英雄的等级，并赋予他们所有适当的能力和天赋.
---@param handle_1 handle
---@return void
function HeroMaxLevel(handle_1) end

---InitLogFile is deprecated. Print to the console for logging instead.
---@param string_1 string
---@param string_2 string
---@return void
function InitLogFile(string_1, string_2) end

---Returns true if this is lua running from the client.dll.
---@return boolean
function IsClient() end

---Returns true if this server is a dedicated server.
---@return boolean
function IsDedicatedServer() end

---Returns true if this is lua running within tools mode.
---@return boolean
function IsInToolsMode() end

---判断某个位置对某个队伍是否在战争迷雾中
---@param iTeamNumber number
---@param vLocation Vector
---@return boolean
function IsLocationVisible(iTeamNumber, vLocation) end

---Is this entity a mango tree? (hEntity).
---@param handle_1 handle
---@return boolean
function IsMangoTree(handle_1) end

---Returns true if the entity is valid and marked for deletion.
---@param handle_1 handle
---@return boolean
function IsMarkedForDeletion(handle_1) end

---Returns true if this is lua running from the server.dll.
---@return boolean
function IsServer() end

---Returns true if the unit is in a valid position in the gridnav.
---@param handle_1 handle
---@return boolean
function IsUnitInValidPosition(handle_1) end

---Checks to see if the given hScript is a valid entity
---@param handle_1 handle
---@return boolean
function IsValidEntity(handle_1) end

---(vector,vector,float) lerp between two vectors by a float factor returning new vector
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@return Vector
function LerpVectors(Vector_1, Vector_2, float_3) end

---Set the limit on the pathfinding search space.
---@param float_1 number
---@return void
function LimitPathingSearchDepth(float_1) end

---Link a lua-defined modifier with the associated class ( className, fileName, LuaModifierType).
---@param string_1 string
---@param string_2 string
---@param int_3 number
---@return void
function LinkLuaModifier(string_1, string_2, int_3) end

---Register as a listener for a game event from script.
---@param string_1 string
---@param handle_2 handle
---@param handle_3 handle
---@return number
function ListenToGameEvent(string_1, handle_2, handle_3) end

---Creates a table from the specified keyvalues text file
---@param string_1 string
---@return table
function LoadKeyValues(string_1) end

---Creates a table from the specified keyvalues string
---@param string_1 string
---@return table
function LoadKeyValuesFromString(string_1) end

---Get the current local time
---@return table
function LocalTime() end

---Checks to see if the given hScript is a valid entity
---@param string_1 string
---@return number
function MakeStringToken(string_1) end

---Triggers the creation of entities in a manually-completed spawn group
---@param int_1 number
---@return void
function ManuallyTriggerSpawnGroupCompletion(int_1) end

---Start a minimap event. (nTeamID, hEntity, nXCoord, nYCoord, nEventType, nEventDuration).
---@param int_1 number
---@param handle_2 handle
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@return void
function MinimapEvent(int_1, handle_2, int_3, int_4, int_5, int_6) end

---Print a message
---@param string_1 string
---@return void
function Msg(string_1) end

---Pause or unpause the game.
---@param bool_1 boolean
---@return void
function PauseGame(bool_1) end

---Get the current float time from the engine
---@return number
function Plat_FloatTime() end

---Get a script instance of a player by index.
---@param int_1 number
---@return handle
function PlayerInstanceFromIndex(int_1) end

---Precache an entity from KeyValues in table
---@param string_1 string
---@param handle_2 handle
---@param handle_3 handle
---@return void
function PrecacheEntityFromTable(string_1, handle_2, handle_3) end

---Precache a list of entity KeyValues tables
---@param handle_1 handle
---@param handle_2 handle
---@return void
function PrecacheEntityListFromTable(handle_1, handle_2) end

---Asynchronously precaches a DOTA item by its dota_npc_items.txt name, provides a callback when it`s finished.
---@param string_1 string
---@param handle_2 handle
---@return void
function PrecacheItemByNameAsync(string_1, handle_2) end

---Precaches a DOTA item by its dota_npc_items.txt name
---@param string_1 string
---@param handle_2 handle
---@return void
function PrecacheItemByNameSync(string_1, handle_2) end

---( modelName, context ) - Manually precache a single model
---@param string_1 string
---@param handle_2 handle
---@return void
function PrecacheModel(string_1, handle_2) end

---手动预载某个资源，model_folder|sound|soundfile|particle|particle_folder
---@param sType string
---@param sPath string
---@param context handle
---@return void
function PrecacheResource(sType, sPath, context) end

---Asynchronously precaches a DOTA unit by its dota_npc_units.txt name, provides a callback when it`s finished.
---@param string_1 string
---@param handle_2 handle
---@param int_3 number
---@return void
function PrecacheUnitByNameAsync(string_1, handle_2, int_3) end

---Precaches a DOTA unit by its dota_npc_units.txt name
---@param string_1 string
---@param handle_2 handle
---@param int_3 number
---@return void
function PrecacheUnitByNameSync(string_1, handle_2, int_3) end

---Precaches a DOTA unit from a table of entity key values.
---@param handle_1 handle
---@param handle_2 handle
---@return void
function PrecacheUnitFromTableAsync(handle_1, handle_2) end

---Precaches a DOTA unit from a table of entity key values.
---@param handle_1 handle
---@param handle_2 handle
---@return void
function PrecacheUnitFromTableSync(handle_1, handle_2) end

---Print a console message with a linked console command
---@param string_1 string
---@param string_2 string
---@return void
function PrintLinkedConsoleMessage(string_1, string_2) end

---(from angle, to angle, time) - Spherical lerp of angle from->to based on time
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@param float_3 number
---@return QAngle
function QSlerp(QAngle_1, QAngle_2, float_3) end

---Get a random float within a range
---@param float_1 number
---@param float_2 number
---@return number
function RandomFloat(float_1, float_2) end

---Get a random int within a range
---@param int_1 number
---@param int_2 number
---@return number
function RandomInt(int_1, int_2) end

---Get a random 2D vector of the given length.
---@param float_1 number
---@return Vector
function RandomVector(float_1) end

---Register a custom animation script to run when a model loads
---@param string_1 string
---@param string_2 string
---@return void
function RegisterCustomAnimationScriptForModel(string_1, string_2) end

---Create a C proxy for a script-based spawn group filter
---@param string_1 string
---@return void
function RegisterSpawnGroupFilterProxy(string_1) end

---Reloads the MotD file
---@return void
function ReloadMOTD() end

---将传入值从范围[a, b]映射到范围[c, d]。并且将返回值限制在范围[c, d]。
---@param input number
---@param a number
---@param b number
---@param c number
---@param d number
---@return number
function RemapValClamped(input, a, b, c, d) end

---Remove temporary vision for a given team ( nTeamID, nViewerID )
---@param int_1 number
---@param int_2 number
---@return void
function RemoveFOWViewer(int_1, int_2) end

---Remove the C proxy for a script-based spawn group filter
---@param string_1 string
---@return void
function RemoveSpawnGroupFilterProxy(string_1) end

---Check and fix units that have been assigned a position inside collision radius of other NPCs.
---@param Vector_1 Vector
---@param float_2 number
---@return void
function ResolveNPCPositions(Vector_1, float_2) end

---(int nPct)
---@param int_1 number
---@return boolean
function RollPercentage(int_1) end

---使用伪随机算法进行随机
---@param flChance unsigned
---@param iPseudoRandomID number
---@param hUnit handle
---@return boolean
function RollPseudoRandomPercentage(flChance, iPseudoRandomID, hUnit) end

---Rotate a QAngle by another QAngle.
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@return QAngle
function RotateOrientation(QAngle_1, QAngle_2) end

---向量绕着中心点旋转
---@param vCenter Vector
---@param QAngle QAngle
---@param vPosition Vector
---@return Vector
function RotatePosition(vCenter, QAngle, vPosition) end

---(quaternion,vector,float) rotates a quaternion by the specified angle around the specified vector axis
---@param Quaternion_1 Quaternion
---@param Vector_2 Vector
---@param float_3 number
---@return Quaternion
function RotateQuaternionByAxisAngle(Quaternion_1, Vector_2, float_3) end

---Find the delta between two QAngles.
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@return QAngle
function RotationDelta(QAngle_1, QAngle_2) end

---converts delta QAngle to an angular velocity Vector
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@return Vector
function RotationDeltaAsAngularVelocity(QAngle_1, QAngle_2) end

---Have Entity say string, and teamOnly or not
---@param handle_1 handle
---@param string_2 string
---@param bool_3 boolean
---@return void
function Say(handle_1, string_2, bool_3) end

---Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
---@param Vector_1 Vector
---@param float_2 number
---@param float_3 number
---@param float_4 number
---@param float_5 number
---@param int_6 number
---@param bool_7 boolean
---@return void
function ScreenShake(Vector_1, float_2, float_3, float_4, float_5, int_6, bool_7) end

---( DOTAPlayer sendToPlayer, int iMessageType, Entity targetEntity, int iValue, DOTAPlayer sourcePlayer ) - sendToPlayer and sourcePlayer can be nil - iMessageType is one of OVERHEAD_ALERT_*
---@param handle_1 handle
---@param int_2 number
---@param handle_3 handle
---@param int_4 number
---@param handle_5 handle
---@return void
function SendOverheadEventMessage(handle_1, int_2, handle_3, int_4, handle_5) end

---Send a string to the console as a client command
---@param string_1 string
---@return void
function SendToConsole(string_1) end

---Send a string to the console as a server command
---@param string_1 string
---@return void
function SendToServerConsole(string_1) end

---Sets an opvar value for all players
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param float_4 number
---@return void
function SetOpvarFloatAll(string_1, string_2, string_3, float_4) end

---Sets an opvar value for a single player
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param float_4 number
---@param handle_5 handle
---@return void
function SetOpvarFloatPlayer(string_1, string_2, string_3, float_4, handle_5) end

---Set Angular Velocity for VPHYS or normal object, from a vector of the axis of rotation, multiplied by the degrees of rotation per second.
---@param handle_1 handle
---@param Vector_2 Vector
---@return void
function SetPhysAngularVelocity(handle_1, Vector_2) end

---Set the current quest name.
---@param string_1 string
---@return void
function SetQuestName(string_1) end

---Set the current quest phase.
---@param int_1 number
---@return void
function SetQuestPhase(int_1) end

---Set rendering on/off for an ehandle
---@param ehandle_1 ehandle
---@param bool_2 boolean
---@return void
function SetRenderingEnabled(ehandle_1, bool_2) end

---( teamNumber, r, g, b )
---@param int_1 number
---@param int_2 number
---@param int_3 number
---@param int_4 number
---@return void
function SetTeamCustomHealthbarColor(int_1, int_2, int_3, int_4) end

---( const char *pszMessage, int nPlayerID, int nValue, float flTime ) - Supports localized strings - %s1 = PlayerName, %s2 = Value, %s3 = TeamName
---@param string_1 string
---@param int_2 number
---@param int_3 number
---@param float_4 number
---@return void
function ShowCustomHeaderMessage(string_1, int_2, int_3, float_4) end

---Show a generic popup dialog for all players.
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param string_4 string
---@param int_5 number
---@return void
function ShowGenericPopup(string_1, string_2, string_3, string_4, int_5) end

---Show a generic popup dialog to a specific player.
---@param handle_1 handle
---@param string_2 string
---@param string_3 string
---@param string_4 string
---@param string_5 string
---@param int_6 number
---@return void
function ShowGenericPopupToPlayer(handle_1, string_2, string_3, string_4, string_5, int_6) end

---Print a hud message on all clients
---@param string_1 string
---@return void
function ShowMessage(string_1) end

---(Vector vOrigin, float flRadius )
---@param Vector_1 Vector
---@param float_2 number
---@return handle
function SpawnDOTAShopTriggerRadiusApproximate(Vector_1, float_2) end

---Spawn an effigy of the target unit.
---@param string_1 string
---@param int_2 number
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param float_5 number
---@param float_6 number
---@param int_7 number
---@return handle
function SpawnEffigyOfUnitOrModel(string_1, int_2, Vector_3, Vector_4, float_5, float_6, int_7) end

---Asynchronously spawns a single entity from a table
---@param string_1 string
---@param handle_2 handle
---@param handle_3 handle
---@param handle_4 handle
---@return void
function SpawnEntityFromTableAsynchronous(string_1, handle_2, handle_3, handle_4) end

---Synchronously spawns a single entity from a table
---@param string_1 string
---@param handle_2 handle
---@return handle
function SpawnEntityFromTableSynchronous(string_1, handle_2) end

---Hierarchically spawn an entity group from a set of spawn tables.
---@param handle_1 handle
---@param bool_2 boolean
---@param handle_3 handle
---@return boolean
function SpawnEntityGroupFromTable(handle_1, bool_2, handle_3) end

---Asynchronously spawn an entity group from a list of spawn tables. A callback will be triggered when the spawning is complete
---@param handle_1 handle
---@param handle_2 handle
---@return number
function SpawnEntityListFromTableAsynchronous(handle_1, handle_2) end

---Synchronously spawn an entity group from a list of spawn tables.
---@param handle_1 handle
---@return handle
function SpawnEntityListFromTableSynchronous(handle_1) end

---Spawn a mango tree ( vPos, nTeam, flDuration, flMangoInterval, nInitialMangoes )
---@param Vector_1 Vector
---@param int_2 number
---@param float_3 number
---@param float_4 number
---@param int_5 number
---@return handle
function SpawnMangoTree(Vector_1, int_2, float_3, float_4, int_5) end

---(quaternion,quaternion,float) very basic interpolation of v0 to v1 over t on [0,1]
---@param Quaternion_1 Quaternion
---@param Quaternion_2 Quaternion
---@param float_3 number
---@return Quaternion
function SplineQuaternions(Quaternion_1, Quaternion_2, float_3) end

---(vector,vector,float) very basic interpolation of v0 to v1 over t on [0,1]
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@return Vector
function SplineVectors(Vector_1, Vector_2, float_3) end

---Start a sound event
---@param string_1 string
---@param handle_2 handle
---@return void
function StartSoundEvent(string_1, handle_2) end

---Start a sound event from position
---@param string_1 string
---@param Vector_2 Vector
---@return void
function StartSoundEventFromPosition(string_1, Vector_2) end

---Start a sound event from position with reliable delivery
---@param string_1 string
---@param Vector_2 Vector
---@return void
function StartSoundEventFromPositionReliable(string_1, Vector_2) end

---Start a sound event from position with optional delivery
---@param string_1 string
---@param Vector_2 Vector
---@return void
function StartSoundEventFromPositionUnreliable(string_1, Vector_2) end

---Start a sound event with reliable delivery
---@param string_1 string
---@param handle_2 handle
---@return void
function StartSoundEventReliable(string_1, handle_2) end

---Start a sound event with optional delivery
---@param string_1 string
---@param handle_2 handle
---@return void
function StartSoundEventUnreliable(string_1, handle_2) end

---Pass entity and effect name
---@param handle_1 handle
---@param string_2 string
---@return void
function StopEffect(handle_1, string_2) end

---Stop named sound for all players
---@param string_1 string
---@return void
function StopGlobalSound(string_1) end

---Stop listening to all game events within a specific context.
---@param handle_1 handle
---@return void
function StopListeningToAllGameEvents(handle_1) end

---Stop listening to a particular game event.
---@param int_1 number
---@return boolean
function StopListeningToGameEvent(int_1) end

---Stops a sound event with optional delivery
---@param string_1 string
---@param handle_2 handle
---@return void
function StopSoundEvent(string_1, handle_2) end

---Stop named sound on Entity
---@param string_1 string
---@param handle_2 handle
---@return void
function StopSoundOn(string_1, handle_2) end

---Get the current server time
---@return number
function Time() end

---Pass table - Inputs: start, end, ent, (optional mins, maxs) -- outputs: pos, fraction, hit, startsolid, normal
---@param handle_1 handle
---@return boolean
function TraceCollideable(handle_1) end

---Pass table - Inputs: start, end, min, max, mask, ignore  -- outputs: pos, fraction, hit, enthit, startsolid
---@param handle_1 handle
---@return boolean
function TraceHull(handle_1) end

---Pass table - Inputs: startpos, endpos, mask, ignore  -- outputs: pos, fraction, hit, enthit, startsolid
---@param handle_1 handle
---@return boolean
function TraceLine(handle_1) end

---Sends colored text to one client.
---@param int_1 number
---@param string_2 string
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@return void
function UTIL_MessageText(int_1, string_2, int_3, int_4, int_5, int_6) end

---Sends colored text to all clients.
---@param string_1 string
---@param int_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@return void
function UTIL_MessageTextAll(string_1, int_2, int_3, int_4, int_5) end

---Sends colored text to all clients. (Valid context keys: player_id, value, team_id)
---@param string_1 string
---@param int_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param handle_6 handle
---@return void
function UTIL_MessageTextAll_WithContext(string_1, int_2, int_3, int_4, int_5, handle_6) end

---Sends colored text to one client. (Valid context keys: player_id, value, team_id)
---@param int_1 number
---@param string_2 string
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param handle_7 handle
---@return void
function UTIL_MessageText_WithContext(int_1, string_2, int_3, int_4, int_5, int_6, handle_7) end

---Removes the specified entity
---@param handle_1 handle
---@return void
function UTIL_Remove(handle_1) end

---Immediately removes the specified entity
---@param handle_1 handle
---@return void
function UTIL_RemoveImmediate(handle_1) end

---Clear all message text on one client.
---@param int_1 number
---@return void
function UTIL_ResetMessageText(int_1) end

---Clear all message text from all clients.
---@return void
function UTIL_ResetMessageTextAll() end

---Check if a unit passes a set of filters. (hNPC, nTargetTeam, nTargetType, nTargetFlags, nTeam
---@param handle_1 handle
---@param int_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@return number
function UnitFilter(handle_1, int_2, int_3, int_4, int_5) end

---Unload a spawn group by name
---@param string_1 string
---@return void
function UnloadSpawnGroup(string_1) end

---Unload a spawn group by handle
---@param int_1 number
---@return void
function UnloadSpawnGroupByHandle(int_1) end

---( hEventPointData )
---@param handle_1 handle
---@return void
function UpdateEventPoints(handle_1) end

---Turn a userid integer (typically, fields named 'userid' in game events) to an HScript representing the associated player controller's script instance.
---@param int_1 number
---@return handle
function UserIDToControllerHScript(int_1) end

---
---@param Vector_1 Vector
---@return QAngle
function VectorAngles(Vector_1) end

---Get Qangles (with no roll) for a Vector.
---@param Vector_1 Vector
---@return QAngle
function VectorToAngles(Vector_1) end

---Print a warning
---@param string_1 string
---@return void
function Warning(string_1) end

---Gets the value of the given cvar, as a float.
---@param string_1 string
---@return number
function cvar_getf(string_1) end

---Sets the value of the given cvar, as a float.
---@param string_1 string
---@param float_2 number
---@return boolean
function cvar_setf(string_1, float_2) end

---Add a rule to the decision database.
---@param handle_1 handle
---@return boolean
function rr_AddDecisionRule(handle_1) end

---Commit the result of QueryBestResponse back to the given entity to play. Call with params (entity, airesponse)
---@param handle_1 handle
---@param handle_2 handle
---@return boolean
function rr_CommitAIResponse(handle_1, handle_2) end

---Retrieve a table of all available expresser targets, in the form { name : handle, name: handle }.
---@return handle
function rr_GetResponseTargets() end

---Params: (entity, query) : tests `query` against entity`s response system and returns the best response found (or null if none found).
---@param handle_1 handle
---@param handle_2 handle
---@param handle_3 handle
---@return boolean
function rr_QueryBestResponse(handle_1, handle_2, handle_3) end

---@class CBaseAnimating : CBaseModelEntity
---Returns the duration in seconds of the active sequence.
---@return number
function CBaseAnimating:ActiveSequenceDuration() end

---Get the cycle of the animation.
---@return number
function CBaseAnimating:GetCycle() end

---Get the value of the given animGraph parameter
---@param pszParam string
---@return table
function CBaseAnimating:GetGraphParameter(pszParam) end

---Returns the name of the active sequence.
---@return string
function CBaseAnimating:GetSequence() end

---Ask whether the main sequence is done playing.
---@return boolean
function CBaseAnimating:IsSequenceFinished() end

---Sets the active sequence by name, resetting the current cycle.
---@param pSequenceName string
---@return void
function CBaseAnimating:ResetSequence(pSequenceName) end

---Returns the duration in seconds of the given sequence name.
---@param pSequenceName string
---@return number
function CBaseAnimating:SequenceDuration(pSequenceName) end

---Set the cycle of the animation.
---@param flCycle number
---@return void
function CBaseAnimating:SetCycle(flCycle) end

---Pass the desired look target in world space to the graph
---@param vValue Vector
---@return void
function CBaseAnimating:SetGraphLookTarget(vValue) end

---Set the specific param value, type is inferred from the type in script
---@param pszParam string
---@param svArg table
---@return void
function CBaseAnimating:SetGraphParameter(pszParam, svArg) end

---Set the specific param on or off
---@param szName string
---@param bValue boolean
---@return void
function CBaseAnimating:SetGraphParameterBool(szName, bValue) end

---Pass the enum (int) value to the specified param
---@param szName string
---@param nValue number
---@return void
function CBaseAnimating:SetGraphParameterEnum(szName, nValue) end

---Pass the float value to the specified param
---@param szName string
---@param flValue number
---@return void
function CBaseAnimating:SetGraphParameterFloat(szName, flValue) end

---Pass the int value to the specified param
---@param szName string
---@param nValue number
---@return void
function CBaseAnimating:SetGraphParameterInt(szName, nValue) end

---Pass the vector value to the specified param in the graph
---@param szName string
---@param vValue Vector
---@return void
function CBaseAnimating:SetGraphParameterVector(szName, vValue) end

---Set the specified pose parameter to the specified value.
---@param szName string
---@param fValue number
---@return number
function CBaseAnimating:SetPoseParameter(szName, fValue) end

---Sets the active sequence by name, keeping the current cycle.
---@param pSequenceName string
---@return void
function CBaseAnimating:SetSequence(pSequenceName) end

---Stop the current animation by setting playback rate to 0.0.
---@return void
function CBaseAnimating:StopAnimation() end

---@class CBaseEntity : CEntityInstance
---AddEffects( int ): Adds the render effect flag.
---@param nFlags number
---@return void
function CBaseEntity:AddEffects(nFlags) end

---Apply a Velocity Impulse
---@param vecImpulse Vector
---@return void
function CBaseEntity:ApplyAbsVelocityImpulse(vecImpulse) end

---Apply an Ang Velocity Impulse
---@param angImpulse Vector
---@return void
function CBaseEntity:ApplyLocalAngularVelocityImpulse(angImpulse) end

---Get float value for an entity attribute.
---@param pName string
---@param flDefault number
---@return number
function CBaseEntity:Attribute_GetFloatValue(pName, flDefault) end

---Get int value for an entity attribute.
---@param pName string
---@param nDefault number
---@return number
function CBaseEntity:Attribute_GetIntValue(pName, nDefault) end

---Set float value for an entity attribute.
---@param pName string
---@param flValue number
---@return void
function CBaseEntity:Attribute_SetFloatValue(pName, flValue) end

---Set int value for an entity attribute.
---@param pName string
---@param nValue number
---@return void
function CBaseEntity:Attribute_SetIntValue(pName, nValue) end

---Delete an entity attribute.
---@param pName string
---@return void
function CBaseEntity:DeleteAttribute(pName) end

---Plays a sound from this entity.
---@param soundname string
---@return void
function CBaseEntity:EmitSound(soundname) end

---Plays/modifies a sound from this entity. changes sound if nPitch and/or flVol or flSoundTime is > 0.
---@param soundname string
---@param nPitch number
---@param flVolume number
---@param flDelay number
---@return void
function CBaseEntity:EmitSoundParams(soundname, nPitch, flVolume, flDelay) end

---Get the qangles that this entity is looking at.
---@return QAngle
function CBaseEntity:EyeAngles() end

---Get vector to eye position - absolute coords.
---@return Vector
function CBaseEntity:EyePosition() end

---
---@return handle
function CBaseEntity:FirstMoveChild() end

---hEntity to follow, bool bBoneMerge
---@param hEnt handle
---@param bBoneMerge boolean
---@return void
function CBaseEntity:FollowEntity(hEnt, bBoneMerge) end

---Returns a table containing the criteria that would be used for response queries on this entity. This is the same as the table that is passed to response rule script function callbacks.
---@param hResult handle
---@return void
function CBaseEntity:GatherCriteria(hResult) end

---获取单位绝对位置坐标
---@return Vector
function CBaseEntity:GetAbsOrigin() end

---
---@return number
function CBaseEntity:GetAbsScale() end

---
---@return QAngle
function CBaseEntity:GetAngles() end

---Get entity pitch, yaw, roll as a vector.
---@return Vector
function CBaseEntity:GetAnglesAsVector() end

---Get the local angular velocity - returns a vector of pitch,yaw,roll
---@return Vector
function CBaseEntity:GetAngularVelocity() end

---Get Base? velocity.
---@return Vector
function CBaseEntity:GetBaseVelocity() end

---Get a vector containing max bounds, centered on object.
---@return Vector
function CBaseEntity:GetBoundingMaxs() end

---Get a vector containing min bounds, centered on object.
---@return Vector
function CBaseEntity:GetBoundingMins() end

---Get a table containing the `Mins` & `Maxs` vector bounds, centered on object.
---@return table
function CBaseEntity:GetBounds() end

---Get vector to center of object - absolute coords
---@return Vector
function CBaseEntity:GetCenter() end

---Get the entities parented to this entity.
---@return handle
function CBaseEntity:GetChildren() end

---GetContext( name ): looks up a context and returns it if available. May return string, float, or null (if the context isn`t found).
---@param name string
---@return table
function CBaseEntity:GetContext(name) end

---得到实体的前向向量。
---@return Vector
function CBaseEntity:GetForwardVector() end

---Get the health of this entity.
---@return number
function CBaseEntity:GetHealth() end

---Get entity local pitch, yaw, roll as a QAngle
---@return QAngle
function CBaseEntity:GetLocalAngles() end

---Maybe local angvel
---@return QAngle
function CBaseEntity:GetLocalAngularVelocity() end

---Get entity local origin as a Vector
---@return Vector
function CBaseEntity:GetLocalOrigin() end

---
---@return number
function CBaseEntity:GetLocalScale() end

---Get Entity relative velocity.
---@return Vector
function CBaseEntity:GetLocalVelocity() end

---Get the mass of an entity. (returns 0 if it doesn`t have a physics object)
---@return number
function CBaseEntity:GetMass() end

---Get the maximum health of this entity.
---@return number
function CBaseEntity:GetMaxHealth() end

---Returns the name of the model.
---@return string
function CBaseEntity:GetModelName() end

---If in hierarchy, retrieves the entity`s parent.
---@return handle
function CBaseEntity:GetMoveParent() end

---
---@return Vector
function CBaseEntity:GetOrigin() end

---Gets this entity`s owner
---@return handle
function CBaseEntity:GetOwner() end

---Get the owner entity, if there is one
---@return handle
function CBaseEntity:GetOwnerEntity() end

---Get the right vector of the entity.
---@return Vector
function CBaseEntity:GetRightVector() end

---If in hierarchy, walks up the hierarchy to find the root parent.
---@return handle
function CBaseEntity:GetRootMoveParent() end

---Returns float duration of the sound. Takes soundname and optional actormodelname.
---@param soundname string
---@param actormodel string
---@return number
function CBaseEntity:GetSoundDuration(soundname, actormodel) end

---Returns the spawn group handle of this entity
---@return number
function CBaseEntity:GetSpawnGroupHandle() end

---Get the team number of this entity.
---@return number
function CBaseEntity:GetTeam() end

---Get the team number of this entity.
---@return number
function CBaseEntity:GetTeamNumber() end

---Get the up vector of the entity.
---@return Vector
function CBaseEntity:GetUpVector() end

---
---@return Vector
function CBaseEntity:GetVelocity() end

---See if an entity has a particular attribute.
---@param pName string
---@return boolean
function CBaseEntity:HasAttribute(pName) end

---Is this entity alive?
---@return boolean
function CBaseEntity:IsAlive() end

---Is this entity a Dota NPC?
---@return boolean
function CBaseEntity:IsDOTANPC() end

---Is this entity an CAI_BaseNPC?
---@return boolean
function CBaseEntity:IsNPC() end

---Is this entity a player?
---@return boolean
function CBaseEntity:IsPlayer() end

---Is this entity a player controller?
---@return boolean
function CBaseEntity:IsPlayerController() end

---Is this entity a player pawn?
---@return boolean
function CBaseEntity:IsPlayerPawn() end

---
---@return void
function CBaseEntity:Kill() end

---
---@return handle
function CBaseEntity:NextMovePeer() end

---Takes duration, value for a temporary override.
---@param duration number
---@param friction number
---@return void
function CBaseEntity:OverrideFriction(duration, friction) end

---Precache a sound for later playing.
---@param soundname string
---@return void
function CBaseEntity:PrecacheScriptSound(soundname) end

---RemoveEffects( int ): Removes the render effect flag.
---@param nFlags number
---@return void
function CBaseEntity:RemoveEffects(nFlags) end

---Set entity pitch, yaw, roll by component.
---@param fPitch number
---@param fYaw number
---@param fRoll number
---@return void
function CBaseEntity:SetAbsAngles(fPitch, fYaw, fRoll) end

---
---@param origin Vector
---@return void
function CBaseEntity:SetAbsOrigin(origin) end

---
---@param flScale number
---@return void
function CBaseEntity:SetAbsScale(flScale) end

---Set entity pitch, yaw, roll by component.
---@param fPitch number
---@param fYaw number
---@param fRoll number
---@return void
function CBaseEntity:SetAngles(fPitch, fYaw, fRoll) end

---Set the local angular velocity - takes float pitch,yaw,roll velocities
---@param pitchVel number
---@param yawVel number
---@param rollVel number
---@return void
function CBaseEntity:SetAngularVelocity(pitchVel, yawVel, rollVel) end

---Set the position of the constraint.
---@param vPos Vector
---@return void
function CBaseEntity:SetConstraint(vPos) end

---SetContext( name , value, duration ): store any key/value pair in this entity`s dialog contexts. Value must be a string. Will last for duration (set 0 to mean `forever`).
---@param pName string
---@param pValue string
---@param duration number
---@return void
function CBaseEntity:SetContext(pName, pValue, duration) end

---SetContextNum( name , value, duration ): store any key/value pair in this entity`s dialog contexts. Value must be a number (int or float). Will last for duration (set 0 to mean `forever`).
---@param pName string
---@param fValue number
---@param duration number
---@return void
function CBaseEntity:SetContextNum(pName, fValue, duration) end

---Set a think function on this entity.
---@param pszContextName string
---@param hThinkFunc handle
---@param flInterval number
---@return void
function CBaseEntity:SetContextThink(pszContextName, hThinkFunc, flInterval) end

---Set the name of an entity.
---@param pName string
---@return void
function CBaseEntity:SetEntityName(pName) end

---Set the orientation of the entity to have this forward vector.
---@param v Vector
---@return void
function CBaseEntity:SetForwardVector(v) end

---Set PLAYER friction, ignored for objects.
---@param flFriction number
---@return void
function CBaseEntity:SetFriction(flFriction) end

---Set PLAYER gravity, ignored for objects.
---@param flGravity number
---@return void
function CBaseEntity:SetGravity(flGravity) end

---Set the health of this entity.
---@param nHealth number
---@return void
function CBaseEntity:SetHealth(nHealth) end

---Set entity local pitch, yaw, roll by component
---@param fPitch number
---@param fYaw number
---@param fRoll number
---@return void
function CBaseEntity:SetLocalAngles(fPitch, fYaw, fRoll) end

---Set entity local origin from a Vector
---@param origin Vector
---@return void
function CBaseEntity:SetLocalOrigin(origin) end

---
---@param flScale number
---@return void
function CBaseEntity:SetLocalScale(flScale) end

---Set the mass of an entity. (does nothing if it doesn`t have a physics object)
---@param flMass number
---@return void
function CBaseEntity:SetMass(flMass) end

---Set the maximum health of this entity.
---@param amt number
---@return void
function CBaseEntity:SetMaxHealth(amt) end

---
---@param v Vector
---@return void
function CBaseEntity:SetOrigin(v) end

---Sets this entity`s owner
---@param pOwner handle
---@return void
function CBaseEntity:SetOwner(pOwner) end

---Set the parent for this entity.
---@param hParent handle
---@param pAttachmentname string
---@return void
function CBaseEntity:SetParent(hParent, pAttachmentname) end

---
---@param iTeamNum number
---@return void
function CBaseEntity:SetTeam(iTeamNum) end

---
---@param vecVelocity Vector
---@return void
function CBaseEntity:SetVelocity(vecVelocity) end

---Stops a named sound playing from this entity.
---@param soundname string
---@return void
function CBaseEntity:StopSound(soundname) end

---Apply damage to this entity. Use CreateDamageInfo() to create a damageinfo object.
---@param hInfo handle
---@return number
function CBaseEntity:TakeDamage(hInfo) end

---Returns the input Vector transformed from entity to world space
---@param vPoint Vector
---@return Vector
function CBaseEntity:TransformPointEntityToWorld(vPoint) end

---Returns the input Vector transformed from world to entity space
---@param vPoint Vector
---@return Vector
function CBaseEntity:TransformPointWorldToEntity(vPoint) end

---Fires off this entity`s OnTrigger responses.
---@return void
function CBaseEntity:Trigger() end

---Validates the private script scope and creates it if one doesn`t exist.
---@return void
function CBaseEntity:ValidatePrivateScriptScope() end

---@class CBaseFlex : CBaseAnimating
---Returns the instance of the oldest active scene entity (if any).
---@return handle
function CBaseFlex:GetCurrentScene() end

---Returns the instance of the scene entity at the specified index.
---@param index number
---@return handle
function CBaseFlex:GetSceneByIndex(index) end

---( vcd file, delay ) - play specified vcd file
---@param pszScene string
---@param flDelay number
---@return number
function CBaseFlex:ScriptPlayScene(pszScene, flDelay) end

---@class CBaseModelEntity : CBaseEntity
---Get the attachment id`s angles as a p,y,r vector.
---@param iAttachment number
---@return Vector
function CBaseModelEntity:GetAttachmentAngles(iAttachment) end

---Get the attachment id`s forward vector.
---@param iAttachment number
---@return Vector
function CBaseModelEntity:GetAttachmentForward(iAttachment) end

---Get the attachment id`s origin vector.
---@param iAttachment number
---@return Vector
function CBaseModelEntity:GetAttachmentOrigin(iAttachment) end

---GetMaterialGroupHash(): Get the material group hash of this entity.
---@return unsigned
function CBaseModelEntity:GetMaterialGroupHash() end

---GetMaterialGroupMask(): Get the mesh group mask of this entity.
---@return uint64
function CBaseModelEntity:GetMaterialGroupMask() end

---Get scale of entity`s model.
---@return number
function CBaseModelEntity:GetModelScale() end

---GetRenderAlpha(): Get the alpha modulation of this entity.
---@return number
function CBaseModelEntity:GetRenderAlpha() end

---GetRenderColor(): Get the render color of the entity.
---@return Vector
function CBaseModelEntity:GetRenderColor() end

---Get the named attachment id.
---@param pAttachmentName string
---@return number
function CBaseModelEntity:ScriptLookupAttachment(pAttachmentName) end

---Sets a bodygroup.
---@param iGroup number
---@param iValue number
---@return void
function CBaseModelEntity:SetBodygroup(iGroup, iValue) end

---Sets a bodygroup by name.
---@param pName string
---@param iValue number
---@return void
function CBaseModelEntity:SetBodygroupByName(pName, iValue) end

---SetLightGroup( string ): Sets the light group of the entity.
---@param pLightGroup string
---@return void
function CBaseModelEntity:SetLightGroup(pLightGroup) end

---SetMaterialGroup( string ): Set the material group of this entity.
---@param pMaterialGroup string
---@return void
function CBaseModelEntity:SetMaterialGroup(pMaterialGroup) end

---SetMaterialGroupHash( uint32 ): Set the material group hash of this entity.
---@param nHash unsigned
---@return void
function CBaseModelEntity:SetMaterialGroupHash(nHash) end

---SetMaterialGroupMask( uint64 ): Set the mesh group mask of this entity.
---@param nMeshGroupMask uint64
---@return void
function CBaseModelEntity:SetMaterialGroupMask(nMeshGroupMask) end

---
---@param pModelName string
---@return void
function CBaseModelEntity:SetModel(pModelName) end

---Set scale of entity`s model.
---@param flScale number
---@return void
function CBaseModelEntity:SetModelScale(flScale) end

---SetRenderAlpha( int ): Set the alpha modulation of this entity.
---@param nAlpha number
---@return void
function CBaseModelEntity:SetRenderAlpha(nAlpha) end

---SetRenderColor( r, g, b ): Sets the render color of the entity.
---@param r number
---@param g number
---@param b number
---@return void
function CBaseModelEntity:SetRenderColor(r, g, b) end

---SetRenderMode( int ): Sets the render mode of the entity.
---@param nMode number
---@return void
function CBaseModelEntity:SetRenderMode(nMode) end

---SetSingleMeshGroup( string ): Set a single mesh group for this entity.
---@param pMeshGroupName string
---@return void
function CBaseModelEntity:SetSingleMeshGroup(pMeshGroupName) end

---
---@param mins Vector
---@param maxs Vector
---@return void
function CBaseModelEntity:SetSize(mins, maxs) end

---Set skin (int).
---@param iSkin number
---@return void
function CBaseModelEntity:SetSkin(iSkin) end

---@class CBaseTrigger : CBaseEntity
---Disable`s the trigger
---@return void
function CBaseTrigger:Disable() end

---Enable the trigger
---@return void
function CBaseTrigger:Enable() end

---Checks whether the passed entity is touching the trigger.
---@param hEnt handle
---@return boolean
function CBaseTrigger:IsTouching(hEnt) end

---@class CBodyComponent
---Apply an impulse at a worldspace position to the physics
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return void
function CBodyComponent:AddImpulseAtPosition(Vector_1, Vector_2) end

---Add linear and angular velocity to the physics object
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return void
function CBodyComponent:AddVelocity(Vector_1, Vector_2) end

---Detach from its parent
---@return void
function CBodyComponent:DetachFromParent() end

---Returns the active sequence
---@return unknown
function CBodyComponent:GetSequence() end

---Is attached to parent
---@return boolean
function CBodyComponent:IsAttachedToParent() end

---Returns a sequence id given a name
---@param string_1 string
---@return unknown
function CBodyComponent:LookupSequence(string_1) end

---Returns the duration in seconds of the specified sequence
---@param string_1 string
---@return number
function CBodyComponent:SequenceDuration(string_1) end

---
---@param Vector_1 Vector
---@return void
function CBodyComponent:SetAngularVelocity(Vector_1) end

---Pass string for the animation to play on this model
---@param string_1 string
---@return void
function CBodyComponent:SetAnimation(string_1) end

---
---@param utlstringtoken_1 utlstringtoken
---@return void
function CBodyComponent:SetMaterialGroup(utlstringtoken_1) end

---
---@param Vector_1 Vector
---@return void
function CBodyComponent:SetVelocity(Vector_1) end

---@class CCustomGameEventManager
---@type CCustomGameEventManager
CustomGameEventManager = CCustomGameEventManager
---( string EventName, func CallbackFunction ) - Register a callback to be called when a particular custom event arrives. Returns a listener ID that can be used to unregister later.
---@param string_1 string
---@param handle_2 handle
---@return number
function CCustomGameEventManager:RegisterListener(string_1, handle_2) end

---( string EventName, table EventData )
---@param string_1 string
---@param handle_2 handle
---@return void
function CCustomGameEventManager:Send_ServerToAllClients(string_1, handle_2) end

---( Entity Player, string EventName, table EventData )
---@param handle_1 handle
---@param string_2 string
---@param handle_3 handle
---@return void
function CCustomGameEventManager:Send_ServerToPlayer(handle_1, string_2, handle_3) end

---( int TeamNumber, string EventName, table EventData )
---@param int_1 number
---@param string_2 string
---@param handle_3 handle
---@return void
function CCustomGameEventManager:Send_ServerToTeam(int_1, string_2, handle_3) end

---( int ListnerID ) - Unregister a specific listener
---@param int_1 number
---@return void
function CCustomGameEventManager:UnregisterListener(int_1) end

---@class CCustomNetTableManager
---@type CCustomNetTableManager
CustomNetTables = CCustomNetTableManager
---( string TableName, string KeyName )
---@param string_1 string
---@param string_2 string
---@return table
function CCustomNetTableManager:GetTableValue(string_1, string_2) end

---( string TableName, string KeyName, script_table Value )
---@param string_1 string
---@param string_2 string
---@param handle_3 handle
---@return boolean
function CCustomNetTableManager:SetTableValue(string_1, string_2, handle_3) end

---@class CDOTABaseAbility : CBaseEntity
---
---@return unknown
function CDOTABaseAbility:CanAbilityBeUpgraded() end

---
---@return boolean
function CDOTABaseAbility:CastAbility() end

---
---@return boolean
function CDOTABaseAbility:ContinueCasting() end

---
---@param vLocation Vector
---@param fRadius number
---@param fDuration number
---@return void
function CDOTABaseAbility:CreateVisibilityNode(vLocation, fRadius, fDuration) end

---
---@return void
function CDOTABaseAbility:DecrementModifierRefCount() end

---
---@param bInterrupted boolean
---@return void
function CDOTABaseAbility:EndChannel(bInterrupted) end

---Clear the cooldown remaining on this ability.
---@return void
function CDOTABaseAbility:EndCooldown() end

---
---@return number
function CDOTABaseAbility:GetAOERadius() end

---
---@return number
function CDOTABaseAbility:GetAbilityDamage() end

---
---@return number
function CDOTABaseAbility:GetAbilityDamageType() end

---
---@return number
function CDOTABaseAbility:GetAbilityIndex() end

---Gets the key values definition for this ability.
---@return table
function CDOTABaseAbility:GetAbilityKeyValues() end

---Returns the name of this ability.
---@return string
function CDOTABaseAbility:GetAbilityName() end

---
---@return number
function CDOTABaseAbility:GetAbilityTargetFlags() end

---
---@return number
function CDOTABaseAbility:GetAbilityTargetTeam() end

---
---@return number
function CDOTABaseAbility:GetAbilityTargetType() end

---
---@return number
function CDOTABaseAbility:GetAbilityType() end

---
---@return boolean
function CDOTABaseAbility:GetAnimationIgnoresModelScale() end

---
---@return string
function CDOTABaseAbility:GetAssociatedPrimaryAbilities() end

---
---@return string
function CDOTABaseAbility:GetAssociatedSecondaryAbilities() end

---
---@return boolean
function CDOTABaseAbility:GetAutoCastState() end

---
---@return number
function CDOTABaseAbility:GetBackswingTime() end

---
---@return number
function CDOTABaseAbility:GetBehavior() end

---Get ability behavior flags as an int for compatability.
---@return number
function CDOTABaseAbility:GetBehaviorInt() end

---
---@return number
function CDOTABaseAbility:GetCastPoint() end

---
---@return number
function CDOTABaseAbility:GetCastPointModifier() end

---Gets the cast range of the ability.
---@param vLocation Vector
---@param hTarget handle
---@return number
function CDOTABaseAbility:GetCastRange(vLocation, hTarget) end

---
---@return CDOTA_BaseNPC
function CDOTABaseAbility:GetCaster() end

---
---@return number
function CDOTABaseAbility:GetChannelStartTime() end

---
---@return number
function CDOTABaseAbility:GetChannelTime() end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetChannelledManaCostPerSecond(iLevel) end

---
---@return handle
function CDOTABaseAbility:GetCloneSource() end

---
---@return number
function CDOTABaseAbility:GetConceptRecipientType() end

---Get the cooldown duration for this ability at a given level, not the amount of cooldown actually left.
---@param iLevel number
---@return number
function CDOTABaseAbility:GetCooldown(iLevel) end

---
---@return number
function CDOTABaseAbility:GetCooldownTime() end

---
---@return number
function CDOTABaseAbility:GetCooldownTimeRemaining() end

---
---@return number
function CDOTABaseAbility:GetCurrentAbilityCharges() end

---
---@return Vector
function CDOTABaseAbility:GetCursorPosition() end

---
---@return CDOTA_BaseNPC
function CDOTABaseAbility:GetCursorTarget() end

---
---@return boolean
function CDOTABaseAbility:GetCursorTargetingNothing() end

---
---@return number
function CDOTABaseAbility:GetDuration() end

---Gets the cast range of the ability, taking modifiers into account.
---@param vLocation Vector
---@param hTarget handle
---@return number
function CDOTABaseAbility:GetEffectiveCastRange(vLocation, hTarget) end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetEffectiveCooldown(iLevel) end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetGoldCost(iLevel) end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetGoldCostForUpgrade(iLevel) end

---
---@return number
function CDOTABaseAbility:GetHeroLevelRequiredToUpgrade() end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetInitialAbilityCharges(iLevel) end

---返回此技能被动给予的修饰器的名称
---@return string
function CDOTABaseAbility:GetIntrinsicModifierName() end

---Get the current level of the ability.
---@return number
function CDOTABaseAbility:GetLevel() end

---
---@param szName string
---@param nLevel number
---@return table
function CDOTABaseAbility:GetLevelSpecialValueFor(szName, nLevel) end

---
---@param szName string
---@param nLevel number
---@return table
function CDOTABaseAbility:GetLevelSpecialValueNoOverride(szName, nLevel) end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetManaCost(iLevel) end

---
---@param iLevel number
---@return number
function CDOTABaseAbility:GetMaxAbilityCharges(iLevel) end

---
---@return number
function CDOTABaseAbility:GetMaxLevel() end

---
---@return number
function CDOTABaseAbility:GetModifierValue() end

---
---@return number
function CDOTABaseAbility:GetModifierValueBonus() end

---
---@return number
function CDOTABaseAbility:GetPlaybackRateOverride() end

---
---@return string
function CDOTABaseAbility:GetSharedCooldownName() end

---从该技能的当前等级的特殊值获取值。
---@param szName string
---@return table
function CDOTABaseAbility:GetSpecialValueFor(szName) end

---
---@return string
function CDOTABaseAbility:GetStolenActivityModifier() end

---
---@return boolean
function CDOTABaseAbility:GetToggleState() end

---
---@return boolean
function CDOTABaseAbility:GetUpgradeRecommended() end

---
---@param flXP number
---@return boolean
function CDOTABaseAbility:HeroXPChange(flXP) end

---
---@return void
function CDOTABaseAbility:IncrementModifierRefCount() end

---
---@return boolean
function CDOTABaseAbility:IsActivated() end

---
---@return boolean
function CDOTABaseAbility:IsAttributeBonus() end

---Returns whether the ability is currently channeling.
---@return boolean
function CDOTABaseAbility:IsChanneling() end

---
---@return boolean
function CDOTABaseAbility:IsCooldownReady() end

---用来判断是否是装饰性技能。比如官方活动里技能栏上方的击掌，打鼓，丢气球这些。
---@param hEntity handle
---@return boolean
function CDOTABaseAbility:IsCosmetic(hEntity) end

---Returns whether the ability can be cast.
---@return boolean
function CDOTABaseAbility:IsFullyCastable() end

---
---@return boolean
function CDOTABaseAbility:IsHidden() end

---
---@return boolean
function CDOTABaseAbility:IsHiddenAsSecondaryAbility() end

---
---@return boolean
function CDOTABaseAbility:IsHiddenWhenStolen() end

---Returns whether the ability is currently casting.
---@return boolean
function CDOTABaseAbility:IsInAbilityPhase() end

---
---@return boolean
function CDOTABaseAbility:IsItem() end

---
---@param nIssuerPlayerID number
---@return boolean
function CDOTABaseAbility:IsOwnersGoldEnough(nIssuerPlayerID) end

---
---@return boolean
function CDOTABaseAbility:IsOwnersGoldEnoughForUpgrade() end

---
---@return boolean
function CDOTABaseAbility:IsOwnersManaEnough() end

---
---@return boolean
function CDOTABaseAbility:IsPassive() end

---
---@return boolean
function CDOTABaseAbility:IsRefreshable() end

---
---@return boolean
function CDOTABaseAbility:IsSharedWithTeammates() end

---
---@return boolean
function CDOTABaseAbility:IsStealable() end

---
---@return boolean
function CDOTABaseAbility:IsStolen() end

---
---@return boolean
function CDOTABaseAbility:IsToggle() end

---
---@return boolean
function CDOTABaseAbility:IsTrained() end

---Mark the ability button for this ability as needing a refresh.
---@return void
function CDOTABaseAbility:MarkAbilityButtonDirty() end

---
---@return number
function CDOTABaseAbility:NumModifiersUsingAbility() end

---
---@return void
function CDOTABaseAbility:OnAbilityPhaseInterrupted() end

---
---@return boolean
function CDOTABaseAbility:OnAbilityPhaseStart() end

---
---@param nPlayerID number
---@param bCtrlHeld boolean
---@return void
function CDOTABaseAbility:OnAbilityPinged(nPlayerID, bCtrlHeld) end

---
---@param bInterrupted boolean
---@return void
function CDOTABaseAbility:OnChannelFinish(bInterrupted) end

---
---@param flInterval number
---@return void
function CDOTABaseAbility:OnChannelThink(flInterval) end

---
---@return void
function CDOTABaseAbility:OnHeroCalculateStatBonus() end

---
---@return void
function CDOTABaseAbility:OnHeroLevelUp() end

---
---@return void
function CDOTABaseAbility:OnOwnerDied() end

---
---@return void
function CDOTABaseAbility:OnOwnerSpawned() end

---
---@return void
function CDOTABaseAbility:OnSpellStart() end

---
---@return void
function CDOTABaseAbility:OnToggle() end

---
---@return void
function CDOTABaseAbility:OnUpgrade() end

---
---@return void
function CDOTABaseAbility:PayGoldCost() end

---
---@return void
function CDOTABaseAbility:PayGoldCostForUpgrade() end

---
---@return void
function CDOTABaseAbility:PayManaCost() end

---
---@return boolean
function CDOTABaseAbility:PlaysDefaultAnimWhenStolen() end

---
---@return boolean
function CDOTABaseAbility:ProcsMagicStick() end

---
---@return boolean
function CDOTABaseAbility:RefCountsModifiers() end

---
---@return void
function CDOTABaseAbility:RefreshCharges() end

---
---@return unknown
function CDOTABaseAbility:RefreshIntrinsicModifier() end

---
---@return void
function CDOTABaseAbility:RefundManaCost() end

---
---@return boolean
function CDOTABaseAbility:RequiresFacing() end

---
---@return boolean
function CDOTABaseAbility:ResetToggleOnRespawn() end

---
---@param iIndex number
---@return void
function CDOTABaseAbility:SetAbilityIndex(iIndex) end

---
---@param bActivated boolean
---@return void
function CDOTABaseAbility:SetActivated(bActivated) end

---
---@param bChanneling boolean
---@return void
function CDOTABaseAbility:SetChanneling(bChanneling) end

---
---@param nCharges number
---@return void
function CDOTABaseAbility:SetCurrentAbilityCharges(nCharges) end

---
---@param bFrozenCooldown boolean
---@return void
function CDOTABaseAbility:SetFrozenCooldown(bFrozenCooldown) end

---
---@param bHidden boolean
---@return void
function CDOTABaseAbility:SetHidden(bHidden) end

---
---@param bInAbilityPhase boolean
---@return void
function CDOTABaseAbility:SetInAbilityPhase(bInAbilityPhase) end

---Sets the level of this ability.
---@param iLevel number
---@return void
function CDOTABaseAbility:SetLevel(iLevel) end

---
---@param flCastPoint number
---@return void
function CDOTABaseAbility:SetOverrideCastPoint(flCastPoint) end

---
---@param bRefCounts boolean
---@return void
function CDOTABaseAbility:SetRefCountsModifiers(bRefCounts) end

---
---@param bStealable boolean
---@return void
function CDOTABaseAbility:SetStealable(bStealable) end

---
---@param bStolen boolean
---@return void
function CDOTABaseAbility:SetStolen(bStolen) end

---
---@param bUpgradeRecommended boolean
---@return void
function CDOTABaseAbility:SetUpgradeRecommended(bUpgradeRecommended) end

---
---@return boolean
function CDOTABaseAbility:ShouldUseResources() end

---
---@param iConcept number
---@return void
function CDOTABaseAbility:SpeakAbilityConcept(iConcept) end

---
---@return unknown
function CDOTABaseAbility:SpeakTrigger() end

---
---@param flCooldown number
---@return void
function CDOTABaseAbility:StartCooldown(flCooldown) end

---
---@return void
function CDOTABaseAbility:ToggleAbility() end

---
---@return void
function CDOTABaseAbility:ToggleAutoCast() end

---升级该技能，一般不用CDOTA_BaseNPC_Hero的那个UpgradeAbility，那个API会导致被动modifier不刷新。
---@param bSupressSpeech boolean
---@return void
function CDOTABaseAbility:UpgradeAbility(bSupressSpeech) end

---调用该技能的各种效果，包括魔法，金钱，冷却时间。
---@param bMana boolean
---@param bGold boolean
---@param bCooldown boolean
---@return void
function CDOTABaseAbility:UseResources(bMana, bGold, bCooldown) end

---@class CDOTABaseGameMode : CBaseEntity
---
---@param pszAbilityName string
---@return void
function CDOTABaseGameMode:AddAbilityUpgradeToWhitelist(pszAbilityName) end

---( pszItem, pszShop, pszCategory ) Add an item to purchase at a custom shop.
---@param pszItemName string
---@param pszShopName string
---@param pszCategory string
---@return void
function CDOTABaseGameMode:AddItemToCustomShop(pszItemName, pszShopName, pszCategory) end

---Begin tracking a sequence of events using the real time combat analyzer.
---@param hQueryTable handle
---@param hPlayer handle
---@param pszQueryName string
---@return number
function CDOTABaseGameMode:AddRealTimeCombatAnalyzerQuery(hQueryTable, hPlayer, pszQueryName) end

---一个锁定战争迷雾的实体。返回类为CFoWBlockerRegion
---@param flMinX number
---@param flMinY number
---@param flMaxX number
---@param flMaxY number
---@param flGridSize number
---@return handle
function CDOTABaseGameMode:AllocateFowBlockerRegion(flMinX, flMinY, flMaxX, flMaxY, flGridSize) end

---Get if weather effects are disabled on the client.
---@return boolean
function CDOTABaseGameMode:AreWeatherEffectsDisabled() end

---Clear the script filter that controls bounty rune pickup behavior.
---@return void
function CDOTABaseGameMode:ClearBountyRunePickupFilter() end

---Clear the script filter that controls how a unit takes damage.
---@return void
function CDOTABaseGameMode:ClearDamageFilter() end

---Clear the script filter that controls when a unit picks up an item.
---@return void
function CDOTABaseGameMode:ClearExecuteOrderFilter() end

---Clear the script filter that controls how a unit heals.
---@return void
function CDOTABaseGameMode:ClearHealingFilter() end

---Clear the script filter that controls the item added to inventory filter.
---@return void
function CDOTABaseGameMode:ClearItemAddedToInventoryFilter() end

---Clear the script filter that controls the modifier filter.
---@return void
function CDOTABaseGameMode:ClearModifierGainedFilter() end

---Clear the script filter that controls how hero experience is modified.
---@return void
function CDOTABaseGameMode:ClearModifyExperienceFilter() end

---Clear the script filter that controls how hero gold is modified.
---@return void
function CDOTABaseGameMode:ClearModifyGoldFilter() end

---Clear the script filter that controls what rune spawns.
---@return void
function CDOTABaseGameMode:ClearRuneSpawnFilter() end

---Clear the script filter that controls when tracking projectiles are launched.
---@return void
function CDOTABaseGameMode:ClearTrackingProjectileFilter() end

---Disable npc_dota_creature clumping behavior by default.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:DisableClumpingBehaviorByDefault(bDisabled) end

---Use to disable hud flip for this mod
---@param bDisable boolean
---@return void
function CDOTABaseGameMode:DisableHudFlip(bDisable) end

---
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:EnableAbilityUpgradeWhitelist(bEnabled) end

---Show the player hero`s inventory in the HUD, regardless of what unit is selected.
---@return boolean
function CDOTABaseGameMode:GetAlwaysShowPlayerInventory() end

---Get whether player names are always shown, regardless of client setting.
---@return boolean
function CDOTABaseGameMode:GetAlwaysShowPlayerNames() end

---Are in-game announcers disabled?
---@return boolean
function CDOTABaseGameMode:GetAnnouncerDisabled() end

---Set a different camera distance; dota default is 1134.
---@return number
function CDOTABaseGameMode:GetCameraDistanceOverride() end

---Get current derived stat value constant.
---@param nDerivedStatType number
---@return number
function CDOTABaseGameMode:GetCustomAttributeDerivedStatValue(nDerivedStatType) end

---Get the current rate cooldown ticks down for items in the backpack.
---@return number
function CDOTABaseGameMode:GetCustomBackpackCooldownPercent() end

---Get the current custom backpack swap cooldown.
---@return number
function CDOTABaseGameMode:GetCustomBackpackSwapCooldown() end

---Turns on capability to define custom buyback cooldowns.
---@return boolean
function CDOTABaseGameMode:GetCustomBuybackCooldownEnabled() end

---Turns on capability to define custom buyback costs.
---@return boolean
function CDOTABaseGameMode:GetCustomBuybackCostEnabled() end

---Get the topbar score display value for dire.
---@return number
function CDOTABaseGameMode:GetCustomDireScore() end

---Get the current custom glyph cooldown.
---@return number
function CDOTABaseGameMode:GetCustomGlyphCooldown() end

---Allows definition of the max level heroes can achieve (default is 25).
---@return number
function CDOTABaseGameMode:GetCustomHeroMaxLevel() end

---Get the topbar score display value for radiant.
---@return number
function CDOTABaseGameMode:GetCustomRadiantScore() end

---Get the current custom scan cooldown.
---@return number
function CDOTABaseGameMode:GetCustomScanCooldown() end

---Get the rate at which the day/night cycle advances (1.0 = default).
---@return number
function CDOTABaseGameMode:GetDaynightCycleAdvanceRate() end

---Get the Game Seed passed from the GC.
---@return number
function CDOTABaseGameMode:GetEventGameSeed() end

---Get the Event Window Start Time passed from the GC.
---@return unsigned
function CDOTABaseGameMode:GetEventWindowStartTime() end

---Gets the fixed respawn time.
---@return number
function CDOTABaseGameMode:GetFixedRespawnTime() end

---Turn the fog of war on or off.
---@return boolean
function CDOTABaseGameMode:GetFogOfWarDisabled() end

---Turn the sound when gold is acquired off/on.
---@return boolean
function CDOTABaseGameMode:GetGoldSoundDisabled() end

---Returns the HUD element visibility.
---@param iElement number
---@return boolean
function CDOTABaseGameMode:GetHUDVisible(iElement) end

---Get the maximum attack speed for units.
---@return number
function CDOTABaseGameMode:GetMaximumAttackSpeed() end

---Get the minimum attack speed for units.
---@return number
function CDOTABaseGameMode:GetMinimumAttackSpeed() end

---Turn the panel for showing recommended items at the shop off/on.
---@return boolean
function CDOTABaseGameMode:GetRecommendedItemsDisabled() end

---Returns the scale applied to non-fixed respawn times.
---@return number
function CDOTABaseGameMode:GetRespawnTimeScale() end

---Turn purchasing items to the stash off/on. If purchasing to the stash is off the player must be at a shop to purchase items.
---@return boolean
function CDOTABaseGameMode:GetStashPurchasingDisabled() end

---Hide the sticky item in the quickbuy.
---@return boolean
function CDOTABaseGameMode:GetStickyItemDisabled() end

---Override the values of the team values on the top game bar.
---@return boolean
function CDOTABaseGameMode:GetTopBarTeamValuesOverride() end

---Turning on/off the team values on the top game bar.
---@return boolean
function CDOTABaseGameMode:GetTopBarTeamValuesVisible() end

---Gets whether tower backdoor protection is enabled or not.
---@return boolean
function CDOTABaseGameMode:GetTowerBackdoorProtectionEnabled() end

---Are custom-defined XP values for hero level ups in use?
---@return boolean
function CDOTABaseGameMode:GetUseCustomHeroLevels() end

---Gets the time from game start during which water runes spawn
---@return number
function CDOTABaseGameMode:GetWaterRuneLastSpawnTime() end

---
---@param pszAbilityName string
---@return boolean
function CDOTABaseGameMode:IsAbilityUpgradeWhitelisted(pszAbilityName) end

---Enables or disables buyback completely.
---@return boolean
function CDOTABaseGameMode:IsBuybackEnabled() end

---Is the day/night cycle disabled?
---@return boolean
function CDOTABaseGameMode:IsDaynightCycleDisabled() end

---Set function and context for real time combat analyzer query failed.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:ListenForQueryFailed(hFunction, hContext) end

---Set function and context for real time combat analyzer query progress changed.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:ListenForQueryProgressChanged(hFunction, hContext) end

---Set function and context for real time combat analyzer query succeeded.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:ListenForQuerySucceeded(hFunction, hContext) end

---
---@param pszAbilityName string
---@return void
function CDOTABaseGameMode:RemoveAbilityUpgradeFromWhitelist(pszAbilityName) end

---( pszItem, pszShop ) Remove an item to purchase at a custom shop.
---@param pszItemName string
---@param pszShopName string
---@return void
function CDOTABaseGameMode:RemoveItemFromCustomShop(pszItemName, pszShopName) end

---Stop tracking a combat analyzer query.
---@param nQueryID number
---@return void
function CDOTABaseGameMode:RemoveRealTimeCombatAnalyzerQuery(nQueryID) end

---Set a filter function to control the tuning values that abilities use. (Modify the table and Return true to use new values, return false to use the old values)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetAbilityTuningValueFilter(hFunction, hContext) end

---If set to true, neutral items will be dropped on killing neutral monsters.  Otherwise nothing will be dropped.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetAllowNeutralItemDrops(bEnabled) end

---Show the player hero`s inventory in the HUD, regardless of what unit is selected.
---@param bAlwaysShow boolean
---@return void
function CDOTABaseGameMode:SetAlwaysShowPlayerInventory(bAlwaysShow) end

---Set whether player names are always shown, regardless of client setting.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetAlwaysShowPlayerNames(bEnabled) end

---Mutes the in-game announcer.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetAnnouncerDisabled(bDisabled) end

---Enables/Disables bots in custom games. Note: this will only work with default heroes in the dota map.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetBotThinkingEnabled(bEnabled) end

---Set if the bots should try their best to push with a human player.
---@param bAlwaysPush boolean
---@return void
function CDOTABaseGameMode:SetBotsAlwaysPushWithHuman(bAlwaysPush) end

---Set if bots should enable their late game behavior.
---@param bLateGame boolean
---@return void
function CDOTABaseGameMode:SetBotsInLateGame(bLateGame) end

---Set the max tier of tower that bots want to push. (-1 to disable)
---@param nMaxTier number
---@return void
function CDOTABaseGameMode:SetBotsMaxPushTier(nMaxTier) end

---Set a filter function to control the behavior when a bounty rune is picked up. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetBountyRunePickupFilter(hFunction, hContext) end

---Set bounty rune spawn rate
---@param flInterval number
---@return void
function CDOTABaseGameMode:SetBountyRuneSpawnInterval(flInterval) end

---Enables or disables buyback completely.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetBuybackEnabled(bEnabled) end

---Set a different camera distance; dota default is 1134.
---@param flCameraDistanceOverride number
---@return void
function CDOTABaseGameMode:SetCameraDistanceOverride(flCameraDistanceOverride) end

---Set a different camera smooth count; dota default is 8.
---@param nSmoothCount number
---@return void
function CDOTABaseGameMode:SetCameraSmoothCountOverride(nSmoothCount) end

---Sets the camera Z range
---@param flMinZ number
---@param flMaxZ number
---@return void
function CDOTABaseGameMode:SetCameraZRange(flMinZ, flMaxZ) end

---bool bAllow
---@param bAllow boolean
---@return void
function CDOTABaseGameMode:SetCanSellAnywhere(bAllow) end

---Modify derived stat value constants. ( AttributeDerivedStat eStatType, float flNewValue.
---@param nStatType number
---@param flNewValue number
---@return void
function CDOTABaseGameMode:SetCustomAttributeDerivedStatValue(nStatType, flNewValue) end

---Set the rate cooldown ticks down for items in the backpack.
---@param flPercent number
---@return void
function CDOTABaseGameMode:SetCustomBackpackCooldownPercent(flPercent) end

---Set a custom cooldown for swapping items into the backpack.
---@param flCooldown number
---@return void
function CDOTABaseGameMode:SetCustomBackpackSwapCooldown(flCooldown) end

---Turns on capability to define custom buyback cooldowns.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetCustomBuybackCooldownEnabled(bEnabled) end

---Turns on capability to define custom buyback costs.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetCustomBuybackCostEnabled(bEnabled) end

---Sets the topbar score display value for dire.
---@param nScore number
---@return void
function CDOTABaseGameMode:SetCustomDireScore(nScore) end

---Force all players to use the specified hero and disable the normal hero selection process. Must be used before hero selection.
---@param pHeroName string
---@return void
function CDOTABaseGameMode:SetCustomGameForceHero(pHeroName) end

---Set a custom cooldown for team Glyph ability.
---@param flCooldown number
---@return void
function CDOTABaseGameMode:SetCustomGlyphCooldown(flCooldown) end

---Allows definition of the max level heroes can achieve (default is 25).
---@param int_1 number
---@return void
function CDOTABaseGameMode:SetCustomHeroMaxLevel(int_1) end

---Sets the topbar score display value for radiant.
---@param nScore number
---@return void
function CDOTABaseGameMode:SetCustomRadiantScore(nScore) end

---Set a custom cooldown for team Scan ability.
---@param flCooldown number
---@return void
function CDOTABaseGameMode:SetCustomScanCooldown(flCooldown) end

---Set the effect used as a custom weather effect, when units are on non-default terrain, in this mode.
---@param pszEffectName string
---@return void
function CDOTABaseGameMode:SetCustomTerrainWeatherEffect(pszEffectName) end

---Allows definition of a table of hero XP values.
---@param hTable handle
---@return void
function CDOTABaseGameMode:SetCustomXPRequiredToReachNextLevel(hTable) end

---Set a filter function to control the behavior when a unit takes damage. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetDamageFilter(hFunction, hContext) end

---Sets the rate at which the day/night cycle advances (1.0 = default).
---@param flRate number
---@return void
function CDOTABaseGameMode:SetDaynightCycleAdvanceRate(flRate) end

---Enable or disable the day/night cycle.
---@param bDisable boolean
---@return void
function CDOTABaseGameMode:SetDaynightCycleDisabled(bDisable) end

---Specify whether the full screen death overlay effect plays when the selected hero dies.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetDeathOverlayDisabled(bDisabled) end

---Sets the default sticky item in the quickbuy
---@param pItem string
---@return void
function CDOTABaseGameMode:SetDefaultStickyItem(pItem) end

---Set drafting hero banning time
---@param flValue number
---@return void
function CDOTABaseGameMode:SetDraftingBanningTimeOverride(flValue) end

---Set drafting hero pick time
---@param flValue number
---@return void
function CDOTABaseGameMode:SetDraftingHeroPickSelectTimeOverride(flValue) end

---Set a filter function to control the behavior when a unit picks up an item. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetExecuteOrderFilter(hFunction, hContext) end

---Set a fixed delay for all players to respawn after.
---@param flFixedRespawnTime number
---@return void
function CDOTABaseGameMode:SetFixedRespawnTime(flFixedRespawnTime) end

---Turn the fog of war on or off.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetFogOfWarDisabled(bDisabled) end

---Prevent users from using the right click deny setting.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetForceRightClickAttackDisabled(bDisabled) end

---Specify a HUD skin that is forced on for this game mode.
---@param pValue string
---@return void
function CDOTABaseGameMode:SetForcedHUDSkin(pValue) end

---Set the constant rate that the fountain will regen mana. (-1 for default)
---@param flConstantManaRegen number
---@return void
function CDOTABaseGameMode:SetFountainConstantManaRegen(flConstantManaRegen) end

---Set the percentage rate that the fountain will regen health. (-1 for default)
---@param flPercentageHealthRegen number
---@return void
function CDOTABaseGameMode:SetFountainPercentageHealthRegen(flPercentageHealthRegen) end

---Set the percentage rate that the fountain will regen mana. (-1 for default)
---@param flPercentageManaRegen number
---@return void
function CDOTABaseGameMode:SetFountainPercentageManaRegen(flPercentageManaRegen) end

---If set to true, enable 7.23 free courier mode.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetFreeCourierModeEnabled(bEnabled) end

---Allows clicks on friendly buildings to be handled normally.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetFriendlyBuildingMoveToEnabled(bEnabled) end

---bool bGive
---@param bGive boolean
---@return void
function CDOTABaseGameMode:SetGiveFreeTPOnDeath(bGive) end

---Turn the sound when gold is acquired off/on.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetGoldSoundDisabled(bDisabled) end

---Set the HUD element visibility.
---@param iHUDElement number
---@param bVisible boolean
---@return void
function CDOTABaseGameMode:SetHUDVisible(iHUDElement, bVisible) end

---Set a filter function to control the behavior when a unit heals. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetHealingFilter(hFunction, hContext) end

---Specify whether the default combat events will show in the HUD.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetHudCombatEventsDisabled(bDisabled) end

---Set the amount blocked innately by melee heroes.
---@param nAmount number
---@return void
function CDOTABaseGameMode:SetInnateMeleeDamageBlockAmount(nAmount) end

---Set the amount innately blocked by melee heroes gained per level.
---@param nPerLevelAmount number
---@return void
function CDOTABaseGameMode:SetInnateMeleeDamageBlockPerLevelAmount(nPerLevelAmount) end

---Set the percent chance a melee hero will innately block damage.
---@param nPercent number
---@return void
function CDOTABaseGameMode:SetInnateMeleeDamageBlockPercent(nPercent) end

---Set a filter function to control what happens to items that are added to an inventory, return false to cancel the event
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetItemAddedToInventoryFilter(hFunction, hContext) end

---Set whether tombstones can be channeled to be removed by enemy heroes.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetKillableTombstones(bEnabled) end

---Mutes the in-game killing spree announcer.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetKillingSpreeAnnouncerDisabled(bDisabled) end

---Use to disable gold loss on death.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetLoseGoldOnDeath(bEnabled) end

---Set the maximum attack speed for units.
---@param nMaxSpeed number
---@return void
function CDOTABaseGameMode:SetMaximumAttackSpeed(nMaxSpeed) end

---Set the minimum attack speed for units.
---@param nMinSpeed number
---@return void
function CDOTABaseGameMode:SetMinimumAttackSpeed(nMinSpeed) end

---Set a filter function to control modifiers that are gained, return false to destroy modifier.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetModifierGainedFilter(hFunction, hContext) end

---Set a filter function to control the behavior when a hero`s experience is modified. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetModifyExperienceFilter(hFunction, hContext) end

---Set a filter function to control the behavior when a hero`s gold is modified. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetModifyGoldFilter(hFunction, hContext) end

---When enabled, undiscovered items in the neutral item stash are hidden.
---@param bEnable boolean
---@return void
function CDOTABaseGameMode:SetNeutralItemHideUndiscoveredEnabled(bEnable) end

---Allow items to be sent to the neutral stash.
---@param bEnable boolean
---@return void
function CDOTABaseGameMode:SetNeutralStashEnabled(bEnable) end

---When enabled, the all neutral items tab cannot be viewed.
---@param bEnable boolean
---@return void
function CDOTABaseGameMode:SetNeutralStashTeamViewOnlyEnabled(bEnable) end

---Set an override for the default selection entity, instead of each player`s hero.
---@param hOverrideEntity handle
---@return void
function CDOTABaseGameMode:SetOverrideSelectionEntity(hOverrideEntity) end

---Set pausing enabled/disabled
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetPauseEnabled(bEnabled) end

---bool bFilter
---@param bFilter boolean
---@return void
function CDOTABaseGameMode:SetPlayerHeroAvailabilityFiltered(bFilter) end

---Set power rune spawn rate
---@param flInterval number
---@return void
function CDOTABaseGameMode:SetPowerRuneSpawnInterval(flInterval) end

---Disables bonus items for randoming a hero.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetRandomHeroBonusItemGrantDisabled(bDisabled) end

---Turn the panel for showing recommended items at the shop off/on.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetRecommendedItemsDisabled(bDisabled) end

---Make it so illusions are immediately removed upon death, rather than sticking around for a few seconds.
---@param bRemove boolean
---@return void
function CDOTABaseGameMode:SetRemoveIllusionsOnDeath(bRemove) end

---Sets the scale applied to non-fixed respawn times. 1 = default DOTA respawn calculations.
---@param flValue number
---@return void
function CDOTABaseGameMode:SetRespawnTimeScale(flValue) end

---Set if a given type of rune is enabled.
---@param nRune number
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetRuneEnabled(nRune, bEnabled) end

---Set a filter function to control what rune spawns. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetRuneSpawnFilter(hFunction, hContext) end

---Enable/disable gold penalty for late picking.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetSelectionGoldPenaltyEnabled(bEnabled) end

---Allow items to be sent to the stash.
---@param bEnable boolean
---@return void
function CDOTABaseGameMode:SetSendToStashEnabled(bEnable) end

---Turn purchasing items to the stash off/on. If purchasing to the stash is off the player must be at a shop to purchase items.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetStashPurchasingDisabled(bDisabled) end

---Hide the sticky item in the quickbuy.
---@param bDisabled boolean
---@return void
function CDOTABaseGameMode:SetStickyItemDisabled(bDisabled) end

---Sets the item which goes in the TP scroll slot
---@param pItemName string
---@return void
function CDOTABaseGameMode:SetTPScrollSlotItemOverride(pItemName) end

---Set the team values on the top game bar.
---@param iTeam number
---@param nValue number
---@return void
function CDOTABaseGameMode:SetTopBarTeamValue(iTeam, nValue) end

---Override the values of the team values on the top game bar.
---@param bOverride boolean
---@return void
function CDOTABaseGameMode:SetTopBarTeamValuesOverride(bOverride) end

---Turning on/off the team values on the top game bar.
---@param bVisible boolean
---@return void
function CDOTABaseGameMode:SetTopBarTeamValuesVisible(bVisible) end

---Enables/Disables tower backdoor protection.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetTowerBackdoorProtectionEnabled(bEnabled) end

---Set a filter function to control when tracking projectiles are launched. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetTrackingProjectileFilter(hFunction, hContext) end

---Enable or disable unseen fog of war. When enabled parts of the map the player has never seen will be completely hidden by fog of war.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetUnseenFogOfWarEnabled(bEnabled) end

---Turn on custom-defined XP values for hero level ups.  The table should be defined before switching this on.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetUseCustomHeroLevels(bEnabled) end

---If set to true, use current rune spawn rules.  Either setting respects custom spawn intervals.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetUseDefaultDOTARuneSpawnLogic(bEnabled) end

---Enables or disables turbo couriers.
---@param bEnabled boolean
---@return void
function CDOTABaseGameMode:SetUseTurboCouriers(bEnabled) end

---Sets the time from game start during which water runes spawn
---@param nValue number
---@return void
function CDOTABaseGameMode:SetWaterRuneLastSpawnTime(nValue) end

---Set if weather effects are disabled.
---@param bDisable boolean
---@return void
function CDOTABaseGameMode:SetWeatherEffectsDisabled(bDisable) end

---
---@return boolean
function CDOTABaseGameMode:ShouldGiveFreeTPOnDeath() end

---@class CDOTAGameManager
---Get the hero unit 
---@param string_1 string
---@return table
function CDOTAGameManager:GetHeroDataByName_Script(string_1) end

---Get the hero ID given the hero name.
---@param string_1 string
---@return number
function CDOTAGameManager:GetHeroIDByName(string_1) end

---Get the hero name given a hero ID.
---@param int_1 number
---@return string
function CDOTAGameManager:GetHeroNameByID(int_1) end

---Get the hero name given a unit name.
---@param string_1 string
---@return string
function CDOTAGameManager:GetHeroNameForUnitName(string_1) end

---Get the hero unit name given the hero ID.
---@param int_1 number
---@return string
function CDOTAGameManager:GetHeroUnitNameByID(int_1) end

---@class CDOTAGamerules
---@type CDOTAGamerules
GameRules = CDOTAGamerules
---Spawn a bot player of the passed hero name, player name, and team.
---@param sHeroName string
---@param sBotName string
---@param iTeamNumber number
---@param sScriptPath string
---@param bool_5 boolean
---@return handle
function CDOTAGamerules:AddBotPlayerWithEntityScript(sHeroName, sBotName, iTeamNumber, sScriptPath, bool_5) end

---Event-only ( string szNameSuffix, int nStars, int nMaxStars, int nExtraData1, int nExtraData2 )
---@param string_1 string
---@param unsigned_2 unsigned
---@param unsigned_3 unsigned
---@param unsigned_4 unsigned
---@param unsigned_5 unsigned
---@param unsigned_6 unsigned
---@param unsigned_7 unsigned
---@param unsigned_8 unsigned
---@param unsigned_9 unsigned
---@return boolean
function CDOTAGamerules:AddEventMetadataLeaderboardEntry(string_1, unsigned_2, unsigned_3, unsigned_4, unsigned_5, unsigned_6, unsigned_7, unsigned_8, unsigned_9) end

---Event-only ( string szNameSuffix, int nScore, int nExtraData1, int nExtraData2 )
---@param string_1 string
---@param unsigned_2 unsigned
---@param unsigned_3 unsigned
---@param unsigned_4 unsigned
---@param unsigned_5 unsigned
---@param unsigned_6 unsigned
---@param unsigned_7 unsigned
---@param unsigned_8 unsigned
---@return boolean
function CDOTAGamerules:AddEventMetadataLeaderboardEntryRawScore(string_1, unsigned_2, unsigned_3, unsigned_4, unsigned_5, unsigned_6, unsigned_7, unsigned_8) end

---Add the hero ID to the hero blacklist if it is not already present
---@param int_1 number
---@return void
function CDOTAGamerules:AddHeroIDToBlacklist(int_1) end

---Add the hero ID to the hero whitelist if it is not already present
---@param int_1 number
---@return void
function CDOTAGamerules:AddHeroIDToWhitelist(int_1) end

---Add the hero to the hero blacklist if it is not already present
---@param string_1 string
---@return void
function CDOTAGamerules:AddHeroToBlacklist(string_1) end

---Adds hero of given ID to available heroes of player of given ID
---@param int_1 number
---@param int_2 number
---@return void
function CDOTAGamerules:AddHeroToPlayerAvailability(int_1, int_2) end

---Add the hero to the hero whitelist if it is not already present
---@param string_1 string
---@return void
function CDOTAGamerules:AddHeroToWhitelist(string_1) end

---Add an item to the whitelist
---@param string_1 string
---@return void
function CDOTAGamerules:AddItemToWhiteList(string_1) end

---Add a point on the minimap.
---@param int_1 number
---@param Vector_2 Vector
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param float_7 number
---@return void
function CDOTAGamerules:AddMinimapDebugPoint(int_1, Vector_2, int_3, int_4, int_5, int_6, float_7) end

---Add a point on the minimap for a specific team.
---@param int_1 number
---@param Vector_2 Vector
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param float_7 number
---@param int_8 number
---@return void
function CDOTAGamerules:AddMinimapDebugPointForTeam(int_1, Vector_2, int_3, int_4, int_5, int_6, float_7, int_8) end

---Begin night stalker night.
---@param float_1 number
---@return void
function CDOTAGamerules:BeginNightstalkerNight(float_1) end

---Begin temporary night.
---@param float_1 number
---@return void
function CDOTAGamerules:BeginTemporaryNight(float_1) end

---Fills all the teams with bots if cheat mode is enabled.
---@return void
function CDOTAGamerules:BotPopulate() end

---Clears the hero blacklist
---@return void
function CDOTAGamerules:ClearHeroBlacklist() end

---Clears the hero whitelist
---@return void
function CDOTAGamerules:ClearHeroWhitelist() end

---Clears available heroes of player of given ID
---@param int_1 number
---@return void
function CDOTAGamerules:ClearPlayerHeroAvailability(int_1) end

---Clears the current river paint
---@return void
function CDOTAGamerules:ClearRiverPaint() end

---Kills the ancient, etc.
---@return void
function CDOTAGamerules:Defeated() end

---true when we have waited some time after end of the game and not received signout
---@return boolean
function CDOTAGamerules:DidMatchSignoutTimeOut() end

---Enabled (true) or disable (false) auto launch for custom game setup.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:EnableCustomGameSetupAutoLaunch(bool_1) end

---向队伍发送小地图标记事件
---@param iTeamNumber number
---@param x number
---@param y number
---@param hUnit handle
---@param int_5 number
---@return void
function CDOTAGamerules:ExecuteTeamPing(iTeamNumber, x, y, hUnit, int_5) end

---Indicate that the custom game setup phase is complete, and advance to the game.
---@return void
function CDOTAGamerules:FinishCustomGameSetup() end

---Spawn the next wave of creeps.
---@return void
function CDOTAGamerules:ForceCreepSpawn() end

---Transition game state to DOTA_GAMERULES_STATE_GAME_IN_PROGRESS
---@return void
function CDOTAGamerules:ForceGameStart() end

---Get the announcer for a team
---@param int_1 number
---@return handle
function CDOTAGamerules:GetAnnouncer(int_1) end

---Returns the hero unit IDs banned in this game, if any
---@return table
function CDOTAGamerules:GetBannedHeroIDs() end

---Returns the hero unit names banned in this game, if any
---@return table
function CDOTAGamerules:GetBannedHeroes() end

---Returns the difficulty level of the custom game mode
---@return number
function CDOTAGamerules:GetCustomGameDifficulty() end

---Get whether a team is selectable during game setup
---@param int_1 number
---@return number
function CDOTAGamerules:GetCustomGameTeamMaxPlayers(int_1) end

---(b IncludePregameTime b IncludeNegativeTime) Returns the actual DOTA in-game clock time.返回Dota游戏内的时间。（是否包含赛前时间或负时间）
---@param IncludePregameTime  boolean
---@param IncludeNegativeTime boolean
---@return number
function CDOTAGamerules:GetDOTATime(IncludePregameTime , IncludeNegativeTime) end

---Returns difficulty level of the custom game mode
---@return number
function CDOTAGamerules:GetDifficulty() end

---Gets the Xth dropped item
---@param int_1 number
---@return handle
function CDOTAGamerules:GetDroppedItem(int_1) end

---Returns the number of seconds elapsed since the last frame was renderered. This time doesn`t count up when the game is paused
---@return number
function CDOTAGamerules:GetGameFrameTime() end

---Get the game mode entity
---@return CDOTABaseGameMode
function CDOTAGamerules:GetGameModeEntity() end

---Get a string value from the game session config (map options)
---@param string_1 string
---@param string_2 string
---@return string
function CDOTAGamerules:GetGameSessionConfigValue(string_1, string_2) end

---Returns the number of seconds elapsed since map start. This time doesn`t count up when the game is paused
---@return number
function CDOTAGamerules:GetGameTime() end

---Get the time it takes to add a new item to stock
---@param int_1 number
---@param string_2 string
---@param int_3 number
---@return number
function CDOTAGamerules:GetIetmStockDuration(int_1, string_2, int_3) end

---Get the stock count of the item
---@param int_1 number
---@param string_2 string
---@param int_3 number
---@return number
function CDOTAGamerules:GetItemStockCount(int_1, string_2, int_3) end

---Get the time an item will be added to stock
---@param int_1 number
---@param string_2 string
---@param int_3 number
---@return number
function CDOTAGamerules:GetItemStockTime(int_1, string_2, int_3) end

---Have we received the post match signout message that includes reward information
---@return boolean
function CDOTAGamerules:GetMatchSignoutComplete() end

---Gets next bounty rune spawn time
---@return number
function CDOTAGamerules:GetNextBountyRuneSpawnTime() end

---Gets next rune spawn time
---@return number
function CDOTAGamerules:GetNextRuneSpawnTime() end

---For New Bloom, get total damage taken by the Nian / Year Beast
---@return number
function CDOTAGamerules:GetNianTotalDamageTaken() end

---(Preview/Unreleased) Gets the player`s custom game account record, as it looked at the start of this session
---@param int_1 number
---@return table
function CDOTAGamerules:GetPlayerCustomGameAccountRecord(int_1) end

---Get time remaining between state changes.
---@return number
function CDOTAGamerules:GetStateTransitionTime() end

---Get the time of day
---@return number
function CDOTAGamerules:GetTimeOfDay() end

---Get Weather Wind Direction Vector
---@return Vector
function CDOTAGamerules:GetWeatherWindDirection() end

---Increase an item`s stock count, clamped to item max (nTeamNumber, szItemName, nCount, nPlayerID .
---@param int_1 number
---@param string_2 string
---@param int_3 number
---@param int_4 number
---@return void
function CDOTAGamerules:IncreaseItemStock(int_1, string_2, int_3, int_4) end

---Are cheats enabled on the server
---@return boolean
function CDOTAGamerules:IsCheatMode() end

---Is it day time?
---@return boolean
function CDOTAGamerules:IsDaytime() end

---
---@return boolean
function CDOTAGamerules:IsDev() end

---Returns whether the game is paused.
---@return boolean
function CDOTAGamerules:IsGamePaused() end

---Is the hero not blacklisted, and is it either whitelisted or the whitelist is empty?
---@param string_1 string
---@return boolean
function CDOTAGamerules:IsHeroEnabledViaLists(string_1) end

---Returns whether hero respawn is enabled.
---@return boolean
function CDOTAGamerules:IsHeroRespawnEnabled() end

---Are we in the ban phase of hero pick?
---@return boolean
function CDOTAGamerules:IsInBanPhase() end

---Query an item in the whitelist
---@param string_1 string
---@return boolean
function CDOTAGamerules:IsItemInWhiteList(string_1) end

---Is it night stalker night-time?
---@return boolean
function CDOTAGamerules:IsNightstalkerNight() end

---Is it temporarily night-time?
---@return boolean
function CDOTAGamerules:IsTemporaryNight() end

---Lock (true) or unlock (false) team assignemnt. If team assignment is locked players cannot change teams.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:LockCustomGameSetupTeamAssignment(bool_1) end

---Makes the specified team lose
---@param int_1 number
---@return void
function CDOTAGamerules:MakeTeamLose(int_1) end

---Like ModifyGold, but will use the gold filter if SetFilterMoreGold has been set true
---@param int_1 number
---@param int_2 number
---@param bool_3 boolean
---@param int_4 number
---@return number
function CDOTAGamerules:ModifyGoldFiltered(int_1, int_2, bool_3, int_4) end

---Returns the number of items currently dropped on the ground
---@return number
function CDOTAGamerules:NumDroppedItems() end

---Whether a player has custom game host privileges (shuffle teams, etc.)
---@param handle_1 handle
---@return boolean
function CDOTAGamerules:PlayerHasCustomGameHostPrivileges(handle_1) end

---Updates custom hero, unit and ability KeyValues in memory with the latest values from disk
---@return void
function CDOTAGamerules:Playtesting_UpdateAddOnKeyValues() end

---Prepare Dota lane style spawners with a given interval
---@param float_1 number
---@return void
function CDOTAGamerules:PrepareSpawners(float_1) end

---Removes a fake client
---@param int_1 number
---@return void
function CDOTAGamerules:RemoveFakeClient(int_1) end

---Remove the hero from the hero blacklist if present
---@param string_1 string
---@return void
function CDOTAGamerules:RemoveHeroFromBlacklist(string_1) end

---Remove the hero from the hero whitelist if present
---@param string_1 string
---@return void
function CDOTAGamerules:RemoveHeroFromWhitelist(string_1) end

---Remove the hero ID from the hero blacklist if present
---@param int_1 number
---@return void
function CDOTAGamerules:RemoveHeroIDFromBlacklist(int_1) end

---Remove the hero ID from the hero whitelist if present
---@param int_1 number
---@return void
function CDOTAGamerules:RemoveHeroIDFromWhitelist(int_1) end

---Remove an item from the whitelist
---@param string_1 string
---@return void
function CDOTAGamerules:RemoveItemFromWhiteList(string_1) end

---Restart after killing the ancient, etc.
---@return void
function CDOTAGamerules:ResetDefeated() end

---Restart gametime from 0
---@return void
function CDOTAGamerules:ResetGameTime() end

---Restart at custom game setup.
---@return void
function CDOTAGamerules:ResetToCustomGameSetup() end

---Restart the game at hero selection
---@return void
function CDOTAGamerules:ResetToHeroSelection() end

---Get the MatchID for this game.
---@return uint64
function CDOTAGamerules:Script_GetMatchID() end

---Sends a message on behalf of a player.
---@param string_1 string
---@param int_2 number
---@param int_3 number
---@return void
function CDOTAGamerules:SendCustomMessage(string_1, int_2, int_3) end

---Sends a message on behalf of a player to the specified team.
---@param string_1 string
---@param int_2 number
---@param int_3 number
---@param int_4 number
---@return void
function CDOTAGamerules:SendCustomMessageToTeam(string_1, int_2, int_3, int_4) end

---Allow Outposts granting XP
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetAllowOutpostBonuses(bool_1) end

---(flMinimapCreepIconScale) - Scale the creep icons on the minimap.
---@param float_1 number
---@return void
function CDOTAGamerules:SetCreepMinimapIconScale(float_1) end

---Sets whether the regular Dota creeps spawn.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetCreepSpawningEnabled(bool_1) end

---(Preview/Unreleased) Sets a callback to handle saving custom game account records (callback is passed a Player ID and should return a flat simple table)
---@param handle_1 handle
---@param handle_2 handle
---@return void
function CDOTAGamerules:SetCustomGameAccountRecordSaveFunction(handle_1, handle_2) end

---Sets a flag to enable/disable the default music handling code for custom games
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetCustomGameAllowBattleMusic(bool_1) end

---Sets a flag to enable/disable the default music handling code for custom games
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetCustomGameAllowHeroPickMusic(bool_1) end

---Sets a flag to enable/disable the default music handling code for custom games
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetCustomGameAllowMusicAtGameStart(bool_1) end

---Sets a flag to enable/disable the casting secondary abilities from units other than the player`s own hero.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetCustomGameAllowSecondaryAbilitiesOnOtherUnits(bool_1) end

---Set number of hero bans each team gets
---@param int_1 number
---@return void
function CDOTAGamerules:SetCustomGameBansPerTeam(int_1) end

---Set the difficulty level of the custom game mode
---@param int_1 number
---@return void
function CDOTAGamerules:SetCustomGameDifficulty(int_1) end

---Sets the game end delay.
---@param float_1 number
---@return void
function CDOTAGamerules:SetCustomGameEndDelay(float_1) end

---Set the amount of time to wait for auto launch.
---@param float_1 number
---@return void
function CDOTAGamerules:SetCustomGameSetupAutoLaunchDelay(float_1) end

---Set the amount of remaining time, in seconds, for custom game setup. 0 = finish immediately, -1 = wait forever
---@param float_1 number
---@return void
function CDOTAGamerules:SetCustomGameSetupRemainingTime(float_1) end

---Setup (pre-gameplay) phase timeout. 0 = instant, -1 = forever (until FinishCustomGameSetup is called)
---@param float_1 number
---@return void
function CDOTAGamerules:SetCustomGameSetupTimeout(float_1) end

---Set whether a team is selectable during game setup
---@param int_1 number
---@param int_2 number
---@return void
function CDOTAGamerules:SetCustomGameTeamMaxPlayers(int_1, int_2) end

---Sets the victory message.
---@param string_1 string
---@return void
function CDOTAGamerules:SetCustomVictoryMessage(string_1) end

---Sets the victory message duration.
---@param float_1 number
---@return void
function CDOTAGamerules:SetCustomVictoryMessageDuration(float_1) end

---Allow alternate hero grids to be used (DOTA+, etc).  True by default.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetEnableAlternateHeroGrids(bool_1) end

---Event-only ( table hMetadataTable )
---@param handle_1 handle
---@return boolean
function CDOTAGamerules:SetEventMetadataCustomTable(handle_1) end

---Event-only ( table hMetadataTable )
---@param handle_1 handle
---@return boolean
function CDOTAGamerules:SetEventSignoutCustomTable(handle_1) end

---Sets whether to filter more gold events than normal
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetFilterMoreGold(bool_1) end

---Sets whether First Blood has been triggered.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetFirstBloodActive(bool_1) end

---Freeze the game time.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetGameTimeFrozen(bool_1) end

---Makes the specified team win
---@param int_1 number
---@return void
function CDOTAGamerules:SetGameWinner(int_1) end

---Set Glyph cooldown for team
---@param int_1 number
---@param float_2 number
---@return void
function CDOTAGamerules:SetGlyphCooldown(int_1, float_2) end

---Set the auto gold increase per timed interval.
---@param int_1 number
---@return void
function CDOTAGamerules:SetGoldPerTick(int_1) end

---Set the time interval between auto gold increases.
---@param float_1 number
---@return void
function CDOTAGamerules:SetGoldTickTime(float_1) end

---(flMinimapHeroIconScale) - Scale the hero minimap icons on the minimap.
---@param float_1 number
---@return void
function CDOTAGamerules:SetHeroMinimapIconScale(float_1) end

---Control if the normal DOTA hero respawn rules apply.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetHeroRespawnEnabled(bool_1) end

---Sets amount of penalty time before randoming a hero
---@param float_1 number
---@return void
function CDOTAGamerules:SetHeroSelectPenaltyTime(float_1) end

---Sets the amount of time players have to pick their hero.
---@param float_1 number
---@return void
function CDOTAGamerules:SetHeroSelectionTime(float_1) end

---Should blacklisted heroes be hidden, or just dimmed, in hero picking?
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetHideBlacklistedHeroes(bool_1) end

---Sets whether the multikill, streak, and first-blood banners appear at the top of the screen.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetHideKillMessageHeaders(bool_1) end

---Set whether custom and event games should ignore Lobby teams when assigning players to teams. Defaults to true.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetIgnoreLobbyTeamsInCustomGame(bool_1) end

---Set the stock count of the item
---@param int_1 number
---@param int_2 number
---@param string_3 string
---@param int_4 number
---@return void
function CDOTAGamerules:SetItemStockCount(int_1, int_2, string_3, int_4) end

---Sets next bounty rune spawn time
---@param float_1 number
---@return void
function CDOTAGamerules:SetNextBountyRuneSpawnTime(float_1) end

---Sets next rune spawn time
---@param float_1 number
---@return void
function CDOTAGamerules:SetNextRuneSpawnTime(float_1) end

---Show this unit`s health on the overlay health bar
---@param handle_1 handle
---@param int_2 number
---@return void
function CDOTAGamerules:SetOverlayHealthBarUnit(handle_1, int_2) end

---Sets the amount of time players have between the game ending and the server disconnecting them.
---@param float_1 number
---@return void
function CDOTAGamerules:SetPostGameTime(float_1) end

---Sets the amount of time players have between picking their hero and game start.
---@param float_1 number
---@return void
function CDOTAGamerules:SetPreGameTime(float_1) end

---Paints the river for a duration
---@param int_1 number
---@param float_2 number
---@return void
function CDOTAGamerules:SetRiverPaint(int_1, float_2) end

---(flMinimapRuneIconScale) - Scale the rune icons on the minimap.
---@param float_1 number
---@return void
function CDOTAGamerules:SetRuneMinimapIconScale(float_1) end

---Sets the amount of time between rune spawns.
---@param float_1 number
---@return void
function CDOTAGamerules:SetRuneSpawnTime(float_1) end

---(bSafeToLeave) - Mark this game as safe to leave.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetSafeToLeave(bool_1) end

---When true, players can repeatedly pick the same hero.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetSameHeroSelectionEnabled(bool_1) end

---Sets the amount of time players have between the strategy phase and entering the pre-game phase.
---@param float_1 number
---@return void
function CDOTAGamerules:SetShowcaseTime(float_1) end

---Set whether to speak a Spawn concept instead of a Respawn concept on respawn.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetSpeechUseSpawnInsteadOfRespawnConcept(bool_1) end

---Set the starting gold amount.
---@param int_1 number
---@return void
function CDOTAGamerules:SetStartingGold(int_1) end

---Sets the amount of time players have between the hero selection and entering the showcase phase.
---@param float_1 number
---@return void
function CDOTAGamerules:SetStrategyTime(float_1) end

---设置一天的时间(0到1)，当值小于0.25和大于0.75时为晚上，反之为白天。
---@param float_1 number
---@return void
function CDOTAGamerules:SetTimeOfDay(float_1) end

---Sets the tree regrow time in seconds.
---@param float_1 number
---@return void
function CDOTAGamerules:SetTreeRegrowTime(float_1) end

---Heroes will use the basic NPC functionality for determining their bounty, rather than DOTA specific formulas.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetUseBaseGoldBountyOnHeroes(bool_1) end

---Allows heroes in the map to give a specific amount of XP (this value must be set).
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetUseCustomHeroXPValues(bool_1) end

---When true, all items are available at as long as any shop is in range.
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetUseUniversalShopMode(bool_1) end

---Set Weather Wind Direction Vector
---@param Vector_1 Vector
---@return void
function CDOTAGamerules:SetWeatherWindDirection(Vector_1) end

---Item whitelist functionality enable/disable
---@param bool_1 boolean
---@return void
function CDOTAGamerules:SetWhiteListEnabled(bool_1) end

---Are blacklisted heroes hidden, or just dimmed, in hero picking?
---@return boolean
function CDOTAGamerules:ShouldHideBlacklistedHeroes() end

---Spawn and release the next creep wave from Dota lane style spawners.
---@return void
function CDOTAGamerules:SpawnAndReleaseCreeps() end

---Spawn and release the next set of neutral camps.
---@return void
function CDOTAGamerules:SpawnNeutralCreeps() end

---Get the current Gamerules state
---@return number
function CDOTAGamerules:State_Get() end

---@class CDOTATutorial
---@type CDOTATutorial
Tutorial = CDOTATutorial
---Add a computer controlled bot.
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param bool_4 boolean
---@return boolean
function CDOTATutorial:AddBot(string_1, string_2, string_3, bool_4) end

---Add a quest to the quest log
---@param string_1 string
---@param int_2 number
---@param string_3 string
---@param string_4 string
---@return void
function CDOTATutorial:AddQuest(string_1, int_2, string_3, string_4) end

---Add an item to the shop whitelist.
---@param string_1 string
---@return void
function CDOTATutorial:AddShopWhitelistItem(string_1) end

---Complete a quest,
---@param string_1 string
---@return void
function CDOTATutorial:CompleteQuest(string_1) end

---Add a task to move to a specific location
---@param Vector_1 Vector
---@return void
function CDOTATutorial:CreateLocationTask(Vector_1) end

---Alert the player when a creep becomes agro to their hero.
---@param bool_1 boolean
---@return void
function CDOTATutorial:EnableCreepAggroViz(bool_1) end

---Enable the tip to alert players how to find their hero.
---@param bool_1 boolean
---@return void
function CDOTATutorial:EnablePlayerOffscreenTip(bool_1) end

---Alert the player when a tower becomes agro to their hero.
---@param bool_1 boolean
---@return void
function CDOTATutorial:EnableTowerAggroViz(bool_1) end

---End the tutorial.
---@return void
function CDOTATutorial:FinishTutorial() end

---Force the start of the game.
---@return void
function CDOTATutorial:ForceGameStart() end

---Is our time frozen?
---@return boolean
function CDOTATutorial:GetTimeFrozen() end

---Is this item currently in the white list.
---@param string_1 string
---@return boolean
function CDOTATutorial:IsItemInWhiteList(string_1) end

---Remove an item from the shop whitelist.
---@param string_1 string
---@return void
function CDOTATutorial:RemoveShopWhitelistItem(string_1) end

---Select a hero for the local player
---@param string_1 string
---@return void
function CDOTATutorial:SelectHero(string_1) end

---Select the team for the local player
---@param string_1 string
---@return void
function CDOTATutorial:SelectPlayerTeam(string_1) end

---Set the current item guide.
---@param string_1 string
---@return void
function CDOTATutorial:SetItemGuide(string_1) end

---Set gold amount for the tutorial player. (int) GoldAmount, (bool) true=Set, false=Modify
---@param int_1 number
---@param bool_2 boolean
---@return void
function CDOTATutorial:SetOrModifyPlayerGold(int_1, bool_2) end

---Set players quick buy item.
---@param string_1 string
---@return void
function CDOTATutorial:SetQuickBuy(string_1) end

---Set the shop open or closed.
---@param bool_1 boolean
---@return void
function CDOTATutorial:SetShopOpen(bool_1) end

---Set if we should freeze time or not.
---@param bool_1 boolean
---@return void
function CDOTATutorial:SetTimeFrozen(bool_1) end

---Set a tutorial convar
---@param string_1 string
---@param string_2 string
---@return void
function CDOTATutorial:SetTutorialConvar(string_1, string_2) end

---Set the UI to use a reduced version to focus attention to specific elements.
---@param int_1 number
---@return void
function CDOTATutorial:SetTutorialUI(int_1) end

---Set if we should whitelist shop items.
---@param bool_1 boolean
---@return void
function CDOTATutorial:SetWhiteListEnabled(bool_1) end

---Initialize Tutorial Mode
---@return void
function CDOTATutorial:StartTutorialMode() end

---Upgrade a specific ability for the local hero
---@param string_1 string
---@return void
function CDOTATutorial:UpgradePlayerAbility(string_1) end

---@class CDOTAVoteSystem
---Starts a vote, based upon a table of parameters
---@param handle_1 handle
---@return void
function CDOTAVoteSystem:StartVote(handle_1) end

---@class CDOTA_Ability_Aghanim_Spear
---Launch Spear to a target position from a source position
---@param vTarget Vector
---@param vStart Vector
---@return void
function CDOTA_Ability_Aghanim_Spear:LaunchSpear(vTarget, vStart) end

---@class CDOTA_Ability_Animation_Attack : CDOTABaseAbility
---Override playbackrate
---@param flRate number
---@return void
function CDOTA_Ability_Animation_Attack:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_Animation_TailSpin : CDOTABaseAbility
---Override playbackrate
---@param flRate number
---@return void
function CDOTA_Ability_Animation_TailSpin:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_DataDriven : CDOTABaseAbility
---Applies a data driven modifier to the target
---@param hCaster handle
---@param hTarget handle
---@param pszModifierName string
---@param hModifierTable handle
---@return handle
function CDOTA_Ability_DataDriven:ApplyDataDrivenModifier(hCaster, hTarget, pszModifierName, hModifierTable) end

---Applies a data driven thinker at the location
---@param hCaster handle
---@param vLocation Vector
---@param pszModifierName string
---@param hModifierTable handle
---@return handle
function CDOTA_Ability_DataDriven:ApplyDataDrivenThinker(hCaster, vLocation, pszModifierName, hModifierTable) end

---@class CDOTA_Ability_Lua : CDOTABaseAbility
---Determine whether an issued command with no target is valid.
---@return number
function CDOTA_Ability_Lua:CastFilterResult() end

---(Vector vLocation) Determine whether an issued command on a location is valid.
---@param vLocation Vector
---@return number
function CDOTA_Ability_Lua:CastFilterResultLocation(vLocation) end

---(HSCRIPT hTarget) Determine whether an issued command on a target is valid.
---@param hTarget handle
---@return number
function CDOTA_Ability_Lua:CastFilterResultTarget(hTarget) end

---Controls the size of the AOE casting cursor.
---@return number
function CDOTA_Ability_Lua:GetAOERadius() end

---Allows code overriding of the ability texture shown in the HUD.
---@return string
function CDOTA_Ability_Lua:GetAbilityTextureName() end

---Returns abilities that are stolen simultaneously, or otherwise related in functionality.
---@return string
function CDOTA_Ability_Lua:GetAssociatedPrimaryAbilities() end

---Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities.
---@return string
function CDOTA_Ability_Lua:GetAssociatedSecondaryAbilities() end

---Return cast behavior type of this ability.
---@return uint64
function CDOTA_Ability_Lua:GetBehavior() end

---Return casting animation of this ability.
---@return number
function CDOTA_Ability_Lua:GetCastAnimation() end

---Return cast point of this ability.
---@return number
function CDOTA_Ability_Lua:GetCastPoint() end

---Return cast range of this ability.
---@param vLocation Vector
---@param hTarget handle
---@return number
function CDOTA_Ability_Lua:GetCastRange(vLocation, hTarget) end

---
---@param hTarget handle
---@param iPseudoCastRange number
---@return number
function CDOTA_Ability_Lua:GetCastRangeBonus(hTarget, iPseudoCastRange) end

---Return channel animation of this ability.
---@return number
function CDOTA_Ability_Lua:GetChannelAnimation() end

---Return the channel time of this ability.
---@return number
function CDOTA_Ability_Lua:GetChannelTime() end

---Return mana cost at the given level per second while channeling (-1 is current).
---@param iLevel number
---@return number
function CDOTA_Ability_Lua:GetChannelledManaCostPerSecond(iLevel) end

---Return who hears speech when this spell is cast.
---@return number
function CDOTA_Ability_Lua:GetConceptRecipientType() end

---Return cooldown of this ability.
---@param iLevel number
---@return number
function CDOTA_Ability_Lua:GetCooldown(iLevel) end

---Return the error string of a failed command with no target.
---@return string
function CDOTA_Ability_Lua:GetCustomCastError() end

---(Vector vLocation) Return the error string of a failed command on a location.
---@param vLocation Vector
---@return string
function CDOTA_Ability_Lua:GetCustomCastErrorLocation(vLocation) end

---(HSCRIPT hTarget) Return the error string of a failed command on a target.
---@param hTarget handle
---@return string
function CDOTA_Ability_Lua:GetCustomCastErrorTarget(hTarget) end

---Return cast range of this ability, accounting for modifiers.
---@param vLocation Vector
---@param hTarget handle
---@return number
function CDOTA_Ability_Lua:GetEffectiveCastRange(vLocation, hTarget) end

---Return gold cost at the given level (-1 is current).
---@param iLevel number
---@return number
function CDOTA_Ability_Lua:GetGoldCost(iLevel) end

---返回此技能被动给予的修饰器的名称
---@return string
function CDOTA_Ability_Lua:GetIntrinsicModifierName() end

---Return mana cost at the given level (-1 is current).
---@param iLevel number
---@return number
function CDOTA_Ability_Lua:GetManaCost(iLevel) end

---Return the animation rate of the cast animation.
---@return number
function CDOTA_Ability_Lua:GetPlaybackRateOverride() end

---Is this a cosmetic only ability?
---@param hEntity handle
---@return boolean
function CDOTA_Ability_Lua:IsCosmetic(hEntity) end

---Returns true if this ability can be used when not on the action panel.
---@return boolean
function CDOTA_Ability_Lua:IsHiddenAbilityCastable() end

---Returns true if this ability is hidden when stolen by Spell Steal.
---@return boolean
function CDOTA_Ability_Lua:IsHiddenWhenStolen() end

---Returns true if this ability is refreshed by Refresher Orb.
---@return boolean
function CDOTA_Ability_Lua:IsRefreshable() end

---Returns true if this ability can be stolen by Spell Steal.
---@return boolean
function CDOTA_Ability_Lua:IsStealable() end

---Cast time did not complete successfully.
---@return void
function CDOTA_Ability_Lua:OnAbilityPhaseInterrupted() end

---Cast time begins (return true for successful cast).
---@return boolean
function CDOTA_Ability_Lua:OnAbilityPhaseStart() end

---The ability was pinged (nPlayerID, bCtrlHeld).
---@param nPlayerID number
---@param bCtrlHeld boolean
---@return void
function CDOTA_Ability_Lua:OnAbilityPinged(nPlayerID, bCtrlHeld) end

---(bool bInterrupted) Channel finished.
---@param bInterrupted boolean
---@return void
function CDOTA_Ability_Lua:OnChannelFinish(bInterrupted) end

---(float flInterval) Channeling is taking place.
---@param flInterval number
---@return void
function CDOTA_Ability_Lua:OnChannelThink(flInterval) end

---Caster (hero only) gained a level, skilled an ability, or received a new stat bonus.
---@return void
function CDOTA_Ability_Lua:OnHeroCalculateStatBonus() end

---A hero has died in the vicinity (ie Urn), takes table of params.
---@param unit handle
---@param attacker handle
---@param table handle
---@return void
function CDOTA_Ability_Lua:OnHeroDiedNearby(unit, attacker, table) end

---Caster gained a level.
---@return void
function CDOTA_Ability_Lua:OnHeroLevelUp() end

---当技能拥有者物品栏中的物品发生变化时触发。物品移动物品栏位置或移动到储藏处时会触发一次，丢下和拾取物品时会额外触发一次。
---@return void
function CDOTA_Ability_Lua:OnInventoryContentsChanged() end

---当技能拥有者装备一件物品时触发
---@param hItem handle
---@return void
function CDOTA_Ability_Lua:OnItemEquipped(hItem) end

---Caster died.
---@return void
function CDOTA_Ability_Lua:OnOwnerDied() end

---Caster respawned or spawned for the first time.
---@return void
function CDOTA_Ability_Lua:OnOwnerSpawned() end

---(HSCRIPT hTarget, Vector vLocation) Projectile has collided with a given target or reached its destination (target is invalid).
---@param hTarget CDOTA_BaseNPC
---@param vLocation Vector
---@return boolean
function CDOTA_Ability_Lua:OnProjectileHit(hTarget, vLocation) end

---(HSCRIPT hTarget, Vector vLocation, int nHandle) 带投射物ID的投射物命中 (target is invalid).
---@param hTarget handle
---@param vLocation Vector
---@param iProjectileHandle number
---@return boolean
function CDOTA_Ability_Lua:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle) end

---当投射物命中目标或者到达最远距离（此时hTarget为无效值）
---@param hTarget handle
---@param vLocation Vector
---@param ExtraData handle
---@return boolean
function CDOTA_Ability_Lua:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData) end

---(Vector vLocation) Projectile is actively moving.
---@param vLocation Vector
---@return void
function CDOTA_Ability_Lua:OnProjectileThink(vLocation) end

---(int nProjectileHandle) Projectile is actively moving.
---@param iProjectileHandle number
---@return void
function CDOTA_Ability_Lua:OnProjectileThinkHandle(iProjectileHandle) end

---(Vector vLocation, table kv ) Projectile is actively moving.
---@param vLocation Vector
---@param table handle
---@return void
function CDOTA_Ability_Lua:OnProjectileThink_ExtraData(vLocation, table) end

---Cast time finished, spell effects begin.
---@return void
function CDOTA_Ability_Lua:OnSpellStart() end

---( HSCRIPT hAbility ) Special behavior when stolen by Spell Steal.
---@param hSourceAbility handle
---@return void
function CDOTA_Ability_Lua:OnStolen(hSourceAbility) end

---Ability is toggled on/off.
---@return void
function CDOTA_Ability_Lua:OnToggle() end

---Special behavior when lost by Spell Steal.
---@return void
function CDOTA_Ability_Lua:OnUnStolen() end

---Ability gained a level.
---@return void
function CDOTA_Ability_Lua:OnUpgrade() end

---
---@return boolean
function CDOTA_Ability_Lua:OtherAbilitiesAlwaysInterruptChanneling() end

---Returns true if this ability will generate magic stick charges for nearby enemies.
---@return boolean
function CDOTA_Ability_Lua:ProcsMagicStick() end

---Does this ability need the caster to face the target before executing?
---@return boolean
function CDOTA_Ability_Lua:RequiresFacing() end

---Returns true if this ability should return to the default toggle state when its parent respawns.
---@return boolean
function CDOTA_Ability_Lua:ResetToggleOnRespawn() end

---Return the type of speech used.
---@return number
function CDOTA_Ability_Lua:SpeakTrigger() end

---@class CDOTA_Ability_Nian_Dive : CDOTABaseAbility
---Override playbackrate
---@param flRate number
---@return void
function CDOTA_Ability_Nian_Dive:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_Nian_Leap : CDOTABaseAbility
---Override playbackrate
---@param flRate number
---@return void
function CDOTA_Ability_Nian_Leap:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_Nian_Roar : CDOTABaseAbility
---Number of times Nian has used the roar
---@return number
function CDOTA_Ability_Nian_Roar:GetCastCount() end

---@class CDOTA_BaseNPC : CBaseFlex
---给单位添加技能
---@param sAbilityName string
---@return CDOTABaseAbility
function CDOTA_BaseNPC:AddAbility(sAbilityName) end

---添加一个activity modifier，该activity modifier会影响以后的StartGesture的调用。该值可以在模型编辑器中模型动作的Activities查看。
---@param sName string
---@return void
function CDOTA_BaseNPC:AddActivityModifier(sName) end

---给单位添加一个物品
---@param hItem CDOTA_Item
---@return CDOTA_Item
function CDOTA_BaseNPC:AddItem(hItem) end

---给单位添加一个物品，直接传入物品名字即可，返回创建的物品实体。
---@param sItemName string
---@return CDOTA_Item
function CDOTA_BaseNPC:AddItemByName(sItemName) end

---给一个单位添加modifier，hModifierTable可以传入持续时间和其他自定义参数，自定义参数可以在modifier的server端获得。
---@param hCaster CDOTA_BaseNPC
---@param hAbility CDOTABaseAbility
---@param pszScriptName string
---@param hModifierTable table
---@return handle
function CDOTA_BaseNPC:AddNewModifier(hCaster, hAbility, pszScriptName, hModifierTable) end

---添加不渲染的标记，使该单位不显示。比如黑鸟的关。
---@return void
function CDOTA_BaseNPC:AddNoDraw() end

---Add a speech bubble(1-4 live at a time) to this NPC.
---@param iBubble number
---@param pszSpeech string
---@param flDuration number
---@param unOffsetX unsigned
---@param unOffsetY unsigned
---@return void
function CDOTA_BaseNPC:AddSpeechBubble(iBubble, pszSpeech, flDuration, unOffsetX, unOffsetY) end

---
---@param hAttacker handle
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:AlertNearbyUnits(hAttacker, hAbility) end

---
---@return void
function CDOTA_BaseNPC:AngerNearbyUnits() end

---
---@param flTime number
---@param flTimeDisparityTolerance number
---@return void
function CDOTA_BaseNPC:AttackNoEarlierThan(flTime, flTimeDisparityTolerance) end

---
---@return boolean
function CDOTA_BaseNPC:AttackReady() end

---
---@return number
function CDOTA_BaseNPC:BoundingRadius2D() end

---
---@return void
function CDOTA_BaseNPC:CalculateGenericBonuses() end

---
---@return boolean
function CDOTA_BaseNPC:CanBeSeenByAnyOpposingTeam() end

---Check FoW to see if an entity is visible.
---@param hEntity handle
---@return boolean
function CDOTA_BaseNPC:CanEntityBeSeenByMyTeam(hEntity) end

---Query if this unit can sell items.
---@return boolean
function CDOTA_BaseNPC:CanSellItems() end

---Cast an ability immediately.
---@param hAbility handle
---@param iPlayerIndex number
---@return void
function CDOTA_BaseNPC:CastAbilityImmediately(hAbility, iPlayerIndex) end

---Cast an ability with no target.
---@param hAbility handle
---@param iPlayerIndex number
---@return void
function CDOTA_BaseNPC:CastAbilityNoTarget(hAbility, iPlayerIndex) end

---Cast an ability on a position.
---@param vPosition Vector
---@param hAbility handle
---@param iPlayerIndex number
---@return void
function CDOTA_BaseNPC:CastAbilityOnPosition(vPosition, hAbility, iPlayerIndex) end

---Cast an ability on a target entity.
---@param hTarget handle
---@param hAbility handle
---@param iPlayerIndex number
---@return void
function CDOTA_BaseNPC:CastAbilityOnTarget(hTarget, hAbility, iPlayerIndex) end

---Toggle an ability.
---@param hAbility handle
---@param iPlayerIndex number
---@return void
function CDOTA_BaseNPC:CastAbilityToggle(hAbility, iPlayerIndex) end

---
---@param iTeamNum number
---@return void
function CDOTA_BaseNPC:ChangeTeam(iTeamNum) end

---Clear Activity modifiers
---@return void
function CDOTA_BaseNPC:ClearActivityModifiers() end

---
---@return void
function CDOTA_BaseNPC:DestroyAllSpeechBubbles() end

---Disassemble the passed item in this unit`s inventory.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:DisassembleItem(hItem) end

---Drop an item at a given point.
---@param vDest Vector
---@param hItem handle
---@return void
function CDOTA_BaseNPC:DropItemAtPosition(vDest, hItem) end

---Immediately drop a carried item at a given position.
---@param hItem handle
---@param vPosition Vector
---@return void
function CDOTA_BaseNPC:DropItemAtPositionImmediate(hItem, vPosition) end

---Drops the selected item out of this unit`s stash.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:EjectItemFromStash(hItem) end

---This unit will be set to face the target point.
---@param vTarget Vector
---@return void
function CDOTA_BaseNPC:FaceTowards(vTarget) end

---Fade and remove the given gesture activity.
---@param nActivity number
---@return void
function CDOTA_BaseNPC:FadeGesture(nActivity) end

---从单位身上寻找技能
---@param sAbilityName string
---@return handle
function CDOTA_BaseNPC:FindAbilityByName(sAbilityName) end

---Returns a table of all of the modifiers on the NPC.
---@return table
function CDOTA_BaseNPC:FindAllModifiers() end

---Returns a table of all of the modifiers on the NPC with the passed name (modifierName)
---@param pszScriptName string
---@return table
function CDOTA_BaseNPC:FindAllModifiersByName(pszScriptName) end

---Get handle to first item in inventory, else nil.
---@param pszItemName string
---@return handle
function CDOTA_BaseNPC:FindItemInInventory(pszItemName) end

---Return a handle to the modifier of the given name if found, else nil (string Name )
---@param pszScriptName string
---@return handle
function CDOTA_BaseNPC:FindModifierByName(pszScriptName) end

---Return a handle to the modifier of the given name from the passed caster if found, else nil ( string Name, hCaster )
---@param pszScriptName string
---@param hCaster handle
---@return handle
function CDOTA_BaseNPC:FindModifierByNameAndCaster(pszScriptName, hCaster) end

---Kill this unit immediately.
---@param bReincarnate boolean
---@return void
function CDOTA_BaseNPC:ForceKill(bReincarnate) end

---Play an activity once, and then go back to idle.
---@param nActivity number
---@return void
function CDOTA_BaseNPC:ForcePlayActivityOnce(nActivity) end

---通过技能索引值获取该单位身上的技能。
---@param iIndex number
---@return CDOTABaseAbility
function CDOTA_BaseNPC:GetAbilityByIndex(iIndex) end

---
---@return number
function CDOTA_BaseNPC:GetAbilityCount() end

---Gets the range at which this unit will auto-acquire.
---@return number
function CDOTA_BaseNPC:GetAcquisitionRange() end

---Combat involving this creature will have this weight added to the music calcuations.
---@return number
function CDOTA_BaseNPC:GetAdditionalBattleMusicWeight() end

---Returns this unit`s aggro target.
---@return handle
function CDOTA_BaseNPC:GetAggroTarget() end

---
---@return number
function CDOTA_BaseNPC:GetAttackAnimationPoint() end

---
---@return number
function CDOTA_BaseNPC:GetAttackCapability() end

---返回介于单位的最小和最大基础伤害之间的随机整数。
---@return number
function CDOTA_BaseNPC:GetAttackDamage() end

---Gets the attack range buffer.
---@return number
function CDOTA_BaseNPC:GetAttackRangeBuffer() end

---
---@return number
function CDOTA_BaseNPC:GetAttackSpeed() end

---
---@return handle
function CDOTA_BaseNPC:GetAttackTarget() end

---获取每秒攻击次数
---@return number
function CDOTA_BaseNPC:GetAttacksPerSecond() end

---返回攻击力的平均值（包括绿字）。
---@param hTarget handle
---@return number
function CDOTA_BaseNPC:GetAverageTrueAttackDamage(hTarget) end

---
---@return number
function CDOTA_BaseNPC:GetBaseAttackRange() end

---
---@return number
function CDOTA_BaseNPC:GetBaseAttackTime() end

---获取基础最大攻击力。
---@return number
function CDOTA_BaseNPC:GetBaseDamageMax() end

---获取基础最小攻击力。
---@return number
function CDOTA_BaseNPC:GetBaseDamageMin() end

---Returns the vision range before modifiers.
---@return number
function CDOTA_BaseNPC:GetBaseDayTimeVisionRange() end

---
---@return number
function CDOTA_BaseNPC:GetBaseHealthBarOffset() end

---获取基础生命回复。
---@return number
function CDOTA_BaseNPC:GetBaseHealthRegen() end

---获取基础魔抗。
---@return number
function CDOTA_BaseNPC:GetBaseMagicalResistanceValue() end

---Gets the base max health value.
---@return number
function CDOTA_BaseNPC:GetBaseMaxHealth() end

---获取基础移动速度。
---@return number
function CDOTA_BaseNPC:GetBaseMoveSpeed() end

---Returns the vision range after modifiers.
---@return number
function CDOTA_BaseNPC:GetBaseNightTimeVisionRange() end

---This Mana regen is derived from constant bonuses like Basilius.
---@return number
function CDOTA_BaseNPC:GetBonusManaRegen() end

---
---@param bAttack boolean
---@return number
function CDOTA_BaseNPC:GetCastPoint(bAttack) end

---
---@return number
function CDOTA_BaseNPC:GetCastRangeBonus() end

---Get clone source (Meepo Prime, if this is a Meepo)
---@return handle
function CDOTA_BaseNPC:GetCloneSource() end

---Returns the size of the collision padding around the hull.
---@return number
function CDOTA_BaseNPC:GetCollisionPadding() end

---
---@return number
function CDOTA_BaseNPC:GetCooldownReduction() end

---
---@return number
function CDOTA_BaseNPC:GetCreationTime() end

---Get the ability this unit is currently casting.
---@return handle
function CDOTA_BaseNPC:GetCurrentActiveAbility() end

---Gets the current vision range.
---@return number
function CDOTA_BaseNPC:GetCurrentVisionRange() end

---
---@return handle
function CDOTA_BaseNPC:GetCursorCastTarget() end

---
---@return Vector
function CDOTA_BaseNPC:GetCursorPosition() end

---
---@return boolean
function CDOTA_BaseNPC:GetCursorTargetingNothing() end

---Get the maximum attack damage of this unit.
---@return number
function CDOTA_BaseNPC:GetDamageMax() end

---Get the minimum attack damage of this unit.
---@return number
function CDOTA_BaseNPC:GetDamageMin() end

---Returns the vision range after modifiers.
---@return number
function CDOTA_BaseNPC:GetDayTimeVisionRange() end

---Get the XP bounty on this unit.
---@return number
function CDOTA_BaseNPC:GetDeathXP() end

---Attack speed expressed as constant value
---@return number
function CDOTA_BaseNPC:GetDisplayAttackSpeed() end

---
---@return number
function CDOTA_BaseNPC:GetEvasion() end

---
---@return handle
function CDOTA_BaseNPC:GetForceAttackTarget() end

---Get the gold bounty on this unit.
---@return number
function CDOTA_BaseNPC:GetGoldBounty() end

---
---@return number
function CDOTA_BaseNPC:GetHasteFactor() end

---返回单位已损失生命值。
---@return number
function CDOTA_BaseNPC:GetHealthDeficit() end

---Get the current health percent of the unit.
---@return number
function CDOTA_BaseNPC:GetHealthPercent() end

---
---@return number
function CDOTA_BaseNPC:GetHealthRegen() end

---Get the collision hull radius of this NPC.
---@return number
function CDOTA_BaseNPC:GetHullRadius() end

---Returns speed after all modifiers.
---@return number
function CDOTA_BaseNPC:GetIdealSpeed() end

---Returns speed after all modifiers, but excluding those that reduce speed.
---@return number
function CDOTA_BaseNPC:GetIdealSpeedNoSlows() end

---
---@return number
function CDOTA_BaseNPC:GetIncreasedAttackSpeed() end

---Returns the initial waypoint goal for this NPC.
---@return handle
function CDOTA_BaseNPC:GetInitialGoalEntity() end

---Get waypoint position for this NPC.
---@return Vector
function CDOTA_BaseNPC:GetInitialGoalPosition() end

---Returns nth item in inventory slot (index is zero based).
---@param i number
---@return CDOTA_Item
function CDOTA_BaseNPC:GetItemInSlot(i) end

---
---@return number
function CDOTA_BaseNPC:GetLastAttackTime() end

---Get the last time this NPC took damage
---@return number
function CDOTA_BaseNPC:GetLastDamageTime() end

---Get the last game time that this unit switched to/from idle state.
---@return number
function CDOTA_BaseNPC:GetLastIdleChangeTime() end

---Returns the level of this unit.
---@return number
function CDOTA_BaseNPC:GetLevel() end

---Returns current magical armor value.
---@return number
function CDOTA_BaseNPC:GetMagicalArmorValue() end

---Returns the player ID of the controlling player.
---@return number
function CDOTA_BaseNPC:GetMainControllingPlayer() end

---Get the mana on this unit.
---@return number
function CDOTA_BaseNPC:GetMana() end

---Get the percent of mana remaining.
---@return number
function CDOTA_BaseNPC:GetManaPercent() end

---
---@return number
function CDOTA_BaseNPC:GetManaRegen() end

---Get the maximum mana of this unit.
---@return number
function CDOTA_BaseNPC:GetMaxMana() end

---Get the maximum gold bounty for this unit.
---@return number
function CDOTA_BaseNPC:GetMaximumGoldBounty() end

---Get the minimum gold bounty for this unit.
---@return number
function CDOTA_BaseNPC:GetMinimumGoldBounty() end

---
---@return number
function CDOTA_BaseNPC:GetModelRadius() end

---How many modifiers does this unit have?
---@return number
function CDOTA_BaseNPC:GetModifierCount() end

---Get a modifier name by index.
---@param nIndex number
---@return string
function CDOTA_BaseNPC:GetModifierNameByIndex(nIndex) end

---Gets the stack count of a given modifier.
---@param pszScriptName string
---@param hCaster handle
---@return number
function CDOTA_BaseNPC:GetModifierStackCount(pszScriptName, hCaster) end

---
---@param flBaseSpeed number
---@param bReturnUnslowed boolean
---@return number
function CDOTA_BaseNPC:GetMoveSpeedModifier(flBaseSpeed, bReturnUnslowed) end

---Set whether this NPC is required to reach each goal entity, rather than being allowed to unkink their path.
---@return boolean
function CDOTA_BaseNPC:GetMustReachEachGoalEntity() end

---Get the name of this camp`s neutral spawner.
---@return string
function CDOTA_BaseNPC:GetNeutralSpawnerName() end

---If set to true, we will never attempt to move this unit to clear space, even when it unphases.
---@return boolean
function CDOTA_BaseNPC:GetNeverMoveToClearSpace() end

---Returns the vision range after modifiers.
---@return number
function CDOTA_BaseNPC:GetNightTimeVisionRange() end

---获取敌方的队伍编号
---@return number
function CDOTA_BaseNPC:GetOpposingTeamNumber() end

---Get the collision hull radius (including padding) of this NPC.
---@return number
function CDOTA_BaseNPC:GetPaddedCollisionRadius() end

---Returns base physical armor value.
---@return number
function CDOTA_BaseNPC:GetPhysicalArmorBaseValue() end

---Returns current physical armor value.
---@param bIgnoreBase boolean
---@return number
function CDOTA_BaseNPC:GetPhysicalArmorValue(false)(bIgnoreBase) end

---Returns the player that owns this unit.
---@return handle
function CDOTA_BaseNPC:GetPlayerOwner() end

---Get the owner player ID for this unit.
---@return number
function CDOTA_BaseNPC:GetPlayerOwnerID() end

---
---@return number
function CDOTA_BaseNPC:GetProjectileSpeed() end

---
---@param hNPC handle
---@return number
function CDOTA_BaseNPC:GetRangeToUnit(hNPC) end

---
---@return string
function CDOTA_BaseNPC:GetRangedProjectileName() end

---
---@return number
function CDOTA_BaseNPC:GetSecondsPerAttack() end

---
---@param bBaseOnly boolean
---@return number
function CDOTA_BaseNPC:GetSpellAmplification(bBaseOnly) end

---
---@return number
function CDOTA_BaseNPC:GetStatusResistance() end

---Get how much gold has been spent on ability upgrades.
---@return number
function CDOTA_BaseNPC:GetTotalPurchasedUpgradeGoldCost() end

---
---@return string
function CDOTA_BaseNPC:GetUnitLabel() end

---Get the name of this unit.
---@return string
function CDOTA_BaseNPC:GetUnitName() end

---Give mana to this unit, this can be used for mana gained by abilities or item usage.
---@param flMana number
---@return void
function CDOTA_BaseNPC:GiveMana(flMana) end

---See whether this unit has an ability by name.
---@param pszAbilityName string
---@return boolean
function CDOTA_BaseNPC:HasAbility(pszAbilityName) end

---
---@return boolean
function CDOTA_BaseNPC:HasAnyActiveAbilities() end

---
---@return boolean
function CDOTA_BaseNPC:HasAttackCapability() end

---
---@return boolean
function CDOTA_BaseNPC:HasFlyMovementCapability() end

---
---@return boolean
function CDOTA_BaseNPC:HasFlyingVision() end

---
---@return boolean
function CDOTA_BaseNPC:HasGroundMovementCapability() end

---Does this unit have an inventory.
---@return boolean
function CDOTA_BaseNPC:HasInventory() end

---See whether this unit has an item by name.
---@param pItemName string
---@return boolean
function CDOTA_BaseNPC:HasItemInInventory(pItemName) end

---Sees if this unit has a given modifier.
---@param pszScriptName string
---@return boolean
function CDOTA_BaseNPC:HasModifier(pszScriptName) end

---
---@return boolean
function CDOTA_BaseNPC:HasMovementCapability() end

---判断单位是否拥有阿哈利姆神杖升级效果
---@return boolean
function CDOTA_BaseNPC:HasScepter() end

---Heal this unit.
---@param flAmount number
---@param hInflictor handle
---@return void
function CDOTA_BaseNPC:Heal(flAmount, hInflictor) end

---Heal this unit (with more parameters)
---@param flAmount number
---@param hInflictor handle
---@param bLifesteal boolean
---@param bAmplify boolean
---@param hSource handle
---@param bSpellLifesteal boolean
---@return void
function CDOTA_BaseNPC:HealWithParams(flAmount, hInflictor, bLifesteal, bAmplify, hSource, bSpellLifesteal) end

---Hold position.
---@return void
function CDOTA_BaseNPC:Hold() end

---
---@return void
function CDOTA_BaseNPC:Interrupt() end

---
---@return void
function CDOTA_BaseNPC:InterruptChannel() end

---
---@param bFindClearSpace boolean
---@return void
function CDOTA_BaseNPC:InterruptMotionControllers(bFindClearSpace) end

---Is this unit alive?
---@return boolean
function CDOTA_BaseNPC:IsAlive() end

---Is this unit an Ancient?
---@return boolean
function CDOTA_BaseNPC:IsAncient() end

---
---@return boolean
function CDOTA_BaseNPC:IsAttackImmune() end

---
---@return boolean
function CDOTA_BaseNPC:IsAttacking() end

---
---@param hEntity handle
---@return boolean
function CDOTA_BaseNPC:IsAttackingEntity(hEntity) end

---Is this unit a Barracks?
---@return boolean
function CDOTA_BaseNPC:IsBarracks() end

---
---@return boolean
function CDOTA_BaseNPC:IsBlind() end

---
---@return boolean
function CDOTA_BaseNPC:IsBlockDisabled() end

---Is this unit a boss?
---@return boolean
function CDOTA_BaseNPC:IsBoss() end

---Is this unit a Boss Creature? (used by custom games)
---@return boolean
function CDOTA_BaseNPC:IsBossCreature() end

---Is this unit a building?
---@return boolean
function CDOTA_BaseNPC:IsBuilding() end

---Is this unit currently channeling a spell?
---@return boolean
function CDOTA_BaseNPC:IsChanneling() end

---Is this unit a clone? (Meepo)
---@return boolean
function CDOTA_BaseNPC:IsClone() end

---
---@return boolean
function CDOTA_BaseNPC:IsCommandRestricted() end

---Is this unit a considered a hero for targeting purposes?
---@return boolean
function CDOTA_BaseNPC:IsConsideredHero() end

---Is this unit controlled by any non-bot player?
---@return boolean
function CDOTA_BaseNPC:IsControllableByAnyPlayer() end

---Is this unit a courier?
---@return boolean
function CDOTA_BaseNPC:IsCourier() end

---Is this a Creature type NPC?
---@return boolean
function CDOTA_BaseNPC:IsCreature() end

---Is this unit a creep?
---@return boolean
function CDOTA_BaseNPC:IsCreep() end

---Is this unit a creep hero?
---@return boolean
function CDOTA_BaseNPC:IsCreepHero() end

---
---@return boolean
function CDOTA_BaseNPC:IsCurrentlyHorizontalMotionControlled() end

---
---@return boolean
function CDOTA_BaseNPC:IsCurrentlyVerticalMotionControlled() end

---
---@return boolean
function CDOTA_BaseNPC:IsDisarmed() end

---
---@return boolean
function CDOTA_BaseNPC:IsDominated() end

---
---@return boolean
function CDOTA_BaseNPC:IsEvadeDisabled() end

---Is this unit an Ancient?
---@return boolean
function CDOTA_BaseNPC:IsFort() end

---
---@return boolean
function CDOTA_BaseNPC:IsFrozen() end

---Is this a hero or hero illusion?
---@return boolean
function CDOTA_BaseNPC:IsHero() end

---
---@return boolean
function CDOTA_BaseNPC:IsHexed() end

---Is this creature currently idle?
---@return boolean
function CDOTA_BaseNPC:IsIdle() end

---
---@return boolean
function CDOTA_BaseNPC:IsIllusion() end

---Ask whether this unit is in range of the specified shop ( DOTA_SHOP_TYPE shop, bool bMustBePhysicallyNear
---@param nShopType number
---@param bPhysical boolean
---@return boolean
function CDOTA_BaseNPC:IsInRangeOfShop(nShopType, bPhysical) end

---Does this unit have an inventory.
---@return boolean
function CDOTA_BaseNPC:IsInventoryEnabled() end

---
---@return boolean
function CDOTA_BaseNPC:IsInvisible() end

---
---@return boolean
function CDOTA_BaseNPC:IsInvulnerable() end

---
---@return boolean
function CDOTA_BaseNPC:IsLowAttackPriority() end

---
---@return boolean
function CDOTA_BaseNPC:IsMagicImmune() end

---
---@return boolean
function CDOTA_BaseNPC:IsMovementImpaired() end

---Is this unit moving?
---@return boolean
function CDOTA_BaseNPC:IsMoving() end

---
---@return boolean
function CDOTA_BaseNPC:IsMuted() end

---Is this a neutral?
---@return boolean
function CDOTA_BaseNPC:IsNeutralUnitType() end

---
---@return boolean
function CDOTA_BaseNPC:IsNightmared() end

---
---@param nTeam number
---@return boolean
function CDOTA_BaseNPC:IsOpposingTeam(nTeam) end

---Is this unit a ward-type unit?
---@return boolean
function CDOTA_BaseNPC:IsOther() end

---
---@return boolean
function CDOTA_BaseNPC:IsOutOfGame() end

---Is this unit owned by any non-bot player?
---@return boolean
function CDOTA_BaseNPC:IsOwnedByAnyPlayer() end

---Is this a phantom unit?
---@return boolean
function CDOTA_BaseNPC:IsPhantom() end

---
---@return boolean
function CDOTA_BaseNPC:IsPhantomBlocker() end

---
---@return boolean
function CDOTA_BaseNPC:IsPhased() end

---
---@param vPosition Vector
---@param flRange number
---@return boolean
function CDOTA_BaseNPC:IsPositionInRange(vPosition, flRange) end

---Is this unit a ranged attacker?
---@return boolean
function CDOTA_BaseNPC:IsRangedAttacker() end

---Is this a real hero?
---@return boolean
function CDOTA_BaseNPC:IsRealHero() end

---
---@return boolean
function CDOTA_BaseNPC:IsReincarnating() end

---
---@return boolean
function CDOTA_BaseNPC:IsRooted() end

---Is this a shrine?
---@return boolean
function CDOTA_BaseNPC:IsShrine() end

---
---@return boolean
function CDOTA_BaseNPC:IsSilenced() end

---
---@return boolean
function CDOTA_BaseNPC:IsSpeciallyDeniable() end

---
---@return boolean
function CDOTA_BaseNPC:IsSpeciallyUndeniable() end

---
---@return boolean
function CDOTA_BaseNPC:IsStunned() end

---Is this unit summoned?
---@return boolean
function CDOTA_BaseNPC:IsSummoned() end

---
---@return boolean
function CDOTA_BaseNPC:IsTempestDouble() end

---Is this a tower?
---@return boolean
function CDOTA_BaseNPC:IsTower() end

---
---@return boolean
function CDOTA_BaseNPC:IsUnableToMiss() end

---
---@return boolean
function CDOTA_BaseNPC:IsUnselectable() end

---
---@return boolean
function CDOTA_BaseNPC:IsUntargetable() end

---Is this entity an Undying Zombie?
---@return boolean
function CDOTA_BaseNPC:IsZombie() end

---Kills this NPC, with the params Ability and Attacker.
---@param hAbility handle
---@param hAttacker handle
---@return void
function CDOTA_BaseNPC:Kill(hAbility, hAttacker) end

---
---@return void
function CDOTA_BaseNPC:MakeIllusion() end

---
---@return void
function CDOTA_BaseNPC:MakePhantomBlocker() end

---
---@param iTeam number
---@param flRadius number
---@return void
function CDOTA_BaseNPC:MakeVisibleDueToAttack(iTeam, flRadius) end

---
---@param iTeam number
---@param flDuration number
---@return void
function CDOTA_BaseNPC:MakeVisibleToTeam(iTeam, flDuration) end

---
---@return void
function CDOTA_BaseNPC:ManageModelChanges() end

---Sets the health to a specific value, with optional flags or inflictors.
---@param iDesiredHealthValue number
---@param hAbility handle
---@param bLethal boolean
---@param iAdditionalFlags number
---@return void
function CDOTA_BaseNPC:ModifyHealth(iDesiredHealthValue, hAbility, bLethal, iAdditionalFlags) end

---Move to follow a unit.
---@param hNPC handle
---@return void
function CDOTA_BaseNPC:MoveToNPC(hNPC) end

---Give an item to another unit.
---@param hNPC handle
---@param hItem handle
---@return void
function CDOTA_BaseNPC:MoveToNPCToGiveItem(hNPC, hItem) end

---Issue a Move-To command.
---@param vDest Vector
---@return void
function CDOTA_BaseNPC:MoveToPosition(vDest) end

---Issue an Attack-Move-To command.
---@param vDest Vector
---@return void
function CDOTA_BaseNPC:MoveToPositionAggressive(vDest) end

---Move to a target to attack.
---@param hTarget handle
---@return void
function CDOTA_BaseNPC:MoveToTargetToAttack(hTarget) end

---
---@return boolean
function CDOTA_BaseNPC:NoHealthBar() end

---
---@return boolean
function CDOTA_BaseNPC:NoTeamMoveTo() end

---
---@return boolean
function CDOTA_BaseNPC:NoTeamSelect() end

---
---@return boolean
function CDOTA_BaseNPC:NoUnitCollision() end

---
---@return boolean
function CDOTA_BaseNPC:NotOnMinimap() end

---
---@return boolean
function CDOTA_BaseNPC:NotOnMinimapForEnemies() end

---
---@param bOriginalModel boolean
---@return void
function CDOTA_BaseNPC:NotifyWearablesOfModelChange(bOriginalModel) end

---判断单位是否被禁用被动
---@return boolean
function CDOTA_BaseNPC:PassivesDisabled() end

---Issue a Patrol-To command.
---@param vDest Vector
---@return void
function CDOTA_BaseNPC:PatrolToPosition(vDest) end

---Performs an attack on a target.
---@param hTarget handle
---@param bUseCastAttackOrb boolean
---@param bProcessProcs boolean
---@param bSkipCooldown boolean
---@param bIgnoreInvis boolean
---@param bUseProjectile boolean
---@param bFakeAttack boolean
---@param bNeverMiss boolean
---@return void
function CDOTA_BaseNPC:PerformAttack(hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss) end

---Pick up a dropped item.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:PickupDroppedItem(hItem) end

---Pick up a rune.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:PickupRune(hItem) end

---Play a VCD on the NPC.
---@param pVCD string
---@return void
function CDOTA_BaseNPC:PlayVCD(pVCD) end

---
---@return boolean
function CDOTA_BaseNPC:ProvidesVision() end

---(bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions)
---@param bRemovePositiveBuffs boolean
---@param bRemoveDebuffs boolean
---@param bFrameOnly boolean
---@param bRemoveStuns boolean
---@param bRemoveExceptions boolean
---@return void
function CDOTA_BaseNPC:Purge(bRemovePositiveBuffs, bRemoveDebuffs, bFrameOnly, bRemoveStuns, bRemoveExceptions) end

---Queue a response system concept with the TLK_DOTA_CUSTOM concept, after a delay.
---@param flDelay number
---@param hCriteriaTable handle
---@param hCompletionCallbackFn handle
---@param hContext handle
---@param hCallbackInfo handle
---@return void
function CDOTA_BaseNPC:QueueConcept(flDelay, hCriteriaTable, hCompletionCallbackFn, hContext, hCallbackInfo) end

---Queue a response system concept with the TLK_DOTA_CUSTOM concept, after a delay, for the same team this speaker is on.
---@param flDelay number
---@param hCriteriaTable handle
---@param hCompletionCallbackFn handle
---@param hContext handle
---@param hCallbackInfo handle
---@return void
function CDOTA_BaseNPC:QueueTeamConcept(flDelay, hCriteriaTable, hCompletionCallbackFn, hContext, hCallbackInfo) end

---Queue a response system concept with the TLK_DOTA_CUSTOM concept, after a delay, for the same team this speaker is on. Is not played for spectators.
---@param flDelay number
---@param hCriteriaTable handle
---@param hCompletionCallbackFn handle
---@param hContext handle
---@param hCallbackInfo handle
---@return void
function CDOTA_BaseNPC:QueueTeamConceptNoSpectators(flDelay, hCriteriaTable, hCompletionCallbackFn, hContext, hCallbackInfo) end

---Remove mana from this unit, this can be used for involuntary mana loss, not for mana that is spent.
---@param flAmount number
---@return void
function CDOTA_BaseNPC:ReduceMana(flAmount) end

---Remove an ability from this unit by name.
---@param pszAbilityName string
---@return void
function CDOTA_BaseNPC:RemoveAbility(pszAbilityName) end

---通过指定技能实体删除单位身上的技能。需要注意技能的被动modifier不会自动销毁，需要手动删除。
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:RemoveAbilityByHandle(hAbility) end

---
---@param pszAbilityName string
---@return void
function CDOTA_BaseNPC:RemoveAbilityFromIndexByName(pszAbilityName) end

---(int targets [0=all, 1=enemy, 2=ally], bool bNow, bool bPermanent, bool bDeath)
---@param targets number
---@param bNow boolean
---@param bPermanent boolean
---@param bDeath boolean
---@return void
function CDOTA_BaseNPC:RemoveAllModifiers(targets, bNow, bPermanent, bDeath) end

---Removes all copies of a modifier.
---@param pszScriptName string
---@return void
function CDOTA_BaseNPC:RemoveAllModifiersOfName(pszScriptName) end

---Remove the given gesture activity.
---@param nActivity number
---@return void
function CDOTA_BaseNPC:RemoveGesture(nActivity) end

---
---@param hBuff handle
---@return void
function CDOTA_BaseNPC:RemoveHorizontalMotionController(hBuff) end

---Removes the passed item from this unit`s inventory and deletes it.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:RemoveItem(hItem) end

---Removes a modifier.
---@param pszScriptName string
---@return void
function CDOTA_BaseNPC:RemoveModifierByName(pszScriptName) end

---Removes a modifier that was cast by the given caster.
---@param pszScriptName string
---@param hCaster handle
---@return void
function CDOTA_BaseNPC:RemoveModifierByNameAndCaster(pszScriptName, hCaster) end

---Remove the no draw flag.
---@return void
function CDOTA_BaseNPC:RemoveNoDraw() end

---
---@param hBuff handle
---@return void
function CDOTA_BaseNPC:RemoveVerticalMotionController(hBuff) end

---Respawns the target unit if it can be respawned.
---@return void
function CDOTA_BaseNPC:RespawnUnit() end

---Gets this unit`s attack range after all modifiers.
---@return number
function CDOTA_BaseNPC:Script_GetAttackRange() end

---
---@return boolean
function CDOTA_BaseNPC:Script_IsDeniable() end

---Sells the passed item in this unit`s inventory.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:SellItem(hItem) end

---Set the ability by index.
---@param hAbility handle
---@param iIndex number
---@return void
function CDOTA_BaseNPC:SetAbilityByIndex(hAbility, iIndex) end

---
---@param nRange number
---@return void
function CDOTA_BaseNPC:SetAcquisitionRange(nRange) end

---Combat involving this creature will have this weight added to the music calcuations.
---@param flWeight number
---@return void
function CDOTA_BaseNPC:SetAdditionalBattleMusicWeight(flWeight) end

---Set this unit`s aggro target to a specified unit.
---@param hAggroTarget handle
---@return void
function CDOTA_BaseNPC:SetAggroTarget(hAggroTarget) end

---设置攻击类型0无攻击1近战2远程
---@param iAttackCapabilities number
---@return void
function CDOTA_BaseNPC:SetAttackCapability(iAttackCapabilities) end

---
---@param hAttackTarget handle
---@return void
function CDOTA_BaseNPC:SetAttacking(hAttackTarget) end

---
---@param flBaseAttackTime number
---@return void
function CDOTA_BaseNPC:SetBaseAttackTime(flBaseAttackTime) end

---Sets the maximum base damage.
---@param nMax number
---@return void
function CDOTA_BaseNPC:SetBaseDamageMax(nMax) end

---Sets the minimum base damage.
---@param nMin number
---@return void
function CDOTA_BaseNPC:SetBaseDamageMin(nMin) end

---
---@param flHealthRegen number
---@return void
function CDOTA_BaseNPC:SetBaseHealthRegen(flHealthRegen) end

---Sets base magical armor value.
---@param flMagicalResistanceValue number
---@return void
function CDOTA_BaseNPC:SetBaseMagicalResistanceValue(flMagicalResistanceValue) end

---
---@param flManaRegen number
---@return void
function CDOTA_BaseNPC:SetBaseManaRegen(flManaRegen) end

---Set a new base max health value.
---@param flBaseMaxHealth number
---@return void
function CDOTA_BaseNPC:SetBaseMaxHealth(flBaseMaxHealth) end

---
---@param iMoveSpeed number
---@return void
function CDOTA_BaseNPC:SetBaseMoveSpeed(iMoveSpeed) end

---Set whether or not this unit is allowed to sell items (bCanSellItems)
---@param bCanSell boolean
---@return void
function CDOTA_BaseNPC:SetCanSellItems(bCanSell) end

---设置玩家可以控制该单位，由于同队伍的碰撞检测较近，bSkipAdjustingPosition为true时，单位可能会被卡住。
---@param nPlayerID number
---@param bSkipAdjustingPosition boolean
---@return void
function CDOTA_BaseNPC:SetControllableByPlayer(nPlayerID, bSkipAdjustingPosition) end

---
---@param hEntity handle
---@return void
function CDOTA_BaseNPC:SetCursorCastTarget(hEntity) end

---
---@param vLocation Vector
---@return void
function CDOTA_BaseNPC:SetCursorPosition(vLocation) end

---
---@param bTargetingNothing boolean
---@return void
function CDOTA_BaseNPC:SetCursorTargetingNothing(bTargetingNothing) end

---在单位血条上显示指定的文字（支持本地化），可设置文字颜色。
---@param pLabel string
---@param r number
---@param g number
---@param b number
---@return void
function CDOTA_BaseNPC:SetCustomHealthLabel(pLabel, r, g, b) end

---Set the base vision range.
---@param iRange number
---@return void
function CDOTA_BaseNPC:SetDayTimeVisionRange(iRange) end

---Set the XP bounty on this unit.
---@param iXPBounty number
---@return void
function CDOTA_BaseNPC:SetDeathXP(iXPBounty) end

---
---@param flFollowRange number
---@return void
function CDOTA_BaseNPC:SetFollowRange(flFollowRange) end

---
---@param hNPC handle
---@return void
function CDOTA_BaseNPC:SetForceAttackTarget(hNPC) end

---
---@param hNPC handle
---@return void
function CDOTA_BaseNPC:SetForceAttackTargetAlly(hNPC) end

---Set if this unit has an inventory.
---@param bHasInventory boolean
---@return void
function CDOTA_BaseNPC:SetHasInventory(bHasInventory) end

---
---@param nOffset number
---@return void
function CDOTA_BaseNPC:SetHealthBarOffsetOverride(nOffset) end

---Set the collision hull radius of this NPC.
---@param flHullRadius number
---@return void
function CDOTA_BaseNPC:SetHullRadius(flHullRadius) end

---
---@param bIdleAcquire boolean
---@return void
function CDOTA_BaseNPC:SetIdleAcquire(bIdleAcquire) end

---Sets the initial waypoint goal for this NPC.
---@param hGoal handle
---@return void
function CDOTA_BaseNPC:SetInitialGoalEntity(hGoal) end

---Set waypoint position for this NPC.
---@param vPosition Vector
---@return void
function CDOTA_BaseNPC:SetInitialGoalPosition(vPosition) end

---Set the mana on this unit.
---@param flMana number
---@return void
function CDOTA_BaseNPC:SetMana(flMana) end

---Set the maximum mana of this unit.
---@param flMaxMana number
---@return void
function CDOTA_BaseNPC:SetMaxMana(flMaxMana) end

---Set the maximum gold bounty for this unit.
---@param iGoldBountyMax number
---@return void
function CDOTA_BaseNPC:SetMaximumGoldBounty(iGoldBountyMax) end

---Set the minimum gold bounty for this unit.
---@param iGoldBountyMin number
---@return void
function CDOTA_BaseNPC:SetMinimumGoldBounty(iGoldBountyMin) end

---Sets the stack count of a given modifier.
---@param pszScriptName string
---@param hCaster handle
---@param nStackCount number
---@return void
function CDOTA_BaseNPC:SetModifierStackCount(pszScriptName, hCaster, nStackCount) end

---
---@param iMoveCapabilities number
---@return void
function CDOTA_BaseNPC:SetMoveCapability(iMoveCapabilities) end

---Set whether this NPC is required to reach each goal entity, rather than being allowed to unkink their path.
---@param must boolean
---@return void
function CDOTA_BaseNPC:SetMustReachEachGoalEntity(must) end

---If set to true, we will never attempt to move this unit to clear space, even when it unphases.
---@param neverMoveToClearSpace boolean
---@return void
function CDOTA_BaseNPC:SetNeverMoveToClearSpace(neverMoveToClearSpace) end

---Returns the vision range after modifiers.
---@param iRange number
---@return void
function CDOTA_BaseNPC:SetNightTimeVisionRange(iRange) end

---Set the unit`s origin.
---@param vLocation Vector
---@return void
function CDOTA_BaseNPC:SetOrigin(vLocation) end

---Sets the original model of this entity, which it will tend to fall back to anytime its state changes.
---@param pszModelName string
---@return void
function CDOTA_BaseNPC:SetOriginalModel(pszModelName) end

---Sets base physical armor value.
---@param flPhysicalArmorValue number
---@return void
function CDOTA_BaseNPC:SetPhysicalArmorBaseValue(flPhysicalArmorValue) end

---
---@param pProjectileName string
---@return void
function CDOTA_BaseNPC:SetRangedProjectileName(pProjectileName) end

---sets the client side map reveal radius for this unit
---@param revealRadius number
---@return void
function CDOTA_BaseNPC:SetRevealRadius(revealRadius) end

---
---@param bShouldVisuallyFly boolean
---@return void
function CDOTA_BaseNPC:SetShouldDoFlyHeightVisual(bShouldVisuallyFly) end

---
---@param bStolenScepter boolean
---@return void
function CDOTA_BaseNPC:SetStolenScepter(bStolenScepter) end

---
---@param bCanRespawn boolean
---@return void
function CDOTA_BaseNPC:SetUnitCanRespawn(bCanRespawn) end

---
---@param pName string
---@return void
function CDOTA_BaseNPC:SetUnitName(pName) end

---
---@return boolean
function CDOTA_BaseNPC:ShouldIdleAcquire() end

---Speak a response system concept with the TLK_DOTA_CUSTOM concept.
---@param hCriteriaTable handle
---@return void
function CDOTA_BaseNPC:SpeakConcept(hCriteriaTable) end

---Spend mana from this unit, this can be used for spending mana from abilities or item usage.
---@param flManaSpent number
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:SpendMana(flManaSpent, hAbility) end

---Add the given gesture activity.
---@param nActivity number
---@return void
function CDOTA_BaseNPC:StartGesture(nActivity) end

---Add the given gesture activity faded according to its sequence settings.
---@param nActivity number
---@return void
function CDOTA_BaseNPC:StartGestureFadeWithSequenceSettings(nActivity) end

---Add the given gesture activity faded according to to the parameters.
---@param nActivity number
---@param fFadeIn number
---@param fFadeOut number
---@return void
function CDOTA_BaseNPC:StartGestureWithFade(nActivity, fFadeIn, fFadeOut) end

---Add the given gesture activity with a playback rate override.
---@param nActivity number
---@param flRate number
---@return void
function CDOTA_BaseNPC:StartGestureWithPlaybackRate(nActivity, flRate) end

---Stop the current order.
---@return void
function CDOTA_BaseNPC:Stop() end

---
---@return void
function CDOTA_BaseNPC:StopFacing() end

---Swaps the slots of the two passed abilities and sets them enabled/disabled.
---@param pAbilityName1 string
---@param pAbilityName2 string
---@param bEnable1 boolean
---@param bEnable2 boolean
---@return void
function CDOTA_BaseNPC:SwapAbilities(pAbilityName1, pAbilityName2, bEnable1, bEnable2) end

---Swap the contents of two item slots (slot1, slot2)
---@param nSlot1 number
---@param nSlot2 number
---@return void
function CDOTA_BaseNPC:SwapItems(nSlot1, nSlot2) end

---Removed the passed item from this unit`s inventory.
---@param hItem handle
---@return handle
function CDOTA_BaseNPC:TakeItem(hItem) end

---
---@return number
function CDOTA_BaseNPC:TimeUntilNextAttack() end

---
---@return boolean
function CDOTA_BaseNPC:TriggerModifierDodge() end

---
---@param hAbility handle
---@return boolean
function CDOTA_BaseNPC:TriggerSpellAbsorb(hAbility) end

---Trigger the Lotus Orb-like effect.(hAbility)
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:TriggerSpellReflect(hAbility) end

---Makes the first ability unhidden, and puts it where second ability currently is. Will do nothing if the first ability is already unhidden and in a valid slot.
---@param pszAbilityName string
---@param pszReplacedAbilityName string
---@return void
function CDOTA_BaseNPC:UnHideAbilityToSlot(pszAbilityName, pszReplacedAbilityName) end

---
---@return boolean
function CDOTA_BaseNPC:UnitCanRespawn() end

---
---@return boolean
function CDOTA_BaseNPC:WasKilledPassively() end

---@class CDOTA_BaseNPC_Building : CDOTA_BaseNPC
---Get the invulnerability count for a building.
---@return number
function CDOTA_BaseNPC_Building:GetInvulnCount() end

---Set the invulnerability counter of this building.
---@param nInvulnCount number
---@return void
function CDOTA_BaseNPC_Building:SetInvulnCount(nInvulnCount) end

---@class CDOTA_BaseNPC_Creature : CDOTA_BaseNPC
---Add the specified item drop to this creature.
---@param hDropData handle
---@return void
function CDOTA_BaseNPC_Creature:AddItemDrop(hDropData) end

---Level the creature up by the specified number of levels
---@param iLevels number
---@return void
function CDOTA_BaseNPC_Creature:CreatureLevelUp(iLevels) end

---Set creature`s current disable resistance
---@return number
function CDOTA_BaseNPC_Creature:GetDisableResistance() end

---Set creature`s current disable resistance from ultimates
---@return number
function CDOTA_BaseNPC_Creature:GetUltimateDisableResistance() end

---Is this unit a champion?
---@return boolean
function CDOTA_BaseNPC_Creature:IsChampion() end

---Is this creature respawning?
---@return boolean
function CDOTA_BaseNPC_Creature:IsReincarnating() end

---Remove all item drops from this creature.
---@return void
function CDOTA_BaseNPC_Creature:RemoveAllItemDrops() end

---Does this creature aggro on the owner of the attacking unit when taking damage?
---@param bAggro boolean
---@return void
function CDOTA_BaseNPC_Creature:SetAggroOnOwnerOnDamage(bAggro) end

---Set the armor gained per level on this creature.
---@param flArmorGain number
---@return void
function CDOTA_BaseNPC_Creature:SetArmorGain(flArmorGain) end

---Set the attack time gained per level on this creature.
---@param flAttackTimeGain number
---@return void
function CDOTA_BaseNPC_Creature:SetAttackTimeGain(flAttackTimeGain) end

---Set the bounty gold gained per level on this creature.
---@param nBountyGain number
---@return void
function CDOTA_BaseNPC_Creature:SetBountyGain(nBountyGain) end

---Flag this unit as a champion creature.
---@param bIsChampion boolean
---@return void
function CDOTA_BaseNPC_Creature:SetChampion(bIsChampion) end

---Set the damage gained per level on this creature.
---@param nDamageGain number
---@return void
function CDOTA_BaseNPC_Creature:SetDamageGain(nDamageGain) end

---Set creature`s current disable resistance
---@param flDisableResistance number
---@return void
function CDOTA_BaseNPC_Creature:SetDisableResistance(flDisableResistance) end

---Set the disable resistance gained per level on this creature.
---@param flDisableResistanceGain number
---@return void
function CDOTA_BaseNPC_Creature:SetDisableResistanceGain(flDisableResistanceGain) end

---Set the hit points gained per level on this creature.
---@param nHPGain number
---@return void
function CDOTA_BaseNPC_Creature:SetHPGain(nHPGain) end

---Set the hit points regen gained per level on this creature.
---@param flHPRegenGain number
---@return void
function CDOTA_BaseNPC_Creature:SetHPRegenGain(flHPRegenGain) end

---Set the magic resistance gained per level on this creature.
---@param flMagicResistanceGain number
---@return void
function CDOTA_BaseNPC_Creature:SetMagicResistanceGain(flMagicResistanceGain) end

---Set the mana points gained per level on this creature.
---@param nManaGain number
---@return void
function CDOTA_BaseNPC_Creature:SetManaGain(nManaGain) end

---Set the mana points regen gained per level on this creature.
---@param flManaRegenGain number
---@return void
function CDOTA_BaseNPC_Creature:SetManaRegenGain(flManaRegenGain) end

---Set the move speed gained per level on this creature.
---@param nMoveSpeedGain number
---@return void
function CDOTA_BaseNPC_Creature:SetMoveSpeedGain(nMoveSpeedGain) end

---Set whether creatures require reaching their end path before becoming idle
---@param bRequiresReachingEndPath boolean
---@return void
function CDOTA_BaseNPC_Creature:SetRequiresReachingEndPath(bRequiresReachingEndPath) end

---Set creature`s current disable resistance from ultimates
---@param flUltDisableResistance number
---@return void
function CDOTA_BaseNPC_Creature:SetUltimateDisableResistance(flUltDisableResistance) end

---Set the XP gained per level on this creature.
---@param nXPGain number
---@return void
function CDOTA_BaseNPC_Creature:SetXPGain(nXPGain) end

---@class CDOTA_BaseNPC_Hero : CDOTA_BaseNPC
---Params: Float XP, Bool applyBotDifficultyScaling
---@param flXP number
---@param nReason number
---@param bApplyBotDifficultyScaling boolean
---@param bIncrementTotal boolean
---@return boolean
function CDOTA_BaseNPC_Hero:AddExperience(flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal) end

---Spend the gold and buyback with this hero.
---@return void
function CDOTA_BaseNPC_Hero:Buyback() end

---Recalculate all stats after the hero gains stats.
---@param bForce boolean
---@return void
function CDOTA_BaseNPC_Hero:CalculateStatBonus(bForce) end

---Returns boolean value result of buyback gold limit time less than game time.
---@return boolean
function CDOTA_BaseNPC_Hero:CanEarnGold() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:ClearLastHitMultikill() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:ClearLastHitStreak() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:ClearStreak() end

---Gets the current unspent ability points.
---@return number
function CDOTA_BaseNPC_Hero:GetAbilityPoints() end

---
---@return table
function CDOTA_BaseNPC_Hero:GetAdditionalOwnedUnits() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetAgility() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetAgilityGain() end

---Value is stored in PlayerResource.
---@return number
function CDOTA_BaseNPC_Hero:GetAssists() end

---
---@param nIndex number
---@return number
function CDOTA_BaseNPC_Hero:GetAttacker(nIndex) end

---
---@return number
function CDOTA_BaseNPC_Hero:GetBaseAgility() end

---Hero damage is also affected by attributes.
---@return number
function CDOTA_BaseNPC_Hero:GetBaseDamageMax() end

---Hero damage is also affected by attributes.
---@return number
function CDOTA_BaseNPC_Hero:GetBaseDamageMin() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetBaseIntellect() end

---Returns the base mana regen.
---@return number
function CDOTA_BaseNPC_Hero:GetBaseManaRegen() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetBaseStrength() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetBonusDamageFromPrimaryStat() end

---Return float value for the amount of time left on cooldown for this hero`s buyback.
---@return number
function CDOTA_BaseNPC_Hero:GetBuybackCooldownTime() end

---Return integer value for the gold cost of a buyback.
---@param bReturnOldValues boolean
---@return number
function CDOTA_BaseNPC_Hero:GetBuybackCost(bReturnOldValues) end

---Returns the amount of time gold gain is limited after buying back.
---@return number
function CDOTA_BaseNPC_Hero:GetBuybackGoldLimitTime() end

---Returns the amount of XP 
---@return number
function CDOTA_BaseNPC_Hero:GetCurrentXP() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetDeathGoldCost() end

---Value is stored in PlayerResource.
---@return number
function CDOTA_BaseNPC_Hero:GetDeaths() end

---Value is stored in PlayerResource.
---@return number
function CDOTA_BaseNPC_Hero:GetDenies() end

---Returns gold amount for the player owning this hero
---@return number
function CDOTA_BaseNPC_Hero:GetGold() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetGoldBounty() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetHeroID() end

---Hero attack speed is also affected by agility.
---@return number
function CDOTA_BaseNPC_Hero:GetIncreasedAttackSpeed() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetIntellect(false) end

---
---@return number
function CDOTA_BaseNPC_Hero:GetIntellectGain() end

---Value is stored in PlayerResource.
---@return number
function CDOTA_BaseNPC_Hero:GetKills() end

---Value is stored in PlayerResource.
---@return number
function CDOTA_BaseNPC_Hero:GetLastHits() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetMostRecentDamageTime() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetMultipleKillCount() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetNumAttackers() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetNumItemsInInventory() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetNumItemsInStash() end

---Hero armor is affected by attributes.
---@return number
function CDOTA_BaseNPC_Hero:GetPhysicalArmorBaseValue() end

---Returns player ID of the player owning this hero
---@return number
function CDOTA_BaseNPC_Hero:GetPlayerID() end

---0 = strength, 1 = agility, 2 = intelligence.
---@return number
function CDOTA_BaseNPC_Hero:GetPrimaryAttribute() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetPrimaryStatValue() end

---
---@return handle
function CDOTA_BaseNPC_Hero:GetReplicatingOtherHero() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetRespawnTime() end

---Is this hero prevented from respawning?
---@return boolean
function CDOTA_BaseNPC_Hero:GetRespawnsDisabled() end

---Value is stored in PlayerResource.
---@return number
function CDOTA_BaseNPC_Hero:GetStreak() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetStrength() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetStrengthGain() end

---
---@return number
function CDOTA_BaseNPC_Hero:GetTimeUntilRespawn() end

---Get wearable entity in slot (slot)
---@param nSlotType number
---@return handle
function CDOTA_BaseNPC_Hero:GetTogglableWearable(nSlotType) end

---
---@return boolean
function CDOTA_BaseNPC_Hero:HasAnyAvailableInventorySpace() end

---
---@return boolean
function CDOTA_BaseNPC_Hero:HasFlyingVision() end

---
---@return boolean
function CDOTA_BaseNPC_Hero:HasOwnerAbandoned() end

---Args: const char* pItemName, bool bIncludeStashCombines, bool bAllowSelling
---@param pItemName string
---@param bIncludeStashCombines boolean
---@param bAllowSelling boolean
---@return number
function CDOTA_BaseNPC_Hero:HasRoomForItem(pItemName, bIncludeStashCombines, bAllowSelling) end

---Levels up the hero, true or false to play effects.
---@param bPlayEffects boolean
---@return void
function CDOTA_BaseNPC_Hero:HeroLevelUp(bPlayEffects) end

---Value is stored in PlayerResource.
---@param iKillerID number
---@return void
function CDOTA_BaseNPC_Hero:IncrementAssists(iKillerID) end

---Value is stored in PlayerResource.
---@param iKillerID number
---@return void
function CDOTA_BaseNPC_Hero:IncrementDeaths(iKillerID) end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementDenies() end

---Passed ID is for the victim, killer ID is ID of the current hero.  Value is stored in PlayerResource.
---@param iVictimID number
---@return void
function CDOTA_BaseNPC_Hero:IncrementKills(iVictimID) end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementLastHitMultikill() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementLastHitStreak() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementLastHits() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementNearbyCreepDeaths() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementStreak() end

---
---@return boolean
function CDOTA_BaseNPC_Hero:IsBuybackDisabledByReapersScythe() end

---
---@return boolean
function CDOTA_BaseNPC_Hero:IsReincarnating() end

---
---@return boolean
function CDOTA_BaseNPC_Hero:IsStashEnabled() end

---Args: Hero, Inflictor
---@param hHero handle
---@param hInflictor handle
---@return void
function CDOTA_BaseNPC_Hero:KilledHero(hHero, hInflictor) end

---Adds passed value to base attribute value, then calls CalculateStatBonus.
---@param flNewAgility number
---@return void
function CDOTA_BaseNPC_Hero:ModifyAgility(flNewAgility) end

---Gives this hero some gold.  Args: int nGoldChange, bool bReliable, int reason
---@param iGoldChange number
---@param bReliable boolean
---@param iReason number
---@return number
function CDOTA_BaseNPC_Hero:ModifyGold(iGoldChange, bReliable, iReason) end

---Adds passed value to base attribute value, then calls CalculateStatBonus.
---@param flNewIntellect number
---@return void
function CDOTA_BaseNPC_Hero:ModifyIntellect(flNewIntellect) end

---Adds passed value to base attribute value, then calls CalculateStatBonus.
---@param flNewStrength number
---@return void
function CDOTA_BaseNPC_Hero:ModifyStrength(flNewStrength) end

---
---@return void
function CDOTA_BaseNPC_Hero:PerformTaunt() end

---
---@return void
function CDOTA_BaseNPC_Hero:RecordLastHit() end

---Respawn this hero.
---@param bBuyBack boolean
---@param bRespawnPenalty boolean
---@return void
function CDOTA_BaseNPC_Hero:RespawnHero(bBuyBack, bRespawnPenalty) end

---Gives this hero some gold, using the gold filter if extra filtering is on.  Args: int nGoldChange, bool bReliable, int reason
---@param iGoldChange number
---@param bReliabe boolean
---@param iReason number
---@return number
function CDOTA_BaseNPC_Hero:Script_ModifyGoldFiltered(iGoldChange, bReliabe, iReason) end

---Sets the current unspent ability points.
---@param iPoints number
---@return void
function CDOTA_BaseNPC_Hero:SetAbilityPoints(iPoints) end

---
---@param flAgility number
---@return void
function CDOTA_BaseNPC_Hero:SetBaseAgility(flAgility) end

---
---@param flIntellect number
---@return void
function CDOTA_BaseNPC_Hero:SetBaseIntellect(flIntellect) end

---
---@param flStrength number
---@return void
function CDOTA_BaseNPC_Hero:SetBaseStrength(flStrength) end

---
---@param nDifficulty number
---@return void
function CDOTA_BaseNPC_Hero:SetBotDifficulty(nDifficulty) end

---
---@param bBuybackDisabled boolean
---@return void
function CDOTA_BaseNPC_Hero:SetBuyBackDisabledByReapersScythe(bBuybackDisabled) end

---Sets the buyback cooldown time.
---@param flTime number
---@return void
function CDOTA_BaseNPC_Hero:SetBuybackCooldownTime(flTime) end

---Set the amount of time gold gain is limited after buying back.
---@param flTime number
---@return void
function CDOTA_BaseNPC_Hero:SetBuybackGoldLimitTime(flTime) end

---Sets a custom experience value for this hero.  Note, GameRules boolean must be set for this to work!
---@param iValue number
---@return void
function CDOTA_BaseNPC_Hero:SetCustomDeathXP(iValue) end

---Sets the gold amount for the player owning this hero
---@param iGold number
---@param bReliable boolean
---@return void
function CDOTA_BaseNPC_Hero:SetGold(iGold, bReliable) end

---
---@param iPlayerID number
---@return void
function CDOTA_BaseNPC_Hero:SetPlayerID(iPlayerID) end

---Set this hero`s primary attribute value.
---@param nPrimaryAttribute number
---@return void
function CDOTA_BaseNPC_Hero:SetPrimaryAttribute(nPrimaryAttribute) end

---
---@param vOrigin Vector
---@return void
function CDOTA_BaseNPC_Hero:SetRespawnPosition(vOrigin) end

---Prevent this hero from respawning.
---@param bDisableRespawns boolean
---@return void
function CDOTA_BaseNPC_Hero:SetRespawnsDisabled(bDisableRespawns) end

---
---@param bEnabled boolean
---@return void
function CDOTA_BaseNPC_Hero:SetStashEnabled(bEnabled) end

---
---@param time number
---@return void
function CDOTA_BaseNPC_Hero:SetTimeUntilRespawn(time) end

---
---@return boolean
function CDOTA_BaseNPC_Hero:ShouldDoFlyHeightVisual() end

---Args: int nGold, int nReason
---@param iCost number
---@param iReason number
---@return void
function CDOTA_BaseNPC_Hero:SpendGold(iCost, iReason) end

---如果存在该技能并且英雄拥有足够的技能点，将会升级该技能。测试中发现似乎不会刷新被动modifier[2021/4/16]
---@param hAbility handle
---@return void
function CDOTA_BaseNPC_Hero:UpgradeAbility(hAbility) end

---
---@return boolean
function CDOTA_BaseNPC_Hero:WillReincarnate() end

---@class CDOTA_BaseNPC_Shop : CDOTA_BaseNPC_Building
---Get the DOTA_SHOP_TYPE
---@return number
function CDOTA_BaseNPC_Shop:GetShopType() end

---Set the DOTA_SHOP_TYPE.
---@param eShopType number
---@return void
function CDOTA_BaseNPC_Shop:SetShopType(eShopType) end

---@class CDOTA_BaseNPC_Trap_Ward : CDOTA_BaseNPC_Creature
---Get the trap target for this entity.
---@return Vector
function CDOTA_BaseNPC_Trap_Ward:GetTrapTarget() end

---Set the animation sequence for this entity.
---@param pAnimation string
---@return void
function CDOTA_BaseNPC_Trap_Ward:SetAnimation(pAnimation) end

---@class CDOTA_BaseNPC_Watch_Tower
---The name of the ability used when triggering interaction on the outpost.
---@return string
function CDOTA_BaseNPC_Watch_Tower:GetInteractAbilityName() end

---The name of the ability used when triggering interaction on the outpost.
---@param pszInteractAbilityName string
---@return void
function CDOTA_BaseNPC_Watch_Tower:SetInteractAbilityName(pszInteractAbilityName) end

---@class CDOTA_Buff
---将一个特效绑定在modifier上，该特效会在modifier销毁时一起删除。
---@param iParticleID number
---@param bDestroyImmediately boolean
---@param bStatusEffect boolean
---@param iPriority number
---@param bHeroEffect boolean
---@param bOverheadEffect boolean
---@return void
function CDOTA_Buff:AddParticle(iParticleID, bDestroyImmediately, bStatusEffect, iPriority, bHeroEffect, bOverheadEffect) end

---
---@param table handle
---@return void
function CDOTA_Buff:CheckStateToTable(table) end

---减少一层叠加层数。
---@return void
function CDOTA_Buff:DecrementStackCount() end

---运行所有关联的destroy函数，然后删除modifier。
---@return void
function CDOTA_Buff:Destroy() end

---modifier到期后是否销毁
---@return boolean
function CDOTA_Buff:DestroyOnExpire() end

---在此modifier上运行所有关联的刷新功能，就像重新添加它一样。
---@return void
function CDOTA_Buff:ForceRefresh() end

---获取该modifier的来源技能。
---@return CDOTA_Ability_Lua
function CDOTA_Buff:GetAbility() end

---返回光环粘滞时间（默认0.5秒）
---@return number
function CDOTA_Buff:GetAuraDuration() end

---获取光环来源单位
---@return handle
function CDOTA_Buff:GetAuraOwner() end

---获取该modifier的来源单位。
---@return CDOTA_BaseNPC
function CDOTA_Buff:GetCaster() end

---
---@return string
function CDOTA_Buff:GetClass() end

---获取创建时间。
---@return number
function CDOTA_Buff:GetCreationTime() end

---返回修改器的过期时间。
---@return number
function CDOTA_Buff:GetDieTime() end

---获取该modifier的持续时间。
---@return number
function CDOTA_Buff:GetDuration() end

---返回自创建修改器后经过的时间。
---@return number
function CDOTA_Buff:GetElapsedTime() end

---获取上次应用时间。
---@return number
function CDOTA_Buff:GetLastAppliedTime() end

---获取该modifier的名字。
---@return string
function CDOTA_Buff:GetName() end

---获取modifier的作用单位。
---@return CDOTA_BaseNPC
function CDOTA_Buff:GetParent() end

---获取剩余时间。
---@return number
function CDOTA_Buff:GetRemainingTime() end

---获取序列号
---@return number
function CDOTA_Buff:GetSerialNumber() end

---获取modifier层数
---@return number
function CDOTA_Buff:GetStackCount() end

---判断是否拥有某个modifierfunction
---@param iFunction number
---@return boolean
function CDOTA_Buff:HasFunction(iFunction) end

---增加一层叠加层数。
---@return void
function CDOTA_Buff:IncrementStackCount() end

---是否是负面buff
---@return boolean
function CDOTA_Buff:IsDebuff() end

---是否是妖术负面buff
---@return boolean
function CDOTA_Buff:IsHexDebuff() end

---是否是晕眩负面buff
---@return boolean
function CDOTA_Buff:IsStunDebuff() end

---通知客户端刷新modifier
---@return void
function CDOTA_Buff:SendBuffRefreshToClients() end

---设置持续时间
---@param flDuration number
---@param bInformClient boolean
---@return void
function CDOTA_Buff:SetDuration(flDuration, bInformClient) end

---
---@param flOffset number
---@return boolean
function CDOTA_Buff:SetOverheadEffectOffset(flOffset) end

---设置叠加层数
---@param iCount number
---@return void
function CDOTA_Buff:SetStackCount(iCount) end

---以给定的间隔启动此修改器的计时器功能（OnIntervalThink）。 传入-1停止该计时器。
---@param flInterval number
---@return void
function CDOTA_Buff:StartIntervalThink(flInterval) end

---@class CDOTA_CustomUIManager
---@type CDOTA_CustomUIManager
CustomUI = CDOTA_CustomUIManager
---Create a new custom UI HUD element for the specified player(s). ( int PlayerID /*-1 means everyone*/, string ElementID /* should be unique */, string LayoutFileName, table DialogVariables /* can be nil */ )
---@param int_1 number
---@param string_2 string
---@param string_3 string
---@param handle_4 handle
---@return void
function CDOTA_CustomUIManager:DynamicHud_Create(int_1, string_2, string_3, handle_4) end

---Destroy a custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID )
---@param int_1 number
---@param string_2 string
---@return void
function CDOTA_CustomUIManager:DynamicHud_Destroy(int_1, string_2) end

---Add or modify dialog variables for an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, table DialogVariables )
---@param int_1 number
---@param string_2 string
---@param handle_3 handle
---@return void
function CDOTA_CustomUIManager:DynamicHud_SetDialogVariables(int_1, string_2, handle_3) end

---Toggle the visibility of an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, bool Visible )
---@param int_1 number
---@param string_2 string
---@param bool_3 boolean
---@return void
function CDOTA_CustomUIManager:DynamicHud_SetVisible(int_1, string_2, bool_3) end

---@class CDOTA_Item : CDOTABaseAbility
---
---@return boolean
function CDOTA_Item:CanBeUsedOutOfInventory() end

---
---@return boolean
function CDOTA_Item:CanOnlyPlayerHeroPickup() end

---Get the container for this item.
---@return GetContainer
function CDOTA_Item:GetContainer() end

---
---@return number
function CDOTA_Item:GetCost() end

---Get the number of charges this item currently has.
---@return number
function CDOTA_Item:GetCurrentCharges() end

---Get the initial number of charges this item has.
---@return number
function CDOTA_Item:GetInitialCharges() end

---
---@return number
function CDOTA_Item:GetItemSlot() end

---Gets whether item is unequipped or ready.
---@return number
function CDOTA_Item:GetItemState() end

---Get the parent for this item.
---@return handle
function CDOTA_Item:GetParent() end

---Get the purchase time of this item
---@return number
function CDOTA_Item:GetPurchaseTime() end

---Get the purchaser for this item.
---@return handle
function CDOTA_Item:GetPurchaser() end

---Get the number of secondary charges this item currently has.
---@return number
function CDOTA_Item:GetSecondaryCharges() end

---
---@return number
function CDOTA_Item:GetShareability() end

---Get the number of valueless charges this item currently has.
---@return number
function CDOTA_Item:GetValuelessCharges() end

---
---@return boolean
function CDOTA_Item:IsAlertableItem() end

---
---@return boolean
function CDOTA_Item:IsCastOnPickup() end

---
---@return boolean
function CDOTA_Item:IsCombinable() end

---
---@return boolean
function CDOTA_Item:IsCombineLocked() end

---
---@return boolean
function CDOTA_Item:IsDisassemblable() end

---
---@return boolean
function CDOTA_Item:IsDroppable() end

---
---@return boolean
function CDOTA_Item:IsInBackpack() end

---
---@return boolean
function CDOTA_Item:IsItem() end

---
---@return boolean
function CDOTA_Item:IsKillable() end

---
---@return boolean
function CDOTA_Item:IsMuted() end

---
---@return boolean
function CDOTA_Item:IsNeutralDrop() end

---
---@return boolean
function CDOTA_Item:IsPermanent() end

---
---@return boolean
function CDOTA_Item:IsPurchasable() end

---
---@return boolean
function CDOTA_Item:IsRecipe() end

---
---@return boolean
function CDOTA_Item:IsRecipeGenerated() end

---
---@return boolean
function CDOTA_Item:IsSellable() end

---
---@return boolean
function CDOTA_Item:IsStackable() end

---
---@param bAutoUse boolean
---@param flHeight number
---@param flDuration number
---@param vEndPoint Vector
---@return void
function CDOTA_Item:LaunchLoot(bAutoUse, flHeight, flDuration, vEndPoint) end

---
---@param bAutoUse boolean
---@param flInitialHeight number
---@param flLaunchHeight number
---@param flDuration number
---@param vEndPoint Vector
---@return void
function CDOTA_Item:LaunchLootInitialHeight(bAutoUse, flInitialHeight, flLaunchHeight, flDuration, vEndPoint) end

---
---@param bAutoUse boolean
---@param flRequiredHeight number
---@param flHeight number
---@param flDuration number
---@param vEndPoint Vector
---@return void
function CDOTA_Item:LaunchLootRequiredHeight(bAutoUse, flRequiredHeight, flHeight, flDuration, vEndPoint) end

---Modifies the number of valueless charges on this item
---@param iCharges number
---@return void
function CDOTA_Item:ModifyNumValuelessCharges(iCharges) end

---
---@return void
function CDOTA_Item:OnEquip() end

---
---@return void
function CDOTA_Item:OnUnequip() end

---
---@return boolean
function CDOTA_Item:RequiresCharges() end

---
---@param bValue boolean
---@return void
function CDOTA_Item:SetCanBeUsedOutOfInventory(bValue) end

---
---@param bCastOnPickUp boolean
---@return void
function CDOTA_Item:SetCastOnPickup(bCastOnPickUp) end

---
---@param bCombineLocked boolean
---@return void
function CDOTA_Item:SetCombineLocked(bCombineLocked) end

---Set the number of charges on this item
---@param iCharges number
---@return void
function CDOTA_Item:SetCurrentCharges(iCharges) end

---
---@param bDroppable boolean
---@return void
function CDOTA_Item:SetDroppable(bDroppable) end

---Sets whether item is unequipped or ready.
---@param iState number
---@return void
function CDOTA_Item:SetItemState(iState) end

---
---@param bOnlyPlayerHero boolean
---@return void
function CDOTA_Item:SetOnlyPlayerHeroPickup(bOnlyPlayerHero) end

---Set the purchase time of this item
---@param flTime number
---@return void
function CDOTA_Item:SetPurchaseTime(flTime) end

---Set the purchaser of record for this item.
---@param hPurchaser handle
---@return void
function CDOTA_Item:SetPurchaser(hPurchaser) end

---Set the number of secondary charges on this item
---@param iCharges number
---@return void
function CDOTA_Item:SetSecondaryCharges(iCharges) end

---
---@param bSellable boolean
---@return void
function CDOTA_Item:SetSellable(bSellable) end

---
---@param iShareability number
---@return void
function CDOTA_Item:SetShareability(iShareability) end

---
---@param bStacksWithOtherOwners boolean
---@return void
function CDOTA_Item:SetStacksWithOtherOwners(bStacksWithOtherOwners) end

---
---@return void
function CDOTA_Item:SpendCharge(0) end

---
---@return boolean
function CDOTA_Item:StacksWithOtherOwners() end

---Think this item
---@return void
function CDOTA_Item:Think() end

---@class CDOTA_ItemSpawner : CBaseEntity
---Returns the item name
---@return string
function CDOTA_ItemSpawner:GetItemName() end

---@class CDOTA_Item_BagOfGold
---Set the life time of this item
---@param flTime number
---@return void
function CDOTA_Item_BagOfGold:SetLifeTime(flTime) end

---@class CDOTA_Item_DataDriven : CDOTA_Item
---Applies a data driven modifier to the target
---@param hCaster handle
---@param hTarget handle
---@param pszModifierName string
---@param hModifierTable handle
---@return void
function CDOTA_Item_DataDriven:ApplyDataDrivenModifier(hCaster, hTarget, pszModifierName, hModifierTable) end

---Applies a data driven thinker at the location
---@param hCaster handle
---@param vLocation Vector
---@param pszModifierName string
---@param hModifierTable handle
---@return handle
function CDOTA_Item_DataDriven:ApplyDataDrivenThinker(hCaster, vLocation, pszModifierName, hModifierTable) end

---@class CDOTA_Item_Lua : CDOTA_Item
---Returns true if this item can be picked up by the target unit.
---@param hUnit handle
---@return boolean
function CDOTA_Item_Lua:CanUnitPickUp(hUnit) end

---Determine whether an issued command with no target is valid.
---@return number
function CDOTA_Item_Lua:CastFilterResult() end

---(Vector vLocation) Determine whether an issued command on a location is valid.
---@param vLocation Vector
---@return number
function CDOTA_Item_Lua:CastFilterResultLocation(vLocation) end

---(HSCRIPT hTarget) Determine whether an issued command on a target is valid.
---@param hTarget handle
---@return number
function CDOTA_Item_Lua:CastFilterResultTarget(hTarget) end

---Controls the size of the AOE casting cursor.
---@return number
function CDOTA_Item_Lua:GetAOERadius() end

---Allows code overriding of the item texture shown in the HUD.
---@return string
function CDOTA_Item_Lua:GetAbilityTextureName() end

---Returns abilities that are stolen simultaneously, or otherwise related in functionality.
---@return string
function CDOTA_Item_Lua:GetAssociatedPrimaryAbilities() end

---Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities.
---@return string
function CDOTA_Item_Lua:GetAssociatedSecondaryAbilities() end

---Return cast behavior type of this ability.
---@return number
function CDOTA_Item_Lua:GetBehavior() end

---Return cast range of this ability.
---@param vLocation Vector
---@param hTarget handle
---@return number
function CDOTA_Item_Lua:GetCastRange(vLocation, hTarget) end

---Return the channel time of this ability.
---@return number
function CDOTA_Item_Lua:GetChannelTime() end

---Return mana cost at the given level per second while channeling (-1 is current).
---@param iLevel number
---@return number
function CDOTA_Item_Lua:GetChannelledManaCostPerSecond(iLevel) end

---Return who hears speech when this spell is cast.
---@return number
function CDOTA_Item_Lua:GetConceptRecipientType() end

---Return cooldown of this ability.
---@param iLevel number
---@return number
function CDOTA_Item_Lua:GetCooldown(iLevel) end

---Return the error string of a failed command with no target.
---@return string
function CDOTA_Item_Lua:GetCustomCastError() end

---(Vector vLocation) Return the error string of a failed command on a location.
---@param vLocation Vector
---@return string
function CDOTA_Item_Lua:GetCustomCastErrorLocation(vLocation) end

---(HSCRIPT hTarget) Return the error string of a failed command on a target.
---@param hTarget handle
---@return string
function CDOTA_Item_Lua:GetCustomCastErrorTarget(hTarget) end

---Return cast range of this ability, taking modifiers into account.
---@param vLocation Vector
---@param hTarget handle
---@return number
function CDOTA_Item_Lua:GetEffectiveCastRange(vLocation, hTarget) end

---Return gold cost at the given level (-1 is current).
---@param iLevel number
---@return number
function CDOTA_Item_Lua:GetGoldCost(iLevel) end

---返回此技能被动给予的修饰器的名称
---@return string
function CDOTA_Item_Lua:GetIntrinsicModifierName() end

---Return mana cost at the given level (-1 is current).
---@param iLevel number
---@return number
function CDOTA_Item_Lua:GetManaCost(iLevel) end

---Return the animation rate of the cast animation.
---@return number
function CDOTA_Item_Lua:GetPlaybackRateOverride() end

---Returns true if this ability can be used when not on the action panel.
---@return boolean
function CDOTA_Item_Lua:IsHiddenAbilityCastable() end

---Returns true if this ability is hidden when stolen by Spell Steal.
---@return boolean
function CDOTA_Item_Lua:IsHiddenWhenStolen() end

---Returns whether this item is muted or not.
---@return boolean
function CDOTA_Item_Lua:IsMuted() end

---Returns true if this ability is refreshed by Refresher Orb.
---@return boolean
function CDOTA_Item_Lua:IsRefreshable() end

---Returns true if this ability can be stolen by Spell Steal.
---@return boolean
function CDOTA_Item_Lua:IsStealable() end

---Cast time did not complete successfully.
---@return void
function CDOTA_Item_Lua:OnAbilityPhaseInterrupted() end

---Cast time begins (return true for successful cast).
---@return boolean
function CDOTA_Item_Lua:OnAbilityPhaseStart() end

---(bool bInterrupted) Channel finished.
---@param bInterrupted boolean
---@return void
function CDOTA_Item_Lua:OnChannelFinish(bInterrupted) end

---(float flInterval) Channeling is taking place.
---@param flInterval number
---@return void
function CDOTA_Item_Lua:OnChannelThink(flInterval) end

---Runs when item`s charge count changes.
---@return void
function CDOTA_Item_Lua:OnChargeCountChanged() end

---Caster (hero only) gained a level, skilled an ability, or received a new stat bonus.
---@return void
function CDOTA_Item_Lua:OnHeroCalculateStatBonus() end

---A hero has died in the vicinity (ie Urn), takes table of params.
---@param unit handle
---@param attacker handle
---@param table handle
---@return void
function CDOTA_Item_Lua:OnHeroDiedNearby(unit, attacker, table) end

---Caster gained a level.
---@return void
function CDOTA_Item_Lua:OnHeroLevelUp() end

---Caster inventory changed.
---@return void
function CDOTA_Item_Lua:OnInventoryContentsChanged() end

---( HSCRIPT hItem ) Caster equipped item.
---@param hItem handle
---@return void
function CDOTA_Item_Lua:OnItemEquipped(hItem) end

---Caster died.
---@return void
function CDOTA_Item_Lua:OnOwnerDied() end

---Caster respawned or spawned for the first time.
---@return void
function CDOTA_Item_Lua:OnOwnerSpawned() end

---(HSCRIPT hTarget, Vector vLocation) Projectile has collided with a given target or reached its destination (target is invalid).
---@param hTarget handle
---@param vLocation Vector
---@return boolean
function CDOTA_Item_Lua:OnProjectileHit(hTarget, vLocation) end

---(Vector vLocation) Projectile is actively moving.
---@param vLocation Vector
---@return void
function CDOTA_Item_Lua:OnProjectileThink(vLocation) end

---Cast time finished, spell effects begin.
---@return void
function CDOTA_Item_Lua:OnSpellStart() end

---( HSCRIPT hAbility ) Special behavior when stolen by Spell Steal.
---@param hSourceAbility handle
---@return void
function CDOTA_Item_Lua:OnStolen(hSourceAbility) end

---Ability is toggled on/off.
---@return void
function CDOTA_Item_Lua:OnToggle() end

---Special behavior when lost by Spell Steal.
---@return void
function CDOTA_Item_Lua:OnUnStolen() end

---Ability gained a level.
---@return void
function CDOTA_Item_Lua:OnUpgrade() end

---Returns true if this ability will generate magic stick charges for nearby enemies.
---@return boolean
function CDOTA_Item_Lua:ProcsMagicStick() end

---Return the type of speech used.
---@return number
function CDOTA_Item_Lua:SpeakTrigger() end

---@class CDOTA_Item_Physical : CBaseAnimating
---Returned the contained item.
---@return CDOTA_Item
function CDOTA_Item_Physical:GetContainedItem() end

---Returns the game time when this item was created in the world
---@return number
function CDOTA_Item_Physical:GetCreationTime() end

---Set the contained item.
---@param hItem handle
---@return void
function CDOTA_Item_Physical:SetContainedItem(hItem) end

---@class CDOTA_MapTree : CBaseEntity
---Cuts down this tree. Parameters: int nTeamNumberKnownTo (-1 = invalid team)
---@param nTeamNumberKnownTo number
---@return void
function CDOTA_MapTree:CutDown(nTeamNumberKnownTo) end

---Cuts down this tree. Parameters: float flRegrowAfter (-1 = never regrow), int nTeamNumberKnownTo (-1 = invalid team)
---@param flRegrowAfter number
---@param nTeamNumberKnownTo number
---@return void
function CDOTA_MapTree:CutDownRegrowAfter(flRegrowAfter, nTeamNumberKnownTo) end

---Grows back the tree if it was cut down.
---@return void
function CDOTA_MapTree:GrowBack() end

---Returns true if the tree is standing, false if it has been cut down
---@return boolean
function CDOTA_MapTree:IsStanding() end

---@class CDOTA_Modifier_Lua : CDOTA_Buff
---在Server端添加自定义数据传送到Client端。HandleCustomTransmitterData在Client端接受传递过来的数据
---@return table
function CDOTA_Modifier_Lua:AddCustomTransmitterData() end

---True/false if this modifier is active on illusions.
---@return boolean
function CDOTA_Modifier_Lua:AllowIllusionDuplicate() end

---
---@return boolean
function CDOTA_Modifier_Lua:CanParentBeAutoAttacked() end

---该修饰器包含的状态。晕眩、沉默、缴械等等。高优先级的修饰器状态会覆盖低优先级的修饰器状态。
---@return table
function CDOTA_Modifier_Lua:CheckState() end

---申明函数，注册修饰器使用的属性。
---@return table
function CDOTA_Modifier_Lua:DeclareFunctions() end

---True/false if this buff is removed when the duration expires.
---@return boolean
function CDOTA_Modifier_Lua:DestroyOnExpire() end

---Return the types of attributes applied to this modifier (enum value from DOTAModifierAttribute_t
---@return number
function CDOTA_Modifier_Lua:GetAttributes() end

---Returns aura stickiness
---@return number
function CDOTA_Modifier_Lua:GetAuraDuration() end

---Return true/false if this entity should receive the aura under specific conditions
---@param hEntity handle
---@return boolean
function CDOTA_Modifier_Lua:GetAuraEntityReject(hEntity) end

---Return the range around the parent this aura tries to apply its buff.
---@return number
function CDOTA_Modifier_Lua:GetAuraRadius() end

---Return the unit flags this aura respects when placing buffs.
---@return number
function CDOTA_Modifier_Lua:GetAuraSearchFlags() end

---Return the teams this aura applies its buff to.
---@return number
function CDOTA_Modifier_Lua:GetAuraSearchTeam() end

---Return the unit classifications this aura applies its buff to.
---@return number
function CDOTA_Modifier_Lua:GetAuraSearchType() end

---A Modifier that listens to MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE has to have a GetCritDamage implementation so we can know when to evaluate it. Value should be in 'times the original value format' e.g: 1.5 not 150
---@return number
function CDOTA_Modifier_Lua:GetCritDamage() end

---Return the attach type of the particle system from GetEffectName.
---@return number
function CDOTA_Modifier_Lua:GetEffectAttachType() end

---Return the name of the particle system that is created while this modifier is active.
---@return string
function CDOTA_Modifier_Lua:GetEffectName() end

---Return the name of the hero effect particle system that is created while this modifier is active.
---@return string
function CDOTA_Modifier_Lua:GetHeroEffectName() end

---The name of the secondary modifier that will be applied by this modifier (if it is an aura).
---@return string
function CDOTA_Modifier_Lua:GetModifierAura() end

---Return the priority order this modifier will be applied over others.
---@return number
function CDOTA_Modifier_Lua:GetPriority() end

---Return the name of the status effect particle system that is created while this modifier is active.
---@return string
function CDOTA_Modifier_Lua:GetStatusEffectName() end

---Return the name of the buff icon to be shown for this modifier.
---@return string
function CDOTA_Modifier_Lua:GetTexture() end

---在Server端添加自定义数据传送到Client端。HandleCustomTransmitterData在Client端接受传递过来的数据
---@return table
function CDOTA_Modifier_Lua:HandleCustomTransmitterData() end

---Relationship of this hero effect with those from other buffs (higher is more likely to be shown).
---@return number
function CDOTA_Modifier_Lua:HeroEffectPriority() end

---True/false if this modifier is an aura.
---@return boolean
function CDOTA_Modifier_Lua:IsAura() end

---True/false if this aura provides buffs when the parent is dead.
---@return boolean
function CDOTA_Modifier_Lua:IsAuraActiveOnDeath() end

---True/false if this modifier should be displayed as a debuff.
---@return boolean
function CDOTA_Modifier_Lua:IsDebuff() end

---True/false if this modifier should be displayed on the buff bar.
---@return boolean
function CDOTA_Modifier_Lua:IsHidden() end

---
---@return boolean
function CDOTA_Modifier_Lua:IsPermanent() end

---True/false ，该修饰器可以/不可以被弱驱散净化。默认false。
---@return boolean
function CDOTA_Modifier_Lua:IsPurgable() end

---True/false if this modifier can be purged by strong dispels.
---@return boolean
function CDOTA_Modifier_Lua:IsPurgeException() end

---True/false if this modifier is considered a stun for purge reasons.
---@return boolean
function CDOTA_Modifier_Lua:IsStunDebuff() end

---Runs when the modifier is created.
---@param table handle
---@return void
function CDOTA_Modifier_Lua:OnCreated(table) end

---Runs when the modifier is destroyed (after unit loses modifier).
---@return void
function CDOTA_Modifier_Lua:OnDestroy() end

---Runs when the think interval occurs.
---@return void
function CDOTA_Modifier_Lua:OnIntervalThink() end

---Runs when the modifier is refreshed.
---@param table handle
---@return void
function CDOTA_Modifier_Lua:OnRefresh(table) end

---Runs when the modifier is destroyed (before unit loses modifier).
---@return void
function CDOTA_Modifier_Lua:OnRemoved() end

---当叠加层数改变时调用，参数为改变前的叠加层数
---@param iStackCount number
---@return void
function CDOTA_Modifier_Lua:OnStackCountChanged(iStackCount) end

---True/false if this modifier is removed when the parent dies.
---@return boolean
function CDOTA_Modifier_Lua:RemoveOnDeath() end

---需要配合AddCustomTransmitterData、HandleCustomTransmitterData这两个函数一起使用。AddCustomTransmitterData在Server端返回需要传递的数据。HandleCustomTransmitterData在Client端接受传递过来的数据（会被像nettable一样处理）
---@param bHasCustomData boolean
---@return void
function CDOTA_Modifier_Lua:SetHasCustomTransmitterData(bHasCustomData) end

---Apply the overhead offset to the attached effect.
---@return boolean
function CDOTA_Modifier_Lua:ShouldUseOverheadOffset() end

---Relationship of this status effect with those from other buffs (higher is more likely to be shown).
---@return number
function CDOTA_Modifier_Lua:StatusEffectPriority() end

---@class CDOTA_Modifier_Lua_Horizontal_Motion : CDOTA_Modifier_Lua
---Starts the horizontal motion controller effects for this buff.  Returns true if successful.注意：宿主单位移动能力如果设置为不可移动（DOTA_UNIT_CAP_MOVE_NONE），则此方法必定返回false
---@return boolean
function CDOTA_Modifier_Lua_Horizontal_Motion:ApplyHorizontalMotionController() end

---Get the priority
---@return number
function CDOTA_Modifier_Lua_Horizontal_Motion:GetPriority() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Horizontal_Motion:OnHorizontalMotionInterrupted() end

---Set the priority
---@param nMotionPriority number
---@return void
function CDOTA_Modifier_Lua_Horizontal_Motion:SetPriority(nMotionPriority) end

---Perform any motion from the given interval on the NPC. UpdateHorizontalMotion先运行，UpdateVerticalMotion后运行。
---@param me handle
---@param dt number
---@return void
function CDOTA_Modifier_Lua_Horizontal_Motion:UpdateHorizontalMotion(me, dt) end

---@class CDOTA_Modifier_Lua_Motion_Both : CDOTA_Modifier_Lua
---Starts the horizontal motion controller effects for this buff.  Returns true if successful.
---@return boolean
function CDOTA_Modifier_Lua_Motion_Both:ApplyHorizontalMotionController() end

---Starts the vertical motion controller effects for this buff.  Returns true if successful.
---@return boolean
function CDOTA_Modifier_Lua_Motion_Both:ApplyVerticalMotionController() end

---Get the priority
---@return number
function CDOTA_Modifier_Lua_Motion_Both:GetPriority() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Motion_Both:OnHorizontalMotionInterrupted() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Motion_Both:OnVerticalMotionInterrupted() end

---Set the priority
---@param nMotionPriority number
---@return void
function CDOTA_Modifier_Lua_Motion_Both:SetPriority(nMotionPriority) end

---Perform any motion from the given interval on the NPC.
---@param me handle
---@param dt number
---@return void
function CDOTA_Modifier_Lua_Motion_Both:UpdateHorizontalMotion(me, dt) end

---Perform any motion from the given interval on the NPC.
---@param me handle
---@param dt number
---@return void
function CDOTA_Modifier_Lua_Motion_Both:UpdateVerticalMotion(me, dt) end

---@class CDOTA_Modifier_Lua_Vertical_Motion : CDOTA_Modifier_Lua
---Starts the vertical motion controller effects for this buff.  Returns true if successful.
---@return boolean
function CDOTA_Modifier_Lua_Vertical_Motion:ApplyVerticalMotionController() end

---Get the priority
---@return number
function CDOTA_Modifier_Lua_Vertical_Motion:GetMotionPriority() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Vertical_Motion:OnVerticalMotionInterrupted() end

---Set the priority
---@param nMotionPriority number
---@return void
function CDOTA_Modifier_Lua_Vertical_Motion:SetMotionPriority(nMotionPriority) end

---Perform any motion from the given interval on the NPC.
---@param me handle
---@param dt number
---@return void
function CDOTA_Modifier_Lua_Vertical_Motion:UpdateVerticalMotion(me, dt) end

---@class CDOTA_NeutralSpawner
---
---@return void
function CDOTA_NeutralSpawner:CreatePendingUnits() end

---
---@return void
function CDOTA_NeutralSpawner:SelectSpawnType() end

---
---@param bIgnoreBlockers boolean
---@return void
function CDOTA_NeutralSpawner:SpawnNextBatch(bIgnoreBlockers) end

---@class CDOTA_PlayerResource : CBaseEntity
---@type CDOTA_PlayerResource
PlayerResource = CDOTA_PlayerResource
---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:AddAegisPickup(iPlayerID) end

---
---@param iPlayerID number
---@param nReason number
---@return void
function CDOTA_PlayerResource:AddCandyEvent(iPlayerID, nReason) end

---
---@param iPlayerID number
---@param flFarmValue number
---@param bEarnedValue boolean
---@return void
function CDOTA_PlayerResource:AddClaimedFarm(iPlayerID, flFarmValue, bEarnedValue) end

---
---@param iPlayerID number
---@param iCost number
---@return void
function CDOTA_PlayerResource:AddGoldSpentOnSupport(iPlayerID, iCost) end

---
---@param iPlayerID number
---@param nTeamNumber number
---@param hItem handle
---@return void
function CDOTA_PlayerResource:AddNeutralItemToStash(iPlayerID, nTeamNumber, hItem) end

---
---@param iPlayerID number
---@param nRunes number
---@return void
function CDOTA_PlayerResource:AddRunePickup(iPlayerID, nRunes) end

---
---@param nUnitOwnerPlayerID number
---@param nOtherPlayerID number
---@return boolean
function CDOTA_PlayerResource:AreUnitsSharedWithPlayerID(nUnitOwnerPlayerID, nOtherPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:CanRepick(iPlayerID) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:ClearKillsMatrix(iPlayerID) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:ClearLastHitMultikill(iPlayerID) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:ClearLastHitStreak(iPlayerID) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:ClearRawPlayerDamageMatrix(iPlayerID) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:ClearStreak(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetAegisPickups(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetAssists(iPlayerID) end

---
---@param iPlayerID number
---@return unsigned
function CDOTA_PlayerResource:GetBroadcasterChannel(iPlayerID) end

---
---@param iPlayerID number
---@return unsigned
function CDOTA_PlayerResource:GetBroadcasterChannelSlot(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetClaimedDenies(iPlayerID) end

---
---@param iPlayerID number
---@param bOnlyEarned boolean
---@return number
function CDOTA_PlayerResource:GetClaimedFarm(iPlayerID, bOnlyEarned) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetClaimedMisses(iPlayerID) end

---
---@param iPlayerID number
---@return unknown
function CDOTA_PlayerResource:GetConnectionState(iPlayerID) end

---
---@param iPlayerID number
---@param bTotal boolean
---@return number
function CDOTA_PlayerResource:GetCreepDamageTaken(iPlayerID, bTotal) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetCustomBuybackCooldown(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetCustomBuybackCost(iPlayerID) end

---Get the current custom team assignment for this player.
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetCustomTeamAssignment(iPlayerID) end

---
---@param iPlayerID number
---@param iVictimID number
---@return number
function CDOTA_PlayerResource:GetDamageDoneToHero(iPlayerID, iVictimID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetDeaths(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetDenies(iPlayerID) end

---(nPlayerID, nActionID)
---@param nPlayerID number
---@param unActionID unsigned
---@return number
function CDOTA_PlayerResource:GetEventGameCustomActionClaimCount(nPlayerID, unActionID) end

---(nPlayerID, pActionName)
---@param nPlayerID number
---@param pActionName string
---@return number
function CDOTA_PlayerResource:GetEventGameCustomActionClaimCountByName(nPlayerID, pActionName) end

---(nPlayerID)
---@param nPlayerID number
---@return handle
function CDOTA_PlayerResource:GetEventGameUpgrades(nPlayerID) end

---
---@param nPlayerID number
---@return unsigned
function CDOTA_PlayerResource:GetEventPointsForPlayerID(nPlayerID) end

---
---@param nPlayerID number
---@return unsigned
function CDOTA_PlayerResource:GetEventPremiumPoints(nPlayerID) end

---
---@param nPlayerID number
---@return unknown
function CDOTA_PlayerResource:GetEventRanks(nPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGold(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGoldLostToDeath(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGoldPerMin(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGoldSpentOnBuybacks(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGoldSpentOnConsumables(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGoldSpentOnItems(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetGoldSpentOnSupport(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetHealing(iPlayerID) end

---
---@param iPlayerID number
---@param bTotal boolean
---@return number
function CDOTA_PlayerResource:GetHeroDamageTaken(iPlayerID, bTotal) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetKills(iPlayerID) end

---
---@param iPlayerID number
---@param iVictimID number
---@return number
function CDOTA_PlayerResource:GetKillsDoneToHero(iPlayerID, iVictimID) end

---(nPlayerID)
---@param nPlayerID number
---@return handle
function CDOTA_PlayerResource:GetLabyrinthEventGameHeroUnlocks(nPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetLastHitMultikill(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetLastHitStreak(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetLastHits(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetLevel(iPlayerID) end

---
---@param iPlayerID number
---@return unknown
function CDOTA_PlayerResource:GetLiveSpectatorTeam(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetMisses(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetNearbyCreepDeaths(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetNetWorth(iPlayerID) end

---
---@param nCourierIndex number
---@param nTeamNumber number
---@return handle
function CDOTA_PlayerResource:GetNthCourierForTeam(nCourierIndex, nTeamNumber) end

---
---@param iTeamNumber number
---@param iNthPlayer number
---@return number
function CDOTA_PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, iNthPlayer) end

---Players on a valid team (radiant, dire, or custom*) who haven't abandoned the game
---@return number
function CDOTA_PlayerResource:GetNumConnectedHumanPlayers() end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetNumConsumablesPurchased(iPlayerID) end

---
---@param nTeamNumber number
---@return number
function CDOTA_PlayerResource:GetNumCouriersForTeam(nTeamNumber) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetNumItemsPurchased(iPlayerID) end

---
---@param iPlayerID number
---@return uint64
function CDOTA_PlayerResource:GetPartyID(iPlayerID) end

---
---@param iPlayerID number
---@return handle
function CDOTA_PlayerResource:GetPlayer(iPlayerID) end

---Includes spectators and players not assigned to a team
---@return number
function CDOTA_PlayerResource:GetPlayerCount() end

---
---@param iTeam number
---@return number
function CDOTA_PlayerResource:GetPlayerCountForTeam(iTeam) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:GetPlayerLoadedCompletely(iPlayerID) end

---
---@param iPlayerID number
---@return string
function CDOTA_PlayerResource:GetPlayerName(iPlayerID) end

---
---@param nPlayerId number
---@return handle
function CDOTA_PlayerResource:GetPreferredCourierForPlayer(nPlayerId) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetRawPlayerDamage(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetReliableGold(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetRespawnSeconds(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetRoshanKills(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetRunePickups(iPlayerID) end

---获取玩家所选英雄
---@param iPlayerID number
---@return CDOTA_BaseNPC_Hero | nil
function CDOTA_PlayerResource:GetSelectedHeroEntity(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetSelectedHeroID(iPlayerID) end

---
---@param iPlayerID number
---@return string
function CDOTA_PlayerResource:GetSelectedHeroName(iPlayerID) end

---
---@param iPlayerID number
---@return unsigned
function CDOTA_PlayerResource:GetSteamAccountID(iPlayerID) end

---Get the 64 bit steam ID for a given player.
---@param iPlayerID number
---@return uint64
function CDOTA_PlayerResource:GetSteamID(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetStreak(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetStuns(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTeam(iPlayerID) end

---
---@param iTeam number
---@return number
function CDOTA_PlayerResource:GetTeamKills(iTeam) end

---Players on a valid team (radiant, dire, or custom*) who haven`t abandoned the game
---@return number
function CDOTA_PlayerResource:GetTeamPlayerCount() end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTimeOfLastConsumablePurchase(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTimeOfLastDeath(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTimeOfLastItemPurchase(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTotalEarnedGold(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTotalEarnedXP(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTotalGoldSpent(iPlayerID) end

---
---@param iPlayerID number
---@param bTotal boolean
---@return number
function CDOTA_PlayerResource:GetTowerDamageTaken(iPlayerID, bTotal) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetTowerKills(iPlayerID) end

---
---@param nPlayerID number
---@param nOtherPlayerID number
---@return number
function CDOTA_PlayerResource:GetUnitShareMaskForPlayer(nPlayerID, nOtherPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetUnreliableGold(iPlayerID) end

---
---@param iPlayerID number
---@return number
function CDOTA_PlayerResource:GetXPPerMin(iPlayerID) end

---Does this player have a custom game ticket for this game?
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:HasCustomGameTicketForPlayerID(iPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:HasRandomed(iPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:HasSelectedHero(iPlayerID) end

---
---@return boolean
function CDOTA_PlayerResource:HasSetEventGameCustomActionClaimCount() end

---
---@return boolean
function CDOTA_PlayerResource:HaveAllPlayersJoined() end

---
---@param iPlayerID number
---@param iVictimID number
---@return void
function CDOTA_PlayerResource:IncrementAssists(iPlayerID, iVictimID) end

---
---@param iPlayerID number
---@param nValue number
---@return void
function CDOTA_PlayerResource:IncrementClaimedDenies(iPlayerID, nValue) end

---
---@param iPlayerID number
---@param nValue number
---@return void
function CDOTA_PlayerResource:IncrementClaimedMisses(iPlayerID, nValue) end

---
---@param iPlayerID number
---@param iKillerID number
---@return void
function CDOTA_PlayerResource:IncrementDeaths(iPlayerID, iKillerID) end

---
---@param iPlayerID number
---@param nValue number
---@return void
function CDOTA_PlayerResource:IncrementDenies(iPlayerID, nValue) end

---
---@param iPlayerID number
---@param iVictimID number
---@return void
function CDOTA_PlayerResource:IncrementKills(iPlayerID, iVictimID) end

---
---@param iPlayerID number
---@param nCount number
---@return void
function CDOTA_PlayerResource:IncrementLastHitMultikill(iPlayerID, nCount) end

---
---@param iPlayerID number
---@param nCount number
---@return void
function CDOTA_PlayerResource:IncrementLastHitStreak(iPlayerID, nCount) end

---
---@param iPlayerID number
---@param nCount number
---@return void
function CDOTA_PlayerResource:IncrementLastHits(iPlayerID, nCount) end

---
---@param iPlayerID number
---@param nValue number
---@return void
function CDOTA_PlayerResource:IncrementMisses(iPlayerID, nValue) end

---
---@param iPlayerID number
---@param nCreeps number
---@return void
function CDOTA_PlayerResource:IncrementNearbyCreepDeaths(iPlayerID, nCreeps) end

---
---@param iPlayerID number
---@param nCount number
---@return void
function CDOTA_PlayerResource:IncrementStreak(iPlayerID, nCount) end

---
---@param iPlayerID number
---@param iXP number
---@param nReason number
---@return void
function CDOTA_PlayerResource:IncrementTotalEarnedXP(iPlayerID, iXP, nReason) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsBroadcaster(iPlayerID) end

---
---@param nPlayerID number
---@param nOtherPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsDisableHelpSetForPlayerID(nPlayerID, nOtherPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsFakeClient(iPlayerID) end

---
---@param pHeroname string
---@param bIgnoreUnrevealedPick boolean
---@return boolean
function CDOTA_PlayerResource:IsHeroSelected(pHeroname, bIgnoreUnrevealedPick) end

---
---@param nUnitOwnerPlayerID number
---@param nOtherPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsHeroSharedWithPlayerID(nUnitOwnerPlayerID, nOtherPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsValidPlayer(iPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsValidPlayerID(iPlayerID) end

---
---@param iPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsValidTeamPlayer(iPlayerID) end

---
---@param nPlayerID number
---@return boolean
function CDOTA_PlayerResource:IsValidTeamPlayerID(nPlayerID) end

---
---@param iPlayerID number
---@param iGoldChange number
---@param bReliable boolean
---@param nReason number
---@return number
function CDOTA_PlayerResource:ModifyGold(iPlayerID, iGoldChange, bReliable, nReason) end

---
---@return number
function CDOTA_PlayerResource:NumPlayers() end

---
---@return number
function CDOTA_PlayerResource:NumTeamPlayers() end

---Increment or decrement consumable charges (nPlayerID, item_definition_index, nChargeIncrementOrDecrement)
---@param iPlayerID number
---@param item_definition_index number
---@param nChargeIncrementOrDecrement number
---@return void
function CDOTA_PlayerResource:RecordConsumableAbilityChargeChange(iPlayerID, item_definition_index, nChargeIncrementOrDecrement) end

---
---@param iPlayerID number
---@param eEvent number
---@param unActionID number
---@param unAudit number
---@param unQuantity unsigned
---@param unAuditData unsigned
---@return void
function CDOTA_PlayerResource:RecordEventActionGrant(iPlayerID, eEvent, unActionID, unAudit, unQuantity, unAuditData) end

---
---@param iPlayerID number
---@param pszActionName string
---@param unAudit number
---@param unQuantity unsigned
---@param unAuditData unsigned
---@return void
function CDOTA_PlayerResource:RecordEventActionGrantForPrimaryEvent(iPlayerID, pszActionName, unAudit, unQuantity, unAuditData) end

---(playerID, heroClassName, gold, XP) - replaces the player`s hero with a new one of the specified class, gold and XP
---@param iPlayerID number
---@param pszHeroClass string
---@param nGold number
---@param nXP number
---@return handle
function CDOTA_PlayerResource:ReplaceHeroWith(iPlayerID, pszHeroClass, nGold, nXP) end

---(playerID, heroClassName, gold, XP) - replaces the player's hero with a new one of the specified class, gold and XP, without transferring items/abilities if same hero
---@param iPlayerID number
---@param pszHeroClass string
---@param nGold number
---@param nXP number
---@return handle
function CDOTA_PlayerResource:ReplaceHeroWithNoTransfer(iPlayerID, pszHeroClass, nGold, nXP) end

---
---@param nPlayerID number
---@return void
function CDOTA_PlayerResource:ResetBuybackCostTime(nPlayerID) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:ResetTotalEarnedGold(iPlayerID) end

---
---@param nPlayerID number
---@param flBuybackCooldown number
---@return void
function CDOTA_PlayerResource:SetBuybackCooldownTime(nPlayerID, flBuybackCooldown) end

---
---@param nPlayerID number
---@param flBuybackCooldown number
---@return void
function CDOTA_PlayerResource:SetBuybackGoldLimitTime(nPlayerID, flBuybackCooldown) end

---(playerID, entity) - force the given player`s camera to follow the given entity
---@param nPlayerID number
---@param hTarget handle
---@return void
function CDOTA_PlayerResource:SetCameraTarget(nPlayerID, hTarget) end

---
---@param iPlayerID number
---@param bCanRepick boolean
---@return void
function CDOTA_PlayerResource:SetCanRepick(iPlayerID, bCanRepick) end

---Set the buyback cooldown for this player.
---@param iPlayerID number
---@param flCooldownTime number
---@return void
function CDOTA_PlayerResource:SetCustomBuybackCooldown(iPlayerID, flCooldownTime) end

---Set the buyback cost for this player.
---@param iPlayerID number
---@param iGoldCost number
---@return void
function CDOTA_PlayerResource:SetCustomBuybackCost(iPlayerID, iGoldCost) end

---
---@param iPlayerID number
---@param iParam number
---@return void
function CDOTA_PlayerResource:SetCustomIntParam(iPlayerID, iParam) end

---Set custom color for player (minimap, scoreboard, etc)
---@param iPlayerID number
---@param r number
---@param g number
---@param b number
---@return void
function CDOTA_PlayerResource:SetCustomPlayerColor(iPlayerID, r, g, b) end

---Set custom team assignment for this player.
---@param iPlayerID number
---@param iTeamAssignment number
---@return void
function CDOTA_PlayerResource:SetCustomTeamAssignment(iPlayerID, iTeamAssignment) end

---
---@param iPlayerID number
---@param iGold number
---@param bReliable boolean
---@return void
function CDOTA_PlayerResource:SetGold(iPlayerID, iGold, bReliable) end

---
---@param iPlayerID number
---@return void
function CDOTA_PlayerResource:SetHasRandomed(iPlayerID) end

---
---@param iPlayerID number
---@param iLastBuybackTime number
---@return void
function CDOTA_PlayerResource:SetLastBuybackTime(iPlayerID, iLastBuybackTime) end

---Set the forced selection entity for a player.
---@param nPlayerID number
---@param hEntity handle
---@return void
function CDOTA_PlayerResource:SetOverrideSelectionEntity(nPlayerID, hEntity) end

---nFlag 1 - 共享英雄 2 - 共享单位 4 - 队友帮助
---@param nPlayerID number
---@param nOtherPlayerID number
---@param nFlag number
---@param bState boolean
---@return void
function CDOTA_PlayerResource:SetUnitShareMaskForPlayer(nPlayerID, nOtherPlayerID, nFlag, bState) end

---
---@param iPlayerID number
---@param iCost number
---@param iReason number
---@return void
function CDOTA_PlayerResource:SpendGold(iPlayerID, iCost, iReason) end

---
---@param iPlayerID number
---@param iTeamNumber number
---@param desiredSlot number
---@return void
function CDOTA_PlayerResource:UpdateTeamSlot(iPlayerID, iTeamNumber, desiredSlot) end

---
---@param pHeroFilename string
---@param bIgnoreUnrevealedPick boolean
---@return number
function CDOTA_PlayerResource:WhoSelectedHero(pHeroFilename, bIgnoreUnrevealedPick) end

---@class CDOTA_ShopTrigger : CBaseTrigger
---Get the DOTA_SHOP_TYPE
---@return number
function CDOTA_ShopTrigger:GetShopType() end

---Set the DOTA_SHOP_TYPE.
---@param eShopType number
---@return void
function CDOTA_ShopTrigger:SetShopType(eShopType) end

---@class CDOTA_SimpleObstruction : CBaseEntity
---Returns whether the obstruction is currently active
---@return boolean
function CDOTA_SimpleObstruction:IsEnabled() end

---Enable or disable the obstruction
---@param bEnabled boolean
---@param bForce boolean
---@return void
function CDOTA_SimpleObstruction:SetEnabled(bEnabled, bForce) end

---@class CDOTA_Unit_Courier : CDOTA_BaseNPC
---Upgrade the courier ( int param ) times.
---@param iLevel number
---@return void
function CDOTA_Unit_Courier:UpgradeCourier(iLevel) end

---@class CDOTA_Unit_CustomGameAnnouncer
---Determines whether response criteria is matched on server or client
---@param bIsServerAuthoritative boolean
---@return void
function CDOTA_Unit_CustomGameAnnouncer:SetServerAuthoritative(bIsServerAuthoritative) end

---@class CDOTA_Unit_Diretide_Portal
---
---@return handle
function CDOTA_Unit_Diretide_Portal:GetPartnerPortal() end

---
---@return void
function CDOTA_Unit_Diretide_Portal:ResetPortal() end

---
---@param nRuneType number
---@return void
function CDOTA_Unit_Diretide_Portal:SetInvasionRuneType(nRuneType) end

---
---@param hPortal handle
---@return void
function CDOTA_Unit_Diretide_Portal:SetPartnerPortal(hPortal) end

---
---@param bActive boolean
---@return void
function CDOTA_Unit_Diretide_Portal:SetPortalActive(bActive) end

---@class CDOTA_Unit_Nian : CDOTA_BaseNPC_Creature
---Is the Nian horn?
---@return handle
function CDOTA_Unit_Nian:GetHorn() end

---Is the Nian`s tail broken?
---@return handle
function CDOTA_Unit_Nian:GetTail() end

---Is the Nian`s horn broken?
---@return boolean
function CDOTA_Unit_Nian:IsHornAlive() end

---Is the Nian`s tail broken?
---@return boolean
function CDOTA_Unit_Nian:IsTailAlive() end

---@class CDebugOverlayScriptHelper
---Draws an axis. Specify origin + orientation in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 number
---@param bool_4 boolean
---@param float_5 number
---@return void
function CDebugOverlayScriptHelper:Axis(Vector_1, Quaternion_2, float_3, bool_4, float_5) end

---Draws a world-space axis-aligned box. Specify bounds in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param bool_7 boolean
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:Box(Vector_1, Vector_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws an oriented box at the origin. Specify bounds in local space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param Quaternion_4 Quaternion
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param bool_9 boolean
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:BoxAngles(Vector_1, Vector_2, Vector_3, Quaternion_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a capsule. Specify base in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 number
---@param float_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param bool_9 boolean
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:Capsule(Vector_1, Quaternion_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a circle. Specify center in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param bool_8 boolean
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:Circle(Vector_1, Quaternion_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a circle oriented to the screen. Specify center in world space.
---@param Vector_1 Vector
---@param float_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param bool_7 boolean
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:CircleScreenOriented(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a wireframe cone. Specify endpoint and direction in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@param float_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param bool_9 boolean
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:Cone(Vector_1, Vector_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a screen-aligned cross. Specify origin in world space.
---@param Vector_1 Vector
---@param float_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param bool_7 boolean
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:Cross(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a world-aligned cross. Specify origin in world space.
---@param Vector_1 Vector
---@param float_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param bool_7 boolean
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:Cross3D(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws an oriented cross. Specify origin in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param bool_8 boolean
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:Cross3DOriented(Vector_1, Quaternion_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a dashed line. Specify endpoints in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param bool_9 boolean
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:DrawTickMarkedLine(Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws the attachments of the entity
---@param ehandle_1 ehandle
---@param float_2 number
---@param float_3 number
---@return void
function CDebugOverlayScriptHelper:EntityAttachments(ehandle_1, float_2, float_3) end

---Draws the axis of the entity origin
---@param ehandle_1 ehandle
---@param float_2 number
---@param bool_3 boolean
---@param float_4 number
---@return void
function CDebugOverlayScriptHelper:EntityAxis(ehandle_1, float_2, bool_3, float_4) end

---Draws bounds of an entity
---@param ehandle_1 ehandle
---@param int_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param bool_6 boolean
---@param float_7 number
---@return void
function CDebugOverlayScriptHelper:EntityBounds(ehandle_1, int_2, int_3, int_4, int_5, bool_6, float_7) end

---Draws the skeleton of the entity
---@param ehandle_1 ehandle
---@param float_2 number
---@return void
function CDebugOverlayScriptHelper:EntitySkeleton(ehandle_1, float_2) end

---Draws text on an entity
---@param ehandle_1 ehandle
---@param int_2 number
---@param string_3 string
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:EntityText(ehandle_1, int_2, string_3, int_4, int_5, int_6, int_7, float_8) end

---Draws a screen-space filled 2D rectangle. Coordinates are in pixels.
---@param Vector2D_1 Vector2D
---@param Vector2D_2 Vector2D
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param float_7 number
---@return void
function CDebugOverlayScriptHelper:FilledRect2D(Vector2D_1, Vector2D_2, int_3, int_4, int_5, int_6, float_7) end

---Draws a horizontal arrow. Specify endpoints in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param bool_8 boolean
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:HorzArrow(Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a line between two points
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param bool_7 boolean
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:Line(Vector_1, Vector_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a line between two points in screenspace
---@param Vector2D_1 Vector2D
---@param Vector2D_2 Vector2D
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param float_7 number
---@return void
function CDebugOverlayScriptHelper:Line2D(Vector2D_1, Vector2D_2, int_3, int_4, int_5, int_6, float_7) end

---Pops the identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch.
---@return void
function CDebugOverlayScriptHelper:PopDebugOverlayScope() end

---Pushes an identifier used to group overlays. Deletes all existing overlays using this overlay id.
---@param utlstringtoken_1 utlstringtoken
---@return void
function CDebugOverlayScriptHelper:PushAndClearDebugOverlayScope(utlstringtoken_1) end

---Pushes an identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch.
---@param utlstringtoken_1 utlstringtoken
---@return void
function CDebugOverlayScriptHelper:PushDebugOverlayScope(utlstringtoken_1) end

---Removes all overlays marked with a specific identifier, regardless of their lifetime.
---@param utlstringtoken_1 utlstringtoken
---@return void
function CDebugOverlayScriptHelper:RemoveAllInScope(utlstringtoken_1) end

---Draws a solid cone. Specify endpoint and direction in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@param float_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param bool_9 boolean
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:SolidCone(Vector_1, Vector_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a wireframe sphere. Specify center in world space.
---@param Vector_1 Vector
---@param float_2 number
---@param int_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param bool_7 boolean
---@param float_8 number
---@return void
function CDebugOverlayScriptHelper:Sphere(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a swept box. Specify endpoints in world space and the bounds in local space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Quaternion_5 Quaternion
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param int_9 number
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:SweptBox(Vector_1, Vector_2, Vector_3, Vector_4, Quaternion_5, int_6, int_7, int_8, int_9, float_10) end

---Draws 2D text. Specify origin in world space.
---@param Vector_1 Vector
---@param int_2 number
---@param string_3 string
---@param float_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:Text(Vector_1, int_2, string_3, float_4, int_5, int_6, int_7, int_8, float_9) end

---Draws a screen-space texture. Coordinates are in pixels.
---@param string_1 string
---@param Vector2D_2 Vector2D
---@param Vector2D_3 Vector2D
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param Vector2D_8 Vector2D
---@param Vector2D_9 Vector2D
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:Texture(string_1, Vector2D_2, Vector2D_3, int_4, int_5, int_6, int_7, Vector2D_8, Vector2D_9, float_10) end

---Draws a filled triangle. Specify vertices in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param bool_8 boolean
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:Triangle(Vector_1, Vector_2, Vector_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws 3D text. Specify origin + orientation in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param string_3 string
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param bool_8 boolean
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:VectorText3D(Vector_1, Quaternion_2, string_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a vertical arrow. Specify endpoints in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 number
---@param int_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param bool_8 boolean
---@param float_9 number
---@return void
function CDebugOverlayScriptHelper:VertArrow(Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a arrow associated with a specific yaw. Specify endpoints in world space.
---@param Vector_1 Vector
---@param float_2 number
---@param float_3 number
---@param float_4 number
---@param int_5 number
---@param int_6 number
---@param int_7 number
---@param int_8 number
---@param bool_9 boolean
---@param float_10 number
---@return void
function CDebugOverlayScriptHelper:YawArrow(Vector_1, float_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---@class CDotaQuest : CBaseEntity
---Add a subquest to this quest
---@param hSubquest handle
---@return void
function CDotaQuest:AddSubquest(hSubquest) end

---Mark this quest complete
---@return void
function CDotaQuest:CompleteQuest() end

---Finds a subquest from this quest by index
---@param nIndex number
---@return handle
function CDotaQuest:GetSubquest(nIndex) end

---Finds a subquest from this quest by name
---@param pszName string
---@return handle
function CDotaQuest:GetSubquestByName(pszName) end

---Remove a subquest from this quest
---@param hSubquest handle
---@return void
function CDotaQuest:RemoveSubquest(hSubquest) end

---Set the text replace string for this quest
---@param pszString string
---@return void
function CDotaQuest:SetTextReplaceString(pszString) end

---Set a quest value
---@param valueSlot number
---@param value number
---@return void
function CDotaQuest:SetTextReplaceValue(valueSlot, value) end

---@class CDotaSubquestBase : CBaseEntity
---Mark this subquest complete
---@return void
function CDotaSubquestBase:CompleteSubquest() end

---Set the text replace string for this subquest
---@param pszString string
---@return void
function CDotaSubquestBase:SetTextReplaceString(pszString) end

---Set a subquest value
---@param valueSlot number
---@param value number
---@return void
function CDotaSubquestBase:SetTextReplaceValue(valueSlot, value) end

---@class CDotaTutorialNPCBlocker
---
---@param bEnabled boolean
---@return void
function CDotaTutorialNPCBlocker:SetEnabled(bEnabled) end

---
---@param hBlocker handle
---@return void
function CDotaTutorialNPCBlocker:SetOtherBlocker(hBlocker) end

---@class CEntities
---@type CEntities
Entities = CEntities
---Creates an entity by classname
---@param string_1 string
---@return handle
function CEntities:CreateByClassname(string_1) end

---Finds all entities by class name. Returns an array containing all the found entities.
---@param string_1 string
---@return table
function CEntities:FindAllByClassname(string_1) end

---Find entities by class name within a radius.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 number
---@return table
function CEntities:FindAllByClassnameWithin(string_1, Vector_2, float_3) end

---Find entities by model name.
---@param string_1 string
---@return table
function CEntities:FindAllByModel(string_1) end

---Find all entities by name. Returns an array containing all the found entities in it.
---@param string_1 string
---@return table
function CEntities:FindAllByName(string_1) end

---Find entities by name within a radius.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 number
---@return table
function CEntities:FindAllByNameWithin(string_1, Vector_2, float_3) end

---Find entities by targetname.
---@param string_1 string
---@return table
function CEntities:FindAllByTarget(string_1) end

---Find entities within a radius.
---@param Vector_1 Vector
---@param float_2 number
---@return table
function CEntities:FindAllInSphere(Vector_1, float_2) end

---Find entities by class name. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByClassname(handle_1, string_2) end

---Find entities by class name nearest to a point.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 number
---@return handle
function CEntities:FindByClassnameNearest(string_1, Vector_2, float_3) end

---Find entities by class name within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@param Vector_3 Vector
---@param float_4 number
---@return handle
function CEntities:FindByClassnameWithin(handle_1, string_2, Vector_3, float_4) end

---Find entities by model name. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByModel(handle_1, string_2) end

---Find entities by model name within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@param Vector_3 Vector
---@param float_4 number
---@return handle
function CEntities:FindByModelWithin(handle_1, string_2, Vector_3, float_4) end

---Find entities by name. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByName(handle_1, string_2) end

---Find entities by name nearest to a point.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 number
---@return handle
function CEntities:FindByNameNearest(string_1, Vector_2, float_3) end

---Find entities by name within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@param Vector_3 Vector
---@param float_4 number
---@return handle
function CEntities:FindByNameWithin(handle_1, string_2, Vector_3, float_4) end

---Find entities by targetname. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByTarget(handle_1, string_2) end

---Find entities within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param Vector_2 Vector
---@param float_3 number
---@return handle
function CEntities:FindInSphere(handle_1, Vector_2, float_3) end

---Begin an iteration over the list of entities
---@return handle
function CEntities:First() end

---Get the local player.
---@return handle
function CEntities:GetLocalPlayer() end

---Get the local player controller.
---@return handle
function CEntities:GetLocalPlayerController() end

---Get the local player pawn.
---@return handle
function CEntities:GetLocalPlayerPawn() end

---在实体列表上继续迭代，提供对以前找到的实体的引用;Continue an iteration over the list of entities, providing reference to a previously found entity
---@param handle_1 handle
---@return handle
function CEntities:Next(handle_1) end

---@class CEntityInstance
---Adds an I/O connection that will call the named function on this entity when the specified output fires.
---@param string_1 string
---@param string_2 string
---@return void
function CEntityInstance:ConnectOutput(string_1, string_2) end

---
---@return void
function CEntityInstance:Destroy() end

---Removes a connected script function from an I/O event on this entity.
---@param string_1 string
---@param string_2 string
---@return void
function CEntityInstance:DisconnectOutput(string_1, string_2) end

---Removes a connected script function from an I/O event on the passed entity.
---@param string_1 string
---@param string_2 string
---@param handle_3 handle
---@return void
function CEntityInstance:DisconnectRedirectedOutput(string_1, string_2, handle_3) end

---触发实体的output，需要在hammer中配置ouptput。
---@param sOutputName string
---@param hActivator handle
---@param hCaller handle
---@param table_4 table
---@param flDelay number
---@return void
function CEntityInstance:FireOutput(sOutputName, hActivator, hCaller, table_4, flDelay) end

---
---@return string
function CEntityInstance:GetClassname() end

---Get the entity name w/help if not defined (i.e. classname/etc)
---@return string
function CEntityInstance:GetDebugName() end

---Get the entity as an EHANDLE
---@return ehandle
function CEntityInstance:GetEntityHandle() end

---
---@return number
function CEntityInstance:GetEntityIndex() end

---Get Integer Attribute
---@param string_1 string
---@return number
function CEntityInstance:GetIntAttr(string_1) end

---
---@return string
function CEntityInstance:GetName() end

---Retrieve, creating if necessary, the private per-instance script-side data associated with an entity
---@return handle
function CEntityInstance:GetOrCreatePrivateScriptScope() end

---Retrieve, creating if necessary, the public script-side data associated with an entity
---@return handle
function CEntityInstance:GetOrCreatePublicScriptScope() end

---Retrieve the private per-instance script-side data associated with an entity
---@return handle
function CEntityInstance:GetPrivateScriptScope() end

---Retrieve the public script-side data associated with an entity
---@return handle
function CEntityInstance:GetPublicScriptScope() end

---Adds an I/O connection that will call the named function on the passed entity when the specified output fires.
---@param string_1 string
---@param string_2 string
---@param handle_3 handle
---@return void
function CEntityInstance:RedirectOutput(string_1, string_2, handle_3) end

---Delete this entity
---@return void
function CEntityInstance:RemoveSelf() end

---Set Integer Attribute
---@param string_1 string
---@param int_2 number
---@return void
function CEntityInstance:SetIntAttr(string_1, int_2) end

---
---@return number
function CEntityInstance:entindex() end

---@class CEnvEntityMaker : CBaseEntity
---Create an entity at the location of the maker
---@return void
function CEnvEntityMaker:SpawnEntity() end

---Create an entity at the location of a specified entity instance
---@param hEntity handle
---@return void
function CEnvEntityMaker:SpawnEntityAtEntityOrigin(hEntity) end

---Create an entity at a specified location and orientaton, orientation is Euler angle in degrees (pitch, yaw, roll)
---@param vecAlternateOrigin Vector
---@param vecAlternateAngles Vector
---@return void
function CEnvEntityMaker:SpawnEntityAtLocation(vecAlternateOrigin, vecAlternateAngles) end

---Create an entity at the location of a named entity
---@param pszName string
---@return void
function CEnvEntityMaker:SpawnEntityAtNamedEntityOrigin(pszName) end

---@class CEnvProjectedTexture : CBaseEntity
---Set light maximum range
---@param flRange number
---@return void
function CEnvProjectedTexture:SetFarRange(flRange) end

---Set light linear attenuation value
---@param flAtten number
---@return void
function CEnvProjectedTexture:SetLinearAttenuation(flAtten) end

---Set light minimum range
---@param flRange number
---@return void
function CEnvProjectedTexture:SetNearRange(flRange) end

---Set light quadratic attenuation value
---@param flAtten number
---@return void
function CEnvProjectedTexture:SetQuadraticAttenuation(flAtten) end

---Turn on/off light volumetrics: bool bOn, float flIntensity, float flNoise, int nPlanes, float flPlaneOffset
---@param bOn boolean
---@param flIntensity number
---@param flNoise number
---@param nPlanes number
---@param flPlaneOffset number
---@return void
function CEnvProjectedTexture:SetVolumetrics(bOn, flIntensity, flNoise, nPlanes, flPlaneOffset) end

---@class CFoWBlockerRegion
---AddRectangularBlocker( vMins, vMaxs, bClear ) : Sets or clears a blocker rectangle
---@param vMins Vector
---@param vMaxs Vector
---@param bClearRegion boolean
---@return void
function CFoWBlockerRegion:AddRectangularBlocker(vMins, vMaxs, bClearRegion) end

---AddRectangularOutlineBlocker( vMins, vMaxs, bClear ) : Sets or clears a blocker rectangle outline
---@param vMins Vector
---@param vMaxs Vector
---@param bClearRegion boolean
---@return void
function CFoWBlockerRegion:AddRectangularOutlineBlocker(vMins, vMaxs, bClearRegion) end

---@class CInfoData : CBaseEntity
---Query color data for this key
---@param tok utlstringtoken
---@param vDefault Vector
---@return Vector
function CInfoData:QueryColor(tok, vDefault) end

---Query float data for this key
---@param tok utlstringtoken
---@param flDefault number
---@return number
function CInfoData:QueryFloat(tok, flDefault) end

---Query int data for this key
---@param tok utlstringtoken
---@param nDefault number
---@return number
function CInfoData:QueryInt(tok, nDefault) end

---Query number data for this key
---@param tok utlstringtoken
---@param flDefault number
---@return number
function CInfoData:QueryNumber(tok, flDefault) end

---Query string data for this key
---@param tok utlstringtoken
---@param pDefault string
---@return string
function CInfoData:QueryString(tok, pDefault) end

---Query vector data for this key
---@param tok utlstringtoken
---@param vDefault Vector
---@return Vector
function CInfoData:QueryVector(tok, vDefault) end

---@class CInfoPlayerStartDota
---Returns whether the object is currently active
---@return boolean
function CInfoPlayerStartDota:IsEnabled() end

---Enable or disable the obstruction
---@param bEnabled boolean
---@return void
function CInfoPlayerStartDota:SetEnabled(bEnabled) end

---@class CInfoWorldLayer : CBaseEntity
---Hides this layer
---@return void
function CInfoWorldLayer:HideWorldLayer() end

---Shows this layer
---@return void
function CInfoWorldLayer:ShowWorldLayer() end

---@class CLogicRelay
---Trigger( hActivator, hCaller ) : Triggers the logic_relay
---@param hActivator handle
---@param hCaller handle
---@return void
function CLogicRelay:Trigger(hActivator, hCaller) end

---@class CMarkupVolumeTagged : CBaseEntity
---Does this volume have the given tag.
---@param pszTagName string
---@return boolean
function CMarkupVolumeTagged:HasTag(pszTagName) end

---@class CNativeOutputs
---Add an output
---@param string_1 string
---@param string_2 string
---@return void
function CNativeOutputs:AddOutput(string_1, string_2) end

---Initialize with number of outputs
---@param int_1 number
---@return void
function CNativeOutputs:Init(int_1) end

---@class CPhysicsProp : CBaseAnimating
---Disable motion for the prop
---@return void
function CPhysicsProp:DisableMotion() end

---Enable motion for the prop
---@return void
function CPhysicsProp:EnableMotion() end

---Enable/disable dynamic vs dynamic continuous collision traces
---@param bIsDynamicVsDynamicContinuousEnabled boolean
---@return void
function CPhysicsProp:SetDynamicVsDynamicContinuous(bIsDynamicVsDynamicContinuousEnabled) end

---@class CPointClientUIWorldPanel : CBaseModelEntity
---Tells the panel to accept user input.
---@return void
function CPointClientUIWorldPanel:AcceptUserInput() end

---Adds CSS class(es) to the panel
---@param pszClasses string
---@return void
function CPointClientUIWorldPanel:AddCSSClasses(pszClasses) end

---Tells the panel to ignore user input.
---@return void
function CPointClientUIWorldPanel:IgnoreUserInput() end

---Returns whether this entity is grabbable.
---@return boolean
function CPointClientUIWorldPanel:IsGrabbable() end

---Remove CSS class(es) from the panel
---@param pszClasses string
---@return void
function CPointClientUIWorldPanel:RemoveCSSClasses(pszClasses) end

---@class CPointTemplate : CBaseEntity
---DeleteCreatedSpawnGroups() : Deletes any spawn groups that this point_template has spawned. Note: The point_template will not be deleted by this.
---@return void
function CPointTemplate:DeleteCreatedSpawnGroups() end

---ForceSpawn() : Spawns all of the entities the point_template is pointing at.
---@return void
function CPointTemplate:ForceSpawn() end

---GetSpawnedEntities() : Get the list of the most recent spawned entities
---@return handle
function CPointTemplate:GetSpawnedEntities() end

---SetSpawnCallback( hCallbackFunc, hCallbackScope, hCallbackData ) : Set a callback for when the template spawns entities. The spawned entities will be passed in as an array.
---@param hCallbackFunc handle
---@param hCallbackScope handle
---@return void
function CPointTemplate:SetSpawnCallback(hCallbackFunc, hCallbackScope) end

---@class CPointWorldText : CBaseModelEntity
---Set the message on this entity.
---@param pMessage string
---@return void
function CPointWorldText:SetMessage(pMessage) end

---@class CSceneEntity : CBaseEntity
---Adds a team (by index) to the broadcast list
---@param int_1 number
---@return void
function CSceneEntity:AddBroadcastTeamTarget(int_1) end

---Cancel scene playback
---@return void
function CSceneEntity:Cancel() end

---Returns length of this scene in seconds.
---@return number
function CSceneEntity:EstimateLength() end

---Get the camera
---@return handle
function CSceneEntity:FindCamera() end

---given an entity reference, such as !target, get actual entity from scene object
---@param string_1 string
---@return handle
function CSceneEntity:FindNamedEntity(string_1) end

---If this scene is currently paused.
---@return boolean
function CSceneEntity:IsPaused() end

---If this scene is currently playing.
---@return boolean
function CSceneEntity:IsPlayingBack() end

---given a dummy scene name and a vcd string, load the scene
---@param string_1 string
---@param string_2 string
---@return boolean
function CSceneEntity:LoadSceneFromString(string_1, string_2) end

---Removes a team (by index) from the broadcast list
---@param int_1 number
---@return void
function CSceneEntity:RemoveBroadcastTeamTarget(int_1) end

---Start scene playback, takes activatorEntity as param
---@param handle_1 handle
---@return void
function CSceneEntity:Start(handle_1) end

---@class CScriptHTTPRequest
---Send a HTTP request.
---@param handle_1 handle
---@return boolean
function CScriptHTTPRequest:Send(handle_1) end

---Set the total timeout on the request.
---@param unsigned_1 unsigned
---@return boolean
function CScriptHTTPRequest:SetHTTPRequestAbsoluteTimeoutMS(unsigned_1) end

---Set a POST or GET parameter on the request.
---@param string_1 string
---@param string_2 string
---@return boolean
function CScriptHTTPRequest:SetHTTPRequestGetOrPostParameter(string_1, string_2) end

---Set a header value on the request.
---@param string_1 string
---@param string_2 string
---@return boolean
function CScriptHTTPRequest:SetHTTPRequestHeaderValue(string_1, string_2) end

---Set the network timeout on the request - this timer is reset when any data is received.
---@param unsigned_1 unsigned
---@return boolean
function CScriptHTTPRequest:SetHTTPRequestNetworkActivityTimeout(unsigned_1) end

---Set the literal body of a post - invalid after setting a post parameter.
---@param string_1 string
---@param string_2 string
---@return boolean
function CScriptHTTPRequest:SetHTTPRequestRawPostBody(string_1, string_2) end

---@class CScriptHeroList
---@type CScriptHeroList
HeroList = CScriptHeroList
---Returns all the heroes in the world
---@return table
function CScriptHeroList:GetAllHeroes() end

---Get the Nth hero in the Hero List
---@param int_1 number
---@return handle
function CScriptHeroList:GetHero(int_1) end

---Returns the number of heroes in the world
---@return number
function CScriptHeroList:GetHeroCount() end

---@class CScriptKeyValues
---Reads a spawn key
---@param string_1 string
---@return table
function CScriptKeyValues:GetValue(string_1) end

---@class CScriptParticleManager
---@type CScriptParticleManager
ParticleManager = CScriptParticleManager
---创建一个粒子特效，返回特效ID
---@param sParticleName string
---@param iAttachment number
---@param hOwner handle
---@return number
function CScriptParticleManager:CreateParticle(sParticleName, iAttachment, hOwner) end

---Creates a new particle effect that only plays for the specified player
---@param string_1 string
---@param int_2 number
---@param handle_3 handle
---@param handle_4 handle
---@return number
function CScriptParticleManager:CreateParticleForPlayer(string_1, int_2, handle_3, handle_4) end

---Creates a new particle effect that only plays for the specified team
---@param string_1 string
---@param int_2 number
---@param handle_3 handle
---@param int_4 number
---@return number
function CScriptParticleManager:CreateParticleForTeam(string_1, int_2, handle_3, int_4) end

---删除一个粒子特效。如果选择立即删除，将不会播放粒子的结束特效。
---@param iIndex number
---@param bDestroyImmediately boolean
---@return void
function CScriptParticleManager:DestroyParticle(iIndex, bDestroyImmediately) end

---获得该粒子特效在该单位身上的替换版本
---@param sParticleName string
---@param hCaster handle
---@return string
function CScriptParticleManager:GetParticleReplacement(sParticleName, hCaster) end

---施放一个特效的索引ID，施放后无法在控制该特效，请保证特效会自己销毁的情况下使用。
---@param iParticleID number
---@return void
function CScriptParticleManager:ReleaseParticleIndex(iParticleID) end

---
---@param int_1 number
---@return void
function CScriptParticleManager:SetParticleAlwaysSimulate(int_1) end

---Set the control point data for a control on a particle effect
---@param int_1 number
---@param int_2 number
---@param Vector_3 Vector
---@return void
function CScriptParticleManager:SetParticleControl(int_1, int_2, Vector_3) end

---将特效（iParticleID）的控制点（iCP）绑定到单位（handle_3）上，该控制点的数据会随着单位的移动而移动
---@param iParticleID number
---@param iCP number
---@param handle_3 handle
---@param int_4 number
---@param string_5 string
---@param Vector_6 Vector
---@param bool_7 boolean
---@return void
function CScriptParticleManager:SetParticleControlEnt(iParticleID, iCP, handle_3, int_4, string_5, Vector_6, bool_7) end

---(int iIndex, int iPoint, Vector vecPosition)
---@param int_1 number
---@param int_2 number
---@param Vector_3 Vector
---@return void
function CScriptParticleManager:SetParticleControlFallback(int_1, int_2, Vector_3) end

---(int nFXIndex, int nPoint, vForward)
---@param int_1 number
---@param int_2 number
---@param Vector_3 Vector
---@return void
function CScriptParticleManager:SetParticleControlForward(int_1, int_2, Vector_3) end

---(int nFXIndex, int nPoint, vForward, vRight, vUp) - Set the orientation for a control on a particle effect (NOTE: This is left handed -- bad!!)
---@param int_1 number
---@param int_2 number
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Vector_5 Vector
---@return void
function CScriptParticleManager:SetParticleControlOrientation(int_1, int_2, Vector_3, Vector_4, Vector_5) end

---(int nFXIndex, int nPoint, Vector vecForward, Vector vecLeft, Vector vecUp) - Set the orientation for a control on a particle effect
---@param int_1 number
---@param int_2 number
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Vector_5 Vector
---@return void
function CScriptParticleManager:SetParticleControlOrientationFLU(int_1, int_2, Vector_3, Vector_4, Vector_5) end

---设置粒子特效在战争迷雾中的属性。控制点为中心半径为flRadius的圆处于战争迷雾外，该特效即对敌人可见。如果填两个控制点则两点间的宽度为flRadius的矩形范围也计算。不填为-1。
---@param iParticleID number
---@param iControlPoint number
---@param iControlPoint2 number
---@param flRadius number
---@return void
function CScriptParticleManager:SetParticleFoWProperties(iParticleID, iControlPoint, iControlPoint2, flRadius) end

---int nfxindex, bool bCheckFoW
---@param int_1 number
---@param bool_2 boolean
---@return boolean
function CScriptParticleManager:SetParticleShouldCheckFoW(int_1, bool_2) end

---@class CScriptPrecacheContext
---Precaches a specific resource
---@param string_1 string
---@return void
function CScriptPrecacheContext:AddResource(string_1) end

---Reads a spawn key
---@param string_1 string
---@return table
function CScriptPrecacheContext:GetValue(string_1) end

---@class Convars : Convars
---@type Convars
ConVars = Convars
---GetBool(name) : returns the convar as a boolean flag.
---@param string_1 string
---@return table
function Convars:GetBool(string_1) end

---GetCommandClient() : returns the player who issued this console command.
---@return handle
function Convars:GetCommandClient() end

---GetDOTACommandClient() : returns the DOTA player who issued this console command.
---@return handle
function Convars:GetDOTACommandClient() end

---GetFloat(name) : returns the convar as a float. May return null if no such convar.
---@param string_1 string
---@return table
function Convars:GetFloat(string_1) end

---GetInt(name) : returns the convar as an int. May return null if no such convar.
---@param string_1 string
---@return table
function Convars:GetInt(string_1) end

---GetStr(name) : returns the convar as a string. May return null if no such convar.
---@param string_1 string
---@return table
function Convars:GetStr(string_1) end

---RegisterCommand(name, fn, helpString, flags) : register a console command.
---@param string_1 string
---@param handle_2 function
---@param string_3 string
---@param int_4 number
---@return void
function Convars:RegisterCommand(string_1, handle_2, string_3, int_4) end

---RegisterConvar(name, defaultValue, helpString, flags): register a new console variable.
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param int_4 number
---@return void
function Convars:RegisterConvar(string_1, string_2, string_3, int_4) end

---SetBool(name, val) : sets the value of the convar to the bool.
---@param string_1 string
---@param bool_2 boolean
---@return void
function Convars:SetBool(string_1, bool_2) end

---SetFloat(name, val) : sets the value of the convar to the float.
---@param string_1 string
---@param float_2 number
---@return void
function Convars:SetFloat(string_1, float_2) end

---SetInt(name, val) : sets the value of the convar to the int.
---@param string_1 string
---@param int_2 number
---@return void
function Convars:SetInt(string_1, int_2) end

---SetStr(name, val) : sets the value of the convar to the string.
---@param string_1 string
---@param string_2 string
---@return void
function Convars:SetStr(string_1, string_2) end

---@class GlobalSys : GlobalSys
---CommandLineCheck(name) : returns true if the command line param was used, otherwise false.
---@param string_1 string
---@return table
function GlobalSys:CommandLineCheck(string_1) end

---CommandLineFloat(name) : returns the command line param as a float.
---@param string_1 string
---@param float_2 number
---@return table
function GlobalSys:CommandLineFloat(string_1, float_2) end

---CommandLineInt(name) : returns the command line param as an int.
---@param string_1 string
---@param int_2 number
---@return table
function GlobalSys:CommandLineInt(string_1, int_2) end

---CommandLineStr(name) : returns the command line param as a string.
---@param string_1 string
---@param string_2 string
---@return table
function GlobalSys:CommandLineStr(string_1, string_2) end

---@class GridNav : GridNav
---Determine if it is possible to reach the specified end point from the specified start point. bool (vStart, vEnd)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return boolean
function GridNav:CanFindPath(Vector_1, Vector_2) end

---Destroy all trees in the area(vPosition, flRadius, bFullCollision
---@param Vector_1 Vector
---@param float_2 number
---@param bool_3 boolean
---@return void
function GridNav:DestroyTreesAroundPoint(Vector_1, float_2, bool_3) end

---Find a path between the two points an return the length of the path. If there is not a path between the points the returned value will be -1. float (vStart, vEnd )
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return number
function GridNav:FindPathLength(Vector_1, Vector_2) end

---Returns a table full of tree HSCRIPTS (vPosition, flRadius, bFullCollision).
---@param Vector_1 Vector
---@param float_2 number
---@param bool_3 boolean
---@return table
function GridNav:GetAllTreesAroundPoint(Vector_1, float_2, bool_3) end

---Get the X position of the center of a given X index
---@param int_1 number
---@return number
function GridNav:GridPosToWorldCenterX(int_1) end

---Get the Y position of the center of a given Y index
---@param int_1 number
---@return number
function GridNav:GridPosToWorldCenterY(int_1) end

---Checks whether the given position is blocked
---@param Vector_1 Vector
---@return boolean
function GridNav:IsBlocked(Vector_1) end

---(position, radius, checkFullTreeRadius?) Checks whether there are any trees overlapping the given point
---@param Vector_1 Vector
---@param float_2 number
---@param bool_3 boolean
---@return boolean
function GridNav:IsNearbyTree(Vector_1, float_2, bool_3) end

---判断目标位置是否可通行
---@param Vector_1 Vector
---@return boolean
function GridNav:IsTraversable(Vector_1) end

---Causes all trees in the map to regrow
---@return void
function GridNav:RegrowAllTrees() end

---Get the X index of a given world X position
---@param float_1 number
---@return number
function GridNav:WorldToGridPosX(float_1) end

---Get the Y index of a given world Y position
---@param float_1 number
---@return number
function GridNav:WorldToGridPosY(float_1) end

---@class ProjectileManager : ProjectileManager
---Update speed
---@param handle_1 handle
---@param int_2 number
---@return void
function ProjectileManager:ChangeTrackingProjectileSpeed(handle_1, int_2) end

---创建一个线性投射物，返回投射物ID。参数: Ability, Source, vSpawnOrigin, vVelocity, vAcceleration, fDistance, fStartRadius, fEndRadius, bHasFrontalCone, iUnitTargetTeam, iUnitTargetType, iUnitTargetFlags, bProvidesVision, iVisionTeamNumber, iVisionRadius, bDrawsOnMinimap, bVisibleToEnemies, bIgnoreSource,fExpireTime, fMaxSpeed
---@param tInfo handle
---@return number
function ProjectileManager:CreateLinearProjectile(tInfo) end

---Creates a tracking projectile
---@param handle_1 handle
---@return number
function ProjectileManager:CreateTrackingProjectile(handle_1) end

---Destroys the linear projectile matching the argument ID
---@param int_1 number
---@return void
function ProjectileManager:DestroyLinearProjectile(int_1) end

---Destroy a tracking projectile early
---@param int_1 number
---@return void
function ProjectileManager:DestroyTrackingProjectile(int_1) end

---Returns current location of projectile
---@param int_1 number
---@return Vector
function ProjectileManager:GetLinearProjectileLocation(int_1) end

---Returns current radius of projectile
---@param int_1 number
---@return number
function ProjectileManager:GetLinearProjectileRadius(int_1) end

---Returns a vector representing the current velocity of the projectile.
---@param int_1 number
---@return Vector
function ProjectileManager:GetLinearProjectileVelocity(int_1) end

---Returns current location of projectile
---@param int_1 number
---@return Vector
function ProjectileManager:GetTrackingProjectileLocation(int_1) end

---Is this a valid projectile?
---@param int_1 number
---@return boolean
function ProjectileManager:IsValidProjectile(int_1) end

---Makes the specified unit dodge projectiles
---@param handle_1 handle
---@return void
function ProjectileManager:ProjectileDodge(handle_1) end

---Update velocity
---@param int_1 number
---@param Vector_2 Vector
---@param float_3 number
---@return void
function ProjectileManager:UpdateLinearProjectileDirection(int_1, Vector_2, float_3) end

---@class SteamInfo : SteamInfo
---Is the script connected to the public Steam universe
---@return boolean
function SteamInfo:IsPublicUniverse() end

---@class Vector
---Cross product of two vectors.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:Cross(a, b) end

---Dot product of two vectors.
---@param a Vector
---@param b Vector
---@return number
function Vector:Dot(a, b) end

---Length of the Vector.
---@return number
function Vector:Length() end

---Length of the Vector in the XY plane.
---@return number
function Vector:Length2D() end

---Linear interpolation between the vector and the passed in target over t = [0,1].
---@param target Vector
---@param t number
---@return Vector
function Vector:Lerp(target, t) end

---Returns the vector normalized.
---@return Vector
function Vector:Normalized() end

---Overloaded +. Adds vectors together.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__add(a, b) end

---Overloaded /. Divides vectors.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__div(a, b) end

---Overloaded ==. Tests for Equality.
---@param a Vector
---@param b Vector
---@return boolean
function Vector:__eq(a, b) end

---Overloaded # returns the length of the vector.
---@return number
function Vector:__len() end

---Overloaded * returns the vectors multiplied together. can also be used to multiply with scalars.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__mul(a, b) end

---Overloaded -. Subtracts vectors
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__sub(a, b) end

---Overloaded .. Converts vectors to strings
---@return string
function Vector:__tostring() end

---Overloaded unary - operator. Reverses the vector.
---@return Vector
function Vector:__unm() end

---创建一个新的Vector，使用笛卡尔坐标系。成员变量x,y,z。
---@param x number
---@param y number
---@param z number
---@return Vector
function Vector:constructor(x, y, z) end

---@class QAngle
---Returns the forward vector.
---@return Vector
function QAngle:Forward() end

---Returns the Left vector.
---@return Vector
function QAngle:Left() end

---Returns the Up vector.
---@return Vector
function QAngle:Up() end

---Overloaded +. Adds angles together.<br>Note: Use RotateOrientation() instead to properly rotate angles.
---@param a QAngle
---@param b QAngle
---@return QAngle
function QAngle:__add(a, b) end

---Overloaded ==. Tests for Equality
---@param a QAngle
---@param b QAngle
---@return QAngle
function QAngle:__eq(a, b) end

---Overloaded .. Converts the QAngle to a human readable string.
---@return string
function QAngle:__tostring() end

---创建一个新的QAngle。成员变量x,y,z。
---@param pitch number
---@param yaw number
---@param roll number
---@return QAngle
function QAngle:constructor(pitch, yaw, roll) end

---@class utilsinit.lua
---将传入值限制在最大值与最小值之间。
---@param val number
---@param min number
---@param max number
---@return number
function Clamp(val, min, max) end

---将角度转换为弧度。
---@param deg number
---@return number
function Deg2Rad(deg) end

---线性插值。传入[0, 1]的值，返回[min, max]中的线性插值。
---@param val number
---@param min number
---@param max number
---@return number
function Lerp(val, min, max) end

---将两个表合并为第三个表，覆盖所有匹配键（t1覆盖t2）。
---@param t1 table
---@param t2 table
---@return table
function Merge(t1, t2) end

---将弧度转换为角度。
---@param rad number
---@return number
function Rad2Deg(rad) end

---将传入值从范围[a, b]映射到范围[c, d]。返回值有可能超过范围[c, d]。
---@param input number
---@param a number
---@param b number
---@param c number
---@param d number
---@return number
function RemapVal(input, a, b, c, d) end

---将传入值从范围[a, b]映射到范围[c, d]。并且将返回值限制在范围[c, d]。
---@param input number
---@param a number
---@param b number
---@param c number
---@param d number
---@return number
function RemapValClamped(input, a, b, c, d) end

---两个矢量之间的距离<br>return math.sqrt(VectorDistanceSq(v1, v2))
---@param v1 Vector
---@param v2 Vector
---@return number
function VectorDistance(v1, v2) end

---两个矢量之间的距离平方(比计算平面距离快)<br>return (v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y) + (v1.z - v2.z) * (v1.z - v2.z)
---@param v1 Vector
---@param v2 Vector
---@return number
function VectorDistanceSq(v1, v2) end

---检查向量是否为零向量。<br>return (v.x == 0.0) and (v.y == 0.0) and (v.z == 0.0)
---@param v Vector
---@return boolean
function VectorIsZero(v) end

---向量值在[0，1]上的线性插值。跟另一个全局函数LerpVectors功能一样。<br>return Vector(Lerp(t, a.x, b.x), Lerp(t, a.y, b.y), Lerp(t, a.z, b.z))
---@param t Vector
---@param v1 Vector
---@param v2 Vector
---@return Vector
function VectorLerp(t, v1, v2) end

---取绝对值
---@param val number
---@return number
function abs(val) end

---返回其中的较大值。
---@param a number
---@param b number
---@return number
function max(a, b) end

---返回其中的较小值。
---@param a number
---@param b number
---@return number
function min(a, b) end

---@class VLua
---Implements Squirrel clear table method.
---@param t table
---@return table
function vlua.clear(t) end

---Implements Squirrel clone operator.
---@param t table
---@return table
function vlua.clone(t) end

---Implements Squirrel three way compare operator ( <=> ).
---@param a number
---@param b number
---@return number
function vlua.compare(a, b) end

---Implements Squirrel in operator.
---@param t table
---@param key variable
---@return boolean
function vlua.contains(t, key) end

---Implements Squirrel slot delete operator.
---@param t table
---@param key variable
---@return table
function vlua.delete(t, key) end

---Implements Squirrel extend method for tables.
---@param o table
---@param array array
---@return table
function vlua.extend(o, array) end

---Implements Squirrel find method for tables and strings. (o, substr, [startidx]) for strings, (o, value) for tables
---param o [table/string]
---@param value variable
---@param startIndex number
---@return variable
function vlua.find(o, value, startIndex) end

---Implements Squirrel map method for tables.
---@param o table
---@param mapFunc function
---@return table
function vlua.map(o, mapFunc) end

---Implements Squirrel rawdelete library function.
---@param t table
---@param key variable
---@return table
function vlua.rawdelete(t, key) end

---Implements Squirrel rawin library function.
---@param t table
---@param key variable
---@return table
function vlua.rawin(t, key) end

---Implements Squirrel reduce method for tables.
---@param o table
---@param reduceFunc function
---@return table
function vlua.reduce(o, reduceFunc) end

---Implements Squirrel resize method for tables.
---@param o string
---@param size number
---@param fill variable
---@return table
function vlua.resize(o, size, fill) end

---Implements Squirrel reverse method for tables.
---@param o table
---@return table
function vlua.reverse(o) end

---Safe Ternary operator. The Lua version will return the wrong value if the value if true is nil.
---@param conditional boolean
---@param valueIfTrue variable
---@param valueIfFalse variable
---@return variable
function vlua.select(conditional, valueIfTrue, valueIfFalse) end

---Implements Squirrel slice method for tables and strings.
---param o [table/string]
---@param startIndex number
---@param endIndex number
---@return variable
function vlua.slice(o, startIndex, endIndex) end

---Implements Squirrel split function for strings.
---@param input string
---@param separator string
---@return table
function vlua.split(input, separator) end

---Implements tableadd function to support += paradigm used in Squirrel.
---@param t1 table
---@param t2 table
---@return table
function vlua.tableadd(t1, t2) end


-- ABILITY_TYPES 
ABILITY_TYPE_ATTRIBUTES = 2														--- 一般视为天赋技能类型
ABILITY_TYPE_BASIC = 0															--- 基础技能类型
ABILITY_TYPE_HIDDEN = 3															--- 隐藏技能，无效，使用DOTA_ABILITY_BEHAVIOR中的DOTA_ABILITY_BEHAVIOR_HIDDEN
ABILITY_TYPE_ULTIMATE = 1														--- 终极技能类型，拥有默认快捷键

-- AbilityLearnResult_t 
ABILITY_CANNOT_BE_UPGRADED_AT_MAX = 2											--- 技能不能升级，因为已达到最大等级
ABILITY_CANNOT_BE_UPGRADED_NOT_UPGRADABLE = 1
ABILITY_CANNOT_BE_UPGRADED_REQUIRES_LEVEL = 3									--- No Description Set
ABILITY_CAN_BE_UPGRADED = 0														--- No Description Set
ABILITY_NOT_LEARNABLE = 4														--- No Description Set

-- AttributeDerivedStats 
DOTA_ATTRIBUTE_AGILITY_ARMOR = 4												--- No Description Set
DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED = 5											--- No Description Set
DOTA_ATTRIBUTE_AGILITY_DAMAGE = 3												--- No Description Set
DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE = 6											--- No Description Set
DOTA_ATTRIBUTE_INTELLIGENCE_MANA = 7											--- No Description Set
DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN = 8										--- No Description Set
DOTA_ATTRIBUTE_STRENGTH_DAMAGE = 0												--- No Description Set
DOTA_ATTRIBUTE_STRENGTH_HP = 1													--- No Description Set
DOTA_ATTRIBUTE_STRENGTH_HP_REGEN = 2											--- No Description Set

-- Attributes 
DOTA_ATTRIBUTE_AGILITY = 1														--- 敏捷属性
DOTA_ATTRIBUTE_INTELLECT = 2													--- 智力属性
DOTA_ATTRIBUTE_INVALID = -1
DOTA_ATTRIBUTE_MAX = 3
DOTA_ATTRIBUTE_STRENGTH = 0														--- 力量属性

-- DAMAGE_TYPES 
DAMAGE_TYPE_ABILITY_DEFINED = 22
DAMAGE_TYPE_ALL = 7																--- 在伤害判断的时候，全部类型伤害均通过
DAMAGE_TYPE_HP_REMOVAL = 8														--- 生命转移类伤害，效果与sethealth类似。不会遭受反伤。例如盛宴，骨法的虹吸
DAMAGE_TYPE_MAGICAL = 2															--- 魔法伤害，受到魔法抗性的影响。
DAMAGE_TYPE_NONE = 0															--- 无类型
DAMAGE_TYPE_PHYSICAL = 1														--- 物理伤害，受到护甲与伤害格挡影响，跟魔法抗性无关且不能影响虚无单位。
DAMAGE_TYPE_PURE = 4															--- 神圣伤害，纯粹伤害，

-- DOTAAbilitySpeakTrigger_t 
DOTA_ABILITY_SPEAK_CAST = 1
DOTA_ABILITY_SPEAK_START_ACTION_PHASE = 0

-- DOTADamageFlag_t 
DOTA_DAMAGE_FLAG_BYPASSES_BLOCK = 8												--- 绕过伤害格挡
DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY = 4									--- 绕过无敌
DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN = 2048					--- 当伤害来源不可见时，不显示造成的伤害。
DOTA_DAMAGE_FLAG_FORCE_SPELL_AMPLIFICATION = 65536
DOTA_DAMAGE_FLAG_HPLOSS = 32													--- 生命移除
DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR = 16384							--- 无视基础护甲
DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR = 1										--- 无视魔抗
DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR = 2										--- 无视护甲
DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK = 131072
DOTA_DAMAGE_FLAG_NONE = 0														--- 没有
DOTA_DAMAGE_FLAG_NON_LETHAL = 128												--- 不致死
DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS = 512									--- 没有伤害放大
DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT = 64
DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION = 1024									--- 没有技能增强
DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL = 4096										--- 没有技能吸血
DOTA_DAMAGE_FLAG_PROPERTY_FIRE = 8192											--- 火焰属性
DOTA_DAMAGE_FLAG_REFLECTION = 16												--- 不反弹
DOTA_DAMAGE_FLAG_SECONDARY_PROJECTILE_ATTACK = 32768
DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY = 256

-- DOTAHUDVisibility_t 
DOTA_HUD_CUSTOMUI_BEHIND_HUD_ELEMENTS = 28
DOTA_HUD_VISIBILITY_ACTION_MINIMAP = 4											--- 小地图
DOTA_HUD_VISIBILITY_ACTION_PANEL = 3
DOTA_HUD_VISIBILITY_AGHANIMS_STATUS = 29
DOTA_HUD_VISIBILITY_COUNT = 30
DOTA_HUD_VISIBILITY_ENDGAME = 22
DOTA_HUD_VISIBILITY_ENDGAME_CHAT = 23
DOTA_HUD_VISIBILITY_HERO_SELECTION_CLOCK = 16
DOTA_HUD_VISIBILITY_HERO_SELECTION_GAME_NAME = 15
DOTA_HUD_VISIBILITY_HERO_SELECTION_TEAMS = 14
DOTA_HUD_VISIBILITY_INVALID = -1
DOTA_HUD_VISIBILITY_INVENTORY_COURIER = 9
DOTA_HUD_VISIBILITY_INVENTORY_GOLD = 11
DOTA_HUD_VISIBILITY_INVENTORY_ITEMS = 7
DOTA_HUD_VISIBILITY_INVENTORY_PANEL = 5
DOTA_HUD_VISIBILITY_INVENTORY_PROTECT = 10
DOTA_HUD_VISIBILITY_INVENTORY_QUICKBUY = 8
DOTA_HUD_VISIBILITY_INVENTORY_SHOP = 6
DOTA_HUD_VISIBILITY_KILLCAM = 26
DOTA_HUD_VISIBILITY_PREGAME_STRATEGYUI = 25
DOTA_HUD_VISIBILITY_QUICK_STATS = 24
DOTA_HUD_VISIBILITY_SHOP_COMMONITEMS = 13
DOTA_HUD_VISIBILITY_SHOP_SUGGESTEDITEMS = 12
DOTA_HUD_VISIBILITY_TOP_BAR = 27
DOTA_HUD_VISIBILITY_TOP_BAR_BACKGROUND = 18
DOTA_HUD_VISIBILITY_TOP_BAR_DIRE_TEAM = 20
DOTA_HUD_VISIBILITY_TOP_BAR_RADIANT_TEAM = 19
DOTA_HUD_VISIBILITY_TOP_BAR_SCORE = 21
DOTA_HUD_VISIBILITY_TOP_HEROES = 1
DOTA_HUD_VISIBILITY_TOP_MENU_BUTTONS = 17
DOTA_HUD_VISIBILITY_TOP_SCOREBOARD = 2
DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY = 0

-- DOTAInventoryFlags_t 
DOTA_INVENTORY_ALLOW_DROP_AT_FOUNTAIN = 8
DOTA_INVENTORY_ALLOW_DROP_ON_GROUND = 4
DOTA_INVENTORY_ALLOW_MAIN = 1
DOTA_INVENTORY_ALLOW_NONE = 0
DOTA_INVENTORY_ALLOW_STASH = 2
DOTA_INVENTORY_ALL_ACCESS = 3
DOTA_INVENTORY_LIMIT_DROP_ON_GROUND = 16

-- DOTALimits_t 
DOTA_DEFAULT_MAX_TEAM = 5														--- Default number of players per team.
DOTA_DEFAULT_MAX_TEAM_PLAYERS = 10												--- Default number of non-spectator players supported.
DOTA_MAX_PLAYERS = 64															--- Max number of players connected to the server including spectators.
DOTA_MAX_PLAYER_TEAMS = 10														--- Max number of player teams supported.
DOTA_MAX_SPECTATOR_LOBBY_SIZE = 15												--- Max number of viewers in a spectator lobby.
DOTA_MAX_SPECTATOR_TEAM_SIZE = 40												--- How many spectators can watch.
DOTA_MAX_TEAM = 24																--- Max number of players per team.
DOTA_MAX_TEAM_PLAYERS = 24														--- Max number of non-spectator players supported.

-- DOTAMinimapEvent_t 
DOTA_MINIMAP_EVENT_ANCIENT_UNDER_ATTACK = 2
DOTA_MINIMAP_EVENT_BASE_GLYPHED = 8
DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK = 4
DOTA_MINIMAP_EVENT_CANCEL_TELEPORTING = 2048
DOTA_MINIMAP_EVENT_ENEMY_TELEPORTING = 1024
DOTA_MINIMAP_EVENT_HINT_LOCATION = 512
DOTA_MINIMAP_EVENT_MOVE_TO_TARGET = 16384
DOTA_MINIMAP_EVENT_RADAR = 4096
DOTA_MINIMAP_EVENT_RADAR_TARGET = 8192
DOTA_MINIMAP_EVENT_TEAMMATE_DIED = 64
DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING = 32
DOTA_MINIMAP_EVENT_TEAMMATE_UNDER_ATTACK = 16
DOTA_MINIMAP_EVENT_TUTORIAL_TASK_ACTIVE = 128
DOTA_MINIMAP_EVENT_TUTORIAL_TASK_FINISHED = 256

-- DOTAModifierAttribute_t 
MODIFIER_ATTRIBUTE_AURA_PRIORITY = 8
MODIFIER_ATTRIBUTE_IGNORE_DODGE = 16
MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE = 4										--- No Description Set
MODIFIER_ATTRIBUTE_MULTIPLE = 2													--- No Description Set
MODIFIER_ATTRIBUTE_NONE = 0
MODIFIER_ATTRIBUTE_PERMANENT = 1												--- No Description Set

-- DOTAMusicStatus_t 
DOTA_MUSIC_STATUS_BATTLE = 2
DOTA_MUSIC_STATUS_DEAD = 4
DOTA_MUSIC_STATUS_EXPLORATION = 1
DOTA_MUSIC_STATUS_LAST = 5
DOTA_MUSIC_STATUS_NONE = 0
DOTA_MUSIC_STATUS_PRE_GAME_EXPLORATION = 3

-- DOTAProjectileAttachment_t 
DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 = 1
DOTA_PROJECTILE_ATTACHMENT_ATTACK_2 = 2
DOTA_PROJECTILE_ATTACHMENT_ATTACK_3 = 4
DOTA_PROJECTILE_ATTACHMENT_ATTACK_4 = 5
DOTA_PROJECTILE_ATTACHMENT_HITLOCATION = 3
DOTA_PROJECTILE_ATTACHMENT_LAST = 6
DOTA_PROJECTILE_ATTACHMENT_NONE = 0

-- DOTAScriptInventorySlot_t 
DOTA_ITEM_SLOT_1 = 0
DOTA_ITEM_SLOT_2 = 1
DOTA_ITEM_SLOT_3 = 2
DOTA_ITEM_SLOT_4 = 3
DOTA_ITEM_SLOT_5 = 4
DOTA_ITEM_SLOT_6 = 5
DOTA_ITEM_SLOT_7 = 6
DOTA_ITEM_SLOT_8 = 7
DOTA_ITEM_SLOT_9 = 8
DOTA_STASH_SLOT_1 = 9
DOTA_STASH_SLOT_2 = 10
DOTA_STASH_SLOT_3 = 11
DOTA_STASH_SLOT_4 = 12
DOTA_STASH_SLOT_5 = 13
DOTA_STASH_SLOT_6 = 14

-- DOTASlotType_t 
DOTA_LOADOUT_PERSONA_1_END = 56
DOTA_LOADOUT_PERSONA_1_START = 29
DOTA_LOADOUT_TYPE_ABILITY1 = 23
DOTA_LOADOUT_TYPE_ABILITY1_PERSONA_1 = 51
DOTA_LOADOUT_TYPE_ABILITY2 = 24
DOTA_LOADOUT_TYPE_ABILITY2_PERSONA_1 = 52
DOTA_LOADOUT_TYPE_ABILITY3 = 25
DOTA_LOADOUT_TYPE_ABILITY3_PERSONA_1 = 53
DOTA_LOADOUT_TYPE_ABILITY4 = 26
DOTA_LOADOUT_TYPE_ABILITY4_PERSONA_1 = 54
DOTA_LOADOUT_TYPE_ABILITY_ATTACK = 22
DOTA_LOADOUT_TYPE_ABILITY_ATTACK_PERSONA_1 = 50
DOTA_LOADOUT_TYPE_ABILITY_ULTIMATE = 27
DOTA_LOADOUT_TYPE_ABILITY_ULTIMATE_PERSONA_1 = 55
DOTA_LOADOUT_TYPE_AMBIENT_EFFECTS = 21
DOTA_LOADOUT_TYPE_AMBIENT_EFFECTS_PERSONA_1 = 49
DOTA_LOADOUT_TYPE_ANNOUNCER = 59
DOTA_LOADOUT_TYPE_ARMOR = 7
DOTA_LOADOUT_TYPE_ARMOR_PERSONA_1 = 36
DOTA_LOADOUT_TYPE_ARMS = 6
DOTA_LOADOUT_TYPE_ARMS_PERSONA_1 = 35
DOTA_LOADOUT_TYPE_BACK = 10
DOTA_LOADOUT_TYPE_BACK_PERSONA_1 = 39
DOTA_LOADOUT_TYPE_BELT = 8
DOTA_LOADOUT_TYPE_BELT_PERSONA_1 = 37
DOTA_LOADOUT_TYPE_BLINK_EFFECT = 70
DOTA_LOADOUT_TYPE_BODY_HEAD = 16
DOTA_LOADOUT_TYPE_BODY_HEAD_PERSONA_1 = 44
DOTA_LOADOUT_TYPE_COSTUME = 15
DOTA_LOADOUT_TYPE_COUNT = 87
DOTA_LOADOUT_TYPE_COURIER = 58
DOTA_LOADOUT_TYPE_COURIER_EFFECT = 83
DOTA_LOADOUT_TYPE_CURSOR_PACK = 68
DOTA_LOADOUT_TYPE_DEATH_EFFECT = 80
DOTA_LOADOUT_TYPE_DIRE_CREEPS = 74
DOTA_LOADOUT_TYPE_DIRE_SIEGE_CREEPS = 85
DOTA_LOADOUT_TYPE_DIRE_TOWER = 76
DOTA_LOADOUT_TYPE_EMBLEM = 71
DOTA_LOADOUT_TYPE_GLOVES = 11
DOTA_LOADOUT_TYPE_GLOVES_PERSONA_1 = 41
DOTA_LOADOUT_TYPE_HEAD = 4
DOTA_LOADOUT_TYPE_HEAD_EFFECT = 81
DOTA_LOADOUT_TYPE_HEAD_PERSONA_1 = 33
DOTA_LOADOUT_TYPE_HEROIC_STATUE = 66
DOTA_LOADOUT_TYPE_HUD_SKIN = 63
DOTA_LOADOUT_TYPE_INVALID = -1
DOTA_LOADOUT_TYPE_KILL_EFFECT = 79
DOTA_LOADOUT_TYPE_LEGS = 12
DOTA_LOADOUT_TYPE_LEGS_PERSONA_1 = 40
DOTA_LOADOUT_TYPE_LOADING_SCREEN = 64
DOTA_LOADOUT_TYPE_MAP_EFFECT = 82
DOTA_LOADOUT_TYPE_MEGA_KILLS = 60
DOTA_LOADOUT_TYPE_MISC = 14
DOTA_LOADOUT_TYPE_MISC_PERSONA_1 = 43
DOTA_LOADOUT_TYPE_MOUNT = 17
DOTA_LOADOUT_TYPE_MOUNT_PERSONA_1 = 45
DOTA_LOADOUT_TYPE_MULTIKILL_BANNER = 67
DOTA_LOADOUT_TYPE_MUSIC = 61
DOTA_LOADOUT_TYPE_NECK = 9
DOTA_LOADOUT_TYPE_NECK_PERSONA_1 = 38
DOTA_LOADOUT_TYPE_NONE = 86
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON = 1
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON2 = 3
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON2_PERSONA_1 = 32
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON_PERSONA_1 = 30
DOTA_LOADOUT_TYPE_PERSONA_SELECTOR = 57
DOTA_LOADOUT_TYPE_RADIANT_CREEPS = 73
DOTA_LOADOUT_TYPE_RADIANT_SIEGE_CREEPS = 84
DOTA_LOADOUT_TYPE_RADIANT_TOWER = 75
DOTA_LOADOUT_TYPE_SHAPESHIFT = 19
DOTA_LOADOUT_TYPE_SHAPESHIFT_PERSONA_1 = 47
DOTA_LOADOUT_TYPE_SHOULDER = 5
DOTA_LOADOUT_TYPE_SHOULDER_PERSONA_1 = 34
DOTA_LOADOUT_TYPE_STREAK_EFFECT = 78
DOTA_LOADOUT_TYPE_SUMMON = 18
DOTA_LOADOUT_TYPE_SUMMON_PERSONA_1 = 46
DOTA_LOADOUT_TYPE_TAIL = 13
DOTA_LOADOUT_TYPE_TAIL_PERSONA_1 = 42
DOTA_LOADOUT_TYPE_TAUNT = 20
DOTA_LOADOUT_TYPE_TAUNT_PERSONA_1 = 48
DOTA_LOADOUT_TYPE_TELEPORT_EFFECT = 69
DOTA_LOADOUT_TYPE_TERRAIN = 72
DOTA_LOADOUT_TYPE_VERSUS_SCREEN = 77
DOTA_LOADOUT_TYPE_VOICE = 28
DOTA_LOADOUT_TYPE_VOICE_PERSONA_1 = 56
DOTA_LOADOUT_TYPE_WARD = 62
DOTA_LOADOUT_TYPE_WEAPON = 0
DOTA_LOADOUT_TYPE_WEAPON2 = 2
DOTA_LOADOUT_TYPE_WEAPON2_PERSONA_1 = 31
DOTA_LOADOUT_TYPE_WEAPON_PERSONA_1 = 29
DOTA_LOADOUT_TYPE_WEATHER = 65
DOTA_PLAYER_LOADOUT_END = 85
DOTA_PLAYER_LOADOUT_START = 58

-- DOTASpeechType_t 
DOTA_SPEECH_BAD_TEAM = 7
DOTA_SPEECH_GOOD_TEAM = 6
DOTA_SPEECH_RECIPIENT_TYPE_MAX = 10
DOTA_SPEECH_SPECTATOR = 8
DOTA_SPEECH_USER_ALL = 5
DOTA_SPEECH_USER_INVALID = 0
DOTA_SPEECH_USER_NEARBY = 4
DOTA_SPEECH_USER_SINGLE = 1
DOTA_SPEECH_USER_TEAM = 2
DOTA_SPEECH_USER_TEAM_NEARBY = 3
DOTA_SPEECH_USER_TEAM_NOSPECTATOR = 9

-- DOTATeam_t 
DOTA_TEAM_BADGUYS = 3															--- 夜魇
DOTA_TEAM_COUNT = 14
DOTA_TEAM_CUSTOM_1 = 6
DOTA_TEAM_CUSTOM_2 = 7
DOTA_TEAM_CUSTOM_3 = 8
DOTA_TEAM_CUSTOM_4 = 9
DOTA_TEAM_CUSTOM_5 = 10
DOTA_TEAM_CUSTOM_6 = 11
DOTA_TEAM_CUSTOM_7 = 12
DOTA_TEAM_CUSTOM_8 = 13
DOTA_TEAM_CUSTOM_COUNT = 8
DOTA_TEAM_CUSTOM_MAX = 13
DOTA_TEAM_CUSTOM_MIN = 6
DOTA_TEAM_FIRST = 2
DOTA_TEAM_GOODGUYS = 2															--- 天辉
DOTA_TEAM_NEUTRALS = 4															--- 中立
DOTA_TEAM_NOTEAM = 5															--- 没有队伍

-- DOTAUnitAttackCapability_t 
DOTA_UNIT_ATTACK_CAPABILITY_BIT_COUNT = 3
DOTA_UNIT_CAP_MELEE_ATTACK = 1													--- 近战攻击
DOTA_UNIT_CAP_NO_ATTACK = 0														--- 没有攻击
DOTA_UNIT_CAP_RANGED_ATTACK = 2													--- 远程攻击
DOTA_UNIT_CAP_RANGED_ATTACK_DIRECTIONAL = 4

-- DOTAUnitMoveCapability_t 
DOTA_UNIT_CAP_MOVE_FLY = 2														--- 飞行移动能力
DOTA_UNIT_CAP_MOVE_GROUND = 1													--- 地面移动能力
DOTA_UNIT_CAP_MOVE_NONE = 0														--- 没有移动能力

-- DOTA_ABILITY_BEHAVIOR 
DOTA_ABILITY_BEHAVIOR_AOE = 32													--- 范围型技能
DOTA_ABILITY_BEHAVIOR_ATTACK = 131072
DOTA_ABILITY_BEHAVIOR_AURA = 65536												--- 光环
DOTA_ABILITY_BEHAVIOR_AUTOCAST = 4096											--- 自动施法
DOTA_ABILITY_BEHAVIOR_CAN_SELF_CAST = 0											--- 不能对自己施放，仅做显示用。
DOTA_ABILITY_BEHAVIOR_CHANNELLED = 128											--- 持续施法
DOTA_ABILITY_BEHAVIOR_DIRECTIONAL = 1024
DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET = 16777216
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL = 536870912
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT = 8388608
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK = 33554432
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT = 262144
DOTA_ABILITY_BEHAVIOR_FREE_DRAW_TARGETING = 0
DOTA_ABILITY_BEHAVIOR_HIDDEN = 1												--- 隐藏
DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING = 134217728								--- 无视后摇
DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL = 4194304
DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE = 2097152
DOTA_ABILITY_BEHAVIOR_IGNORE_SILENCE = 0										--- 无视沉默
DOTA_ABILITY_BEHAVIOR_IMMEDIATE = 2048											--- 立即
DOTA_ABILITY_BEHAVIOR_ITEM = 256
DOTA_ABILITY_BEHAVIOR_LAST_RESORT_POINT = -2147483648
DOTA_ABILITY_BEHAVIOR_NONE = 0
DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN = 67108864
DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE = 64										--- 不能学习
DOTA_ABILITY_BEHAVIOR_NO_TARGET = 4												--- 无目标
DOTA_ABILITY_BEHAVIOR_OPTIONAL_NO_TARGET = 32768
DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT = 16384
DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET = 8192
DOTA_ABILITY_BEHAVIOR_OVERSHOOT = 0
DOTA_ABILITY_BEHAVIOR_PASSIVE = 2												--- 被动
DOTA_ABILITY_BEHAVIOR_POINT = 16												--- 点目标
DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES = 524288									--- 缠绕时不可用
DOTA_ABILITY_BEHAVIOR_RUNE_TARGET = 268435456									--- 可选神符目标
DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES = 0
DOTA_ABILITY_BEHAVIOR_SUPPRESS_ASSOCIATED_CONSUMABLE = 0
DOTA_ABILITY_BEHAVIOR_TOGGLE = 512												--- 开关型
DOTA_ABILITY_BEHAVIOR_UNIT_TARGET = 8											--- 单位目标
DOTA_ABILITY_BEHAVIOR_UNLOCKED_BY_EFFECT_INDEX = 0
DOTA_ABILITY_BEHAVIOR_UNRESTRICTED = 1048576									--- 不受限制，死亡的时候也能使用，但是死亡的时候不能转身所以有些技能放不出来，可以修改成无视转身或者立即施法。
DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING = 1073741824								--- 矢量技能

-- DOTA_GameState 
DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP = 2
DOTA_GAMERULES_STATE_DISCONNECT = 11
DOTA_GAMERULES_STATE_GAME_IN_PROGRESS = 9
DOTA_GAMERULES_STATE_HERO_SELECTION = 3
DOTA_GAMERULES_STATE_INIT = 0
DOTA_GAMERULES_STATE_POST_GAME = 10
DOTA_GAMERULES_STATE_PRE_GAME = 7
DOTA_GAMERULES_STATE_SCENARIO_SETUP = 8
DOTA_GAMERULES_STATE_STRATEGY_TIME = 4
DOTA_GAMERULES_STATE_TEAM_SHOWCASE = 5
DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD = 6
DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD = 1

-- DOTA_HeroPickState 
DOTA_HEROPICK_STATE_ALL_DRAFT_SELECT = 57
DOTA_HEROPICK_STATE_AP_SELECT = 1
DOTA_HEROPICK_STATE_AR_SELECT = 32
DOTA_HEROPICK_STATE_BD_SELECT = 54
DOTA_HEROPICK_STATE_CD_BAN1 = 37
DOTA_HEROPICK_STATE_CD_BAN2 = 38
DOTA_HEROPICK_STATE_CD_BAN3 = 39
DOTA_HEROPICK_STATE_CD_BAN4 = 40
DOTA_HEROPICK_STATE_CD_BAN5 = 41
DOTA_HEROPICK_STATE_CD_BAN6 = 42
DOTA_HEROPICK_STATE_CD_CAPTAINPICK = 36
DOTA_HEROPICK_STATE_CD_INTRO = 35
DOTA_HEROPICK_STATE_CD_PICK = 53
DOTA_HEROPICK_STATE_CD_SELECT1 = 43
DOTA_HEROPICK_STATE_CD_SELECT10 = 52
DOTA_HEROPICK_STATE_CD_SELECT2 = 44
DOTA_HEROPICK_STATE_CD_SELECT3 = 45
DOTA_HEROPICK_STATE_CD_SELECT4 = 46
DOTA_HEROPICK_STATE_CD_SELECT5 = 47
DOTA_HEROPICK_STATE_CD_SELECT6 = 48
DOTA_HEROPICK_STATE_CD_SELECT7 = 49
DOTA_HEROPICK_STATE_CD_SELECT8 = 50
DOTA_HEROPICK_STATE_CD_SELECT9 = 51
DOTA_HEROPICK_STATE_CM_BAN1 = 7
DOTA_HEROPICK_STATE_CM_BAN10 = 16
DOTA_HEROPICK_STATE_CM_BAN11 = 17
DOTA_HEROPICK_STATE_CM_BAN12 = 18
DOTA_HEROPICK_STATE_CM_BAN13 = 19
DOTA_HEROPICK_STATE_CM_BAN14 = 20
DOTA_HEROPICK_STATE_CM_BAN2 = 8
DOTA_HEROPICK_STATE_CM_BAN3 = 9
DOTA_HEROPICK_STATE_CM_BAN4 = 10
DOTA_HEROPICK_STATE_CM_BAN5 = 11
DOTA_HEROPICK_STATE_CM_BAN6 = 12
DOTA_HEROPICK_STATE_CM_BAN7 = 13
DOTA_HEROPICK_STATE_CM_BAN8 = 14
DOTA_HEROPICK_STATE_CM_BAN9 = 15
DOTA_HEROPICK_STATE_CM_CAPTAINPICK = 6
DOTA_HEROPICK_STATE_CM_INTRO = 5
DOTA_HEROPICK_STATE_CM_PICK = 31
DOTA_HEROPICK_STATE_CM_SELECT1 = 21
DOTA_HEROPICK_STATE_CM_SELECT10 = 30
DOTA_HEROPICK_STATE_CM_SELECT2 = 22
DOTA_HEROPICK_STATE_CM_SELECT3 = 23
DOTA_HEROPICK_STATE_CM_SELECT4 = 24
DOTA_HEROPICK_STATE_CM_SELECT5 = 25
DOTA_HEROPICK_STATE_CM_SELECT6 = 26
DOTA_HEROPICK_STATE_CM_SELECT7 = 27
DOTA_HEROPICK_STATE_CM_SELECT8 = 28
DOTA_HEROPICK_STATE_CM_SELECT9 = 29
DOTA_HEROPICK_STATE_COUNT = 62
DOTA_HEROPICK_STATE_CUSTOM_PICK_RULES = 60
DOTA_HEROPICK_STATE_FH_SELECT = 34
DOTA_HEROPICK_STATE_INTRO_SELECT_UNUSED = 3
DOTA_HEROPICK_STATE_MO_SELECT = 33
DOTA_HEROPICK_STATE_NONE = 0
DOTA_HEROPICK_STATE_RD_SELECT_UNUSED = 4
DOTA_HEROPICK_STATE_SCENARIO_PICK = 61
DOTA_HEROPICK_STATE_SD_SELECT = 2
DOTA_HEROPICK_STATE_SELECT_PENALTY = 59
DOTA_HERO_PICK_STATE_ABILITY_DRAFT_SELECT = 55
DOTA_HERO_PICK_STATE_ARDM_SELECT = 56
DOTA_HERO_PICK_STATE_CUSTOMGAME_SELECT = 58

-- DOTA_MOTION_CONTROLLER_PRIORITY 
DOTA_MOTION_CONTROLLER_PRIORITY_HIGH = 3										--- 运动控制器优先级：高
DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST = 4										--- 运动控制器优先级：最高
DOTA_MOTION_CONTROLLER_PRIORITY_LOW = 1											--- 运动控制器优先级：低
DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST = 0										--- 运动控制器优先级：最低
DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM = 2										--- 运动控制器优先级：中

-- DOTA_RUNES 
DOTA_RUNE_ARCANE = 6															--- 奥术神符
DOTA_RUNE_BOUNTY = 5															--- 赏金神符
DOTA_RUNE_COUNT = 8
DOTA_RUNE_DOUBLEDAMAGE = 0														--- 双倍神符
DOTA_RUNE_HASTE = 1																--- 急速神符
DOTA_RUNE_ILLUSION = 2															--- 幻象神符
DOTA_RUNE_INVALID = -1
DOTA_RUNE_INVISIBILITY = 3														--- 隐身神符
DOTA_RUNE_REGENERATION = 4														--- 恢复神符
DOTA_RUNE_WATER = 7

-- DOTA_SHOP_TYPE 
DOTA_SHOP_CUSTOM = 6
DOTA_SHOP_GROUND = 3
DOTA_SHOP_HOME = 0
DOTA_SHOP_NEUTRALS = 7
DOTA_SHOP_NONE = 8
DOTA_SHOP_SECRET = 2
DOTA_SHOP_SECRET2 = 5
DOTA_SHOP_SIDE = 1
DOTA_SHOP_SIDE2 = 4

-- DOTA_UNIT_TARGET_FLAGS 
DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP = 65536								--- 检查是否禁用帮助
DOTA_UNIT_TARGET_FLAG_DEAD = 8													--- 死亡单位
DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE = 128											--- 迷雾可见
DOTA_UNIT_TARGET_FLAG_INVULNERABLE = 64											--- 无敌
DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES = 16									--- 魔法免疫的敌人
DOTA_UNIT_TARGET_FLAG_MANA_ONLY = 32768											--- 拥有魔法
DOTA_UNIT_TARGET_FLAG_MELEE_ONLY = 4											--- 只有近战
DOTA_UNIT_TARGET_FLAG_NONE = 0													--- 没有标记
DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS = 512										--- 没有远古单位
DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE = 16384									--- 没有攻击免疫单位
DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO = 131072									--- 没有英雄级普通单位
DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED = 2048										--- 没有被支配的单位
DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS = 8192										--- 没有幻象
DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES = 32								--- 没有魔法免疫的单位
DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED = 524288									--- 没有噩梦状态单位
DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED = 4096										--- 没有召唤物
DOTA_UNIT_TARGET_FLAG_NO_INVIS = 256											--- 没有隐身单位
DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD = 262144										--- 不在游戏中的单位
DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED = 1024									--- 玩家控制的单位
DOTA_UNIT_TARGET_FLAG_PREFER_ENEMIES = 1048576
DOTA_UNIT_TARGET_FLAG_RANGED_ONLY = 2											--- 只有远程
DOTA_UNIT_TARGET_FLAG_RESPECT_OBSTRUCTIONS = 2097152

-- DOTA_UNIT_TARGET_TEAM 
DOTA_UNIT_TARGET_TEAM_BOTH = 3													--- 双方队伍
DOTA_UNIT_TARGET_TEAM_CUSTOM = 4
DOTA_UNIT_TARGET_TEAM_ENEMY = 2													--- 敌方队伍
DOTA_UNIT_TARGET_TEAM_FRIENDLY = 1												--- 友方队伍
DOTA_UNIT_TARGET_TEAM_NONE = 0													--- 没有队伍

-- DOTA_UNIT_TARGET_TYPE 
DOTA_UNIT_TARGET_ALL = 55
DOTA_UNIT_TARGET_BASIC = 18														--- DOTA_UNIT_TARGET_COURIER + DOTA_UNIT_TARGET_CREEP
DOTA_UNIT_TARGET_BUILDING = 4													--- 以防御塔为目标
DOTA_UNIT_TARGET_COURIER = 16													--- 信使目标
DOTA_UNIT_TARGET_CREEP = 2														--- 普通单位目标
DOTA_UNIT_TARGET_CUSTOM = 128
DOTA_UNIT_TARGET_HERO = 1														--- 英雄目标
DOTA_UNIT_TARGET_NONE = 0														--- 没有目标
DOTA_UNIT_TARGET_OTHER = 32
DOTA_UNIT_TARGET_TREE = 64														--- 以树为目标

-- DamageCategory_t 
DOTA_DAMAGE_CATEGORY_ATTACK = 1													--- 攻击伤害类型
DOTA_DAMAGE_CATEGORY_SPELL = 0													--- 施法伤害类型

-- DotaDefaultUIElement_t 
DOTA_DEFAULT_UI_ACTION_MINIMAP = 4
DOTA_DEFAULT_UI_ACTION_PANEL = 3
DOTA_DEFAULT_UI_AGHANIMS_STATUS = 29
DOTA_DEFAULT_UI_CUSTOMUI_BEHIND_HUD_ELEMENTS = 28
DOTA_DEFAULT_UI_ELEMENT_COUNT = 30
DOTA_DEFAULT_UI_ENDGAME = 22
DOTA_DEFAULT_UI_ENDGAME_CHAT = 23
DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD = 2
DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK = 16
DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME = 15
DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS = 14
DOTA_DEFAULT_UI_INVALID = -1
DOTA_DEFAULT_UI_INVENTORY_COURIER = 9
DOTA_DEFAULT_UI_INVENTORY_GOLD = 11
DOTA_DEFAULT_UI_INVENTORY_ITEMS = 7
DOTA_DEFAULT_UI_INVENTORY_PANEL = 5
DOTA_DEFAULT_UI_INVENTORY_PROTECT = 10
DOTA_DEFAULT_UI_INVENTORY_QUICKBUY = 8
DOTA_DEFAULT_UI_INVENTORY_SHOP = 6
DOTA_DEFAULT_UI_KILLCAM = 26
DOTA_DEFAULT_UI_PREGAME_STRATEGYUI = 25
DOTA_DEFAULT_UI_QUICK_STATS = 24
DOTA_DEFAULT_UI_SHOP_COMMONITEMS = 13
DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS = 12
DOTA_DEFAULT_UI_TOP_BAR = 27
DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND = 18
DOTA_DEFAULT_UI_TOP_BAR_DIRE_TEAM = 20
DOTA_DEFAULT_UI_TOP_BAR_RADIANT_TEAM = 19
DOTA_DEFAULT_UI_TOP_BAR_SCORE = 21
DOTA_DEFAULT_UI_TOP_HEROES = 1
DOTA_DEFAULT_UI_TOP_MENU_BUTTONS = 17
DOTA_DEFAULT_UI_TOP_TIMEOFDAY = 0

-- EDOTA_ModifyGold_Reason 
DOTA_ModifyGold_AbandonedRedistribute = 5										--- 队友掉线后分配的金钱
DOTA_ModifyGold_AbilityCost = 7													--- 技能消耗
DOTA_ModifyGold_AbilityGold = 19
DOTA_ModifyGold_BountyRune = 17													--- 赏金符
DOTA_ModifyGold_Building = 11													--- 建筑金钱奖励
DOTA_ModifyGold_Buyback = 2														--- 买活消耗
DOTA_ModifyGold_CheatCommand = 8												--- 作弊指令
DOTA_ModifyGold_CourierKill = 16												--- 信使击杀
DOTA_ModifyGold_CourierKilledByThisPlayer = 21
DOTA_ModifyGold_CreepKill = 13													--- 杀怪金钱奖励
DOTA_ModifyGold_Death = 1														--- 死亡金钱损失
DOTA_ModifyGold_GameTick = 10													--- 固定工资
DOTA_ModifyGold_HeroKill = 12													--- 英雄击杀
DOTA_ModifyGold_NeutralKill = 14												--- 野怪击杀
DOTA_ModifyGold_PurchaseConsumable = 3											--- 购买消耗品
DOTA_ModifyGold_PurchaseItem = 4												--- 购买物品
DOTA_ModifyGold_RoshanKill = 15													--- 肉山击杀
DOTA_ModifyGold_SelectionPenalty = 9											--- 选择英雄超时金钱惩罚
DOTA_ModifyGold_SellItem = 6													--- 出售物品
DOTA_ModifyGold_SharedGold = 18
DOTA_ModifyGold_Unspecified = 0													--- 未指定
DOTA_ModifyGold_WardKill = 20													--- 排眼金钱奖励

-- EDOTA_ModifyXP_Reason 
DOTA_ModifyXP_CreepKill = 2														--- 杀怪经验奖励
DOTA_ModifyXP_HeroKill = 1														--- 英雄击杀经验奖励
DOTA_ModifyXP_MAX = 6
DOTA_ModifyXP_Outpost = 5
DOTA_ModifyXP_RoshanKill = 3													--- 肉山击杀经验奖励
DOTA_ModifyXP_TomeOfKnowledge = 4												--- 经验书奖励
DOTA_ModifyXP_Unspecified = 0													--- 未指定

-- EShareAbility 
ITEM_FULLY_SHAREABLE = 0														--- 完全共享
ITEM_NOT_SHAREABLE = 2															--- 不共享
ITEM_PARTIALLY_SHAREABLE = 1													--- 部分共享

-- GameActivity_t 
ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END = 1580
ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START = 1572
ACT_DOTA_ALCHEMIST_CONCOCTION = 1573
ACT_DOTA_ALCHEMIST_CONCOCTION_THROW = 1579
ACT_DOTA_AMBUSH = 1627
ACT_DOTA_ANCESTRAL_SPIRIT = 1677
ACT_DOTA_ARCTIC_BURN_END = 1682
ACT_DOTA_AREA_DENY = 1661
ACT_DOTA_ATTACK = 1503
ACT_DOTA_ATTACK2 = 1504
ACT_DOTA_ATTACK_EVENT = 1505
ACT_DOTA_ATTACK_EVENT_BASH = 1705
ACT_DOTA_ATTACK_SPECIAL = 1758
ACT_DOTA_AW_MAGNETIC_FIELD = 1707
ACT_DOTA_BELLYACHE_END = 1614
ACT_DOTA_BELLYACHE_LOOP = 1613
ACT_DOTA_BELLYACHE_START = 1612
ACT_DOTA_BLINK_DAGGER = 1732
ACT_DOTA_BLINK_DAGGER_END = 1733
ACT_DOTA_BRIDGE_DESTROY = 1640
ACT_DOTA_BRIDGE_THREAT = 1650
ACT_DOTA_CAGED_CREEP_RAGE = 1644
ACT_DOTA_CAGED_CREEP_RAGE_OUT = 1645
ACT_DOTA_CAGED_CREEP_SMASH = 1646
ACT_DOTA_CAGED_CREEP_SMASH_OUT = 1647
ACT_DOTA_CANCEL_SIREN_SONG = 1599
ACT_DOTA_CAPTURE = 1533
ACT_DOTA_CAPTURE_CARD = 1717
ACT_DOTA_CAPTURE_PET = 1698
ACT_DOTA_CAPTURE_RARE = 1706
ACT_DOTA_CAST_ABILITY_1 = 1510
ACT_DOTA_CAST_ABILITY_1_END = 1540
ACT_DOTA_CAST_ABILITY_2 = 1511
ACT_DOTA_CAST_ABILITY_2_ALLY = 1748
ACT_DOTA_CAST_ABILITY_2_END = 1541
ACT_DOTA_CAST_ABILITY_2_ES_ROLL = 1653
ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END = 1654
ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START = 1652
ACT_DOTA_CAST_ABILITY_3 = 1512
ACT_DOTA_CAST_ABILITY_3_END = 1542
ACT_DOTA_CAST_ABILITY_4 = 1513
ACT_DOTA_CAST_ABILITY_4_END = 1543
ACT_DOTA_CAST_ABILITY_5 = 1514
ACT_DOTA_CAST_ABILITY_6 = 1515
ACT_DOTA_CAST_ABILITY_7 = 1598
ACT_DOTA_CAST_ABILITY_ROT = 1547
ACT_DOTA_CAST_ALACRITY = 1585
ACT_DOTA_CAST_ALACRITY_ORB = 1741
ACT_DOTA_CAST_BURROW_END = 1702
ACT_DOTA_CAST_CHAOS_METEOR = 1586
ACT_DOTA_CAST_CHAOS_METEOR_ORB = 1742
ACT_DOTA_CAST_COLD_SNAP = 1581
ACT_DOTA_CAST_COLD_SNAP_ORB = 1737
ACT_DOTA_CAST_DEAFENING_BLAST = 1590
ACT_DOTA_CAST_DEAFENING_BLAST_ORB = 1746
ACT_DOTA_CAST_DRAGONBREATH = 1538
ACT_DOTA_CAST_EMP = 1584
ACT_DOTA_CAST_EMP_ORB = 1740
ACT_DOTA_CAST_FORGE_SPIRIT = 1588
ACT_DOTA_CAST_FORGE_SPIRIT_ORB = 1744
ACT_DOTA_CAST_GHOST_SHIP = 1708
ACT_DOTA_CAST_GHOST_WALK = 1582
ACT_DOTA_CAST_GHOST_WALK_ORB = 1738
ACT_DOTA_CAST_ICE_WALL = 1589
ACT_DOTA_CAST_ICE_WALL_ORB = 1745
ACT_DOTA_CAST_LIFE_BREAK_END = 1564
ACT_DOTA_CAST_LIFE_BREAK_START = 1563
ACT_DOTA_CAST_REFRACTION = 1597
ACT_DOTA_CAST_SUN_STRIKE = 1587
ACT_DOTA_CAST_SUN_STRIKE_ORB = 1743
ACT_DOTA_CAST_TORNADO = 1583
ACT_DOTA_CAST_TORNADO_ORB = 1739
ACT_DOTA_CAST_WILD_AXES_END = 1562
ACT_DOTA_CENTAUR_STAMPEDE = 1611
ACT_DOTA_CHANNEL_ABILITY_1 = 1520
ACT_DOTA_CHANNEL_ABILITY_2 = 1521
ACT_DOTA_CHANNEL_ABILITY_3 = 1522
ACT_DOTA_CHANNEL_ABILITY_4 = 1523
ACT_DOTA_CHANNEL_ABILITY_5 = 1524
ACT_DOTA_CHANNEL_ABILITY_6 = 1525
ACT_DOTA_CHANNEL_ABILITY_7 = 1600
ACT_DOTA_CHANNEL_END_ABILITY_1 = 1526
ACT_DOTA_CHANNEL_END_ABILITY_2 = 1527
ACT_DOTA_CHANNEL_END_ABILITY_3 = 1528
ACT_DOTA_CHANNEL_END_ABILITY_4 = 1529
ACT_DOTA_CHANNEL_END_ABILITY_5 = 1530
ACT_DOTA_CHANNEL_END_ABILITY_6 = 1531
ACT_DOTA_CHILLING_TOUCH = 1673
ACT_DOTA_COLD_FEET = 1671
ACT_DOTA_CONSTANT_LAYER = 1532
ACT_DOTA_CUSTOM_TOWER_ATTACK = 1734
ACT_DOTA_CUSTOM_TOWER_DIE = 1736
ACT_DOTA_CUSTOM_TOWER_HIGH_FIVE = 1757
ACT_DOTA_CUSTOM_TOWER_IDLE = 1735
ACT_DOTA_CUSTOM_TOWER_IDLE_RARE = 1755
ACT_DOTA_CUSTOM_TOWER_TAUNT = 1756
ACT_DOTA_DAGON = 1651
ACT_DOTA_DEATH_BY_SNIPER = 1642
ACT_DOTA_DEFEAT = 1592
ACT_DOTA_DEFEAT_START = 1711
ACT_DOTA_DIE = 1506
ACT_DOTA_DIE_SPECIAL = 1548
ACT_DOTA_DISABLED = 1509
ACT_DOTA_DP_SPIRIT_SIPHON = 1712
ACT_DOTA_EARTHSHAKER_TOTEM_ATTACK = 1570
ACT_DOTA_ECHO_SLAM = 1539
ACT_DOTA_ENFEEBLE = 1674
ACT_DOTA_ES_STONE_CALLER = 1714
ACT_DOTA_FATAL_BONDS = 1675
ACT_DOTA_FLAIL = 1508
ACT_DOTA_FLEE = 1685
ACT_DOTA_FLINCH = 1507
ACT_DOTA_FORCESTAFF_END = 1602
ACT_DOTA_FRUSTRATION = 1630
ACT_DOTA_FXANIM = 1709
ACT_DOTA_GENERIC_CHANNEL_1 = 1728
ACT_DOTA_GENERIC_CHANNEL_1_START = 1754
ACT_DOTA_GESTURE_ACCENT = 1625
ACT_DOTA_GESTURE_POINT = 1624
ACT_DOTA_GREET = 1690
ACT_DOTA_GREEVIL_BLINK_BONE = 1621
ACT_DOTA_GREEVIL_CAST = 1617
ACT_DOTA_GREEVIL_HOOK_END = 1620
ACT_DOTA_GREEVIL_HOOK_START = 1619
ACT_DOTA_GREEVIL_OVERRIDE_ABILITY = 1618
ACT_DOTA_GS_INK_CREATURE = 1730
ACT_DOTA_GS_SOUL_CHAIN = 1729
ACT_DOTA_ICE_VORTEX = 1672
ACT_DOTA_IDLE = 1500
ACT_DOTA_IDLE_IMPATIENT = 1636
ACT_DOTA_IDLE_IMPATIENT_SWORD_TAP = 1648
ACT_DOTA_IDLE_RARE = 1501
ACT_DOTA_IDLE_SLEEPING = 1622
ACT_DOTA_IDLE_SLEEPING_END = 1639
ACT_DOTA_INTRO = 1623
ACT_DOTA_INTRO_LOOP = 1649
ACT_DOTA_ITEM_DROP = 1697
ACT_DOTA_ITEM_LOOK = 1628
ACT_DOTA_ITEM_PICKUP = 1696
ACT_DOTA_JAKIRO_LIQUIDFIRE_LOOP = 1575
ACT_DOTA_JAKIRO_LIQUIDFIRE_START = 1574
ACT_DOTA_KILLTAUNT = 1535
ACT_DOTA_KINETIC_FIELD = 1679
ACT_DOTA_LASSO_LOOP = 1578
ACT_DOTA_LEAP_STUN = 1658
ACT_DOTA_LEAP_SWIPE = 1659
ACT_DOTA_LIFESTEALER_ASSIMILATE = 1703
ACT_DOTA_LIFESTEALER_EJECT = 1704
ACT_DOTA_LIFESTEALER_INFEST = 1576
ACT_DOTA_LIFESTEALER_INFEST_END = 1577
ACT_DOTA_LIFESTEALER_OPEN_WOUNDS = 1567
ACT_DOTA_LIFESTEALER_RAGE = 1566
ACT_DOTA_LOADOUT = 1601
ACT_DOTA_LOADOUT_RARE = 1683
ACT_DOTA_LOOK_AROUND = 1643
ACT_DOTA_MAGNUS_SKEWER_END = 1606
ACT_DOTA_MAGNUS_SKEWER_START = 1605
ACT_DOTA_MEDUSA_STONE_GAZE = 1607
ACT_DOTA_MIDNIGHT_PULSE = 1676
ACT_DOTA_MINI_TAUNT = 1681
ACT_DOTA_MK_FUR_ARMY = 1722
ACT_DOTA_MK_SPRING_CAST = 1723
ACT_DOTA_MK_SPRING_END = 1719
ACT_DOTA_MK_SPRING_SOAR = 1718
ACT_DOTA_MK_STRIKE = 1715
ACT_DOTA_MK_TREE_END = 1721
ACT_DOTA_MK_TREE_SOAR = 1720
ACT_DOTA_NECRO_GHOST_SHROUD = 1724
ACT_DOTA_NIAN_INTRO_LEAP = 1660
ACT_DOTA_NIAN_PIN_END = 1657
ACT_DOTA_NIAN_PIN_LOOP = 1656
ACT_DOTA_NIAN_PIN_START = 1655
ACT_DOTA_NIAN_PIN_TO_STUN = 1662
ACT_DOTA_NIGHTSTALKER_TRANSITION = 1565
ACT_DOTA_NOTICE = 1747
ACT_DOTA_OVERRIDE_ABILITY_1 = 1516
ACT_DOTA_OVERRIDE_ABILITY_2 = 1517
ACT_DOTA_OVERRIDE_ABILITY_3 = 1518
ACT_DOTA_OVERRIDE_ABILITY_4 = 1519
ACT_DOTA_OVERRIDE_ARCANA = 1725
ACT_DOTA_OVERRIDE_LOADOUT = 1751
ACT_DOTA_PET_LEVEL = 1701
ACT_DOTA_PET_WARD_OBSERVER = 1699
ACT_DOTA_PET_WARD_SENTRY = 1700
ACT_DOTA_PIERCE_THE_VEIL = 1760
ACT_DOTA_POOF_END = 1603
ACT_DOTA_PRESENT_ITEM = 1635
ACT_DOTA_RATTLETRAP_BATTERYASSAULT = 1549
ACT_DOTA_RATTLETRAP_HOOKSHOT_END = 1553
ACT_DOTA_RATTLETRAP_HOOKSHOT_LOOP = 1552
ACT_DOTA_RATTLETRAP_HOOKSHOT_START = 1551
ACT_DOTA_RATTLETRAP_POWERCOGS = 1550
ACT_DOTA_RAZE_1 = 1663
ACT_DOTA_RAZE_2 = 1664
ACT_DOTA_RAZE_3 = 1665
ACT_DOTA_RELAX_END = 1610
ACT_DOTA_RELAX_LOOP = 1609
ACT_DOTA_RELAX_LOOP_END = 1634
ACT_DOTA_RELAX_START = 1608
ACT_DOTA_ROQUELAIRE_LAND = 1615
ACT_DOTA_ROQUELAIRE_LAND_IDLE = 1616
ACT_DOTA_RUN = 1502
ACT_DOTA_SAND_KING_BURROW_IN = 1568
ACT_DOTA_SAND_KING_BURROW_OUT = 1569
ACT_DOTA_SHAKE = 1687
ACT_DOTA_SHALLOW_GRAVE = 1670
ACT_DOTA_SHARPEN_WEAPON = 1637
ACT_DOTA_SHARPEN_WEAPON_OUT = 1638
ACT_DOTA_SHOPKEEPER_PET_INTERACT = 1695
ACT_DOTA_SHRUG = 1633
ACT_DOTA_SHUFFLE_L = 1749
ACT_DOTA_SHUFFLE_R = 1750
ACT_DOTA_SLARK_POUNCE = 1604
ACT_DOTA_SLEEPING_END = 1626
ACT_DOTA_SLIDE = 1726
ACT_DOTA_SLIDE_LOOP = 1727
ACT_DOTA_SPAWN = 1534
ACT_DOTA_SPIRIT_BREAKER_CHARGE_END = 1594
ACT_DOTA_SPIRIT_BREAKER_CHARGE_POSE = 1593
ACT_DOTA_STARTLE = 1629
ACT_DOTA_STATIC_STORM = 1680
ACT_DOTA_SWIM = 1684
ACT_DOTA_SWIM_IDLE = 1688
ACT_DOTA_TAUNT = 1536
ACT_DOTA_TAUNT_SNIPER = 1641
ACT_DOTA_TAUNT_SPECIAL = 1752
ACT_DOTA_TELEPORT = 1595
ACT_DOTA_TELEPORT_COOP_END = 1693
ACT_DOTA_TELEPORT_COOP_EXIT = 1694
ACT_DOTA_TELEPORT_COOP_START = 1691
ACT_DOTA_TELEPORT_COOP_WAIT = 1692
ACT_DOTA_TELEPORT_END = 1596
ACT_DOTA_TELEPORT_END_REACT = 1632
ACT_DOTA_TELEPORT_REACT = 1631
ACT_DOTA_TELEPORT_START = 1753
ACT_DOTA_THIRST = 1537
ACT_DOTA_THUNDER_STRIKE = 1678
ACT_DOTA_TINKER_REARM1 = 1555
ACT_DOTA_TINKER_REARM2 = 1556
ACT_DOTA_TINKER_REARM3 = 1557
ACT_DOTA_TRANSITION = 1731
ACT_DOTA_TRANSITION_IDLE = 1759
ACT_DOTA_TRICKS_END = 1713
ACT_DOTA_TROT = 1686
ACT_DOTA_UNDYING_DECAY = 1666
ACT_DOTA_UNDYING_SOUL_RIP = 1667
ACT_DOTA_UNDYING_TOMBSTONE = 1668
ACT_DOTA_VERSUS = 1716
ACT_DOTA_VICTORY = 1591
ACT_DOTA_VICTORY_START = 1710
ACT_DOTA_WAIT_IDLE = 1689
ACT_DOTA_WEAVERBUG_ATTACH = 1561
ACT_DOTA_WHEEL_LAYER = 1571
ACT_DOTA_WHIRLING_AXES_RANGED = 1669
ACT_MIRANA_LEAP_END = 1544
ACT_STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE = 1554
ACT_TINY_AVALANCHE = 1558
ACT_TINY_GROWL = 1560
ACT_TINY_TOSS = 1559
ACT_WAVEFORM_END = 1546
ACT_WAVEFORM_START = 1545

-- LuaModifierType 
LUA_MODIFIER_INVALID = 4
LUA_MODIFIER_MOTION_BOTH = 3
LUA_MODIFIER_MOTION_HORIZONTAL = 1
LUA_MODIFIER_MOTION_NONE = 0
LUA_MODIFIER_MOTION_VERTICAL = 2

-- ParticleAttachment_t 
MAX_PATTACH_TYPES = 16
PATTACH_ABSORIGIN = 0
PATTACH_ABSORIGIN_FOLLOW = 1
PATTACH_CENTER_FOLLOW = 13
PATTACH_CUSTOMORIGIN = 2
PATTACH_CUSTOMORIGIN_FOLLOW = 3
PATTACH_CUSTOM_GAME_STATE_1 = 14
PATTACH_EYES_FOLLOW = 6
PATTACH_HEALTHBAR = 15
PATTACH_INVALID = -1
PATTACH_MAIN_VIEW = 11
PATTACH_OVERHEAD_FOLLOW = 7
PATTACH_POINT = 4
PATTACH_POINT_FOLLOW = 5
PATTACH_RENDERORIGIN_FOLLOW = 10
PATTACH_ROOTBONE_FOLLOW = 9
PATTACH_WATERWAKE = 12
PATTACH_WORLDORIGIN = 8

-- UnitFilterResult 
UF_FAIL_ANCIENT = 9																--- 无法对远古单位施放
UF_FAIL_ATTACK_IMMUNE = 22														--- 目标无法被攻击
UF_FAIL_BUILDING = 6															--- 无法对建筑物施放
UF_FAIL_CONSIDERED_HERO = 4														--- 技能不能以此英雄为目标
UF_FAIL_COURIER = 7																--- 无法对信使施放
UF_FAIL_CREEP = 5																--- 无法对普通单位施放
UF_FAIL_CUSTOM = 23																--- 自定义
UF_FAIL_DEAD = 15																--- 死亡
UF_FAIL_DISABLE_HELP = 25														--- 目标设置了禁用帮助
UF_FAIL_DOMINATED = 12															--- 无法对被支配单位施放
UF_FAIL_ENEMY = 2																--- 无法对敌军施放
UF_FAIL_FRIENDLY = 1															--- 无法对友军施放
UF_FAIL_HERO = 3																--- 无法对英雄施放
UF_FAIL_ILLUSION = 10															--- 技能无法以幻象为目标
UF_FAIL_INVALID_LOCATION = 24													--- 无效目标
UF_FAIL_INVISIBLE = 20
UF_FAIL_INVULNERABLE = 18
UF_FAIL_IN_FOW = 19
UF_FAIL_MAGIC_IMMUNE_ALLY = 16
UF_FAIL_MAGIC_IMMUNE_ENEMY = 17
UF_FAIL_MELEE = 13
UF_FAIL_NIGHTMARED = 27
UF_FAIL_NOT_PLAYER_CONTROLLED = 21
UF_FAIL_OBSTRUCTED = 28
UF_FAIL_OTHER = 8
UF_FAIL_OUT_OF_WORLD = 26
UF_FAIL_RANGED = 14
UF_FAIL_SUMMONED = 11
UF_SUCCESS = 0

-- attackfail 
DOTA_ATTACK_RECORD_CANNOT_FAIL = 6												--- 必中
DOTA_ATTACK_RECORD_FAIL_BLOCKED_BY_OBSTRUCTION = 7								--- 被障碍物阻挡
DOTA_ATTACK_RECORD_FAIL_NO = 0													--- 没有丢失
DOTA_ATTACK_RECORD_FAIL_SOURCE_MISS = 2											--- 自身丢失
DOTA_ATTACK_RECORD_FAIL_TARGET_EVADED = 3										--- 目标闪避
DOTA_ATTACK_RECORD_FAIL_TARGET_INVULNERABLE = 4									--- 目标无敌？
DOTA_ATTACK_RECORD_FAIL_TARGET_OUT_OF_RANGE = 5									--- 超出缓冲距离
DOTA_ATTACK_RECORD_FAIL_TERRAIN_MISS = 1										--- 地形丢失

-- modifierfunction 
MODIFIER_EVENT_ON_ABILITY_END_CHANNEL = 186										--- 当持续施法结束
MODIFIER_EVENT_ON_ABILITY_EXECUTED = 183										--- 当任意类型技能使用时触发,OnSpellStart前的一瞬间，同帧
MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = 184										--- 当技能完成释放时触发，不会触发切换型技能，事件在MODIFIER_EVENT_ON_ABILITY_EXECUTED后触发。
MODIFIER_EVENT_ON_ABILITY_START = 182											--- 当技能开始抬手时就会触发，不会触发切换技能类型
MODIFIER_EVENT_ON_ASSIST = 231
MODIFIER_EVENT_ON_ATTACK = 175													--- 整个攻击行为事件
MODIFIER_EVENT_ON_ATTACKED = 196												--- 当受到攻击时
MODIFIER_EVENT_ON_ATTACK_ALLIED = 178											--- No Description Set
MODIFIER_EVENT_ON_ATTACK_CANCELLED = 244
MODIFIER_EVENT_ON_ATTACK_FAIL = 177												--- 当攻击失败时，失败的具体记录查看 常量attackfail
MODIFIER_EVENT_ON_ATTACK_FINISHED = 234											--- No Description Set
MODIFIER_EVENT_ON_ATTACK_LANDED = 176
MODIFIER_EVENT_ON_ATTACK_RECORD = 173
MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = 241
MODIFIER_EVENT_ON_ATTACK_START = 174
MODIFIER_EVENT_ON_ATTEMPT_PROJECTILE_DODGE = 251
MODIFIER_EVENT_ON_BREAK_INVISIBILITY = 185										--- No Description Set
MODIFIER_EVENT_ON_BUILDING_KILLED = 208											--- No Description Set
MODIFIER_EVENT_ON_DAMAGE_CALCULATED = 194
MODIFIER_EVENT_ON_DEATH = 197
MODIFIER_EVENT_ON_DEATH_PREVENTED = 190
MODIFIER_EVENT_ON_DOMINATED = 229
MODIFIER_EVENT_ON_HEALTH_GAINED = 203
MODIFIER_EVENT_ON_HEAL_RECEIVED = 207
MODIFIER_EVENT_ON_HERO_KILLED = 206												--- 击杀英雄事件。传进来的参数里attacker为玩家的主英雄，unit为实际凶手单位，target为死亡目标。(反了，attacker是击杀玩家英雄的，params.unit才是玩家英雄，不是有范例吗，还写错了)
MODIFIER_EVENT_ON_KILL = 230
MODIFIER_EVENT_ON_MAGIC_DAMAGE_CALCULATED = 195
MODIFIER_EVENT_ON_MANA_GAINED = 204
MODIFIER_EVENT_ON_MODEL_CHANGED = 209
MODIFIER_EVENT_ON_MODIFIER_ADDED = 210
MODIFIER_EVENT_ON_ORB_EFFECT = 192
MODIFIER_EVENT_ON_ORDER = 180
MODIFIER_EVENT_ON_PREDEBUFF_APPLIED = 252
MODIFIER_EVENT_ON_PROCESS_CLEAVE = 193
MODIFIER_EVENT_ON_PROCESS_UPGRADE = 187
MODIFIER_EVENT_ON_PROJECTILE_DODGE = 179
MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT = 242
MODIFIER_EVENT_ON_REFRESH = 188
MODIFIER_EVENT_ON_RESPAWN = 198
MODIFIER_EVENT_ON_SET_LOCATION = 202
MODIFIER_EVENT_ON_SPELL_TARGET_READY = 172										--- 指向性技能选中目标后，OnSpellStart前的一瞬间，同帧
MODIFIER_EVENT_ON_SPENT_MANA = 199
MODIFIER_EVENT_ON_STATE_CHANGED = 191
MODIFIER_EVENT_ON_TAKEDAMAGE = 189
MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT = 205
MODIFIER_EVENT_ON_TELEPORTED = 201
MODIFIER_EVENT_ON_TELEPORTING = 200
MODIFIER_EVENT_ON_UNIT_MOVED = 181
MODIFIER_FUNCTION_INVALID = 255
MODIFIER_FUNCTION_LAST = 254
MODIFIER_PROPERTY_ABILITY_LAYOUT = 228
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL = 148								--- No Description Set
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = 147								--- No Description Set
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE = 149									--- No Description Set
MODIFIER_PROPERTY_ABSORB_SPELL = 137											--- No Description Set
MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK = 159
MODIFIER_PROPERTY_ALWAYS_AUTOATTACK_WHILE_HOLD_POSITION = 171
MODIFIER_PROPERTY_ALWAYS_ETHEREAL_ATTACK = 160
MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE = 29
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 31
MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE = 250
MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE = 247
MODIFIER_PROPERTY_ATTACK_ANIM_TIME_PERCENTAGE = 121
MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT = 38
MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE = 106
MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = 107
MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE = 109
MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE = 108
MODIFIER_PROPERTY_ATTACK_WHILE_MOVING_TARGET = 249
MODIFIER_PROPERTY_AVOID_DAMAGE = 67
MODIFIER_PROPERTY_AVOID_SPELL = 68
MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE = 4
MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE = 56
MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE_UNIQUE = 57
MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = 35
MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT_ADJUST = 36
MODIFIER_PROPERTY_BASE_ATTACK_TIME_PERCENTAGE = 37
MODIFIER_PROPERTY_BASE_MANA_REGEN = 82
MODIFIER_PROPERTY_BONUSDAMAGEOUTGOING_PERCENTAGE = 39
MODIFIER_PROPERTY_BONUS_DAY_VISION = 140
MODIFIER_PROPERTY_BONUS_NIGHT_VISION = 141
MODIFIER_PROPERTY_BONUS_NIGHT_VISION_UNIQUE = 142
MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE = 143
MODIFIER_PROPERTY_BOT_ATTACK_SCORE_BONUS = 246
MODIFIER_PROPERTY_BOUNTY_CREEP_MULTIPLIER = 163
MODIFIER_PROPERTY_BOUNTY_OTHER_MULTIPLIER = 164
MODIFIER_PROPERTY_CAN_ATTACK_TREES = 236
MODIFIER_PROPERTY_CASTTIME_PERCENTAGE = 120
MODIFIER_PROPERTY_CAST_RANGE_BONUS = 102
MODIFIER_PROPERTY_CAST_RANGE_BONUS_PERCENTAGE = 103
MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING = 105
MODIFIER_PROPERTY_CAST_RANGE_BONUS_TARGET = 104
MODIFIER_PROPERTY_CHANGE_ABILITY_VALUE = 225
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE = 118
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_ONGOING = 119
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING = 253
MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT = 33
MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE = 40
MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION = 41
MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION_AMPLIFY = 42
MODIFIER_PROPERTY_DEATHGOLDCOST = 124
MODIFIER_PROPERTY_DISABLE_AUTOATTACK = 139
MODIFIER_PROPERTY_DISABLE_HEALING = 158
MODIFIER_PROPERTY_DISABLE_TURNING = 223
MODIFIER_PROPERTY_DODGE_PROJECTILE = 166
MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER = 239
MODIFIER_PROPERTY_EVASION_CONSTANT = 62											--- 攻击闪避系数
MODIFIER_PROPERTY_EXP_RATE_BOOST = 125
MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS = 92
MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE = 94
MODIFIER_PROPERTY_EXTRA_MANA_BONUS = 93
MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE = 95
MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS = 91
MODIFIER_PROPERTY_FIXED_ATTACK_RATE = 30
MODIFIER_PROPERTY_FIXED_DAY_VISION = 144
MODIFIER_PROPERTY_FIXED_NIGHT_VISION = 145
MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP = 222
MODIFIER_PROPERTY_GOLD_RATE_BOOST = 126
MODIFIER_PROPERTY_HEALTH_BONUS = 89
MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = 86
MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 87
MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE = 88
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE = 47
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET = 48
MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE = 50
MODIFIER_PROPERTY_HP_REGEN_CAN_BE_NEGATIVE = 49
MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT = 32
MODIFIER_PROPERTY_IGNORE_CAST_ANGLE = 224
MODIFIER_PROPERTY_IGNORE_COOLDOWN = 235
MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT = 27
MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR = 76
MODIFIER_PROPERTY_ILLUSION_LABEL = 151
MODIFIER_PROPERTY_INCOMING_DAMAGE_ILLUSION = 238
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = 58
MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT = 60
MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = 59
MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT = 61
MODIFIER_PROPERTY_INVISIBILITY_ATTACK_BEHAVIOR_EXCEPTION = 14
MODIFIER_PROPERTY_INVISIBILITY_LEVEL = 13
MODIFIER_PROPERTY_IS_ILLUSION = 150
MODIFIER_PROPERTY_IS_SCEPTER = 214
MODIFIER_PROPERTY_IS_SHARD = 215
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE = 51
MODIFIER_PROPERTY_LIFETIME_FRACTION = 219
MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK = 129
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BASE_REDUCTION = 77
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS = 79
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS_ILLUSIONS = 80
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE = 81
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION = 78
MODIFIER_PROPERTY_MANACOST_PERCENTAGE = 122
MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING = 123
MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT = 34
MODIFIER_PROPERTY_MANA_BONUS = 90
MODIFIER_PROPERTY_MANA_DRAIN_AMPLIFY_PERCENTAGE = 54
MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = 83
MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE = 84
MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE = 85
MODIFIER_PROPERTY_MAX_ATTACK_RANGE = 110
MODIFIER_PROPERTY_MAX_DEBUFF_DURATION = 168
MODIFIER_PROPERTY_MIN_HEALTH = 146
MODIFIER_PROPERTY_MISS_PERCENTAGE = 69
MODIFIER_PROPERTY_MODEL_CHANGE = 212
MODIFIER_PROPERTY_MODEL_SCALE = 213
MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE = 24
MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX = 26
MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN = 25
MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE = 17
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = 16
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT_UNIQUE = 22
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT_UNIQUE_2 = 23
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = 18
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE = 19
MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE = 20
MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE_2 = 21
MODIFIER_PROPERTY_MOVESPEED_LIMIT = 28
MODIFIER_PROPERTY_MOVESPEED_REDUCTION_PERCENTAGE = 248
MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE = 53
MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE = 55
MODIFIER_PROPERTY_NEGATIVE_EVASION_CONSTANT = 63
MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL = 226
MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE = 227
MODIFIER_PROPERTY_OVERRIDE_ANIMATION = 134
MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE = 136
MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT = 135
MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE = 11									--- 重写攻击伤害，伤害效果无视格挡效果。
MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL = 161
MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY = 15
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE = 70							--- 基础护甲降低（白字护甲）
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = 72										--- No Description Set
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_POST = 75
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE = 73
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE = 74
MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE = 71
MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK = 130
MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL = 131
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE = 0									--- 额外攻击力（绿字）加成
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT = 3
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_PROC = 2
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_TARGET = 1
MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE = 127
MODIFIER_PROPERTY_PREATTACK_DEADLY_BLOW = 170
MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE = 128
MODIFIER_PROPERTY_PRESERVE_PARTICLES_ON_MODEL_CHANGE = 233
MODIFIER_PROPERTY_PRE_ATTACK = 12
MODIFIER_PROPERTY_PRIMARY_STAT_DAMAGE_MULTIPLIER = 169
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL = 7
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL_TARGET = 9
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL = 5							--- 本次伤害增加固定数值
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE = 8								--- 攻击附加额外的纯粹伤害，不会被暴击
MODIFIER_PROPERTY_PROCATTACK_CONVERT_PHYSICAL_TO_MAGICAL = 6
MODIFIER_PROPERTY_PROCATTACK_FEEDBACK = 10
MODIFIER_PROPERTY_PROJECTILE_NAME = 113
MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS = 111
MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS_PERCENTAGE = 112
MODIFIER_PROPERTY_PROVIDES_FOW_POSITION = 220
MODIFIER_PROPERTY_RADAR_COOLDOWN_REDUCTION = 216
MODIFIER_PROPERTY_REFLECT_SPELL = 138
MODIFIER_PROPERTY_REINCARNATION = 114
MODIFIER_PROPERTY_RESPAWNTIME = 115
MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE = 116									--- 复活时间缩减百分比，最大值为1，即没有复活时间。
MODIFIER_PROPERTY_RESPAWNTIME_STACKING = 117
MODIFIER_PROPERTY_SPELLS_REQUIRE_HP = 221
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE = 45									--- 技能增强百分比，多个效果非线性叠加。
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_CREEP = 44
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE = 46
MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE = 52
MODIFIER_PROPERTY_STATS_AGILITY_BONUS = 97
MODIFIER_PROPERTY_STATS_AGILITY_BONUS_PERCENTAGE = 100
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = 98
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS_PERCENTAGE = 101
MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = 96
MODIFIER_PROPERTY_STATS_STRENGTH_BONUS_PERCENTAGE = 99
MODIFIER_PROPERTY_STATUS_RESISTANCE = 64
MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER = 66
MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING = 65
MODIFIER_PROPERTY_STRONG_ILLUSION = 152
MODIFIER_PROPERTY_SUPER_ILLUSION = 153
MODIFIER_PROPERTY_SUPER_ILLUSION_WITH_ULTIMATE = 154
MODIFIER_PROPERTY_SUPPRESS_CLEAVE = 245
MODIFIER_PROPERTY_SUPPRESS_TELEPORT = 243
MODIFIER_PROPERTY_TEMPEST_DOUBLE = 232
MODIFIER_PROPERTY_TOOLTIP = 211
MODIFIER_PROPERTY_TOOLTIP2 = 240
MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE = 43							--- No Description Set
MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK = 133
MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR = 132				--- No Description Set
MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = 217
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND = 218
MODIFIER_PROPERTY_TRIGGER_COSMETIC_AND_END_ATTACK = 167
MODIFIER_PROPERTY_TURN_RATE_OVERRIDE = 157
MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE = 156
MODIFIER_PROPERTY_UNIT_DISALLOW_UPGRADING = 165
MODIFIER_PROPERTY_UNIT_STATS_NEEDS_REFRESH = 162
MODIFIER_PROPERTY_VISUAL_Z_DELTA = 237
MODIFIER_PROPERTY_XP_DURING_DEATH = 155

-- modifierpriority 
MODIFIER_PRIORITY_HIGH = 2														--- 高优先级
MODIFIER_PRIORITY_LOW = 0														--- 低优先级
MODIFIER_PRIORITY_NORMAL = 1													--- 普通优先级
MODIFIER_PRIORITY_SUPER_ULTRA = 4												--- 最高优先级
MODIFIER_PRIORITY_ULTRA = 3														--- 更高优先级

-- modifierremove 
DOTA_BUFF_REMOVE_ALL = 0														--- 移除友军和敌军施加的modifier
DOTA_BUFF_REMOVE_ALLY = 2														--- 移除友军施加的modifier
DOTA_BUFF_REMOVE_ENEMY = 1														--- 移除敌军施加的modifier

-- modifierstate 
MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS = 47								--- 允许在悬崖上通行
MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE = 48								--- 允许在沟壑上通行
MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES = 37									--- 允许在树木中通行
MODIFIER_STATE_ATTACK_ALLIES = 46												--- 允许攻击队友
MODIFIER_STATE_ATTACK_IMMUNE = 2												--- 攻击免疫
MODIFIER_STATE_BLIND = 30														--- 致盲，完全失去视野
MODIFIER_STATE_BLOCK_DISABLED = 12												--- 禁用格挡
MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED = 44									--- 不受运动控制影响
MODIFIER_STATE_CANNOT_MISS = 16													--- 不会丢失，无视闪避
MODIFIER_STATE_CANNOT_TARGET_ENEMIES = 15										--- 禁用单位目标命令
MODIFIER_STATE_COMMAND_RESTRICTED = 19											--- 无法执行命令
MODIFIER_STATE_DISARMED = 1														--- 缴械
MODIFIER_STATE_DOMINATED = 29													--- 支配，可用于过滤是否是支配单位
MODIFIER_STATE_EVADE_DISABLED = 13												--- 无法闪避
MODIFIER_STATE_FAKE_ALLY = 32
MODIFIER_STATE_FEARED = 42														--- 恐惧
MODIFIER_STATE_FLYING = 24														--- 飞行
MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY = 33							--- 贴地飞行
MODIFIER_STATE_FORCED_FLYING_VISION = 45
MODIFIER_STATE_FROZEN = 18														--- 冰冻，动作会暂停
MODIFIER_STATE_HEXED = 6														--- 妖术，头顶会有妖术进度条
MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS = 36								--- 禁用移动与攻击指令
MODIFIER_STATE_IGNORING_STOP_ORDERS = 41										--- 禁用停止指令
MODIFIER_STATE_INVISIBLE = 7													--- 隐身
MODIFIER_STATE_INVULNERABLE = 8													--- 无敌
MODIFIER_STATE_LAST = 50
MODIFIER_STATE_LOW_ATTACK_PRIORITY = 21											--- 低攻击优先级
MODIFIER_STATE_MAGIC_IMMUNE = 9													--- 魔法免疫
MODIFIER_STATE_MUTED = 4														--- 锁闭，禁用物品，头上有锁闭进度条
MODIFIER_STATE_NIGHTMARED = 11													--- 睡眠，头上会有睡眠进度条
MODIFIER_STATE_NOT_ON_MINIMAP = 20												--- 没有小地图图标
MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES = 38									--- 对敌人没有小地图图标
MODIFIER_STATE_NO_HEALTH_BAR = 22												--- 没有生命条
MODIFIER_STATE_NO_HEALTH_BAR_FOR_ENEMIES = 23
MODIFIER_STATE_NO_TEAM_MOVE_TO = 26
MODIFIER_STATE_NO_TEAM_SELECT = 27
MODIFIER_STATE_NO_UNIT_COLLISION = 25											--- 没有碰撞体积
MODIFIER_STATE_OUT_OF_GAME = 31													--- 离开游戏
MODIFIER_STATE_PASSIVES_DISABLED = 28											--- 破坏，禁用被动，头上有破坏进度条
MODIFIER_STATE_PROVIDES_VISION = 10												--- 提供视野
MODIFIER_STATE_ROOTED = 0														--- 缠绕，无法移动，头上有缠绕进度条
MODIFIER_STATE_SILENCED = 3														--- 沉默，无法施法，头上有沉默进度条
MODIFIER_STATE_SPECIALLY_DENIABLE = 17											--- 可被反补
MODIFIER_STATE_SPECIALLY_UNDENIABLE = 49
MODIFIER_STATE_STUNNED = 5														--- 晕眩，头上有晕眩进度条
MODIFIER_STATE_TAUNTED = 43														--- 嘲讽状态，没有特殊效果，仅作为标记用，但是官方没有提供api判断是否拥有该状态(2021_7_15)。。为负面状态时血条上有嘲讽进度条
MODIFIER_STATE_TETHERED = 40													--- 束缚状态，没有特殊效果，仅作为标记用，但是官方没有提供api判断是否拥有该状态(2021_7_15)。天涯墨客的大招使用了该状态。为负面状态时血条上有束缚进度条
MODIFIER_STATE_TRUESIGHT_IMMUNE = 34											--- 真视宝石免疫，使modifier_truesight这个buff不能显隐，所以显隐之尘不受这个状态影响。应该只是作为标记用，但是官方没有提供api检测该状态。
MODIFIER_STATE_UNSELECTABLE = 14												--- 不可选择
MODIFIER_STATE_UNSLOWABLE = 39													--- 无法减速
MODIFIER_STATE_UNTARGETABLE = 35												--- 无法作为目标

-- quest_text_replace_values_t 
QUEST_NUM_TEXT_REPLACE_VALUES = 4
QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE = 0
QUEST_TEXT_REPLACE_VALUE_REWARD = 3
QUEST_TEXT_REPLACE_VALUE_ROUND = 2
QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE = 1

-- subquest_text_replace_values_t 
SUBQUEST_NUM_TEXT_REPLACE_VALUES = 2
SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE = 0
SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE = 1

-- Find Types 
FIND_UNITS_EVERYWHERE = -1														--- 在整个地图中查找单位。
FIND_ANY_ORDER = 0																--- 随机寻找到的单位。
FIND_CLOSEST = 1																--- 离中心从近到远排序。
FIND_FARTHEST = 2																--- 离中心从远到远排序。

-- Activation types 
ACTIVATE_TYPE_INITIAL_CREATION = 0												--- When the function is called after entity creation.
ACTIVATE_TYPE_DATAUPDATE_CREATION = 1											--- To do
ACTIVATE_TYPE_ONRESTORE = 2														--- When the function is called after the entity has been restored from a saved game.

-- DOTA_CONNECTION_STATE 
DOTA_CONNECTION_STATE_UNKNOWN = 0												--- 无
DOTA_CONNECTION_STATE_NOT_YET_CONNECTED = 1										--- 无
DOTA_CONNECTION_STATE_CONNECTED = 2												--- 无
DOTA_CONNECTION_STATE_DISCONNECTED = 3											--- 无
DOTA_CONNECTION_STATE_ABANDONED = 4												--- 无
DOTA_CONNECTION_STATE_LOADING = 5												--- 无
DOTA_CONNECTION_STATE_FAILED = 6												--- 无

-- DOTA_OVERHEAD_ALERT 
OVERHEAD_ALERT_GOLD = 0															--- 金钱类型头顶通知
OVERHEAD_ALERT_DENY = 1															--- 无
OVERHEAD_ALERT_CRITICAL = 2														--- 无
OVERHEAD_ALERT_XP = 3															--- 无
OVERHEAD_ALERT_BONUS_SPELL_DAMAGE = 4											--- 无
OVERHEAD_ALERT_MISS = 5															--- 无
OVERHEAD_ALERT_DAMAGE = 6														--- 无
OVERHEAD_ALERT_EVADE = 7														--- 无
OVERHEAD_ALERT_BLOCK = 8														--- 无
OVERHEAD_ALERT_BONUS_POISON_DAMAGE = 9											--- 无
OVERHEAD_ALERT_HEAL = 10														--- 无
OVERHEAD_ALERT_MANA_ADD = 11													--- 无
OVERHEAD_ALERT_MANA_LOSS = 12													--- 无
OVERHEAD_ALERT_LAST_HIT_EARLY = 13												--- 无
OVERHEAD_ALERT_LAST_HIT_CLOSE = 14												--- 无
OVERHEAD_ALERT_LAST_HIT_MISS = 15												--- 无
OVERHEAD_ALERT_MAGICAL_BLOCK = 16												--- 无
OVERHEAD_ALERT_INCOMING_DAMAGE = 17												--- 无
OVERHEAD_ALERT_OUTGOING_DAMAGE = 18												--- 无
OVERHEAD_ALERT_DISABLE_RESIST = 19												--- 无
OVERHEAD_ALERT_DEATH = 20														--- 无
OVERHEAD_ALERT_BLOCKED = 21														--- 无
OVERHEAD_ALERT_ITEM_RECEIVED = 22												--- 无
OVERHEAD_ALERT_SHARD = 23														--- 无
OVERHEAD_ALERT_DEADLY_BLOW = 24													--- 无

-- dotaunitorder_t 
DOTA_UNIT_ORDER_NONE = 0														--- 无
DOTA_UNIT_ORDER_MOVE_TO_POSITION = 1											--- 移动到目标点指令
DOTA_UNIT_ORDER_MOVE_TO_TARGET = 2												--- 移动到目标单位指令
DOTA_UNIT_ORDER_ATTACK_MOVE = 3													--- 攻击移动指令
DOTA_UNIT_ORDER_ATTACK_TARGET = 4												--- 攻击目标单位指令
DOTA_UNIT_ORDER_CAST_POSITION = 5												--- 点目标施法指令
DOTA_UNIT_ORDER_CAST_TARGET = 6													--- 单位目标施放指令
DOTA_UNIT_ORDER_CAST_TARGET_TREE = 7											--- 树目标施法指令
DOTA_UNIT_ORDER_CAST_NO_TARGET = 8												--- 无目标施法指令
DOTA_UNIT_ORDER_CAST_TOGGLE = 9													--- 开关技能指令
DOTA_UNIT_ORDER_HOLD_POSITION = 10												--- 固守位置指令
DOTA_UNIT_ORDER_TRAIN_ABILITY = 11												--- 无
DOTA_UNIT_ORDER_DROP_ITEM = 12													--- 无
DOTA_UNIT_ORDER_GIVE_ITEM = 13													--- 无
DOTA_UNIT_ORDER_PICKUP_ITEM = 14												--- 无
DOTA_UNIT_ORDER_PICKUP_RUNE = 15												--- 无
DOTA_UNIT_ORDER_PURCHASE_ITEM = 16												--- 无
DOTA_UNIT_ORDER_SELL_ITEM = 17													--- 无
DOTA_UNIT_ORDER_DISASSEMBLE_ITEM = 18											--- 无
DOTA_UNIT_ORDER_MOVE_ITEM = 19													--- 无
DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO = 20											--- 无
DOTA_UNIT_ORDER_STOP = 21														--- 停止指令
DOTA_UNIT_ORDER_TAUNT = 22														--- 无
DOTA_UNIT_ORDER_BUYBACK = 23													--- 无
DOTA_UNIT_ORDER_GLYPH = 24														--- 无
DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH = 25										--- 无
DOTA_UNIT_ORDER_CAST_RUNE = 26													--- 无
DOTA_UNIT_ORDER_PING_ABILITY = 27												--- 无
DOTA_UNIT_ORDER_MOVE_TO_DIRECTION = 28											--- 无
DOTA_UNIT_ORDER_PATROL = 29														--- 无
DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION = 30										--- 无
DOTA_UNIT_ORDER_RADAR = 31														--- 无
DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK = 32										--- 无
DOTA_UNIT_ORDER_CONTINUE = 33													--- 无
DOTA_UNIT_ORDER_VECTOR_TARGET_CANCELED = 34										--- 无
DOTA_UNIT_ORDER_CAST_RIVER_PAINT = 35											--- 无
DOTA_UNIT_ORDER_PREGAME_ADJUST_ITEM_ASSIGNMENT = 36								--- 无
DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN = 37										--- 无
DOTA_UNIT_ORDER_TAKE_ITEM_FROM_NEUTRAL_ITEM_STASH = 38							--- 无

-- FCVAR flags 
FCVAR_PROTECTED = 32															--- 如果变量包含私密信息(密码等)，我们不希望其他玩家看到它们。使用FCVAR_PROTECTED将信息标记为机密信息。
FCVAR_SPONLY = 64																--- If executing a command or changing a variable should only be allowed in single player mode, then label it with flag.FCVAR_SPONLY
FCVAR_ARCHIVE = 128																--- Some console variables contain user specific settings we want to restore each time the game is started (like or ). If a console variable is labeled as , it is saved in the file when the game shuts down and is reloaded when the game is reopened. The command can also be used to save the settings to .namenetwork_rateFCVAR_ARCHIVEconfig.cfghost_writeconfigconfig.cfg
FCVAR_NOTIFY = 256																--- If a console variable is flagged as , the server sends a notification message to all clients whenever the variable is changed. This should be used for variables that change game play rules, which are important for all players ( etc).FCVAR_NOTIFYmp_friendlyfire
FCVAR_USERINFO = 512															--- Some console variables contain client information the server needs to know about, like the player's name or their network settings. These variables must be flagged as , so they get transmitted to the server and updated every time the user changes them. When the player changes one of these variables the engine notifies the server code via . The game server can also query the engine for specific client settings with .FCVAR_USERINFOClientSettingsChanged()GetClientConVarValue()
FCVAR_PRINTABLEONLY = 1024														--- Some important variables are logged or broadcasted (gamerules etc), so it is important that they contain only printable characters (no control chars etc) to prevent arbitrary code execution and other problems.
FCVAR_NEVER_AS_STRING = 4096													--- The flag tells the engine never to print this variable as a string since it contains control sequences.FCVAR_NEVER_AS_STRING
FCVAR_REPLICATED = 8192															--- When the game server and clients are using shared code where it's important that both sides run the exact same path using the same data (e.g. predicted movement/weapons, game rules). If this code uses console variables, they must have the same values on both sides. The flag ensures that by broadcasting these values to all clients. While connected, clients can't change these values and are forced to use the server-side values.FCVAR_REPLICATED
FCVAR_CHEAT = 16384																--- Most commands and variables are for debugging purposes and not removed in release builds since they are also useful for 3rd party developers and map makers. Unfortunately we cannot allow normal players to use these debugging tools since it gives them an unfair advantage over other players (cheating). A good rule is to add to every new console command you add unless it's an explicit and legitimate options setting for players. Experience has shown that even the most harmless looking debugging command can be misused as a cheat somehow.FCVAR_CHEATThe game server's setting of decides if cheats are enabled or not. If a client connects to a server where cheats are disabled (should be the default case), all client side console variables labeled as are reverted to their default values and can't be changed as long as the client stays connected. Console commands marked as can't be executed either.sv_cheatsFCVAR_CHEATFCVAR_CHEAT
FCVAR_DEMO = 65536																--- When starting to record a demo file, some console variables must explicitly be added to the recording to ensure a correct playback.
FCVAR_DONTRECORD = 131072														--- This is the opposite of , some console commands shouldn't be recorded in demo files.FCVAR_DEMO
FCVAR_NOT_CONNECTED = 4194304													--- Some console variables should not be changeable while the client is currently in a server (eg. fps_max) due to the possibility of exploitation of the command.
