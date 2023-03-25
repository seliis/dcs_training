do
  local rootPath = "D:/DCS/training"

  local mergeOrder = {
    "/init.lua",
    "/common/common.lua",
    "/air_combat/air_combat.lua",
    "/mission_commands/mission_commands.lua",
    "/main.lua",
  }

  local buildPath = "/.build/build.lua"

  local function merge()
    local file = io.open(rootPath .. buildPath, "w+"); if file == nil then
      print("Not Found Build Path " .. buildPath)
      return
    end
  
    for _, sourcePath in ipairs(mergeOrder) do
      local source = io.open(rootPath .. sourcePath, "r"); if source then
        file:write(source:read("*a") .. "\n\n")
        source:close()
      else
        print("Not Found Source Path " .. sourcePath)
      end
    end
  
    file:close()
  end

  merge()
end