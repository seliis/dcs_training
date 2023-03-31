do
  local function makeUnitsData(originData, makeData)
    local unitsData = {}; for index = 1, makeData.targetAmount, 1 do
      local unitNumber = string.format("%03d", index)
      unitsData[index] = {
        name        = string.format("RA%s#%s", MIZ.NextAirCombatTargetId, unitNumber),
        type        = originData.type,
        x           = makeData.targetPoint.x,
        y           = makeData.targetPoint.z,
        alt         = originData.alt,
        alt_type    = originData.alt_type,
        speed       = originData.speed,
        payload     = originData.payload,
        callsign    = originData.callsign,
        livery_id   = originData.livery_id,
        onboard_num = unitNumber,
        skill       = "High",
        heading     = math.rad(MIZ.Common:HeadingTo(makeData.targetPoint, makeData.userPoint)),
      }
    end

    return unitsData
  end

  local function getNearFriends(coordinate)
    local friends = {}; world.searchObjects(
      Object.Category.UNIT,
      {
        id     = world.VolumeType.SPHERE,
        params = {
          point  = coordinate,
          radius = 18520,
        }
      },
      function(foundObject)
        if foundObject:inAir() and foundObject:getCoalition() == coalition.side.BLUE then
          friends[#friends + 1] = foundObject
        end
      end
    )

    return friends
  end

  local function setOption(controller, delay)
    timer.scheduleFunction(
      function(async)
        async.controller:setOption(1, 2) -- Reaction on Threat: Evade Fire
        async.controller:setOption(25, false) -- Fuel Tank Jettison: Inhibit
      end,
      {
        controller = controller,
      },
      timer.getTime() + (delay or 1)
    )
  end

  local function pushTask(controller, task, delay)
    timer.scheduleFunction(
      function(async)
        async.controller:pushTask(task)
      end,
      {
        controller = controller,
      },
      timer.getTime() + (delay or 1)
    )
  end

  local function addToSpawnedGroupList(targetGroup, userList)
    MIZ.AirCombat.SpawnedGroup[tostring(timer.getTime())] = {
      targetGroup = targetGroup,
      userList = userList,
    }
  end

  MIZ.AirCombat.Reset = function()
    for key, data in pairs(MIZ.AirCombat.SpawnedGroup) do
      data.targetGroup:destroy();
      for _, user in pairs(data.userList) do
        MIZ.Common:OutMessageForUnit(user, "Air Combat Reset", MIZ.Sound.Beep)
      end
      MIZ.AirCombat.SpawnedGroup[key] = nil
    end
  end

  MIZ.AirCombat.MakeSet = function(dataSet)
    local entityData = MIZ:DeepCopy(MIZ.Common:GetGroupData(dataSet.targetName))
    local userGroupStatus = MIZ.Common:GetUserGroupStatus(dataSet.groupName)
    
    local targetData = {
      name  = string.format("RA%s", MIZ.NextAirCombatTargetId),
      task  = entityData.task,
      units = makeUnitsData(entityData.units[1], {
        targetAmount = dataSet.targetAmount,
        userPoint    = userGroupStatus.coordinate,
        targetPoint  = MIZ.Common:MutateCoordinate(
          userGroupStatus.coordinate,
          dataSet.targetDistance,
          userGroupStatus.heading + dataSet.targetDirection
        ),
      })
    }

    local targetGroup = coalition.addGroup(country.id.CJTF_RED, Group.Category.AIRPLANE, targetData)
    MIZ.NextAirCombatTargetId = MIZ.NextAirCombatTargetId + 1
    local targetController = targetGroup:getController()
    setOption(targetController)

    local userList = getNearFriends(userGroupStatus.coordinate); for index, user in ipairs(userList) do
      pushTask(
        targetController,
        {
          id     = "AttackUnit",
          params = {
            unitId = user:getID(),
          }
        },
        index + 1
      )
      MIZ.Common:OutMessageForUnit(user, "Air Combat Start", MIZ.Sound.Beep)
    end

    addToSpawnedGroupList(targetGroup, userList)
  end
end