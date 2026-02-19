---@meta
---@namespace love

---Provides an interface to the user's joystick.
love.joystick = {}

--region Joystick

---Represents a physical joystick.
---
---[Open in Browser](https://love2d.org/wiki/Joystick)
---
---@class Joystick : Object
local Joystick = {}
---Gets the direction of each axis.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getAxes)
---
---@return number, number, number
function Joystick:getAxes() end

---Gets the direction of an axis.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getAxis)
---
---@param axis number # The index of the axis to be checked.
---@return number
function Joystick:getAxis(axis) end

---Gets the number of axes on the joystick.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getAxisCount)
---
---@return number
function Joystick:getAxisCount() end

---Gets the number of buttons on the joystick.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getButtonCount)
---
---@return number
function Joystick:getButtonCount() end

---Gets the USB vendor ID, product ID, and product version numbers of joystick which consistent across operating systems.
---
---Can be used to show different icons, etc. for different gamepads.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getDeviceInfo)
---
---@return number, number, number
function Joystick:getDeviceInfo() end

---Gets a stable GUID unique to the type of the physical joystick which does not change over time. For example, all Sony Dualshock 3 controllers in OS X have the same GUID. The value is platform-dependent.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getGUID)
---
---@return string
function Joystick:getGUID() end

---Gets the direction of a virtual gamepad axis. If the Joystick isn't recognized as a gamepad or isn't connected, this function will always return 0.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getGamepadAxis)
---
---@param axis love.GamepadAxis # The virtual axis to be checked.
---@return number
function Joystick:getGamepadAxis(axis) end

---Gets the button, axis or hat that a virtual gamepad input is bound to.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getGamepadMapping)
---
---@param axis love.GamepadAxis # The virtual gamepad axis to get the binding for.
---@return love.JoystickInputType, number, love.JoystickHat
---
---The physical locations for the virtual gamepad axes and buttons correspond as closely as possible to the layout of a standard Xbox 360 controller.
---@overload fun(self:Joystick, button:love.GamepadButton):love.JoystickInputType, number, love.JoystickHat
function Joystick:getGamepadMapping(axis) end

---Gets the full gamepad mapping string of this Joystick, or nil if it's not recognized as a gamepad.
---
---The mapping string contains binding information used to map the Joystick's buttons an axes to the standard gamepad layout, and can be used later with love.joystick.loadGamepadMappings.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getGamepadMappingString)
---
---@return string
function Joystick:getGamepadMappingString() end

---Gets the direction of the Joystick's hat.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getHat)
---
---@param hat number # The index of the hat to be checked.
---@return love.JoystickHat
function Joystick:getHat(hat) end

---Gets the number of hats on the joystick.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getHatCount)
---
---@return number
function Joystick:getHatCount() end

---Gets the joystick's unique identifier. The identifier will remain the same for the life of the game, even when the Joystick is disconnected and reconnected, but it '''will''' change when the game is re-launched.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getID)
---
---@return number, number
function Joystick:getID() end

---Gets the name of the joystick.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getName)
---
---@return string
function Joystick:getName() end

---Gets the current vibration motor strengths on a Joystick with rumble support.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.getVibration)
---
---@return number, number
function Joystick:getVibration() end

---Gets whether the Joystick is connected.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.isConnected)
---
---@return boolean
function Joystick:isConnected() end

---Checks if a button on the Joystick is pressed.
---
---LÖVE 0.9.0 had a bug which required the button indices passed to Joystick:isDown to be 0-based instead of 1-based, for example button 1 would be 0 for this function. It was fixed in 0.9.1.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.isDown)
---
---@param buttonN number # The index of a button to check.
---@return boolean
function Joystick:isDown(buttonN) end

---Gets whether the Joystick is recognized as a gamepad. If this is the case, the Joystick's buttons and axes can be used in a standardized manner across different operating systems and joystick models via Joystick:getGamepadAxis, Joystick:isGamepadDown, love.gamepadpressed, and related functions.
---
---LÖVE automatically recognizes most popular controllers with a similar layout to the Xbox 360 controller as gamepads, but you can add more with love.joystick.setGamepadMapping.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.isGamepad)
---
---@return boolean
function Joystick:isGamepad() end

---Checks if a virtual gamepad button on the Joystick is pressed. If the Joystick is not recognized as a Gamepad or isn't connected, then this function will always return false.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.isGamepadDown)
---
---@param buttonN love.GamepadButton # The gamepad button to check.
---@return boolean
function Joystick:isGamepadDown(buttonN) end

---Gets whether the Joystick supports vibration.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.isVibrationSupported)
---
---@return boolean
function Joystick:isVibrationSupported() end

---Sets the vibration motor speeds on a Joystick with rumble support. Most common gamepads have this functionality, although not all drivers give proper support. Use Joystick:isVibrationSupported to check.
---
---[Open in Browser](https://love2d.org/wiki/Joystick.setVibration)
---
---@param left number # Strength of the left vibration motor on the Joystick. Must be in the range of 1.
---@param right number # Strength of the right vibration motor on the Joystick. Must be in the range of 1.
---@param duration number? # The duration of the vibration in seconds. A negative value means infinite duration. (Defaults to -1.)
---@return boolean
---@overload fun(self:Joystick, left:number, right:number):boolean
---
---Disables vibration.
---@overload fun(self:Joystick):boolean
function Joystick:setVibration(left, right, duration) end

--endregion Joystick

---Virtual gamepad axes.
---
---[Open in Browser](https://love2d.org/wiki/GamepadAxis)
---
---@alias GamepadAxis
---| "leftx" -- The x-axis of the left thumbstick.
---| "lefty" -- The y-axis of the left thumbstick.
---| "rightx" -- The x-axis of the right thumbstick.
---| "righty" -- The y-axis of the right thumbstick.
---| "triggerleft" -- Left analog trigger.
---| "triggerright" -- Right analog trigger.

---Virtual gamepad buttons.
---
---[Open in Browser](https://love2d.org/wiki/GamepadButton)
---
---@alias GamepadButton
---| "a" -- Bottom face button (A).
---| "b" -- Right face button (B).
---| "x" -- Left face button (X).
---| "y" -- Top face button (Y).
---| "back" -- Back button.
---| "guide" -- Guide button.
---| "start" -- Start button.
---| "leftstick" -- Left stick click button.
---| "rightstick" -- Right stick click button.
---| "leftshoulder" -- Left bumper.
---| "rightshoulder" -- Right bumper.
---| "dpup" -- D-pad up.
---| "dpdown" -- D-pad down.
---| "dpleft" -- D-pad left.
---| "dpright" -- D-pad right.

---Joystick hat positions.
---
---[Open in Browser](https://love2d.org/wiki/JoystickHat)
---
---@alias JoystickHat
---| "c" -- Centered
---| "d" -- Down
---| "l" -- Left
---| "ld" -- Left+Down
---| "lu" -- Left+Up
---| "r" -- Right
---| "rd" -- Right+Down
---| "ru" -- Right+Up
---| "u" -- Up

---Types of Joystick inputs.
---
---[Open in Browser](https://love2d.org/wiki/JoystickInputType)
---
---@alias JoystickInputType
---| "axis" -- Analog axis.
---| "button" -- Button.
---| "hat" -- 8-direction hat value.

---Gets the full gamepad mapping string of the Joysticks which have the given GUID, or nil if the GUID isn't recognized as a gamepad.
---
---The mapping string contains binding information used to map the Joystick's buttons an axes to the standard gamepad layout, and can be used later with love.joystick.loadGamepadMappings.
---
---[Open in Browser](https://love2d.org/wiki/love.joystick.getGamepadMappingString)
---
---@param guid string # The GUID value to get the mapping string for.
---@return string
function love.joystick.getGamepadMappingString(guid) end

---Gets the number of connected joysticks.
---
---[Open in Browser](https://love2d.org/wiki/love.joystick.getJoystickCount)
---
---@return number
function love.joystick.getJoystickCount() end

---Gets a list of connected Joysticks.
---
---[Open in Browser](https://love2d.org/wiki/love.joystick.getJoysticks)
---
---@return table
function love.joystick.getJoysticks() end

---Loads a gamepad mappings string or file created with love.joystick.saveGamepadMappings.
---
---It also recognizes any SDL gamecontroller mapping string, such as those created with Steam's Big Picture controller configure interface, or this nice database. If a new mapping is loaded for an already known controller GUID, the later version will overwrite the one currently loaded.
---
---[Open in Browser](https://love2d.org/wiki/love.joystick.loadGamepadMappings)
---
---@param filename string # The filename to load the mappings string from.
---
---Loads a gamepad mappings string directly.
---@overload fun(mappings:string):nil
function love.joystick.loadGamepadMappings(filename) end

---Saves the virtual gamepad mappings of all recognized as gamepads and have either been recently used or their gamepad bindings have been modified.
---
---The mappings are stored as a string for use with love.joystick.loadGamepadMappings.
---
---[Open in Browser](https://love2d.org/wiki/love.joystick.saveGamepadMappings)
---
---@param filename string # The filename to save the mappings string to.
---@return string
---
---Returns the mappings string without writing to a file.
---@overload fun():string
function love.joystick.saveGamepadMappings(filename) end

---Binds a virtual gamepad input to a button, axis or hat for all Joysticks of a certain type. For example, if this function is used with a GUID returned by a Dualshock 3 controller in OS X, the binding will affect Joystick:getGamepadAxis and Joystick:isGamepadDown for ''all'' Dualshock 3 controllers used with the game when run in OS X.
---
---LÖVE includes built-in gamepad bindings for many common controllers. This function lets you change the bindings or add new ones for types of Joysticks which aren't recognized as gamepads by default.
---
---The virtual gamepad buttons and axes are designed around the Xbox 360 controller layout.
---
---[Open in Browser](https://love2d.org/wiki/love.joystick.setGamepadMapping)
---
---@param guid string # The OS-dependent GUID for the type of Joystick the binding will affect.
---@param button love.GamepadButton # The virtual gamepad button to bind.
---@param inputtype love.JoystickInputType # The type of input to bind the virtual gamepad button to.
---@param inputindex number # The index of the axis, button, or hat to bind the virtual gamepad button to.
---@param hatdir love.JoystickHat? # The direction of the hat, if the virtual gamepad button will be bound to a hat. nil otherwise. (Defaults to nil.)
---@return boolean
---
---The physical locations for the bound gamepad axes and buttons should correspond as closely as possible to the layout of a standard Xbox 360 controller.
---@overload fun(guid:string, axis:love.GamepadAxis, inputtype:love.JoystickInputType, inputindex:number, hatdir:love.JoystickHat?):boolean
function love.joystick.setGamepadMapping(guid, button, inputtype, inputindex, hatdir) end

