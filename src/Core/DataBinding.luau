--[[
    DataBinding.lua
    
    Reaktivní data binding systém pro Roblox UI Framework
    Umožòuje propojit data s UI elementy, které se automaticky aktualizují
    
    Použití:
        local DataBinding = require(script.Parent.DataBinding)
        local data = DataBinding.new({
            playerName = "Hráè",
            score = 0
        })
        
        -- Propojení s textem
        data:BindToText(textLabel, "Skóre: {score}")
        
        -- Zmìna hodnoty automaticky aktualizuje UI
        data:Set("score", 100)
]]

local Signal = require(script.Parent.Signal)

local DataBinding = {}
DataBinding.__index = DataBinding

--[[
    Vytvoøí nový data binding objekt
    
    @param initialData table - Poèáteèní data
    @return DataBinding - Instance data bindingu
]]
function DataBinding.new(initialData)
	local self = setmetatable({}, DataBinding)

	-- Uložení dat
	self._data = initialData or {}

	-- Signály pro zmìny jednotlivých klíèù
	self._signals = {}

	-- Binding pro text elementy
	self._textBindings = {}

	-- Binding pro vlastnosti
	self._propertyBindings = {}

	return self
end

--[[
    Nastaví hodnotu a vyvolá zmìnu
    
    @param key string - Klíè dat
    @param value any - Nová hodnota
]]
function DataBinding:Set(key, value)
	local oldValue = self._data[key]
	self._data[key] = value

	-- Vyvolat signál zmìny
	if self._signals[key] then
		self._signals[key]:Fire(value, oldValue)
	end

	-- Aktualizovat text bindings
	self:_UpdateTextBindings()

	-- Aktualizovat property bindings
	self:_UpdatePropertyBindings(key)
end

--[[
    Získá hodnotu
    
    @param key string - Klíè dat
    @return any - Hodnota
]]
function DataBinding:Get(key)
	return self._data[key]
end

--[[
    Nastaví více hodnot najednou
    
    @param data table - Tabulka s hodnotami
]]
function DataBinding:SetMultiple(data)
	for key, value in pairs(data) do
		self:Set(key, value)
	end
end

--[[
    Získá všechna data
    
    @return table - Všechna data
]]
function DataBinding:GetAll()
	return self._data
end

--[[
    Pøipojí callback na zmìnu hodnoty
    
    @param key string - Klíè dat
    @param callback function - Funkce volaná pøi zmìnì (newValue, oldValue)
    @return Connection - Objekt pro odpojení
]]
function DataBinding:OnChanged(key, callback)
	if not self._signals[key] then
		self._signals[key] = Signal.new()
	end

	return self._signals[key]:Connect(callback)
end

--[[
    Propojí data s text elementem
    Text mùže obsahovat {klíè} pro substituci hodnot
    
    @param textElement TextLabel|TextButton|TextBox - Text element
    @param template string - Šablona textu s {klíèi}
    @return table - Binding objekt
]]
function DataBinding:BindToText(textElement, template)
	if not textElement or not (textElement:IsA("TextLabel") or textElement:IsA("TextButton") or textElement:IsA("TextBox")) then
		error("BindToText expects a text element", 2)
	end

	local binding = {
		Element = textElement,
		Template = template,
		Active = true
	}

	table.insert(self._textBindings, binding)

	-- Prvotní update
	self:_UpdateTextBinding(binding)

	return binding
end

--[[
    Propojí hodnotu s vlastností elementu
    
    @param element Instance - GUI element
    @param property string - Název vlastnosti
    @param key string - Klíè dat
    @param transform function - Volitelná transformaèní funkce
    @return table - Binding objekt
]]
function DataBinding:BindToProperty(element, property, key, transform)
	if not element or not element:IsA("GuiObject") then
		error("BindToProperty expects a GuiObject", 2)
	end

	local binding = {
		Element = element,
		Property = property,
		Key = key,
		Transform = transform,
		Active = true
	}

	if not self._propertyBindings[key] then
		self._propertyBindings[key] = {}
	end

	table.insert(self._propertyBindings[key], binding)

	-- Prvotní update
	self:_UpdatePropertyBinding(binding)

	return binding
end

--[[
    Interní: Aktualizuje text binding
    
    @param binding table - Binding objekt
]]
function DataBinding:_UpdateTextBinding(binding)
	if not binding.Active or not binding.Element or not binding.Element.Parent then
		return
	end

	local text = binding.Template

	-- Nahradit všechny {klíè} hodnotami
	for key, value in pairs(self._data) do
		text = string.gsub(text, "{" .. key .. "}", tostring(value))
	end

	binding.Element.Text = text
end

--[[
    Interní: Aktualizuje všechny text bindings
]]
function DataBinding:_UpdateTextBindings()
	for i = #self._textBindings, 1, -1 do
		local binding = self._textBindings[i]

		-- Odstranit neaktivní binding
		if not binding.Active or not binding.Element or not binding.Element.Parent then
			table.remove(self._textBindings, i)
		else
			self:_UpdateTextBinding(binding)
		end
	end
end

--[[
    Interní: Aktualizuje property binding
    
    @param binding table - Binding objekt
]]
function DataBinding:_UpdatePropertyBinding(binding)
	if not binding.Active or not binding.Element or not binding.Element.Parent then
		return
	end

	local value = self._data[binding.Key]

	-- Aplikovat transformaci
	if binding.Transform then
		value = binding.Transform(value)
	end

	-- Nastavit vlastnost
	binding.Element[binding.Property] = value
end

--[[
    Interní: Aktualizuje property bindings pro klíè
    
    @param key string - Klíè dat
]]
function DataBinding:_UpdatePropertyBindings(key)
	if not self._propertyBindings[key] then
		return
	end

	for i = #self._propertyBindings[key], 1, -1 do
		local binding = self._propertyBindings[key][i]

		-- Odstranit neaktivní binding
		if not binding.Active or not binding.Element or not binding.Element.Parent then
			table.remove(self._propertyBindings[key], i)
		else
			self:_UpdatePropertyBinding(binding)
		end
	end
end

--[[
    Odpojí binding
    
    @param binding table - Binding objekt
]]
function DataBinding:Unbind(binding)
	binding.Active = false
end

--[[
    Odpojí všechny bindings
]]
function DataBinding:UnbindAll()
	-- Deaktivovat text bindings
	for _, binding in pairs(self._textBindings) do
		binding.Active = false
	end
	self._textBindings = {}

	-- Deaktivovat property bindings
	for _, bindings in pairs(self._propertyBindings) do
		for _, binding in pairs(bindings) do
			binding.Active = false
		end
	end
	self._propertyBindings = {}
end

--[[
    Vytvoøí computed hodnotu (odvozená od jiných hodnot)
    
    @param key string - Klíè nové computed hodnoty
    @param dependencies table - Seznam klíèù, na kterých závisí
    @param computeFunction function - Funkce pro výpoèet hodnoty
]]
function DataBinding:Computed(key, dependencies, computeFunction)
	-- Funkce pro pøepoèítání
	local function recompute()
		local args = {}
		for _, depKey in ipairs(dependencies) do
			table.insert(args, self:Get(depKey))
		end

		local newValue = computeFunction(table.unpack(args))
		self._data[key] = newValue

		-- Vyvolat signál zmìny
		if self._signals[key] then
			self._signals[key]:Fire(newValue, nil)
		end
	end

	-- Pøipojit k závislým hodnotám
	for _, depKey in ipairs(dependencies) do
		self:OnChanged(depKey, function()
			recompute()
		end)
	end

	-- Prvotní výpoèet
	recompute()
end

--[[
    Znièí data binding a všechny signály
]]
function DataBinding:Destroy()
	self:UnbindAll()

	for _, signal in pairs(self._signals) do
		signal:Destroy()
	end

	self._data = {}
	self._signals = {}
	setmetatable(self, nil)
end

return DataBinding