# Binds!

## Example:
```lua
-- Include the file yourself. Running it alone in autorun won't do anything.
local bind = include("binds.lua")

-- Add a bind without the object
bind.Add("Test 1", BIND_TOGGLE, KEY_I, function(self, enabled)
	chat.AddText(string.format("TestBind1 %s!", enabled and "enabled" or "disabled"))
end)

-- Using an object
local TestBind2 = bind.Add("Test 2")
TestBind2:SetType(BIND_TOGGLE) -- There's also BIND_HOLD and BIND_RELEASE
TestBind2:SetButton(KEY_I)
TestBind2:SetEnabled(true)

function TestBind2:OnChanged(enabled)
	chat.AddText(string.format("TestBind2 %s!", enabled and "enabled" or "disabled"))
end

-- Using a DBinder to change the bind's key
local TestBind3 = bind.Add("Test 3", BIND_TOGGLE, KEY_NONE)

function TestBind3:OnChanged(enabled)
	chat.AddText(string.format("TestBind3 %s!", enabled and "enabled" or "disabled"))
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
## Output:
```
Rebound TestBind3 to I!
TestBind1 enabled!
TestBind2 disabled!
TestBind3 enabled!
```
