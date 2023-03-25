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

  function MIZ.AirCombat.StartOacmSet(dataSet)
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
          27780,
          userGroupStatus.heading
        ),
      })
    }

    local targetGroup = coalition.addGroup(country.id.CJTF_RED, Group.Category.AIRPLANE, targetData)
    MIZ.NextAirCombatTargetId = MIZ.NextAirCombatTargetId + 1
    local targetController = targetGroup:getController()
    setOption(targetController)

    local userFriends = getNearFriends(userGroupStatus.coordinate); for index, friend in ipairs(userFriends) do
      pushTask(
        targetController,
        {
          id     = "AttackUnit",
          params = {
            unitId = friend:getID(),
          }
        },
        index + 1
      )
      MIZ.Common:OutTextForUnit(friend, "Air Combat Start")
      MIZ.Common:OutSoundForUnit(friend, MIZ.Sound.Beep)
    end
  end
end