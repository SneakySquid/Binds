local _R = debug.getregistry()

_R.Binds = _R.Binds or {
	Buttons = {},
	Identifiers = {},
}

local BIND = {}
BIND.__index = BIND

BIND_TOGGLE = 0
BIND_HOLD = 1
BIND_RELEASE = 2

AccessorFunc(BIND, "m_iType", "Type", FORCE_NUMBER)
AccessorFunc(BIND, "m_iButton", "Button", FORCE_NUMBER)
AccessorFunc(BIND, "m_bEnabled", "Enabled", FORCE_BOOL)

function BIND:__tostring()
	return string.format("Bind: %p", self)
end

function BIND:OnChanged(enabled)
	-- for override
end

function BIND:SetButton(button)
	_R.Binds.Buttons[button] = _R.Binds.Buttons[button] or {}

	if (self:GetButton()) then
		table.RemoveByValue(_R.Binds.Buttons[self:GetButton()], self)
	end

	table.insert(_R.Binds.Buttons[button], self)

	self.m_iButton = button
end

function BIND:SetEnabled(enabled)
	if (self:GetEnabled() ~= enabled) then
		self:OnChanged(enabled)
	end

	self.m_bEnabled = enabled
end

function BIND:CheckEnabled(down)
	if (self:GetType() == BIND_HOLD) then
		self:SetEnabled(down)
	elseif (self:GetType() == BIND_RELEASE) then
		self:SetEnabled(not down)
	elseif (down) then
		self:SetEnabled(not self:GetEnabled())
	end
end

local function Remove(id)
	if (not id) then return end

	local bind = _R.Binds.Identifiers[id]
	if (not bind) then return false end

	table.RemoveByValue(_R.Binds.Buttons[bind:GetButton()], bind)
	table.Empty(bind)

	setmetatable(bind, nil)

	return true
end

local function Add(id, type, button, callback)
	if (_R.Binds.Identifiers[id]) then Remove(id) end

	local bind = setmetatable({}, BIND)

	bind:SetType(tonumber(type) or BIND_TOGGLE)
	bind:SetButton(tonumber(button) or KEY_NONE)

	if (isfunction(callback)) then
		bind.OnChanged = callback
	end

	_R.Binds.Identifiers[id] = bind

	return bind
end

local function GetTable()
	return _R.Binds
end

hook.Add("PlayerButtonDown", "Kraken.Binds.CheckDown", function(ply, button)
	if (not IsFirstTimePredicted()) then return end

	local binds = _R.Binds.Buttons[button]
	if (not binds) then return end

	for _, bind in ipairs(binds) do
		bind:CheckEnabled(true)
	end
end)

hook.Add("PlayerButtonUp", "Kraken.Binds.CheckUp", function(ply, button)
	if (not IsFirstTimePredicted()) then return end

	local binds = _R.Binds.Buttons[button]
	if (not binds) then return end

	for _, bind in ipairs(binds) do
		bind:CheckEnabled(false)
	end
end)

return {
	Add = Add,
	Remove = Remove,
	GetTable = GetTable,
}
