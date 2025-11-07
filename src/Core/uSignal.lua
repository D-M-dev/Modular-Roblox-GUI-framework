--[[
    Signal.lua
    
    Signal/event system implementation for Roblox UI Framework
    Allows creating custom events and attaching callback functions
    
    Usage:
        local signal = Signal.new()
        signal:Connect(function(arg1, arg2) print(arg1, arg2) end)
        signal:Fire("Hello", "World")
]]

local Signal = {}
Signal.__index = Signal

--[[
    Creates a new signal
    
    @return Signal - New signal instance
]]
function Signal.new()
	local self = setmetatable({}, Signal)

	-- Internal storage for connected functions
	self._connections = {}
	self._nextId = 1

	return self
end

--[[
    Connects a callback function to the signal
    
    @param callback function - Function to be called when Fire() is invoked
    @return Connection - Object for disconnecting the callback
]]
function Signal:Connect(callback)
	if type(callback) ~= "function" then
		error("Signal:Connect expects a function", 2)
	end

	local id = self._nextId
	self._nextId = self._nextId + 1

	-- Store callback function
	self._connections[id] = callback

	-- Create connection object for disconnection
	local connection = {
		Connected = true,
		_signal = self,
		_id = id
	}

	-- Disconnect function
	function connection:Disconnect()
		if self.Connected then
			self.Connected = false
			self._signal._connections[self._id] = nil
		end
	end

	return connection
end

--[[
    Connects a callback that will be called only once
    
    @param callback function - Function to be called once when Fire() is invoked
    @return Connection - Object for disconnecting the callback
]]
function Signal:Once(callback)
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		callback(...)
	end)
	return connection
end

--[[
    Fires the signal and calls all connected functions
    
    @param ... any - Arguments to pass to callback functions
]]
function Signal:Fire(...)
	for _, callback in pairs(self._connections) do
		-- Use coroutine for async call
		coroutine.wrap(callback)(...)
	end
end

--[[
    Waits until the signal is fired
    
    @return ... - Arguments passed when Fire() is called
]]
function Signal:Wait()
	local thread = coroutine.running()
	local connection

	connection = self:Connect(function(...)
		connection:Disconnect()
		coroutine.resume(thread, ...)
	end)

	return coroutine.yield()
end

--[[
    Disconnects all callback functions
]]
function Signal:DisconnectAll()
	for id, _ in pairs(self._connections) do
		self._connections[id] = nil
	end
end

--[[
    Destroys the signal and disconnects all callbacks
]]
function Signal:Destroy()
	self:DisconnectAll()
	setmetatable(self, nil)
end

--[[
    Returns the number of active connections
    
    @return number - Number of connected callback functions
]]
function Signal:GetConnectionCount()
	local count = 0
	for _ in pairs(self._connections) do
		count = count + 1
	end
	return count
end

return Signal