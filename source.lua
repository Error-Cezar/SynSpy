-- Minimized cuz that shits takes like 50 lines but its god damn good
function dump(a)local b,c,d={},{},{}local e=1;local f="{\n"while true do local g=0;for h,i in pairs(a)do g=g+1 end;local j=1;for h,i in pairs(a)do if b[a]==nil or j>=b[a]then if string.find(f,"}",f:len())then f=f..",\n"elseif not string.find(f,"\n",f:len())then f=f.."\n"end;table.insert(d,f)f=""local k;if type(h)=="number"or type(h)=="boolean"then k="["..tostring(h).."]"else k="['"..tostring(h).."']"end;if type(i)=="number"or type(i)=="boolean"then f=f..string.rep('\t',e)..k.." = "..tostring(i)elseif type(i)=="table"then f=f..string.rep('\t',e)..k.." = {\n"table.insert(c,a)table.insert(c,i)b[a]=j+1;break else f=f..string.rep('\t',e)..k.." = '"..tostring(i).."'"end;if j==g then f=f.."\n"..string.rep('\t',e-1).."}"else f=f..","end else if j==g then f=f.."\n"..string.rep('\t',e-1).."}"end end;j=j+1 end;if g==0 then f=f.."\n"..string.rep('\t',e-1).."}"end;if#c>0 then a=c[#c]c[#c]=nil;e=b[a]==nil and e+1 or e-1 else break end end;table.insert(d,f)f=table.concat(d)return f end

local RHooks = {
    ["Namecall"] = {
            ["FireServer"] = true,
            ["InvokeServer"] = true,
            ["Fire"] = true,
            ["Invoke"] = true
    },
    ["Index"] = {
        ["FireServer"] = true,
        ["InvokeServer"] = true,
        ["Fire"] = true,
        ["Invoke"] = true
    }
}
local re = Instance.new("RemoteEvent")
local rf = Instance.new("RemoteFunction")
local be = Instance.new("BindableEvent")
local bf = Instance.new("BindableFunction")
local Hooks = {
    ["RemoteEvent"]      = {},
    ["RemoteFunction"]   = {},
    ["BindableEvent"]    = {},
    ["BindableFunction"] = {}
}

local msettings = {
    blocked = {}, -- Might add more soon
}

local hook = hookfunction or hookfunc or hook_function
local metahook = hookmetamethod or hook_metamethod or hook_meta_method
local space = [[        ]]
local limiter = "------------------------------"

function HookFind(T, A)
    for n,v in pairs(RHooks[T]) do
        if n == A and v == true then
            return true
        end
    end
    return false
end

function change(val, a, typ)
    if typeof(typ) ~= "string" then typ = "Namecall" end
    if typeof(a) ~= "boolean" then a = true end
    -- print(val, a , typ)
    for n,v in pairs(RHooks[typ]) do
        if n == val then RHooks[type][v] = a end
    end
end

function settingsmodif(setting, value)
    for n,v in pairs(msettings) do
        if n == setting then v = value return true end
    end
    return false
end

function GetSettings(setting) 
    if typeof(setting) ~= "string" then
        return msettings
    end
    for n,v in pairs(msettings) do
        if n == setting then return v end
    end
end

function Blacklist(r)
    for n,v in pairs(msettings["blocked"]) do
        if v == r then return false end
    end
    table.insert(msettings["blocked"], r)
    return true
end

function Whitelist(r)
    for n,v in pairs(msettings["blocked"]) do
        if v == r then table.remove(msettings["blocked"], n) return true end
    end
    return false
end

local hints = { "Settings available are : modify, get, blacklist, whitelist, status and clear", "This spy supports index and namecall firing !", "https://x.synapse.to" }
local tip = hints[math.random(#hints)]
function clear()
    rconsoleclear()
    rconsoleprint("RemoteSpy (re)loaded\nSettings can be modified with getgenv().SynSpy_Settings\n")
    rconsoleprint("Today's tip : "..tip.."\n")
end

getgenv().SynSpy_Settings = {
    modify    = settingsmodif,  -- modifies a setting
    get       = GetSettings, -- gets the available settings (or a specific one)
    blacklist = Blacklist, -- blacklists a remote
    whitelist = Whitelist, -- removes a remote from blacklist
    status    = change, -- whenever you want a see a specific remote type or not
    clear     = clear -- clears console
}

function OnRemote(t)
    -- if curpage == t then
	local v = Hooks[t][#Hooks[t]]
	rconsoleprint("\nName: "..v["Name"].."\nCaller: "..tostring(v["Call"]).."\nROBLOX Call: "..tostring(v["Env"]).."\nMethod: "..(tostring(v["Method"]) or "None").."\nArguments: "..dump(v["Arg"] or {}).."\nType: "..tostring(v["Type"]).."\nBlocked: "..tostring(v["Blocked"]).."\n"..limiter)
	-- end
end

function GetBlocked(r)
    local a = msettings
    if typeof(a) ~= "table" then a = {} else a = a["blocked"] or {} end
    for _,v in pairs(a) do
        if v == r or tostring(v) == r then return true end
    end
    return false
end

function GetFullName(par)
    local cool = tostring(par)
    while par ~= nil do
        par = par.Parent
        if par == nil then continue end
            cool = cool.."."..tostring(par)
    end
    local g = string.split(cool, ".")
    local final = ""
    for i=0, #g-1 do
        final = final..g[#g - i]
        if i ~= #g-1 then final = final.."." end
    end
    return final
end

function AddRemote(t: string, tab: table)
    for n,v in pairs(Hooks) do
        if n == t then
            table.insert(v, tab)
        end
    end
	OnRemote(t)
end

local MetaTemp = {
    Blocked = true,
    Env     = false,

}

local OldMeta, invokeserver_original, fireserver_original, invoke_original, fire_original = nil, nil, nil, nil, nil
OldMeta = metahook(game, "__namecall", function(self, ...)
    local Args = { ... }
    local origin = getcallingscript()
    local NameCall = getnamecallmethod()
    if HookFind("Namecall", NameCall) then
        local nam = GetFullName(self)
        AddRemote(self.ClassName, {
            Name    = nam,
            Arg     = Args,
            Call    = GetFullName(origin),
            Blocked = GetBlocked(self),
            Env     = not checkcaller(),
            Type    = "index | "..self.ClassName
        })
        if GetBlocked(self) then return nil end
        -- print("returned")
        return OldMeta(self, ...)
    end
    return OldMeta(self, ...)
end)

fireserver_original = hook(re.FireServer, newcclosure(function(self, method, ...)
    local origin = getcallingscript()
    local Args = { ... }
    if HookFind("Index", "FireServer") then
        local nam = GetFullName(self)
        AddRemote(self.ClassName, {
            Name    = nam,
            Arg     = Args,
            Method  = method,
            Call    = GetFullName(origin),
            Blocked = GetBlocked(self),
            Env     = not checkcaller(),
            Type    = "index | "..self.ClassName
        })
        if GetBlocked(self) then return nil end
        return fireserver_original(self, method, ...)
    end
    return fireserver_original(self, method, ...)
end))

invokeserver_original = hook(rf.InvokeServer, newcclosure(function(self, method, ...)
    local origin = getcallingscript()
    local Args = { ... }
    if HookFind("Index", "InvokeServer") then
        local nam = GetFullName(self)
        AddRemote(self.ClassName, {
            Name    = nam,
            Arg     = Args,
            Method  = method,
            Call    = GetFullName(origin),
            Blocked = GetBlocked(self),
            Env     = not checkcaller(),
            Type    = "index | "..self.ClassName
        })
        if GetBlocked(self) then return nil end
        return invokeserver_original(self, method, ...)
    end
    return invokeserver_original(self, method, ...)
end))

fire_original = hook(be.Fire, newcclosure(function(self, method, ...)
    local origin = getcallingscript()
    local Args = { ... }
    if HookFind("Index", "Fire") then
        local nam = GetFullName(self)
        AddRemote(self.ClassName, {
            Name    = nam,
            Arg     = Args,
            Method  = method,
            Call    = GetFullName(origin),
            Blocked = GetBlocked(self),
            Env     = not checkcaller(),
            Type    = "index | "..self.ClassName
        })
        if GetBlocked(self) then return nil end
        return fire_original(self, method, ...)
    end
    return fire_original(self, method, ...)
end))

invoke_original = hook(bf.Invoke, newcclosure(function(self, method, ...)
    local origin = getcallingscript()
    local Args = { ... }
    if HookFind("Index", "Invoke") then
        local nam = GetFullName(self)
        AddRemote(self.ClassName, {
            Name    = nam,
            Arg     = Args,
            Method  = method,
            Call    = GetFullName(origin),
            Blocked = GetBlocked(self),
            Env     = not checkcaller(),
            Type    = "index | "..self.ClassName
        })
        if GetBlocked(self) then return nil end
        return invoke_original(self, method, ...)
    end
    return invoke_original(self, method, ...)
end))

clear()
