# Binds!

#### Example 1:
```lua
-- Include the file yourself. Running it alone in autorun won't do anything.
local bind = include("binds.lua")

bind.Add("Test 1", KEY_I, BIND_TOGGLE, function(self, enabled)
	chat.AddText(string.format("Test bind 1 %s!", enabled and "enabled" or "disabled"))
end)
```


#### Example 2:
```lua
local bind = include("binds.lua")

local TestBind2 = bind.Add("Test 2")
TestBind2:SetButton(KEY_I)
TestBind2:SetType(BIND_TOGGLE) -- There's also BIND_HOLD and BIND_RELEASE
TestBind2:SetEnabled(true)

function TestBind2:OnChanged(enabled)
	chat.AddText(string.format("Test bind 2 %s!", enabled and "enabled" or "disabled"))
end
```


#### Example 3:
```lua
local bind = include("binds.lua")

local TestBind3 = bind.Add("Test 3", KEY_NONE, BIND_TOGGLE)

function TestBind3:OnChanged(enabled)
	chat.AddText(string.format("Test bind 3 %s!", enabled and "enabled" or "disabled"))
end

local Frame = vgui.Create("DFrame")
Frame:SetSize(250, 100)
Frame:Center()
Frame:MakePopup()

local Binder = Frame:Add("DBinder")
Binder:SetValue(KEY_NONE)
Binder:Dock(FILL)

function Binder:OnChange(key)
	TestBind3:SetButton(key)

	-- If you don't have the bind object you could always use 'Rebind'
	-- bind.Rebind("Test 3", new Type [use nil or false to keep the same], new Button [use nil or false to keep the same])

	chat.AddText(string.format("Rebound TestBind3 to %s!", language.GetPhrase(input.GetKeyName(key)):upper()))
end
```
