function MIZ.MissionCommands:AddMenu(groupId, menuName, parentPath)
  return missionCommands.addSubMenuForGroup(groupId, menuName, parentPath)
end

function MIZ.MissionCommands:AddCommand(groupId, commandName, parentPath, callbackFunc, dataSet)
  return missionCommands.addCommandForGroup(groupId, commandName, parentPath, callbackFunc, dataSet)
end

function MIZ.MissionCommands:BuildAirToAirCommands(groupId, groupName)
  local rootMenu = self:AddMenu(groupId, "Air to Air")

  local function makeOacmMenu()
    local subMenu = self:AddMenu(groupId, "Offensive Air Combat Maneuver", rootMenu)
    
    for targetAmount = 1, 4 do
      self:AddCommand(groupId, targetAmount .. "-Ship", subMenu, MIZ.AirCombat.StartOacmSet, {
        groupId = groupId,
        groupName = groupName,
        targetName = "RED_ACM_MG19",
        targetAmount = targetAmount,
      })
    end
  end

  makeOacmMenu()
end