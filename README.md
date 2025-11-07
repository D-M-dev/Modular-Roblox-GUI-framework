# 🎨 Roblox UI Framework

**A modern, modular GUI framework for Roblox Studio**

A solution for creating complex user interfaces in Roblox without having to manually create GUI elements. Notice that comments in modules, scripts are in Czech, I will translate it in a few days...
## ✨ Main Features

- 🧩 **Fully Modular Architecture** - each component is a separate module
- 🎯 **OOP Design** - class-like construction for easy work
- 🔌 **Extensibility** - easy to add custom components
- 🎛️ **UI Manager** - centralized management of components and their lifecycle
- ⚡ **Signal System** - robust event handling (onClick, onHover, onOpen, onClose)
- 🎨 **Theme System** - predefined dark/light modes + custom themes
- ✨ **Animation** - smooth tweening and transition effects
- 📐 **Layout System** - Grid, VerticalList, HorizontalList
- 🔗 **Data Binding** - reactive data binding to UI elements
- 📚 **Complete Documentation** - each feature is described in detail

## 🚀 Quick Start

### Installation

1. Copy the `src` folder to your Roblox project (into `ReplicatedStorage` or `StarterPlayer`)
2. Create a `ModuleScript` and require the framework:

```lua
local UIFramework = require(game.ReplicatedStorage.RobloxUIFramework.Init)

-- Initialize the framework
local UI = UIFramework.new()

-- Create a simple button
local button = UI:CreateComponent("Button", {
Text = "Click me!",
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = UDim2.new(0, 200, 0, 50),
Parent = script.Parent
})

button.OnClick:Connect(function()
print("Button was clicked!")
end)
```

### Basic Example - Button Panel

```lua
local UIFramework = require(game.ReplicatedStorage.RobloxUIFramework.Init)
local UI = UIFramework.new()

-- Create main panel
local panel = UI:CreateComponent("Panel", {
Position = UDim2.new(0.5, -200, 0.5, -150),
Size = UDim2.new(0, 400, 0, 300),
Title = "My panel",
Parent = script.Parent
})

-- Add vertical layout
panel:SetLayout("Vertical", {
Padding = 10,
Alignment = "Center"
})

-- Add buttons
for i = 1, 3 to
local button = UI:CreateComponent("Button", {
Text = "Button " .. i,
Parent = panel.Container
})

button.OnClick:Connect(function()
print("Button clicked", i)
end)
end
```

## 📦 Components

### Basic components

- **Button** - Interactive button with hover effects
- **Panel** - Container with name and closing options
- **Text** - Styled text element
- **Input** - Text input field
- **ScrollFrame** - Scrollable container
- **Image** - Image component

### Layout system

- **VerticalLayout** - Vertical layout of elements
- **HorizontalLayout** - Horizontal layout of elements
- **GridLayout** - Grid layout (rows x columns)

## 🎨 Themes

Framework supports switching between themes:

```lua
-- Dark mode (default)

UI:SetTheme("Dark")

-- Light mode

UI:SetTheme("Light")

-- Custom theme
UI:SetTheme({
Primary = Color3.fromRGB(100, 50, 200),
Secondary = Color3.fromRGB(150, 100, 250),
Background = Color3.fromRGB(20, 20, 20),
Text = Color3.fromRGB(255, 255, 255)
})
```

## 🔗 Data Binding

Automatic data binding to UI:

```lua
local data = UI:CreateDataBinding({
playerName = "Player123",
score = 0
})

local text = UI:CreateComponent("Text", {
Text = "Score: {score}",
Parent = panel.Container,
DataBinding = data
})

-- Changing the value automatically updates the UI
data:Set("score", 100) -- The text changes to "Score: 100"
```

## ✨ Animation

```lua
-- Open animation
panel:AnimateOpen({
Duration = 0.5,
Style = Enum.EasingStyle.Quint,
Direction = Enum.EasingDirection.Out
})

-- Custom animation
button:Animate({
Size = UDim2.new(0, 250, 0, 60),
Duration = 0.3
})
```

## 📚 Documentation

- [API Reference](docs/API.md)
- [Components](docs/Components.md)
- [Templates](docs/Themes.md)
- [Examples](examples/)

## 🤝 Contributions

Dm on my discord-taco_system

## 📄 License

MIT License - Free to use for any project

## 🔗 Links

- [Roblox API Reference](https://create.roblox.com/docs)

---

**Created for the Roblox community with by part of Roblox community❤️**
