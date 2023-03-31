MIZ                       = {}
MIZ.Event                 = {}
MIZ.Common                = {}
MIZ.Sound                 = {
  Beep = "beep.ogg",
  Bell = "bell.ogg",
  Dead = "dead.ogg",
}
MIZ.AirCombat             = {
  SpawnedGroup = {},
}
MIZ.AirStrike             = {
  InertGroupStatus  = {},
  MovingGroupStatus = {},
}
MIZ.MissionCommands       = {}
MIZ.NextAirCombatTargetId = 10000

function MIZ:PrintTable(tableObject, indentCount)
  indentCount = indentCount or 0

  local indent = "";
  
  if indentCount ~= 0 then
    for _ = 1, indentCount do
      indent = indent .. " "
    end
  end

  for k, v in pairs(tableObject) do
    if type(k) == "number" then
      k = "[" .. k .. "]"
    end
    local valueType = type(v)
    if valueType ~= "table" then
      local text; if valueType == "string" then
        text = indent .. k .. ' = "' .. v .. '",'
      elseif valueType == "boolean" then
        text = indent .. k .. " = " .. tostring(v) .. ","
      else
        text = indent .. k .. " = " .. v .. ","
      end
      env.info(text, false)
    else
      env.info(indent .. k .. " = {")
      self:PrintTable(v, indentCount + 2)
      env.info(indent .. "}, -- end of " .. k)
    end
  end
end

function MIZ:DeepCopy(object, seen)
  if type(object) ~= "table" then return object end
  if seen and seen[object] then return seen[object] end

  local recurse = seen or {}
  local result = {}

  recurse[object] = result

  for k, v in next, object, nil do
    result[self:DeepCopy(k, recurse)] = self:DeepCopy(v, recurse)
  end

  return setmetatable(result, getmetatable(object))
end