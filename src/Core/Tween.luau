--[[
    Tween.lua
    
    Tween/Animation systém pro Roblox UI Framework
    Poskytuje snadné rozhraní pro animace GUI elementù
    
    Použití:
        local Tween = require(script.Parent.Tween)
        Tween.Create(frame, {
            Size = UDim2.new(0, 300, 0, 200),
            Duration = 0.5
        })
]]

local TweenService = game:GetService("TweenService")

local Tween = {}

--[[
    Výchozí nastavení pro tweeny
]]
local DEFAULT_TWEEN_INFO = {
	Duration = 0.3,
	Style = Enum.EasingStyle.Quad,
	Direction = Enum.EasingDirection.Out,
	RepeatCount = 0,
	Reverses = false,
	DelayTime = 0
}

--[[
    Vytvoøí a spustí tween animaci
    
    @param instance Instance - GUI element k animaci
    @param properties table - Vlastnosti k animaci a nastavení
        - Duration: number - Délka animace v sekundách
        - Style: EasingStyle - Styl easing
        - Direction: EasingDirection - Smìr easing
        - Properties: table - Vlastnosti k animaci (Size, Position, atd.)
        - OnComplete: function - Callback po dokonèení
    @return Tween - Vytvoøený tween objekt
]]
function Tween.Create(instance, properties)
	if not instance or not instance:IsA("GuiObject") then
		error("Tween.Create expects a GuiObject", 2)
	end

	if not properties then
		error("Tween.Create expects properties table", 2)
	end

	-- Extrakce tween info parametrù
	local tweenInfo = TweenInfo.new(
		properties.Duration or DEFAULT_TWEEN_INFO.Duration,
		properties.Style or DEFAULT_TWEEN_INFO.Style,
		properties.Direction or DEFAULT_TWEEN_INFO.Direction,
		properties.RepeatCount or DEFAULT_TWEEN_INFO.RepeatCount,
		properties.Reverses or DEFAULT_TWEEN_INFO.Reverses,
		properties.DelayTime or DEFAULT_TWEEN_INFO.DelayTime
	)

	-- Extrakce vlastností k animaci
	local goals = {}
	for key, value in pairs(properties) do
		-- Ignorovat konfiguraèní klíèe
		if key ~= "Duration" and key ~= "Style" and key ~= "Direction" 
			and key ~= "RepeatCount" and key ~= "Reverses" 
			and key ~= "DelayTime" and key ~= "OnComplete" then
			goals[key] = value
		end
	end

	-- Vytvoøení tweenu
	local tween = TweenService:Create(instance, tweenInfo, goals)

	-- Callback po dokonèení
	if properties.OnComplete then
		tween.Completed:Connect(function()
			properties.OnComplete()
		end)
	end

	-- Spuštìní tweenu
	tween:Play()

	return tween
end

--[[
    Animuje zmìnu barvy
    
    @param instance Instance - GUI element
    @param targetColor Color3 - Cílová barva
    @param duration number - Délka animace
    @return Tween
]]
function Tween.Color(instance, targetColor, duration)
	return Tween.Create(instance, {
		BackgroundColor3 = targetColor,
		Duration = duration or DEFAULT_TWEEN_INFO.Duration
	})
end

--[[
    Animuje zmìnu prùhlednosti
    
    @param instance Instance - GUI element
    @param targetTransparency number - Cílová prùhlednost (0-1)
    @param duration number - Délka animace
    @return Tween
]]
function Tween.Fade(instance, targetTransparency, duration)
	return Tween.Create(instance, {
		BackgroundTransparency = targetTransparency,
		Duration = duration or DEFAULT_TWEEN_INFO.Duration
	})
end

--[[
    Animuje pozici
    
    @param instance Instance - GUI element
    @param targetPosition UDim2 - Cílová pozice
    @param duration number - Délka animace
    @return Tween
]]
function Tween.Position(instance, targetPosition, duration)
	return Tween.Create(instance, {
		Position = targetPosition,
		Duration = duration or DEFAULT_TWEEN_INFO.Duration
	})
end

--[[
    Animuje velikost
    
    @param instance Instance - GUI element
    @param targetSize UDim2 - Cílová velikost
    @param duration number - Délka animace
    @return Tween
]]
function Tween.Size(instance, targetSize, duration)
	return Tween.Create(instance, {
		Size = targetSize,
		Duration = duration or DEFAULT_TWEEN_INFO.Duration
	})
end

--[[
    Fade In animace (z prùhledné na viditelnou)
    
    @param instance Instance - GUI element
    @param duration number - Délka animace
    @return Tween
]]
function Tween.FadeIn(instance, duration)
	instance.BackgroundTransparency = 1
	instance.Visible = true

	return Tween.Fade(instance, 0, duration)
end

--[[
    Fade Out animace (z viditelné na prùhlednou)
    
    @param instance Instance - GUI element
    @param duration number - Délka animace
    @param hideAfter boolean - Skrýt element po dokonèení
    @return Tween
]]
function Tween.FadeOut(instance, duration, hideAfter)
	local tween = Tween.Fade(instance, 1, duration)

	if hideAfter then
		tween.Completed:Connect(function()
			instance.Visible = false
		end)
	end

	return tween
end

--[[
    Bounce animace
    
    @param instance Instance - GUI element
    @param duration number - Délka animace
    @return Tween
]]
function Tween.Bounce(instance, duration)
	local originalSize = instance.Size

	return Tween.Create(instance, {
		Size = UDim2.new(
			originalSize.X.Scale * 1.1,
			originalSize.X.Offset * 1.1,
			originalSize.Y.Scale * 1.1,
			originalSize.Y.Offset * 1.1
		),
		Duration = (duration or 0.3) / 2,
		Style = Enum.EasingStyle.Bounce,
		Direction = Enum.EasingDirection.Out,
		Reverses = true
	})
end

--[[
    Pulse animace (opakující se zvìtšení/zmenšení)
    
    @param instance Instance - GUI element
    @param scale number - Mìøítko pulzu (napø. 1.1)
    @param duration number - Délka jednoho cyklu
    @return Tween
]]
function Tween.Pulse(instance, scale, duration)
	local originalSize = instance.Size

	return Tween.Create(instance, {
		Size = originalSize * (scale or 1.05),
		Duration = (duration or 0.5) / 2,
		RepeatCount = -1,  -- Nekoneèné opakování
		Reverses = true
	})
end

--[[
    Shake animace
    
    @param instance Instance - GUI element
    @param intensity number - Intenzita tøesení
    @param duration number - Délka animace
]]
function Tween.Shake(instance, intensity, duration)
	local originalPosition = instance.Position
	intensity = intensity or 10
	duration = duration or 0.5

	local shakes = 10
	local shakeInterval = duration / shakes

	for i = 1, shakes do
		local offsetX = math.random(-intensity, intensity)
		local offsetY = math.random(-intensity, intensity)

		local targetPos = UDim2.new(
			originalPosition.X.Scale,
			originalPosition.X.Offset + offsetX,
			originalPosition.Y.Scale,
			originalPosition.Y.Offset + offsetY
		)

		task.wait(shakeInterval)

		if i == shakes then
			-- Vrátit na pùvodní pozici
			Tween.Position(instance, originalPosition, shakeInterval)
		else
			Tween.Position(instance, targetPos, shakeInterval)
		end
	end
end

--[[
    Slide In animace (ze strany obrazovky)
    
    @param instance Instance - GUI element
    @param direction string - "Left", "Right", "Top", "Bottom"
    @param duration number - Délka animace
    @return Tween
]]
function Tween.SlideIn(instance, direction, duration)
	local targetPosition = instance.Position
	direction = direction or "Left"

	-- Nastavení poèáteèní pozice mimo obrazovku
	if direction == "Left" then
		instance.Position = UDim2.new(-1, 0, targetPosition.Y.Scale, targetPosition.Y.Offset)
	elseif direction == "Right" then
		instance.Position = UDim2.new(1, 0, targetPosition.Y.Scale, targetPosition.Y.Offset)
	elseif direction == "Top" then
		instance.Position = UDim2.new(targetPosition.X.Scale, targetPosition.X.Offset, -1, 0)
	elseif direction == "Bottom" then
		instance.Position = UDim2.new(targetPosition.X.Scale, targetPosition.X.Offset, 1, 0)
	end

	instance.Visible = true

	return Tween.Create(instance, {
		Position = targetPosition,
		Duration = duration or 0.5,
		Style = Enum.EasingStyle.Quint,
		Direction = Enum.EasingDirection.Out
	})
end

--[[
    Zastaví všechny tweeny na elementu
    
    @param instance Instance - GUI element
]]
function Tween.Stop(instance)
	-- Najde a zastaví všechny aktivní tweeny
	for _, tween in pairs(TweenService:GetTweens()) do
		if tween.Instance == instance then
			tween:Cancel()
		end
	end
end

return Tween