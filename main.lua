MIZ:PrintTable(env.mission)

for _, groupData in ipairs(env.mission.coalition.blue.country[1].plane.group) do
  MIZ.MissionCommands:BuildAirCombatCommands(groupData.groupId, groupData.name)
  MIZ.MissionCommands:BuildAirStrikeCommands(groupData.groupId, groupData.name)
end

MIZ.AirStrike:PrepareInertTarget()