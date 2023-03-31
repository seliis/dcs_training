do
  function MIZ.Event:onEvent(event)
    if event.id == world.event.S_EVENT_DISCARD_CHAIR_AFTER_EJECTION then
      event.initiator:destroy()
      event.target:destroy()
    end
  end

  world.addEventHandler(MIZ.Event)
end