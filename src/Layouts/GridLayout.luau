--[[
    GridLayout.lua
    
    Møížkový layout systém - uspoøádá elementy do møížky
    
    Použití:
        local GridLayout = require(script.Parent.GridLayout)
        local layout = GridLayout.new(container, {
            Columns = 3,
            Rows = 2,
            Padding = 10,
            CellSize = UDim2.new(0, 100, 0, 100)
        })
]]

local BaseLayout = require(script.Parent.BaseLayout)

local GridLayout = setmetatable({}, {__index = BaseLayout})
GridLayout.__index = GridLayout

--[[
    Vytvoøí nový grid layout
    
    @param container Instance - Container pro elementy
    @param properties table - Vlastnosti layoutu
        - Columns: number - Poèet sloupcù (pokud není specifikováno Rows)
        - Rows: number - Poèet øádkù (pokud není specifikováno Columns)
        - Padding: number - Mezera mezi buòkami
        - CellSize: UDim2 - Velikost bunìk (volitelné)
        - StartPadding: number - Padding okolo møížky
        - FillDirection: string - "Horizontal" nebo "Vertical"
    @return GridLayout - Instance layoutu
]]
function GridLayout.new(container, properties)
	properties = properties or {}

	local self = setmetatable(BaseLayout.new(container, properties), GridLayout)

	-- Specifické vlastnosti pro grid layout
	self.Columns = properties.Columns
	self.Rows = properties.Rows
	self.CellSize = properties.CellSize
	self.StartPadding = properties.StartPadding or 0
	self.FillDirection = properties.FillDirection or "Horizontal" -- Horizontal nebo Vertical

	-- Musí být specifikován buï Columns nebo Rows
	if not self.Columns and not self.Rows then
		self.Columns = 3 -- Výchozí hodnota
	end

	-- Nastavit listener pro zmìny
	self:_SetupChildListener()

	-- Prvotní update
	self:Update()

	return self
end

--[[
    Aktualizuje pozice všech elementù v møížce
]]
function GridLayout:Update()
	if not self.Active or not self.Container then return end

	local children = self:_GetChildren()
	if #children == 0 then return end

	-- Výpoèet poètu øádkù a sloupcù
	local columns, rows

	if self.Columns then
		columns = self.Columns
		rows = math.ceil(#children / columns)
	else
		rows = self.Rows
		columns = math.ceil(#children / rows)
	end

	-- Výpoèet velikosti bunìk
	local cellWidth, cellHeight

	if self.CellSize then
		cellWidth = self.CellSize.X.Offset
		cellHeight = self.CellSize.Y.Offset
	else
		-- Automatický výpoèet podle velikosti containeru
		local containerWidth = self.Container.AbsoluteSize.X - (self.StartPadding * 2)
		local containerHeight = self.Container.AbsoluteSize.Y - (self.StartPadding * 2)

		cellWidth = (containerWidth - (self.Padding * (columns - 1))) / columns
		cellHeight = (containerHeight - (self.Padding * (rows - 1))) / rows
	end

	-- Uspoøádání elementù
	local index = 0

	for row = 0, rows - 1 do
		for col = 0, columns - 1 do
			index = index + 1

			if index > #children then
				break
			end

			local child = children[index]

			if child.Visible then
				-- Výpoèet pozice
				local x, y

				if self.FillDirection == "Vertical" then
					-- Plnit vertikálnì (po sloupcích)
					local actualCol = math.floor((index - 1) / rows)
					local actualRow = (index - 1) % rows

					x = self.StartPadding + (actualCol * (cellWidth + self.Padding))
					y = self.StartPadding + (actualRow * (cellHeight + self.Padding))
				else
					-- Plnit horizontálnì (po øádcích) - výchozí
					x = self.StartPadding + (col * (cellWidth + self.Padding))
					y = self.StartPadding + (row * (cellHeight + self.Padding))
				end

				-- Nastavení pozice a velikosti
				child.Position = UDim2.new(0, x, 0, y)
				child.Size = UDim2.new(0, cellWidth, 0, cellHeight)
			end
		end
	end
end

--[[
    Nastaví poèet sloupcù
    
    @param columns number - Poèet sloupcù
]]
function GridLayout:SetColumns(columns)
	self.Columns = columns
	self.Rows = nil -- Resetovat rows
	self:Update()
end

--[[
    Nastaví poèet øádkù
    
    @param rows number - Poèet øádkù
]]
function GridLayout:SetRows(rows)
	self.Rows = rows
	self.Columns = nil -- Resetovat columns
	self:Update()
end

--[[
    Nastaví velikost bunìk
    
    @param cellSize UDim2 - Velikost bunìk
]]
function GridLayout:SetCellSize(cellSize)
	self.CellSize = cellSize
	self:Update()
end

--[[
    Nastaví smìr plnìní
    
    @param direction string - "Horizontal" nebo "Vertical"
]]
function GridLayout:SetFillDirection(direction)
	self.FillDirection = direction
	self:Update()
end

--[[
    Získá poèet sloupcù
    
    @return number - Poèet sloupcù
]]
function GridLayout:GetColumns()
	if self.Columns then
		return self.Columns
	else
		local children = self:_GetChildren()
		return math.ceil(#children / self.Rows)
	end
end

--[[
    Získá poèet øádkù
    
    @return number - Poèet øádkù
]]
function GridLayout:GetRows()
	if self.Rows then
		return self.Rows
	else
		local children = self:_GetChildren()
		return math.ceil(#children / self.Columns)
	end
end

return GridLayout