--[[
    Theme.lua
    
    Systém témat pro Roblox UI Framework
    Spravuje barvy, styly a vzhled celého UI
    
    Použití:
        local Theme = require(script.Parent.Theme)
        local theme = Theme.new("Dark")
        local primaryColor = theme:GetColor("Primary")
]]

local Theme = {}
Theme.__index = Theme

--[[
    Pøeddefinovaná témata
]]
local THEMES = {
	-- Tmavý režim
	Dark = {
		Name = "Dark",

		-- Hlavní barvy
		Primary = Color3.fromRGB(88, 101, 242),        -- Discord modrá
		Secondary = Color3.fromRGB(114, 137, 218),     -- Svìtlejší modrá
		Success = Color3.fromRGB(67, 181, 129),        -- Zelená
		Warning = Color3.fromRGB(250, 166, 26),        -- Oranžová
		Danger = Color3.fromRGB(237, 66, 69),          -- Èervená

		-- Pozadí
		Background = Color3.fromRGB(32, 34, 37),       -- Hlavní pozadí
		BackgroundSecondary = Color3.fromRGB(47, 49, 54),  -- Sekundární pozadí
		BackgroundTertiary = Color3.fromRGB(64, 68, 75),   -- Terciární pozadí

		-- Text
		Text = Color3.fromRGB(220, 221, 222),          -- Hlavní text
		TextSecondary = Color3.fromRGB(142, 146, 151), -- Sekundární text
		TextMuted = Color3.fromRGB(114, 118, 125),     -- Ztlumený text

		-- Okraje
		Border = Color3.fromRGB(30, 31, 34),
		BorderHover = Color3.fromRGB(88, 101, 242),

		-- Hover stavy
		Hover = Color3.fromRGB(54, 57, 63),
		Active = Color3.fromRGB(67, 70, 77),

		-- Transparentnosti
		Transparency = {
			None = 0,
			Light = 0.1,
			Medium = 0.3,
			Heavy = 0.5,
			Full = 1
		},

		-- Font
		Font = Enum.Font.Gotham,
		FontBold = Enum.Font.GothamBold,
		FontMono = Enum.Font.Code,

		-- Velikosti fontù
		FontSize = {
			Small = 12,
			Medium = 14,
			Large = 18,
			XLarge = 24
		},

		-- Corner radii
		CornerRadius = {
			Small = 4,
			Medium = 8,
			Large = 12
		}
	},

	-- Svìtlý režim
	Light = {
		Name = "Light",

		-- Hlavní barvy
		Primary = Color3.fromRGB(88, 101, 242),
		Secondary = Color3.fromRGB(114, 137, 218),
		Success = Color3.fromRGB(67, 181, 129),
		Warning = Color3.fromRGB(250, 166, 26),
		Danger = Color3.fromRGB(237, 66, 69),

		-- Pozadí
		Background = Color3.fromRGB(255, 255, 255),
		BackgroundSecondary = Color3.fromRGB(242, 243, 245),
		BackgroundTertiary = Color3.fromRGB(227, 229, 232),

		-- Text
		Text = Color3.fromRGB(32, 34, 37),
		TextSecondary = Color3.fromRGB(79, 84, 92),
		TextMuted = Color3.fromRGB(142, 146, 151),

		-- Okraje
		Border = Color3.fromRGB(227, 229, 232),
		BorderHover = Color3.fromRGB(88, 101, 242),

		-- Hover stavy
		Hover = Color3.fromRGB(242, 243, 245),
		Active = Color3.fromRGB(227, 229, 232),

		-- Transparentnosti
		Transparency = {
			None = 0,
			Light = 0.1,
			Medium = 0.3,
			Heavy = 0.5,
			Full = 1
		},

		-- Font
		Font = Enum.Font.Gotham,
		FontBold = Enum.Font.GothamBold,
		FontMono = Enum.Font.Code,

		-- Velikosti fontù
		FontSize = {
			Small = 12,
			Medium = 14,
			Large = 18,
			XLarge = 24
		},

		-- Corner radii
		CornerRadius = {
			Small = 4,
			Medium = 8,
			Large = 12
		}
	},

	-- Neon téma
	Neon = {
		Name = "Neon",

		Primary = Color3.fromRGB(255, 0, 255),
		Secondary = Color3.fromRGB(0, 255, 255),
		Success = Color3.fromRGB(0, 255, 0),
		Warning = Color3.fromRGB(255, 255, 0),
		Danger = Color3.fromRGB(255, 0, 0),

		Background = Color3.fromRGB(10, 10, 10),
		BackgroundSecondary = Color3.fromRGB(20, 20, 20),
		BackgroundTertiary = Color3.fromRGB(30, 30, 30),

		Text = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(200, 200, 200),
		TextMuted = Color3.fromRGB(150, 150, 150),

		Border = Color3.fromRGB(255, 0, 255),
		BorderHover = Color3.fromRGB(0, 255, 255),

		Hover = Color3.fromRGB(40, 40, 40),
		Active = Color3.fromRGB(50, 50, 50),

		Transparency = {
			None = 0,
			Light = 0.1,
			Medium = 0.3,
			Heavy = 0.5,
			Full = 1
		},

		Font = Enum.Font.GothamBold,
		FontBold = Enum.Font.GothamBold,
		FontMono = Enum.Font.Code,

		FontSize = {
			Small = 12,
			Medium = 14,
			Large = 18,
			XLarge = 24
		},

		CornerRadius = {
			Small = 4,
			Medium = 8,
			Large = 12
		}
	}
}

--[[
    Vytvoøí novou instanci Theme
    
    @param themeName string|table - Název tématu nebo vlastní téma
    @return Theme - Instance tématu
]]
function Theme.new(themeName)
	local self = setmetatable({}, Theme)

	if type(themeName) == "table" then
		-- Vlastní téma
		self._theme = themeName
	else
		-- Pøeddefinované téma
		themeName = themeName or "Dark"
		self._theme = THEMES[themeName] or THEMES.Dark
	end

	return self
end

--[[
    Získá barvu z tématu
    
    @param colorName string - Název barvy (Primary, Background, Text, atd.)
    @return Color3 - Barva
]]
function Theme:GetColor(colorName)
	return self._theme[colorName] or Color3.new(1, 1, 1)
end

--[[
    Získá font z tématu
    
    @param fontType string - Typ fontu ("Font", "FontBold", "FontMono")
    @return Enum.Font
]]
function Theme:GetFont(fontType)
	fontType = fontType or "Font"
	return self._theme[fontType] or Enum.Font.Gotham
end

--[[
    Získá velikost fontu
    
    @param sizeType string - Typ velikosti ("Small", "Medium", "Large", "XLarge")
    @return number
]]
function Theme:GetFontSize(sizeType)
	sizeType = sizeType or "Medium"
	return self._theme.FontSize[sizeType] or 14
end

--[[
    Získá corner radius
    
    @param sizeType string - Typ velikosti ("Small", "Medium", "Large")
    @return number
]]
function Theme:GetCornerRadius(sizeType)
	sizeType = sizeType or "Medium"
	return self._theme.CornerRadius[sizeType] or 8
end

--[[
    Získá transparentnost
    
    @param type string - Typ transparentnosti ("None", "Light", "Medium", "Heavy", "Full")
    @return number
]]
function Theme:GetTransparency(type)
	type = type or "None"
	return self._theme.Transparency[type] or 0
end

--[[
    Zmìní téma
    
    @param themeName string|table - Název nového tématu nebo vlastní téma
]]
function Theme:ChangeTheme(themeName)
	if type(themeName) == "table" then
		self._theme = themeName
	else
		self._theme = THEMES[themeName] or THEMES.Dark
	end
end

--[[
    Získá celé téma
    
    @return table - Aktuální téma
]]
function Theme:GetTheme()
	return self._theme
end

--[[
    Získá název tématu
    
    @return string - Název tématu
]]
function Theme:GetName()
	return self._theme.Name or "Custom"
end

--[[
    Vrátí všechna dostupná témata
    
    @return table - Tabulka s názvy témat
]]
function Theme.GetAvailableThemes()
	local themes = {}
	for name, _ in pairs(THEMES) do
		table.insert(themes, name)
	end
	return themes
end

--[[
    Aplikuje téma na GUI element
    
    @param element Instance - GUI element
    @param style string - Styl ("Primary", "Secondary", "Danger", atd.)
]]
function Theme:ApplyToElement(element, style)
	style = style or "Primary"

	if element:IsA("GuiObject") then
		-- Aplikuj barvy
		if self._theme[style] then
			element.BackgroundColor3 = self:GetColor(style)
		else
			element.BackgroundColor3 = self:GetColor("Background")
		end

		-- Aplikuj okraj
		local border = element:FindFirstChild("UIStroke")
		if border then
			border.Color = self:GetColor("Border")
		end

		-- Aplikuj zaoblení rohù
		local corner = element:FindFirstChild("UICorner")
		if corner then
			corner.CornerRadius = UDim.new(0, self:GetCornerRadius("Medium"))
		end
	end

	-- Aplikuj font na TextLabel/TextButton
	if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
		element.Font = self:GetFont("Font")
		element.TextSize = self:GetFontSize("Medium")
		element.TextColor3 = self:GetColor("Text")
	end
end

return Theme