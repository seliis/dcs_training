MIZ:PrintTable(env.mission)

for _, groupData in ipairs(env.mission.coalition.blue.country[1].plane.group) do
  MIZ.MissionCommands:BuildAirToAirCommands(groupData.groupId, groupData.name)
end