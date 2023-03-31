do
  local inertGroup = Group.getByName("RED_GROUND_INERT_GROUP")

  local inertEvent = {}; function inertEvent:onEvent(event)
    if (event.id == world.event.S_EVENT_HIT) then
      local target = event.target
      local targetName = target:getName()
      if MIZ.AirStrike.InertGroupStatus[targetName] == false then
        MIZ.Common:OutMessageForUnit(event.initiator, "Hit", MIZ.Sound.Bell)
        MIZ.AirStrike.InertGroupStatus[targetName] = true
        trigger.action.effectSmokeBig(
          target:getPoint(),
          1,
          1,
          targetName
        )
      end
    end
  end; world.addEventHandler(inertEvent)

  local function setCommand(controller)
    controller:setCommand({
      id = "SetImmortal", params = {
        value = true,
      }
    })
  end

  local function setOption(controller)
    controller:setOption(9, 2) -- AlarmState: Red
  end

  local function setOff(controller)
    timer.scheduleFunction(
      function(async)
        async.controller:setOnOff(false)
      end,
      {
        controller = controller,
      },
      timer.getTime() + 10
    )
  end

  function MIZ.AirStrike:PrepareInertTarget()
    for _, unit in ipairs(inertGroup:getUnits()) do
      MIZ.AirStrike.InertGroupStatus[unit:getName()] = false
    end

    local inertGroupController = inertGroup:getController()
    setCommand(inertGroupController)
    setOption(inertGroupController)
    setOff(inertGroupController)
  end

  MIZ.AirStrike.ResetInertTarget = function()
    for inertUnitName, inertUnitStatus in pairs(MIZ.AirStrike.InertGroupStatus) do
      if inertUnitStatus == true then
        MIZ.AirStrike.InertGroupStatus[inertUnitName] = false
        trigger.action.effectSmokeStop(inertUnitName)
      end
    end
  end
end