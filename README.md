# Binds!

## Example:
```lua
local bind = include("binds.lua")

bind.Add("Test 1", BIND_TOGGLE, KEY_I, function(self, enabled)
	chat.AddText(string.format("TestBind1 %s!", enabled and "enabled" or "disabled"))
end)

local TestBind2 = bind.Add("Test 2")
TestBind2:SetType(BIND_TOGGLE)
TestBind2:SetButton(KEY_I)
TestBind2:SetEnabled(true)

function TestBind2:OnChanged(enabled)
	chat.AddText(string.format("TestBind2 %s!", enabled and "enabled" or "disabled"))
end
```
