do
  local function addMenu(groupId, menuName, parentPath)
    return missionCommands.addSubMenuForGroup(groupId, menuName, parentPath)
  end

  local function addCommand(groupId, commandName, parentPath, callbackFunc, dataSet)
    return missionCommands.addCommandForGroup(groupId, commandName, parentPath, callbackFunc, dataSet)
  end

  function MIZ.MissionCommands:BuildAirCombatCommands(groupId, groupName)
    local rootMenu = addMenu(groupId, "Air Combat")

    local oacmMenu = addMenu(groupId, "Offensive Air Combat Maneuver", rootMenu); for targetAmount = 1, 4 do
      addCommand(groupId, targetAmount .. "-Ship", oacmMenu, MIZ.AirCombat.MakeSet, {
        groupId = groupId,
        groupName = groupName,
        targetName = "RED_ACM_TEMPLATE_GROUP",
        targetAmount = targetAmount,
        targetDistance = 27780,
        targetDirection = 0,
      })
    end

    local dacmMenu = addMenu(groupId, "Defensive Air Combat Maneuver", rootMenu); for targetAmount = 1, 4 do
      addCommand(groupId, targetAmount .. "-Ship", dacmMenu, MIZ.AirCombat.MakeSet, {
        groupId = groupId,
        groupName = groupName,
        targetName = "RED_ACM_TEMPLATE_GROUP",
        targetAmount = targetAmount,
        targetDistance = 2778,
        targetDirection = 180,
      })
    end

    addCommand(groupId, "Reset", rootMenu, MIZ.AirCombat.Reset)
  end

  function MIZ.MissionCommands:BuildAirStrikeCommands(groupId, groupName)
    local rootMenu = addMenu(groupId, "Air Strike")
    addCommand(groupId, "Reset Inert", rootMenu, MIZ.AirStrike.ResetInertTarget)
  end
end