---@meta
---@namespace love

---Provides an interface to the user's clock.
love.timer = {}

---Returns the average delta time (seconds per frame) over the last second.
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getAverageDelta)
---
---@return number
function love.timer.getAverageDelta() end

---Returns the time between the last two frames.
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getDelta)
---
---@return number
function love.timer.getDelta() end

---Returns the current frames per second.
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getFPS)
---
---@return number
function love.timer.getFPS() end

---Returns the value of a timer with an unspecified starting time.
---
---This function should only be used to calculate differences between points in time, as the starting time of the timer is unknown.
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getTime)
---
---@return number
function love.timer.getTime() end

---Pauses the current thread for the specified amount of time.
---
---[Open in Browser](https://love2d.org/wiki/love.timer.sleep)
---
---@param s number # Seconds to sleep for.
function love.timer.sleep(s) end

---Measures the time between two frames.
---
---Calling this changes the return value of love.timer.getDelta.
---
---[Open in Browser](https://love2d.org/wiki/love.timer.step)
---
---@return number
function love.timer.step() end

