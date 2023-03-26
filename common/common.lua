function MIZ.Common:GetGroupData(groupName)
  for _, coalition in pairs(env.mission.coalition) do
    for _, country in pairs(coalition.country) do
      for _, category in pairs(country) do
        if type(category) == "table" then
          for _, group in pairs(category.group) do
            if group.name == groupName then
              return group
            end
          end
        end
      end
    end
  end
end

function MIZ.Common:MutateCoordinate(coordinate, distance, angle, altitude)
  local radian = math.rad(angle); if altitude then
      return {
          x = (distance * math.cos(radian)) + coordinate.x,
          z = (distance * math.sin(radian)) + coordinate.z,
          y = altitude
      }
  else
      return {
          x = (distance * math.cos(radian)) + coordinate.x,
          z = (distance * math.sin(radian)) + coordinate.z,
          y = coordinate.y
      }
  end
end

function MIZ.Common:GetNorthCorrection(point)
  local lat, lon = coord.LOtoLL(point)
  local north = coord.LLtoLO(lat + 1, lon)
  return math.atan2(north.z - point.z, north.x - point.x)
end

function MIZ.Common:GetHeading(unitObject)
  local position = unitObject:getPosition()
  local heading = math.atan2(position.x.z, position.x.x) + self:GetNorthCorrection(position.p); if heading < 0 then
    heading = heading + (math.pi * 2)
  end
  
  return math.deg(heading)
end

function MIZ.Common:HeadingTo(from, to)
  local dz = to.z - from.z
  local dx = to.x - from.x
  local heading = math.deg(math.atan2(dz, dx)); if heading < 0 then
    heading = heading + 360
  end

  return heading
end

function MIZ.Common:GetUserGroupStatus(groupName)
  local userGroup = Group.getByName(groupName)
  local userUnit = userGroup:getUnit(1)
  return {
    coordinate = userUnit:getPoint(),
    heading = self:GetHeading(userUnit),
  }
end

function MIZ.Common:OutMessageForUnit(unit, text, sound, displayTime, clearview)
  local id = unit:getID()
  trigger.action.outTextForUnit(
    id,
    text,
    displayTime or 10,
    clearview or false
  )
  if sound then trigger.action.outSoundForUnit(id, sound) end
end