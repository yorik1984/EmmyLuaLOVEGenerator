---@meta
---@namespace love

---Provides an interface to the user's mouse.
love.mouse = {}

--region Cursor

---Represents a hardware cursor.
---
---[Open in Browser](https://love2d.org/wiki/Cursor)
---
---@class Cursor : Object
local Cursor = {}
---Gets the type of the Cursor.
---
---[Open in Browser](https://love2d.org/wiki/Cursor.getType)
---
---@return love.CursorType
function Cursor:getType() end

--endregion Cursor

---Types of hardware cursors.
---
---[Open in Browser](https://love2d.org/wiki/CursorType)
---
---@alias CursorType
---| "image" -- The cursor is using a custom image.
---| "arrow" -- An arrow pointer.
---| "ibeam" -- An I-beam, normally used when mousing over editable or selectable text.
---| "wait" -- Wait graphic.
---| "waitarrow" -- Small wait cursor with an arrow pointer.
---| "crosshair" -- Crosshair symbol.
---| "sizenwse" -- Double arrow pointing to the top-left and bottom-right.
---| "sizenesw" -- Double arrow pointing to the top-right and bottom-left.
---| "sizewe" -- Double arrow pointing left and right.
---| "sizens" -- Double arrow pointing up and down.
---| "sizeall" -- Four-pointed arrow pointing up, down, left, and right.
---| "no" -- Slashed circle or crossbones.
---| "hand" -- Hand symbol.

---Gets the current Cursor.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.getCursor)
---
---@return love.Cursor
function love.mouse.getCursor() end

---Returns the current position of the mouse.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.getPosition)
---
---@return number, number
function love.mouse.getPosition() end

---Gets whether relative mode is enabled for the mouse.
---
---If relative mode is enabled, the cursor is hidden and doesn't move when the mouse does, but relative mouse motion events are still generated via love.mousemoved. This lets the mouse move in any direction indefinitely without the cursor getting stuck at the edges of the screen.
---
---The reported position of the mouse is not updated while relative mode is enabled, even when relative mouse motion events are generated.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.getRelativeMode)
---
---@return boolean
function love.mouse.getRelativeMode() end

---Gets a Cursor object representing a system-native hardware cursor.
---
---Hardware cursors are framerate-independent and work the same way as normal operating system cursors. Unlike drawing an image at the mouse's current coordinates, hardware cursors never have visible lag between when the mouse is moved and when the cursor position updates, even at low framerates.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.getSystemCursor)
---
---@param ctype love.CursorType # The type of system cursor to get. 
---@return love.Cursor
function love.mouse.getSystemCursor(ctype) end

---Returns the current x-position of the mouse.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.getX)
---
---@return number
function love.mouse.getX() end

---Returns the current y-position of the mouse.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.getY)
---
---@return number
function love.mouse.getY() end

---Gets whether cursor functionality is supported.
---
---If it isn't supported, calling love.mouse.newCursor and love.mouse.getSystemCursor will cause an error. Mobile devices do not support cursors.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.isCursorSupported)
---
---@return boolean
function love.mouse.isCursorSupported() end

---Checks whether a certain mouse button is down.
---
---This function does not detect mouse wheel scrolling; you must use the love.wheelmoved (or love.mousepressed in version 0.9.2 and older) callback for that. 
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.isDown)
---
---@param button number # The index of a button to check. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependant.
---@vararg number # Additional button numbers to check.
---@return boolean
function love.mouse.isDown(button, ...) end

---Checks if the mouse is grabbed.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.isGrabbed)
---
---@return boolean
function love.mouse.isGrabbed() end

---Checks if the cursor is visible.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.isVisible)
---
---@return boolean
function love.mouse.isVisible() end

---Creates a new hardware Cursor object from an image file or ImageData.
---
---Hardware cursors are framerate-independent and work the same way as normal operating system cursors. Unlike drawing an image at the mouse's current coordinates, hardware cursors never have visible lag between when the mouse is moved and when the cursor position updates, even at low framerates.
---
---The hot spot is the point the operating system uses to determine what was clicked and at what position the mouse cursor is. For example, the normal arrow pointer normally has its hot spot at the top left of the image, but a crosshair cursor might have it in the middle.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.newCursor)
---
---@param imageData love.ImageData # The ImageData to use for the new Cursor.
---@param hotx number? # The x-coordinate in the ImageData of the cursor's hot spot. (Defaults to 0.)
---@param hoty number? # The y-coordinate in the ImageData of the cursor's hot spot. (Defaults to 0.)
---@return love.Cursor
---@overload fun(filename:string, hotx:number?, hoty:number?):love.Cursor
---@overload fun(fileData:love.FileData, hotx:number?, hoty:number?):love.Cursor
function love.mouse.newCursor(imageData, hotx, hoty) end

---Sets the current mouse cursor.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setCursor)
---
---@param cursor love.Cursor # The Cursor object to use as the current mouse cursor.
---
---Resets the current mouse cursor to the default.
---@overload fun():nil
function love.mouse.setCursor(cursor) end

---Grabs the mouse and confines it to the window.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setGrabbed)
---
---@param grab boolean # True to confine the mouse, false to let it leave the window.
function love.mouse.setGrabbed(grab) end

---Sets the current position of the mouse. Non-integer values are floored.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setPosition)
---
---@param x number # The new position of the mouse along the x-axis.
---@param y number # The new position of the mouse along the y-axis.
function love.mouse.setPosition(x, y) end

---Sets whether relative mode is enabled for the mouse.
---
---When relative mode is enabled, the cursor is hidden and doesn't move when the mouse does, but relative mouse motion events are still generated via love.mousemoved. This lets the mouse move in any direction indefinitely without the cursor getting stuck at the edges of the screen.
---
---The reported position of the mouse may not be updated while relative mode is enabled, even when relative mouse motion events are generated.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setRelativeMode)
---
---@param enable boolean # True to enable relative mode, false to disable it.
function love.mouse.setRelativeMode(enable) end

---Sets the current visibility of the cursor.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setVisible)
---
---@param visible boolean # True to set the cursor to visible, false to hide the cursor.
function love.mouse.setVisible(visible) end

---Sets the current X position of the mouse.
---
---Non-integer values are floored.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setX)
---
---@param x number # The new position of the mouse along the x-axis.
function love.mouse.setX(x) end

---Sets the current Y position of the mouse.
---
---Non-integer values are floored.
---
---[Open in Browser](https://love2d.org/wiki/love.mouse.setY)
---
---@param y number # The new position of the mouse along the y-axis.
function love.mouse.setY(y) end

