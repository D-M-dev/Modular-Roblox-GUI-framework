--[[
    BaseLayout.lua
    
    Základní tøída pro všechny layout systémy
    Poskytuje spoleènou funkcionalitu pro uspoøádání elementù
]]

local BaseLayout = {}
BaseLayout.__index = BaseLayout

--[[
    Vytvoøí novou instanci BaseLayout
    
    @param container Instance - Container pro elementy
    @param properties table - Vlastnosti layoutu
    @return BaseLayout - Instance layoutu
]]
function BaseLayout.new(container, properties)
	local self = setmetatable({}, BaseLayout)

	-- Základní vlastnosti
	self.Container = container
	self.Properties = properties or {}
	self.Elements = {}
	self.Active = true

	-- Výchozí vlastnosti
	self.Padding = properties.Padding or 5
	self.Alignment = properties.Alignment or "Start" -- Start, Center, End
	self.FillDirection = properties.FillDirection or "Vertical" -- Vertical, Horizontal

	return self
end

--[[
    Získá všechny child elementy z containeru
    
    @return table - Seznam elementù
]]
function BaseLayout:_GetChildren()
	local children = {}

	if self.Container then
		for _, child in ipairs(self.Container:GetChildren()) do
			if child:IsA("GuiObject") then
				table.insert(children, child)
			end
		end
	end

	return children
end

--[[
    Aktualizuje layout - musí být implementováno v podtøídì
]]
function BaseLayout:Update()
	error("Update() must be implemented by subclass")
end

--[[
    Nastaví padding
    
    @param padding number - Nový padding
]]
function BaseLayout:SetPadding(padding)
	self.Padding = padding
	self:Update()
end

--[[
    Nastaví alignment
    
    @param alignment string - Nové zarovnání
]]
function BaseLayout:SetAlignment(alignment)
	self.Alignment = alignment
	self:Update()
end

--[[
    Pøipojí listener na zmìny v containeru
]]
function BaseLayout:_SetupChildListener()
	if not self.Container then return end

	-- Poslouchat pøidání nových dìtí
	self._childAddedConnection = self.Container.ChildAdded:Connect(function()
		task.wait(0.1) -- Malé zpoždìní pro inicializaci elementu
		self:Update()
	end)

	-- Poslouchat odstranìní dìtí
	self._childRemovedConnection = self.Container.ChildRemoved:Connect(function()
		self:Update()
	end)
end

--[[
    Znièí layout a odpojí listenery
]]
function BaseLayout:Destroy()
	self.Active = false

	if self._childAddedConnection then
		self._childAddedConnection:Disconnect()
	end

	if self._childRemovedConnection then
		self._childRemovedConnection:Disconnect()
	end

	self.Container = nil
	self.Elements = {}

	setmetatable(self, nil)
end

return BaseLayout