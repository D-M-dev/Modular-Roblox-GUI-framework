--[[
    VerticalLayout.lua
    
    Vertikální layout systém - uspoøádá elementy pod sebe
    
    Použití:
        local VerticalLayout = require(script.Parent.VerticalLayout)
        local layout = VerticalLayout.new(container, {
            Padding = 10,
            Alignment = "Center"
        })
]]

local BaseLayout = require(script.Parent.BaseLayout)

local VerticalLayout = setmetatable({}, {__index = BaseLayout})
VerticalLayout.__index = VerticalLayout

--[[
    Vytvoøí nový vertikální layout
    
    @param container Instance - Container pro elementy
    @param properties table - Vlastnosti layoutu
        - Padding: number - Mezera mezi elementy
        - Alignment: string - "Start", "Center", "End"
        - StartPadding: number - Padding na zaèátku
        - FillWidth: boolean - Vyplnit celou šíøku
    @return VerticalLayout - Instance layoutu
]]
function VerticalLayout.new(container, properties)
	properties = properties or {}

	local self = setmetatable(BaseLayout.new(container, properties), VerticalLayout)

	-- Specifické vlastnosti pro vertikální layout
	self.StartPadding = properties.StartPadding or 0
	self.FillWidth = properties.FillWidth ~= false

	-- Nastavit listener pro zmìny
	self:_SetupChildListener()

	-- Prvotní update
	self:Update()

	return self
end

--[[
    Aktualizuje pozice všech elementù
]]
function VerticalLayout:Update()
	if not self.Active or not self.Container then return end

	local children = self:_GetChildren()
	if #children == 0 then return end

	local currentY = self.StartPadding
	local containerWidth = self.Container.AbsoluteSize.X

	for _, child in ipairs(children) do
		if child.Visible then
			local childWidth = child.Size.X.Offset
			local childHeight = child.Size.Y.Offset

			-- Výpoèet X pozice podle alignmentu
			local xPos = 0

			if self.Alignment == "Center" then
				xPos = (containerWidth - childWidth) / 2
			elseif self.Alignment == "End" then
				xPos = containerWidth - childWidth
			else -- Start
				xPos = 0
			end

			-- Nastavení pozice
			child.Position = UDim2.new(0, xPos, 0, currentY)

			-- Vyplnit šíøku
			if self.FillWidth then
				child.Size = UDim2.new(1, 0, 0, childHeight)
			end

			-- Posun pro další element
			currentY = currentY + childHeight + self.Padding
		end
	end
end

--[[
    Nastaví vyplnìní šíøky
    
    @param fillWidth boolean - Vyplnit šíøku
]]
function VerticalLayout:SetFillWidth(fillWidth)
	self.FillWidth = fillWidth
	self:Update()
end

--[[
    Nastaví poèáteèní padding
    
    @param padding number - Poèáteèní padding
]]
function VerticalLayout:SetStartPadding(padding)
	self.StartPadding = padding
	self:Update()
end

--[[
    Získá celkovou výšku všech elementù
    
    @return number - Celková výška
]]
function VerticalLayout:GetTotalHeight()
	local children = self:_GetChildren()
	local totalHeight = self.StartPadding

	for i, child in ipairs(children) do
		if child.Visible then
			totalHeight = totalHeight + child.Size.Y.Offset
			if i < #children then
				totalHeight = totalHeight + self.Padding
			end
		end
	end

	return totalHeight
end

return VerticalLayout