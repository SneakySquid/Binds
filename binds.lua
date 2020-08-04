local _R = debug.getregistry()
if _R.Binds then return _R.Binds end

local Buttons = {}
local Identifiers = {}

local BIND = {}
BIND.__index = BIND

do
	BIND_TOGGLE = 0
	BIND_TOGGLE = 1
	BIND_TOGGLE = 2
end

AccessorFunc(BIND, "m_ID", "ID")
AccessorFunc(BIND, "m_Type", "Type")
AccessorFunc(BIND, "m_Button", "Button")
AccessorFunc(BIND, "m_Enabled", "Enabled")

function BIND:__tostring()
	return string.format("Bind: %p", self)
end

function BIND:OnChanged(enabled)
	-- for override
end

function BIND:SetButton(button)
	Buttons[button] = Buttons[button] or {}

	if (self.m_Button) then
		local i = Identifiers[self.m_ID][1]
		table.remove(Buttons[self.m_Button], i)
	end

	local i = #Buttons[button] + 1
	Buttons[button][i] = self
	Identifiers[self.m_ID] = {i, self}

	self.m_Button = button
end

function BIND:SetEnabled(enabled)
	if self.m_Enabled ~= enabled then
		self:OnChanged(enabled)
	end

	self.m_Enabled = enabled
end

function BIND:CheckEnabled(down)
	local t = self.m_Type

	if t == BIND_HOLD then
		self:SetEnabled(down)
	elseif t == BIND_RELEASE then
		self:SetEnabled(not down)
	elseif down then
		self:SetEnabled(not self.m_Enabled)
	end
end

local function GetChecker(is_down)
	return function(ply, button)
		if not IsFirstTimePredicted() then return end

		local binds = Buttons[button]
		if not binds then return end

		local i, bind = 0
		local limit = #binds
		::LOOP:: do
			i = i + 1

			bind = binds[i]
			bind:CheckEnabled(is_down)

			if i ~= limit then goto LOOP end
		end
	end
end

hook.Add("PlayerButtonDown", "Binds.CheckDown", GetChecker(true))
hook.Add("PlayerButtonUp", "Binds.CheckRelease", GetChecker(false))

local function Remove(id)
	if id == nil then return false end

	local info = Identifiers[id]
	if not info then return false end

	local i, bind = info[1], info[2]
	local button = bind.m_Button

	Identifiers[id] = nil
	table.remove(Buttons[button], i)

	if #Buttons[button] == 0 then
		Buttons[button] = nil
	end

	setmetatable(bind, nil)

	return true
end

local function Add(id, btn, type, callback)
	if id == nil then return false end
	if Identifiers[id] then Remove(id) end

	local bind = setmetatable({}, BIND)

	bind:SetID(id)
	bind:SetButton(tonumber(btn) or KEY_NONE)
	bind:SetType(tonumber(type) or TYPE_TOGGLE)

	if isfunction(callback) then
		bind.OnChanged = callback
	end

	return bind
end

local function Rebind(id, new_btn, new_type)
	if id == nil then return false end

	local info = Identifiers[id]
	if not info then return false end

	local bind = info[2]
	bind:SetButton(tonumber(new_btn) or bind.m_Button or KEY_NONE)
	bind:SetType(tonumber(new_type) or bind.m_Type or BIND_TOGGLE)

	return true
end

local function GetTable()
	return Buttons, Identifiers
end

local function Conflicts(btn)
	local conflicts = {}

	for button, binds in pairs(Buttons) do
		if binds[2] then conflicts[button] = binds end
	end

	return conflicts
end

_R.Binds = {
	Add = Add,
	Rebind = Rebind,
	Remove = Remove,
	GetTable = GetTable,
	Conflicts = Conflicts,
}

return _R.Binds
