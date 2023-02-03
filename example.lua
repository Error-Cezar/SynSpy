local spy = loadstring(game:HttpGet("https://raw.githubusercontent.com/Error-Cezar/SynSpy/main/source.lua"))()

function Blacklist(remote)
  local stat = getgenv().SynSpy_Settings.blacklist(remote)
  if stat then
    -- success
  else
    -- failure
  end
end

function Whitelist(remote)
  local stat = getgenv().SynSpy_Settings.whitelist(remote)
  if stat then
    -- success
  else
    -- failure
  end
end

function get(setting)
  local setting = getgenv().SynSpy_Settings.get(setting or nil)
   print(setting or "No Setting Found")
end

function clearconsole()
  getgenv().SynSpy_Settings.clear()
end

function ChangeStatus(Namecall, Value, Category)
  getgenv().SynSpy_Settings.status(Namecall, Value, Category) -- Not working as of now
end

function modify_setting(settingName, Value)
  local stat = getgenv().SynSpy_Settings.modify(settingName, Value)
    if stat then
    -- success
  else
    -- failure
  end
end
