--[[
    HorizontalLayout.lua
    
    Horizontální layout systém - uspoøádá elementy vedle sebe
    
    Použití:
        local HorizontalLayout = require(script.Parent.HorizontalLayout)
        local layout = HorizontalLayout.new(container, {
            Padding = 10,
            Alignment = "Center"
        })
]]

local BaseLayout = require(script.Parent.BaseLayout)

local HorizontalLayout = setmetatable({}, {__index = BaseLayout})
HorizontalLayout.__index = HorizontalLayout

--[[
    Vytvoøí nový horizontální layout
    
    @param container Instance - Container pro elementy
    @param properties table - Vlastnosti layoutu
        - Padding: number - Mezera mezi elementy
        - Alignment: string - "Start", "Center", "End"
        - StartPadding: number - Padding na zaèátku
        - FillHeight: boolean - Vyplnit celou výšku
    @return HorizontalLayout - Instance layoutu
]]
function HorizontalLayout.new(container, properties)
	properties = properties or {}

	local self = setmetatable(BaseLayout.new(container, properties), HorizontalLayout)

	-- Specifické vlastnosti pro horizontální layout
	self.StartPadding = properties.StartPadding or 0
	self.FillHeight = properties.FillHeight or false

	-- Nastavit listener pro zmìny
	self:_SetupChildListener()

	-- Prvotní update
	self:Update()

	return self
end

--[[
    Aktualizuje pozice všech elementù
]]
function HorizontalLayout:Update()
	if not self.Active or not self.Container then return end

	local children = self:_GetChildren()
	if #children == 0 then return end

	local currentX = self.StartPadding
	local containerHeight = self.Container.AbsoluteSize.Y

	for _, child in ipairs(children) do
		if child.Visible then
			local childWidth = child.Size.X.Offset
			local childHeight = child.Size.Y.Offset

			-- Výpoèet Y pozice podle alignmentu
			local yPos = 0

			if self.Alignment == "Center" then
				yPos = (containerHeight - childHeight) / 2
			elseif self.Alignment == "End" then
				yPos = containerHeight - childHeight
			else -- Start
				yPos = 0
			end

			-- Nastavení pozice
			child.Position = UDim2.new(0, currentX, 0, yPos)

			-- Vyplnit výšku
			if self.FillHeight then
				child.Size = UDim2.new(0, childWidth, 1, 0)
			end

			-- Posun pro další element
			currentX = currentX + childWidth + self.Padding
		end
	end
end

--[[
    Nastaví vyplnìní výšky
    
    @param fillHeight boolean - Vyplnit výšku
]]
function HorizontalLayout:SetFillHeight(fillHeight)
	self.FillHeight = fillHeight
	self:Update()
end

--[[
    Nastaví poèáteèní padding
    
    @param padding number - Poèáteèní padding
]]
function HorizontalLayout:SetStartPadding(padding)
	self.StartPadding = padding
	self:Update()
end

--[[
    Získá celkovou šíøku všech elementù
    
    @return number - Celková šíøka
]]
function HorizontalLayout:GetTotalWidth()
	local children = self:_GetChildren()
	local totalWidth = self.StartPadding

	for i, child in ipairs(children) do
		if child.Visible then
			totalWidth = totalWidth + child.Size.X.Offset
			if i < #children then
				totalWidth = totalWidth + self.Padding
			end
		end
	end

	return totalWidth
end

return HorizontalLayout