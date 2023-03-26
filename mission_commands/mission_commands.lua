do
  local function addMenu(groupId, menuName, parentPath)
    return missionCommands.addSubMenuForGroup(groupId, menuName, parentPath)
  end

  local function addCommand(groupId, commandName, parentPath, callbackFunc, dataSet)
    return missionCommands.addCommandForGroup(groupId, commandName, parentPath, callbackFunc, dataSet)
  end

  function MIZ.MissionCommands:BuildAirToAirCommands(groupId, groupName)
    local rootMenu = addMenu(groupId, "Air to Air")

    local oacmMenu = addMenu(groupId, "Offensive Air Combat Maneuver", rootMenu); for targetAmount = 1, 4 do
      addCommand(groupId, targetAmount .. "-Ship", oacmMenu, MIZ.AirCombat.StartOacmSet, {
        groupId = groupId,
        groupName = groupName,
        targetName = "RED_ACM_TEMPLATE_GROUP",
        targetAmount = targetAmount,
      })
    end

    addCommand(groupId, "Reset", rootMenu, MIZ.AirCombat.Reset)
  end
end