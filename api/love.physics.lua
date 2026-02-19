---@meta
---@namespace love

---Can simulate 2D rigid body physics in a realistic manner. This module is based on Box2D, and this API corresponds to the Box2D API as closely as possible.
love.physics = {}

--region Body

---Bodies are objects with velocity and position.
---
---[Open in Browser](https://love2d.org/wiki/Body)
---
---@class Body : Object
local Body = {}
---Applies an angular impulse to a body. This makes a single, instantaneous addition to the body momentum.
---
---A body with with a larger mass will react less. The reaction does '''not''' depend on the timestep, and is equivalent to applying a force continuously for 1 second. Impulses are best used to give a single push to a body. For a continuous push to a body it is better to use Body:applyForce.
---
---[Open in Browser](https://love2d.org/wiki/Body.applyAngularImpulse)
---
---@param impulse number # The impulse in kilogram-square meter per second.
function Body:applyAngularImpulse(impulse) end

---Apply force to a Body.
---
---A force pushes a body in a direction. A body with with a larger mass will react less. The reaction also depends on how long a force is applied: since the force acts continuously over the entire timestep, a short timestep will only push the body for a short time. Thus forces are best used for many timesteps to give a continuous push to a body (like gravity). For a single push that is independent of timestep, it is better to use Body:applyLinearImpulse.
---
---If the position to apply the force is not given, it will act on the center of mass of the body. The part of the force not directed towards the center of mass will cause the body to spin (and depends on the rotational inertia).
---
---Note that the force components and position must be given in world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.applyForce)
---
---@param fx number # The x component of force to apply.
---@param fy number # The y component of force to apply.
---@param x number # The x position to apply the force.
---@param y number # The y position to apply the force.
---@overload fun(self:Body, fx:number, fy:number):nil
function Body:applyForce(fx, fy, x, y) end

---Applies an impulse to a body.
---
---This makes a single, instantaneous addition to the body momentum.
---
---An impulse pushes a body in a direction. A body with with a larger mass will react less. The reaction does '''not''' depend on the timestep, and is equivalent to applying a force continuously for 1 second. Impulses are best used to give a single push to a body. For a continuous push to a body it is better to use Body:applyForce.
---
---If the position to apply the impulse is not given, it will act on the center of mass of the body. The part of the impulse not directed towards the center of mass will cause the body to spin (and depends on the rotational inertia). 
---
---Note that the impulse components and position must be given in world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.applyLinearImpulse)
---
---@param ix number # The x component of the impulse.
---@param iy number # The y component of the impulse.
---@param x number # The x position to apply the impulse.
---@param y number # The y position to apply the impulse.
---@overload fun(self:Body, ix:number, iy:number):nil
function Body:applyLinearImpulse(ix, iy, x, y) end

---Apply torque to a body.
---
---Torque is like a force that will change the angular velocity (spin) of a body. The effect will depend on the rotational inertia a body has.
---
---[Open in Browser](https://love2d.org/wiki/Body.applyTorque)
---
---@param torque number # The torque to apply.
function Body:applyTorque(torque) end

---Explicitly destroys the Body and all fixtures and joints attached to it.
---
---An error will occur if you attempt to use the object after calling this function. In 0.7.2, when you don't have time to wait for garbage collection, this function may be used to free the object immediately.
---
---[Open in Browser](https://love2d.org/wiki/Body.destroy)
---
function Body:destroy() end

---Get the angle of the body.
---
---The angle is measured in radians. If you need to transform it to degrees, use math.deg.
---
---A value of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes ''clockwise'' from our point of view.
---
---[Open in Browser](https://love2d.org/wiki/Body.getAngle)
---
---@return number
function Body:getAngle() end

---Gets the Angular damping of the Body
---
---The angular damping is the ''rate of decrease of the angular velocity over time'': A spinning body with no damping and no external forces will continue spinning indefinitely. A spinning body with damping will gradually stop spinning.
---
---Damping is not the same as friction - they can be modelled together. However, only damping is provided by Box2D (and LOVE).
---
---Damping parameters should be between 0 and infinity, with 0 meaning no damping, and infinity meaning full damping. Normally you will use a damping value between 0 and 0.1.
---
---[Open in Browser](https://love2d.org/wiki/Body.getAngularDamping)
---
---@return number
function Body:getAngularDamping() end

---Get the angular velocity of the Body.
---
---The angular velocity is the ''rate of change of angle over time''.
---
---It is changed in World:update by applying torques, off centre forces/impulses, and angular damping. It can be set directly with Body:setAngularVelocity.
---
---If you need the ''rate of change of position over time'', use Body:getLinearVelocity.
---
---[Open in Browser](https://love2d.org/wiki/Body.getAngularVelocity)
---
---@return number
function Body:getAngularVelocity() end

---Gets a list of all Contacts attached to the Body.
---
---[Open in Browser](https://love2d.org/wiki/Body.getContacts)
---
---@return table
function Body:getContacts() end

---Returns a table with all fixtures.
---
---[Open in Browser](https://love2d.org/wiki/Body.getFixtures)
---
---@return table
function Body:getFixtures() end

---Returns the gravity scale factor.
---
---[Open in Browser](https://love2d.org/wiki/Body.getGravityScale)
---
---@return number
function Body:getGravityScale() end

---Gets the rotational inertia of the body.
---
---The rotational inertia is how hard is it to make the body spin.
---
---[Open in Browser](https://love2d.org/wiki/Body.getInertia)
---
---@return number
function Body:getInertia() end

---Returns a table containing the Joints attached to this Body.
---
---[Open in Browser](https://love2d.org/wiki/Body.getJoints)
---
---@return table
function Body:getJoints() end

---Gets the linear damping of the Body.
---
---The linear damping is the ''rate of decrease of the linear velocity over time''. A moving body with no damping and no external forces will continue moving indefinitely, as is the case in space. A moving body with damping will gradually stop moving.
---
---Damping is not the same as friction - they can be modelled together.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLinearDamping)
---
---@return number
function Body:getLinearDamping() end

---Gets the linear velocity of the Body from its center of mass.
---
---The linear velocity is the ''rate of change of position over time''.
---
---If you need the ''rate of change of angle over time'', use Body:getAngularVelocity.
---
---If you need to get the linear velocity of a point different from the center of mass:
---
---*  Body:getLinearVelocityFromLocalPoint allows you to specify the point in local coordinates.
---
---*  Body:getLinearVelocityFromWorldPoint allows you to specify the point in world coordinates.
---
---See page 136 of 'Essential Mathematics for Games and Interactive Applications' for definitions of local and world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLinearVelocity)
---
---@return number, number
function Body:getLinearVelocity() end

---Get the linear velocity of a point on the body.
---
---The linear velocity for a point on the body is the velocity of the body center of mass plus the velocity at that point from the body spinning.
---
---The point on the body must given in local coordinates. Use Body:getLinearVelocityFromWorldPoint to specify this with world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLinearVelocityFromLocalPoint)
---
---@param x number # The x position to measure velocity.
---@param y number # The y position to measure velocity.
---@return number, number
function Body:getLinearVelocityFromLocalPoint(x, y) end

---Get the linear velocity of a point on the body.
---
---The linear velocity for a point on the body is the velocity of the body center of mass plus the velocity at that point from the body spinning.
---
---The point on the body must given in world coordinates. Use Body:getLinearVelocityFromLocalPoint to specify this with local coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLinearVelocityFromWorldPoint)
---
---@param x number # The x position to measure velocity.
---@param y number # The y position to measure velocity.
---@return number, number
function Body:getLinearVelocityFromWorldPoint(x, y) end

---Get the center of mass position in local coordinates.
---
---Use Body:getWorldCenter to get the center of mass in world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLocalCenter)
---
---@return number, number
function Body:getLocalCenter() end

---Transform a point from world coordinates to local coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLocalPoint)
---
---@param worldX number # The x position in world coordinates.
---@param worldY number # The y position in world coordinates.
---@return number, number
function Body:getLocalPoint(worldX, worldY) end

---Transforms multiple points from world coordinates to local coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLocalPoints)
---
---@param x1 number # (Argument) The x position of the first point.
---@param y1 number # (Argument) The y position of the first point.
---@param x2 number # (Argument) The x position of the second point.
---@param y2 number # (Argument) The y position of the second point.
---@vararg number # (Argument) You can continue passing x and y position of the points.
---@return number, number, number, number, number
function Body:getLocalPoints(x1, y1, x2, y2, ...) end

---Transform a vector from world coordinates to local coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getLocalVector)
---
---@param worldX number # The vector x component in world coordinates.
---@param worldY number # The vector y component in world coordinates.
---@return number, number
function Body:getLocalVector(worldX, worldY) end

---Get the mass of the body.
---
---Static bodies always have a mass of 0.
---
---[Open in Browser](https://love2d.org/wiki/Body.getMass)
---
---@return number
function Body:getMass() end

---Returns the mass, its center, and the rotational inertia.
---
---[Open in Browser](https://love2d.org/wiki/Body.getMassData)
---
---@return number, number, number, number
function Body:getMassData() end

---Get the position of the body.
---
---Note that this may not be the center of mass of the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.getPosition)
---
---@return number, number
function Body:getPosition() end

---Get the position and angle of the body.
---
---Note that the position may not be the center of mass of the body. An angle of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes clockwise from our point of view.
---
---[Open in Browser](https://love2d.org/wiki/Body.getTransform)
---
---@return number, number, number
function Body:getTransform() end

---Returns the type of the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.getType)
---
---@return love.BodyType
function Body:getType() end

---Returns the Lua value associated with this Body.
---
---[Open in Browser](https://love2d.org/wiki/Body.getUserData)
---
---@return any
function Body:getUserData() end

---Gets the World the body lives in.
---
---[Open in Browser](https://love2d.org/wiki/Body.getWorld)
---
---@return love.World
function Body:getWorld() end

---Get the center of mass position in world coordinates.
---
---Use Body:getLocalCenter to get the center of mass in local coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getWorldCenter)
---
---@return number, number
function Body:getWorldCenter() end

---Transform a point from local coordinates to world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getWorldPoint)
---
---@param localX number # The x position in local coordinates.
---@param localY number # The y position in local coordinates.
---@return number, number
function Body:getWorldPoint(localX, localY) end

---Transforms multiple points from local coordinates to world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getWorldPoints)
---
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@return number, number, number, number
function Body:getWorldPoints(x1, y1, x2, y2) end

---Transform a vector from local coordinates to world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getWorldVector)
---
---@param localX number # The vector x component in local coordinates.
---@param localY number # The vector y component in local coordinates.
---@return number, number
function Body:getWorldVector(localX, localY) end

---Get the x position of the body in world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getX)
---
---@return number
function Body:getX() end

---Get the y position of the body in world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/Body.getY)
---
---@return number
function Body:getY() end

---Returns whether the body is actively used in the simulation.
---
---[Open in Browser](https://love2d.org/wiki/Body.isActive)
---
---@return boolean
function Body:isActive() end

---Returns the sleep status of the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.isAwake)
---
---@return boolean
function Body:isAwake() end

---Get the bullet status of a body.
---
---There are two methods to check for body collisions:
---
---*  at their location when the world is updated (default)
---
---*  using continuous collision detection (CCD)
---
---The default method is efficient, but a body moving very quickly may sometimes jump over another body without producing a collision. A body that is set as a bullet will use CCD. This is less efficient, but is guaranteed not to jump when moving quickly.
---
---Note that static bodies (with zero mass) always use CCD, so your walls will not let a fast moving body pass through even if it is not a bullet.
---
---[Open in Browser](https://love2d.org/wiki/Body.isBullet)
---
---@return boolean
function Body:isBullet() end

---Gets whether the Body is destroyed. Destroyed bodies cannot be used.
---
---[Open in Browser](https://love2d.org/wiki/Body.isDestroyed)
---
---@return boolean
function Body:isDestroyed() end

---Returns whether the body rotation is locked.
---
---[Open in Browser](https://love2d.org/wiki/Body.isFixedRotation)
---
---@return boolean
function Body:isFixedRotation() end

---Returns the sleeping behaviour of the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.isSleepingAllowed)
---
---@return boolean
function Body:isSleepingAllowed() end

---Gets whether the Body is touching the given other Body.
---
---[Open in Browser](https://love2d.org/wiki/Body.isTouching)
---
---@param otherbody love.Body # The other body to check.
---@return boolean
function Body:isTouching(otherbody) end

---Resets the mass of the body by recalculating it from the mass properties of the fixtures.
---
---[Open in Browser](https://love2d.org/wiki/Body.resetMassData)
---
function Body:resetMassData() end

---Sets whether the body is active in the world.
---
---An inactive body does not take part in the simulation. It will not move or cause any collisions.
---
---[Open in Browser](https://love2d.org/wiki/Body.setActive)
---
---@param active boolean # If the body is active or not.
function Body:setActive(active) end

---Set the angle of the body.
---
---The angle is measured in radians. If you need to transform it from degrees, use math.rad.
---
---A value of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes ''clockwise'' from our point of view.
---
---It is possible to cause a collision with another body by changing its angle. 
---
---[Open in Browser](https://love2d.org/wiki/Body.setAngle)
---
---@param angle number # The angle in radians.
function Body:setAngle(angle) end

---Sets the angular damping of a Body
---
---See Body:getAngularDamping for a definition of angular damping.
---
---Angular damping can take any value from 0 to infinity. It is recommended to stay between 0 and 0.1, though. Other values will look unrealistic.
---
---[Open in Browser](https://love2d.org/wiki/Body.setAngularDamping)
---
---@param damping number # The new angular damping.
function Body:setAngularDamping(damping) end

---Sets the angular velocity of a Body.
---
---The angular velocity is the ''rate of change of angle over time''.
---
---This function will not accumulate anything; any impulses previously applied since the last call to World:update will be lost. 
---
---[Open in Browser](https://love2d.org/wiki/Body.setAngularVelocity)
---
---@param w number # The new angular velocity, in radians per second
function Body:setAngularVelocity(w) end

---Wakes the body up or puts it to sleep.
---
---[Open in Browser](https://love2d.org/wiki/Body.setAwake)
---
---@param awake boolean # The body sleep status.
function Body:setAwake(awake) end

---Set the bullet status of a body.
---
---There are two methods to check for body collisions:
---
---*  at their location when the world is updated (default)
---
---*  using continuous collision detection (CCD)
---
---The default method is efficient, but a body moving very quickly may sometimes jump over another body without producing a collision. A body that is set as a bullet will use CCD. This is less efficient, but is guaranteed not to jump when moving quickly.
---
---Note that static bodies (with zero mass) always use CCD, so your walls will not let a fast moving body pass through even if it is not a bullet.
---
---[Open in Browser](https://love2d.org/wiki/Body.setBullet)
---
---@param status boolean # The bullet status of the body.
function Body:setBullet(status) end

---Set whether a body has fixed rotation.
---
---Bodies with fixed rotation don't vary the speed at which they rotate. Calling this function causes the mass to be reset. 
---
---[Open in Browser](https://love2d.org/wiki/Body.setFixedRotation)
---
---@param isFixed boolean # Whether the body should have fixed rotation.
function Body:setFixedRotation(isFixed) end

---Sets a new gravity scale factor for the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.setGravityScale)
---
---@param scale number # The new gravity scale factor.
function Body:setGravityScale(scale) end

---Set the inertia of a body.
---
---[Open in Browser](https://love2d.org/wiki/Body.setInertia)
---
---@param inertia number # The new moment of inertia, in kilograms * pixel squared.
function Body:setInertia(inertia) end

---Sets the linear damping of a Body
---
---See Body:getLinearDamping for a definition of linear damping.
---
---Linear damping can take any value from 0 to infinity. It is recommended to stay between 0 and 0.1, though. Other values will make the objects look 'floaty'(if gravity is enabled).
---
---[Open in Browser](https://love2d.org/wiki/Body.setLinearDamping)
---
---@param ld number # The new linear damping
function Body:setLinearDamping(ld) end

---Sets a new linear velocity for the Body.
---
---This function will not accumulate anything; any impulses previously applied since the last call to World:update will be lost.
---
---[Open in Browser](https://love2d.org/wiki/Body.setLinearVelocity)
---
---@param x number # The x-component of the velocity vector.
---@param y number # The y-component of the velocity vector.
function Body:setLinearVelocity(x, y) end

---Sets a new body mass.
---
---[Open in Browser](https://love2d.org/wiki/Body.setMass)
---
---@param mass number # The mass, in kilograms.
function Body:setMass(mass) end

---Overrides the calculated mass data.
---
---[Open in Browser](https://love2d.org/wiki/Body.setMassData)
---
---@param x number # The x position of the center of mass.
---@param y number # The y position of the center of mass.
---@param mass number # The mass of the body.
---@param inertia number # The rotational inertia.
function Body:setMassData(x, y, mass, inertia) end

---Set the position of the body.
---
---Note that this may not be the center of mass of the body.
---
---This function cannot wake up the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.setPosition)
---
---@param x number # The x position.
---@param y number # The y position.
function Body:setPosition(x, y) end

---Sets the sleeping behaviour of the body. Should sleeping be allowed, a body at rest will automatically sleep. A sleeping body is not simulated unless it collided with an awake body. Be wary that one can end up with a situation like a floating sleeping body if the floor was removed.
---
---[Open in Browser](https://love2d.org/wiki/Body.setSleepingAllowed)
---
---@param allowed boolean # True if the body is allowed to sleep or false if not.
function Body:setSleepingAllowed(allowed) end

---Set the position and angle of the body.
---
---Note that the position may not be the center of mass of the body. An angle of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes clockwise from our point of view.
---
---This function cannot wake up the body.
---
---[Open in Browser](https://love2d.org/wiki/Body.setTransform)
---
---@param x number # The x component of the position.
---@param y number # The y component of the position.
---@param angle number # The angle in radians.
function Body:setTransform(x, y, angle) end

---Sets a new body type.
---
---[Open in Browser](https://love2d.org/wiki/Body.setType)
---
---@param type love.BodyType # The new type.
function Body:setType(type) end

---Associates a Lua value with the Body.
---
---To delete the reference, explicitly pass nil.
---
---[Open in Browser](https://love2d.org/wiki/Body.setUserData)
---
---@param value any # The Lua value to associate with the Body.
function Body:setUserData(value) end

---Set the x position of the body.
---
---This function cannot wake up the body. 
---
---[Open in Browser](https://love2d.org/wiki/Body.setX)
---
---@param x number # The x position.
function Body:setX(x) end

---Set the y position of the body.
---
---This function cannot wake up the body. 
---
---[Open in Browser](https://love2d.org/wiki/Body.setY)
---
---@param y number # The y position.
function Body:setY(y) end

--endregion Body

--region ChainShape

---A ChainShape consists of multiple line segments. It can be used to create the boundaries of your terrain. The shape does not have volume and can only collide with PolygonShape and CircleShape.
---
---Unlike the PolygonShape, the ChainShape does not have a vertices limit or has to form a convex shape, but self intersections are not supported.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape)
---
---@class ChainShape : Shape, Object
local ChainShape = {}
---Returns a child of the shape as an EdgeShape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.getChildEdge)
---
---@param index number # The index of the child.
---@return love.EdgeShape
function ChainShape:getChildEdge(index) end

---Gets the vertex that establishes a connection to the next shape.
---
---Setting next and previous ChainShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.getNextVertex)
---
---@return number, number
function ChainShape:getNextVertex() end

---Returns a point of the shape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.getPoint)
---
---@param index number # The index of the point to return.
---@return number, number
function ChainShape:getPoint(index) end

---Returns all points of the shape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.getPoints)
---
---@return number, number, number, number
function ChainShape:getPoints() end

---Gets the vertex that establishes a connection to the previous shape.
---
---Setting next and previous ChainShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.getPreviousVertex)
---
---@return number, number
function ChainShape:getPreviousVertex() end

---Returns the number of vertices the shape has.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.getVertexCount)
---
---@return number
function ChainShape:getVertexCount() end

---Sets a vertex that establishes a connection to the next shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.setNextVertex)
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function ChainShape:setNextVertex(x, y) end

---Sets a vertex that establishes a connection to the previous shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/ChainShape.setPreviousVertex)
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function ChainShape:setPreviousVertex(x, y) end

--endregion ChainShape

--region CircleShape

---Circle extends Shape and adds a radius and a local position.
---
---[Open in Browser](https://love2d.org/wiki/CircleShape)
---
---@class CircleShape : Shape, Object
local CircleShape = {}
---Gets the center point of the circle shape.
---
---[Open in Browser](https://love2d.org/wiki/CircleShape.getPoint)
---
---@return number, number
function CircleShape:getPoint() end

---Gets the radius of the circle shape.
---
---[Open in Browser](https://love2d.org/wiki/CircleShape.getRadius)
---
---@return number
function CircleShape:getRadius() end

---Sets the location of the center of the circle shape.
---
---[Open in Browser](https://love2d.org/wiki/CircleShape.setPoint)
---
---@param x number # The x-component of the new center point of the circle.
---@param y number # The y-component of the new center point of the circle.
function CircleShape:setPoint(x, y) end

---Sets the radius of the circle.
---
---[Open in Browser](https://love2d.org/wiki/CircleShape.setRadius)
---
---@param radius number # The radius of the circle
function CircleShape:setRadius(radius) end

--endregion CircleShape

--region Contact

---Contacts are objects created to manage collisions in worlds.
---
---[Open in Browser](https://love2d.org/wiki/Contact)
---
---@class Contact : Object
local Contact = {}
---Gets the child indices of the shapes of the two colliding fixtures. For ChainShapes, an index of 1 is the first edge in the chain.
---Used together with Fixture:rayCast or ChainShape:getChildEdge.
---
---[Open in Browser](https://love2d.org/wiki/Contact.getChildren)
---
---@return number, number
function Contact:getChildren() end

---Gets the two Fixtures that hold the shapes that are in contact.
---
---[Open in Browser](https://love2d.org/wiki/Contact.getFixtures)
---
---@return love.Fixture, love.Fixture
function Contact:getFixtures() end

---Get the friction between two shapes that are in contact.
---
---[Open in Browser](https://love2d.org/wiki/Contact.getFriction)
---
---@return number
function Contact:getFriction() end

---Get the normal vector between two shapes that are in contact.
---
---This function returns the coordinates of a unit vector that points from the first shape to the second.
---
---[Open in Browser](https://love2d.org/wiki/Contact.getNormal)
---
---@return number, number
function Contact:getNormal() end

---Returns the contact points of the two colliding fixtures. There can be one or two points.
---
---[Open in Browser](https://love2d.org/wiki/Contact.getPositions)
---
---@return number, number, number, number
function Contact:getPositions() end

---Get the restitution between two shapes that are in contact.
---
---[Open in Browser](https://love2d.org/wiki/Contact.getRestitution)
---
---@return number
function Contact:getRestitution() end

---Returns whether the contact is enabled. The collision will be ignored if a contact gets disabled in the preSolve callback.
---
---[Open in Browser](https://love2d.org/wiki/Contact.isEnabled)
---
---@return boolean
function Contact:isEnabled() end

---Returns whether the two colliding fixtures are touching each other.
---
---[Open in Browser](https://love2d.org/wiki/Contact.isTouching)
---
---@return boolean
function Contact:isTouching() end

---Resets the contact friction to the mixture value of both fixtures.
---
---[Open in Browser](https://love2d.org/wiki/Contact.resetFriction)
---
function Contact:resetFriction() end

---Resets the contact restitution to the mixture value of both fixtures.
---
---[Open in Browser](https://love2d.org/wiki/Contact.resetRestitution)
---
function Contact:resetRestitution() end

---Enables or disables the contact.
---
---[Open in Browser](https://love2d.org/wiki/Contact.setEnabled)
---
---@param enabled boolean # True to enable or false to disable.
function Contact:setEnabled(enabled) end

---Sets the contact friction.
---
---[Open in Browser](https://love2d.org/wiki/Contact.setFriction)
---
---@param friction number # The contact friction.
function Contact:setFriction(friction) end

---Sets the contact restitution.
---
---[Open in Browser](https://love2d.org/wiki/Contact.setRestitution)
---
---@param restitution number # The contact restitution.
function Contact:setRestitution(restitution) end

--endregion Contact

--region DistanceJoint

---Keeps two bodies at the same distance.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint)
---
---@class DistanceJoint : Joint, Object
local DistanceJoint = {}
---Gets the damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint.getDampingRatio)
---
---@return number
function DistanceJoint:getDampingRatio() end

---Gets the response speed.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint.getFrequency)
---
---@return number
function DistanceJoint:getFrequency() end

---Gets the equilibrium distance between the two Bodies.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint.getLength)
---
---@return number
function DistanceJoint:getLength() end

---Sets the damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint.setDampingRatio)
---
---@param ratio number # The damping ratio.
function DistanceJoint:setDampingRatio(ratio) end

---Sets the response speed.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint.setFrequency)
---
---@param Hz number # The response speed.
function DistanceJoint:setFrequency(Hz) end

---Sets the equilibrium distance between the two Bodies.
---
---[Open in Browser](https://love2d.org/wiki/DistanceJoint.setLength)
---
---@param l number # The length between the two Bodies.
function DistanceJoint:setLength(l) end

--endregion DistanceJoint

--region EdgeShape

---A EdgeShape is a line segment. They can be used to create the boundaries of your terrain. The shape does not have volume and can only collide with PolygonShape and CircleShape.
---
---[Open in Browser](https://love2d.org/wiki/EdgeShape)
---
---@class EdgeShape : Shape, Object
local EdgeShape = {}
---Gets the vertex that establishes a connection to the next shape.
---
---Setting next and previous EdgeShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/EdgeShape.getNextVertex)
---
---@return number, number
function EdgeShape:getNextVertex() end

---Returns the local coordinates of the edge points.
---
---[Open in Browser](https://love2d.org/wiki/EdgeShape.getPoints)
---
---@return number, number, number, number
function EdgeShape:getPoints() end

---Gets the vertex that establishes a connection to the previous shape.
---
---Setting next and previous EdgeShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/EdgeShape.getPreviousVertex)
---
---@return number, number
function EdgeShape:getPreviousVertex() end

---Sets a vertex that establishes a connection to the next shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/EdgeShape.setNextVertex)
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function EdgeShape:setNextVertex(x, y) end

---Sets a vertex that establishes a connection to the previous shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---[Open in Browser](https://love2d.org/wiki/EdgeShape.setPreviousVertex)
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function EdgeShape:setPreviousVertex(x, y) end

--endregion EdgeShape

--region Fixture

---Fixtures attach shapes to bodies.
---
---[Open in Browser](https://love2d.org/wiki/Fixture)
---
---@class Fixture : Object
local Fixture = {}
---Destroys the fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.destroy)
---
function Fixture:destroy() end

---Returns the body to which the fixture is attached.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getBody)
---
---@return love.Body
function Fixture:getBody() end

---Returns the points of the fixture bounding box. In case the fixture has multiple children a 1-based index can be specified. For example, a fixture will have multiple children with a chain shape.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getBoundingBox)
---
---@param index number? # A bounding box of the fixture. (Defaults to 1.)
---@return number, number, number, number
function Fixture:getBoundingBox(index) end

---Returns the categories the fixture belongs to.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getCategory)
---
---@return number
function Fixture:getCategory() end

---Returns the density of the fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getDensity)
---
---@return number
function Fixture:getDensity() end

---Returns the filter data of the fixture.
---
---Categories and masks are encoded as the bits of a 16-bit integer.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getFilterData)
---
---@return number, number, number
function Fixture:getFilterData() end

---Returns the friction of the fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getFriction)
---
---@return number
function Fixture:getFriction() end

---Returns the group the fixture belongs to. Fixtures with the same group will always collide if the group is positive or never collide if it's negative. The group zero means no group.
---
---The groups range from -32768 to 32767.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getGroupIndex)
---
---@return number
function Fixture:getGroupIndex() end

---Returns which categories this fixture should '''NOT''' collide with.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getMask)
---
---@return number
function Fixture:getMask() end

---Returns the mass, its center and the rotational inertia.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getMassData)
---
---@return number, number, number, number
function Fixture:getMassData() end

---Returns the restitution of the fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getRestitution)
---
---@return number
function Fixture:getRestitution() end

---Returns the shape of the fixture. This shape is a reference to the actual data used in the simulation. It's possible to change its values between timesteps.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getShape)
---
---@return love.Shape
function Fixture:getShape() end

---Returns the Lua value associated with this fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.getUserData)
---
---@return any
function Fixture:getUserData() end

---Gets whether the Fixture is destroyed. Destroyed fixtures cannot be used.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.isDestroyed)
---
---@return boolean
function Fixture:isDestroyed() end

---Returns whether the fixture is a sensor.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.isSensor)
---
---@return boolean
function Fixture:isSensor() end

---Casts a ray against the shape of the fixture and returns the surface normal vector and the line position where the ray hit. If the ray missed the shape, nil will be returned.
---
---The ray starts on the first point of the input line and goes towards the second point of the line. The fifth argument is the maximum distance the ray is going to travel as a scale factor of the input line length.
---
---The childIndex parameter is used to specify which child of a parent shape, such as a ChainShape, will be ray casted. For ChainShapes, the index of 1 is the first edge on the chain. Ray casting a parent shape will only test the child specified so if you want to test every shape of the parent, you must loop through all of its children.
---
---The world position of the impact can be calculated by multiplying the line vector with the third return value and adding it to the line starting point.
---
---hitx, hity = x1 + (x2 - x1) * fraction, y1 + (y2 - y1) * fraction
---
---[Open in Browser](https://love2d.org/wiki/Fixture.rayCast)
---
---@param x1 number # The x position of the input line starting point.
---@param y1 number # The y position of the input line starting point.
---@param x2 number # The x position of the input line end point.
---@param y2 number # The y position of the input line end point.
---@param maxFraction number # Ray length parameter.
---@param childIndex number? # The index of the child the ray gets cast against. (Defaults to 1.)
---@return number, number, number
function Fixture:rayCast(x1, y1, x2, y2, maxFraction, childIndex) end

---Sets the categories the fixture belongs to. There can be up to 16 categories represented as a number from 1 to 16.
---
---All fixture's default category is 1.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setCategory)
---
---@vararg number # The categories.
function Fixture:setCategory(...) end

---Sets the density of the fixture. Call Body:resetMassData if this needs to take effect immediately.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setDensity)
---
---@param density number # The fixture density in kilograms per square meter.
function Fixture:setDensity(density) end

---Sets the filter data of the fixture.
---
---Groups, categories, and mask can be used to define the collision behaviour of the fixture.
---
---If two fixtures are in the same group they either always collide if the group is positive, or never collide if it's negative. If the group is zero or they do not match, then the contact filter checks if the fixtures select a category of the other fixture with their masks. The fixtures do not collide if that's not the case. If they do have each other's categories selected, the return value of the custom contact filter will be used. They always collide if none was set.
---
---There can be up to 16 categories. Categories and masks are encoded as the bits of a 16-bit integer.
---
---When created, prior to calling this function, all fixtures have category set to 1, mask set to 65535 (all categories) and group set to 0.
---
---This function allows setting all filter data for a fixture at once. To set only the categories, the mask or the group, you can use Fixture:setCategory, Fixture:setMask or Fixture:setGroupIndex respectively.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setFilterData)
---
---@param categories number # The categories as an integer from 0 to 65535.
---@param mask number # The mask as an integer from 0 to 65535.
---@param group number # The group as an integer from -32768 to 32767.
function Fixture:setFilterData(categories, mask, group) end

---Sets the friction of the fixture.
---
---Friction determines how shapes react when they 'slide' along other shapes. Low friction indicates a slippery surface, like ice, while high friction indicates a rough surface, like concrete. Range: 0.0 - 1.0.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setFriction)
---
---@param friction number # The fixture friction.
function Fixture:setFriction(friction) end

---Sets the group the fixture belongs to. Fixtures with the same group will always collide if the group is positive or never collide if it's negative. The group zero means no group.
---
---The groups range from -32768 to 32767.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setGroupIndex)
---
---@param group number # The group as an integer from -32768 to 32767.
function Fixture:setGroupIndex(group) end

---Sets the category mask of the fixture. There can be up to 16 categories represented as a number from 1 to 16.
---
---This fixture will '''NOT''' collide with the fixtures that are in the selected categories if the other fixture also has a category of this fixture selected.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setMask)
---
---@vararg number # The masks.
function Fixture:setMask(...) end

---Sets the restitution of the fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setRestitution)
---
---@param restitution number # The fixture restitution.
function Fixture:setRestitution(restitution) end

---Sets whether the fixture should act as a sensor.
---
---Sensors do not cause collision responses, but the begin-contact and end-contact World callbacks will still be called for this fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setSensor)
---
---@param sensor boolean # The sensor status.
function Fixture:setSensor(sensor) end

---Associates a Lua value with the fixture.
---
---To delete the reference, explicitly pass nil.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.setUserData)
---
---@param value any # The Lua value to associate with the fixture.
function Fixture:setUserData(value) end

---Checks if a point is inside the shape of the fixture.
---
---[Open in Browser](https://love2d.org/wiki/Fixture.testPoint)
---
---@param x number # The x position of the point.
---@param y number # The y position of the point.
---@return boolean
function Fixture:testPoint(x, y) end

--endregion Fixture

--region FrictionJoint

---A FrictionJoint applies friction to a body.
---
---[Open in Browser](https://love2d.org/wiki/FrictionJoint)
---
---@class FrictionJoint : Joint, Object
local FrictionJoint = {}
---Gets the maximum friction force in Newtons.
---
---[Open in Browser](https://love2d.org/wiki/FrictionJoint.getMaxForce)
---
---@return number
function FrictionJoint:getMaxForce() end

---Gets the maximum friction torque in Newton-meters.
---
---[Open in Browser](https://love2d.org/wiki/FrictionJoint.getMaxTorque)
---
---@return number
function FrictionJoint:getMaxTorque() end

---Sets the maximum friction force in Newtons.
---
---[Open in Browser](https://love2d.org/wiki/FrictionJoint.setMaxForce)
---
---@param maxForce number # Max force in Newtons.
function FrictionJoint:setMaxForce(maxForce) end

---Sets the maximum friction torque in Newton-meters.
---
---[Open in Browser](https://love2d.org/wiki/FrictionJoint.setMaxTorque)
---
---@param torque number # Maximum torque in Newton-meters.
function FrictionJoint:setMaxTorque(torque) end

--endregion FrictionJoint

--region GearJoint

---Keeps bodies together in such a way that they act like gears.
---
---[Open in Browser](https://love2d.org/wiki/GearJoint)
---
---@class GearJoint : Joint, Object
local GearJoint = {}
---Get the Joints connected by this GearJoint.
---
---[Open in Browser](https://love2d.org/wiki/GearJoint.getJoints)
---
---@return love.Joint, love.Joint
function GearJoint:getJoints() end

---Get the ratio of a gear joint.
---
---[Open in Browser](https://love2d.org/wiki/GearJoint.getRatio)
---
---@return number
function GearJoint:getRatio() end

---Set the ratio of a gear joint.
---
---[Open in Browser](https://love2d.org/wiki/GearJoint.setRatio)
---
---@param ratio number # The new ratio of the joint.
function GearJoint:setRatio(ratio) end

--endregion GearJoint

--region Joint

---Attach multiple bodies together to interact in unique ways.
---
---[Open in Browser](https://love2d.org/wiki/Joint)
---
---@class Joint : Object
local Joint = {}
---Explicitly destroys the Joint. An error will occur if you attempt to use the object after calling this function.
---
---In 0.7.2, when you don't have time to wait for garbage collection, this function 
---
---may be used to free the object immediately.
---
---[Open in Browser](https://love2d.org/wiki/Joint.destroy)
---
function Joint:destroy() end

---Get the anchor points of the joint.
---
---[Open in Browser](https://love2d.org/wiki/Joint.getAnchors)
---
---@return number, number, number, number
function Joint:getAnchors() end

---Gets the bodies that the Joint is attached to.
---
---[Open in Browser](https://love2d.org/wiki/Joint.getBodies)
---
---@return love.Body, love.Body
function Joint:getBodies() end

---Gets whether the connected Bodies collide.
---
---[Open in Browser](https://love2d.org/wiki/Joint.getCollideConnected)
---
---@return boolean
function Joint:getCollideConnected() end

---Returns the reaction force in newtons on the second body
---
---[Open in Browser](https://love2d.org/wiki/Joint.getReactionForce)
---
---@param x number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number, number
function Joint:getReactionForce(x) end

---Returns the reaction torque on the second body.
---
---[Open in Browser](https://love2d.org/wiki/Joint.getReactionTorque)
---
---@param invdt number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number
function Joint:getReactionTorque(invdt) end

---Gets a string representing the type.
---
---[Open in Browser](https://love2d.org/wiki/Joint.getType)
---
---@return love.JointType
function Joint:getType() end

---Returns the Lua value associated with this Joint.
---
---[Open in Browser](https://love2d.org/wiki/Joint.getUserData)
---
---@return any
function Joint:getUserData() end

---Gets whether the Joint is destroyed. Destroyed joints cannot be used.
---
---[Open in Browser](https://love2d.org/wiki/Joint.isDestroyed)
---
---@return boolean
function Joint:isDestroyed() end

---Associates a Lua value with the Joint.
---
---To delete the reference, explicitly pass nil.
---
---[Open in Browser](https://love2d.org/wiki/Joint.setUserData)
---
---@param value any # The Lua value to associate with the Joint.
function Joint:setUserData(value) end

--endregion Joint

--region MotorJoint

---Controls the relative motion between two Bodies. Position and rotation offsets can be specified, as well as the maximum motor force and torque that will be applied to reach the target offsets.
---
---[Open in Browser](https://love2d.org/wiki/MotorJoint)
---
---@class MotorJoint : Joint, Object
local MotorJoint = {}
---Gets the target angular offset between the two Bodies the Joint is attached to.
---
---[Open in Browser](https://love2d.org/wiki/MotorJoint.getAngularOffset)
---
---@return number
function MotorJoint:getAngularOffset() end

---Gets the target linear offset between the two Bodies the Joint is attached to.
---
---[Open in Browser](https://love2d.org/wiki/MotorJoint.getLinearOffset)
---
---@return number, number
function MotorJoint:getLinearOffset() end

---Sets the target angluar offset between the two Bodies the Joint is attached to.
---
---[Open in Browser](https://love2d.org/wiki/MotorJoint.setAngularOffset)
---
---@param angleoffset number # The target angular offset in radians: the second body's angle minus the first body's angle.
function MotorJoint:setAngularOffset(angleoffset) end

---Sets the target linear offset between the two Bodies the Joint is attached to.
---
---[Open in Browser](https://love2d.org/wiki/MotorJoint.setLinearOffset)
---
---@param x number # The x component of the target linear offset, relative to the first Body.
---@param y number # The y component of the target linear offset, relative to the first Body.
function MotorJoint:setLinearOffset(x, y) end

--endregion MotorJoint

--region MouseJoint

---For controlling objects with the mouse.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint)
---
---@class MouseJoint : Joint, Object
local MouseJoint = {}
---Returns the damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.getDampingRatio)
---
---@return number
function MouseJoint:getDampingRatio() end

---Returns the frequency.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.getFrequency)
---
---@return number
function MouseJoint:getFrequency() end

---Gets the highest allowed force.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.getMaxForce)
---
---@return number
function MouseJoint:getMaxForce() end

---Gets the target point.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.getTarget)
---
---@return number, number
function MouseJoint:getTarget() end

---Sets a new damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.setDampingRatio)
---
---@param ratio number # The new damping ratio.
function MouseJoint:setDampingRatio(ratio) end

---Sets a new frequency.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.setFrequency)
---
---@param freq number # The new frequency in hertz.
function MouseJoint:setFrequency(freq) end

---Sets the highest allowed force.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.setMaxForce)
---
---@param f number # The max allowed force.
function MouseJoint:setMaxForce(f) end

---Sets the target point.
---
---[Open in Browser](https://love2d.org/wiki/MouseJoint.setTarget)
---
---@param x number # The x-component of the target.
---@param y number # The y-component of the target.
function MouseJoint:setTarget(x, y) end

--endregion MouseJoint

--region PolygonShape

---A PolygonShape is a convex polygon with up to 8 vertices.
---
---[Open in Browser](https://love2d.org/wiki/PolygonShape)
---
---@class PolygonShape : Shape, Object
local PolygonShape = {}
---Get the local coordinates of the polygon's vertices.
---
---This function has a variable number of return values. It can be used in a nested fashion with love.graphics.polygon.
---
---[Open in Browser](https://love2d.org/wiki/PolygonShape.getPoints)
---
---@return number, number, number, number
function PolygonShape:getPoints() end

--endregion PolygonShape

--region PrismaticJoint

---Restricts relative motion between Bodies to one shared axis.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint)
---
---@class PrismaticJoint : Joint, Object
local PrismaticJoint = {}
---Checks whether the limits are enabled.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.areLimitsEnabled)
---
---@return boolean
function PrismaticJoint:areLimitsEnabled() end

---Gets the world-space axis vector of the Prismatic Joint.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getAxis)
---
---@return number, number
function PrismaticJoint:getAxis() end

---Get the current joint angle speed.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getJointSpeed)
---
---@return number
function PrismaticJoint:getJointSpeed() end

---Get the current joint translation.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getJointTranslation)
---
---@return number
function PrismaticJoint:getJointTranslation() end

---Gets the joint limits.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getLimits)
---
---@return number, number
function PrismaticJoint:getLimits() end

---Gets the lower limit.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getLowerLimit)
---
---@return number
function PrismaticJoint:getLowerLimit() end

---Gets the maximum motor force.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getMaxMotorForce)
---
---@return number
function PrismaticJoint:getMaxMotorForce() end

---Returns the current motor force.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getMotorForce)
---
---@param invdt number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number
function PrismaticJoint:getMotorForce(invdt) end

---Gets the motor speed.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getMotorSpeed)
---
---@return number
function PrismaticJoint:getMotorSpeed() end

---Gets the reference angle.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getReferenceAngle)
---
---@return number
function PrismaticJoint:getReferenceAngle() end

---Gets the upper limit.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.getUpperLimit)
---
---@return number
function PrismaticJoint:getUpperLimit() end

---Checks whether the motor is enabled.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.isMotorEnabled)
---
---@return boolean
function PrismaticJoint:isMotorEnabled() end

---Sets the limits.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setLimits)
---
---@param lower number # The lower limit, usually in meters.
---@param upper number # The upper limit, usually in meters.
function PrismaticJoint:setLimits(lower, upper) end

---Enables/disables the joint limit.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setLimitsEnabled)
---
---@return boolean
function PrismaticJoint:setLimitsEnabled() end

---Sets the lower limit.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setLowerLimit)
---
---@param lower number # The lower limit, usually in meters.
function PrismaticJoint:setLowerLimit(lower) end

---Set the maximum motor force.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setMaxMotorForce)
---
---@param f number # The maximum motor force, usually in N.
function PrismaticJoint:setMaxMotorForce(f) end

---Enables/disables the joint motor.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setMotorEnabled)
---
---@param enable boolean # True to enable, false to disable.
function PrismaticJoint:setMotorEnabled(enable) end

---Sets the motor speed.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setMotorSpeed)
---
---@param s number # The motor speed, usually in meters per second.
function PrismaticJoint:setMotorSpeed(s) end

---Sets the upper limit.
---
---[Open in Browser](https://love2d.org/wiki/PrismaticJoint.setUpperLimit)
---
---@param upper number # The upper limit, usually in meters.
function PrismaticJoint:setUpperLimit(upper) end

--endregion PrismaticJoint

--region PulleyJoint

---Allows you to simulate bodies connected through pulleys.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint)
---
---@class PulleyJoint : Joint, Object
local PulleyJoint = {}
---Get the total length of the rope.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.getConstant)
---
---@return number
function PulleyJoint:getConstant() end

---Get the ground anchor positions in world coordinates.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.getGroundAnchors)
---
---@return number, number, number, number
function PulleyJoint:getGroundAnchors() end

---Get the current length of the rope segment attached to the first body.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.getLengthA)
---
---@return number
function PulleyJoint:getLengthA() end

---Get the current length of the rope segment attached to the second body.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.getLengthB)
---
---@return number
function PulleyJoint:getLengthB() end

---Get the maximum lengths of the rope segments.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.getMaxLengths)
---
---@return number, number
function PulleyJoint:getMaxLengths() end

---Get the pulley ratio.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.getRatio)
---
---@return number
function PulleyJoint:getRatio() end

---Set the total length of the rope.
---
---Setting a new length for the rope updates the maximum length values of the joint.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.setConstant)
---
---@param length number # The new length of the rope in the joint.
function PulleyJoint:setConstant(length) end

---Set the maximum lengths of the rope segments.
---
---The physics module also imposes maximum values for the rope segments. If the parameters exceed these values, the maximum values are set instead of the requested values.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.setMaxLengths)
---
---@param max1 number # The new maximum length of the first segment.
---@param max2 number # The new maximum length of the second segment.
function PulleyJoint:setMaxLengths(max1, max2) end

---Set the pulley ratio.
---
---[Open in Browser](https://love2d.org/wiki/PulleyJoint.setRatio)
---
---@param ratio number # The new pulley ratio of the joint.
function PulleyJoint:setRatio(ratio) end

--endregion PulleyJoint

--region RevoluteJoint

---Allow two Bodies to revolve around a shared point.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint)
---
---@class RevoluteJoint : Joint, Object
local RevoluteJoint = {}
---Checks whether limits are enabled.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.areLimitsEnabled)
---
---@return boolean
function RevoluteJoint:areLimitsEnabled() end

---Get the current joint angle.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getJointAngle)
---
---@return number
function RevoluteJoint:getJointAngle() end

---Get the current joint angle speed.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getJointSpeed)
---
---@return number
function RevoluteJoint:getJointSpeed() end

---Gets the joint limits.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getLimits)
---
---@return number, number
function RevoluteJoint:getLimits() end

---Gets the lower limit.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getLowerLimit)
---
---@return number
function RevoluteJoint:getLowerLimit() end

---Gets the maximum motor force.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getMaxMotorTorque)
---
---@return number
function RevoluteJoint:getMaxMotorTorque() end

---Gets the motor speed.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getMotorSpeed)
---
---@return number
function RevoluteJoint:getMotorSpeed() end

---Get the current motor force.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getMotorTorque)
---
---@return number
function RevoluteJoint:getMotorTorque() end

---Gets the reference angle.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getReferenceAngle)
---
---@return number
function RevoluteJoint:getReferenceAngle() end

---Gets the upper limit.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.getUpperLimit)
---
---@return number
function RevoluteJoint:getUpperLimit() end

---Checks whether limits are enabled.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.hasLimitsEnabled)
---
---@return boolean
function RevoluteJoint:hasLimitsEnabled() end

---Checks whether the motor is enabled.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.isMotorEnabled)
---
---@return boolean
function RevoluteJoint:isMotorEnabled() end

---Sets the limits.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setLimits)
---
---@param lower number # The lower limit, in radians.
---@param upper number # The upper limit, in radians.
function RevoluteJoint:setLimits(lower, upper) end

---Enables/disables the joint limit.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setLimitsEnabled)
---
---@param enable boolean # True to enable, false to disable.
function RevoluteJoint:setLimitsEnabled(enable) end

---Sets the lower limit.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setLowerLimit)
---
---@param lower number # The lower limit, in radians.
function RevoluteJoint:setLowerLimit(lower) end

---Set the maximum motor force.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setMaxMotorTorque)
---
---@param f number # The maximum motor force, in Nm.
function RevoluteJoint:setMaxMotorTorque(f) end

---Enables/disables the joint motor.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setMotorEnabled)
---
---@param enable boolean # True to enable, false to disable.
function RevoluteJoint:setMotorEnabled(enable) end

---Sets the motor speed.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setMotorSpeed)
---
---@param s number # The motor speed, radians per second.
function RevoluteJoint:setMotorSpeed(s) end

---Sets the upper limit.
---
---[Open in Browser](https://love2d.org/wiki/RevoluteJoint.setUpperLimit)
---
---@param upper number # The upper limit, in radians.
function RevoluteJoint:setUpperLimit(upper) end

--endregion RevoluteJoint

--region RopeJoint

---The RopeJoint enforces a maximum distance between two points on two bodies. It has no other effect.
---
---[Open in Browser](https://love2d.org/wiki/RopeJoint)
---
---@class RopeJoint : Joint, Object
local RopeJoint = {}
---Gets the maximum length of a RopeJoint.
---
---[Open in Browser](https://love2d.org/wiki/RopeJoint.getMaxLength)
---
---@return number
function RopeJoint:getMaxLength() end

---Sets the maximum length of a RopeJoint.
---
---[Open in Browser](https://love2d.org/wiki/RopeJoint.setMaxLength)
---
---@param maxLength number # The new maximum length of the RopeJoint.
function RopeJoint:setMaxLength(maxLength) end

--endregion RopeJoint

--region Shape

---Shapes are solid 2d geometrical objects which handle the mass and collision of a Body in love.physics.
---
---Shapes are attached to a Body via a Fixture. The Shape object is copied when this happens. 
---
---The Shape's position is relative to the position of the Body it has been attached to.
---
---[Open in Browser](https://love2d.org/wiki/Shape)
---
---@class Shape : Object
local Shape = {}
---Returns the points of the bounding box for the transformed shape.
---
---[Open in Browser](https://love2d.org/wiki/Shape.computeAABB)
---
---@param tx number # The translation of the shape on the x-axis.
---@param ty number # The translation of the shape on the y-axis.
---@param tr number # The shape rotation.
---@param childIndex number? # The index of the child to compute the bounding box of. (Defaults to 1.)
---@return number, number, number, number
function Shape:computeAABB(tx, ty, tr, childIndex) end

---Computes the mass properties for the shape with the specified density.
---
---[Open in Browser](https://love2d.org/wiki/Shape.computeMass)
---
---@param density number # The shape density.
---@return number, number, number, number
function Shape:computeMass(density) end

---Returns the number of children the shape has.
---
---[Open in Browser](https://love2d.org/wiki/Shape.getChildCount)
---
---@return number
function Shape:getChildCount() end

---Gets the radius of the shape.
---
---[Open in Browser](https://love2d.org/wiki/Shape.getRadius)
---
---@return number
function Shape:getRadius() end

---Gets a string representing the Shape.
---
---This function can be useful for conditional debug drawing.
---
---[Open in Browser](https://love2d.org/wiki/Shape.getType)
---
---@return love.ShapeType
function Shape:getType() end

---Casts a ray against the shape and returns the surface normal vector and the line position where the ray hit. If the ray missed the shape, nil will be returned. The Shape can be transformed to get it into the desired position.
---
---The ray starts on the first point of the input line and goes towards the second point of the line. The fourth argument is the maximum distance the ray is going to travel as a scale factor of the input line length.
---
---The childIndex parameter is used to specify which child of a parent shape, such as a ChainShape, will be ray casted. For ChainShapes, the index of 1 is the first edge on the chain. Ray casting a parent shape will only test the child specified so if you want to test every shape of the parent, you must loop through all of its children.
---
---The world position of the impact can be calculated by multiplying the line vector with the third return value and adding it to the line starting point.
---
---hitx, hity = x1 + (x2 - x1) * fraction, y1 + (y2 - y1) * fraction
---
---[Open in Browser](https://love2d.org/wiki/Shape.rayCast)
---
---@param x1 number # The x position of the input line starting point.
---@param y1 number # The y position of the input line starting point.
---@param x2 number # The x position of the input line end point.
---@param y2 number # The y position of the input line end point.
---@param maxFraction number # Ray length parameter.
---@param tx number # The translation of the shape on the x-axis.
---@param ty number # The translation of the shape on the y-axis.
---@param tr number # The shape rotation.
---@param childIndex number? # The index of the child the ray gets cast against. (Defaults to 1.)
---@return number, number, number
function Shape:rayCast(x1, y1, x2, y2, maxFraction, tx, ty, tr, childIndex) end

---This is particularly useful for mouse interaction with the shapes. By looping through all shapes and testing the mouse position with this function, we can find which shapes the mouse touches.
---
---[Open in Browser](https://love2d.org/wiki/Shape.testPoint)
---
---@param tx number # Translates the shape along the x-axis.
---@param ty number # Translates the shape along the y-axis.
---@param tr number # Rotates the shape.
---@param x number # The x-component of the point.
---@param y number # The y-component of the point.
---@return boolean
function Shape:testPoint(tx, ty, tr, x, y) end

--endregion Shape

--region WeldJoint

---A WeldJoint essentially glues two bodies together.
---
---[Open in Browser](https://love2d.org/wiki/WeldJoint)
---
---@class WeldJoint : Joint, Object
local WeldJoint = {}
---Returns the damping ratio of the joint.
---
---[Open in Browser](https://love2d.org/wiki/WeldJoint.getDampingRatio)
---
---@return number
function WeldJoint:getDampingRatio() end

---Returns the frequency.
---
---[Open in Browser](https://love2d.org/wiki/WeldJoint.getFrequency)
---
---@return number
function WeldJoint:getFrequency() end

---Gets the reference angle.
---
---[Open in Browser](https://love2d.org/wiki/WeldJoint.getReferenceAngle)
---
---@return number
function WeldJoint:getReferenceAngle() end

---Sets a new damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/WeldJoint.setDampingRatio)
---
---@param ratio number # The new damping ratio.
function WeldJoint:setDampingRatio(ratio) end

---Sets a new frequency.
---
---[Open in Browser](https://love2d.org/wiki/WeldJoint.setFrequency)
---
---@param freq number # The new frequency in hertz.
function WeldJoint:setFrequency(freq) end

--endregion WeldJoint

--region WheelJoint

---Restricts a point on the second body to a line on the first body.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint)
---
---@class WheelJoint : Joint, Object
local WheelJoint = {}
---Gets the world-space axis vector of the Wheel Joint.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getAxis)
---
---@return number, number
function WheelJoint:getAxis() end

---Returns the current joint translation speed.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getJointSpeed)
---
---@return number
function WheelJoint:getJointSpeed() end

---Returns the current joint translation.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getJointTranslation)
---
---@return number
function WheelJoint:getJointTranslation() end

---Returns the maximum motor torque.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getMaxMotorTorque)
---
---@return number
function WheelJoint:getMaxMotorTorque() end

---Returns the speed of the motor.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getMotorSpeed)
---
---@return number
function WheelJoint:getMotorSpeed() end

---Returns the current torque on the motor.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getMotorTorque)
---
---@param invdt number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number
function WheelJoint:getMotorTorque(invdt) end

---Returns the damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getSpringDampingRatio)
---
---@return number
function WheelJoint:getSpringDampingRatio() end

---Returns the spring frequency.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.getSpringFrequency)
---
---@return number
function WheelJoint:getSpringFrequency() end

---Checks if the joint motor is running.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.isMotorEnabled)
---
---@return boolean
function WheelJoint:isMotorEnabled() end

---Sets a new maximum motor torque.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.setMaxMotorTorque)
---
---@param maxTorque number # The new maximum torque for the joint motor in newton meters.
function WheelJoint:setMaxMotorTorque(maxTorque) end

---Starts and stops the joint motor.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.setMotorEnabled)
---
---@param enable boolean # True turns the motor on and false turns it off.
function WheelJoint:setMotorEnabled(enable) end

---Sets a new speed for the motor.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.setMotorSpeed)
---
---@param speed number # The new speed for the joint motor in radians per second.
function WheelJoint:setMotorSpeed(speed) end

---Sets a new damping ratio.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.setSpringDampingRatio)
---
---@param ratio number # The new damping ratio.
function WheelJoint:setSpringDampingRatio(ratio) end

---Sets a new spring frequency.
---
---[Open in Browser](https://love2d.org/wiki/WheelJoint.setSpringFrequency)
---
---@param freq number # The new frequency in hertz.
function WheelJoint:setSpringFrequency(freq) end

--endregion WheelJoint

--region World

---A world is an object that contains all bodies and joints.
---
---[Open in Browser](https://love2d.org/wiki/World)
---
---@class World : Object
local World = {}
---Destroys the world, taking all bodies, joints, fixtures and their shapes with it. 
---
---An error will occur if you attempt to use any of the destroyed objects after calling this function.
---
---[Open in Browser](https://love2d.org/wiki/World.destroy)
---
function World:destroy() end

---Returns a table with all bodies.
---
---[Open in Browser](https://love2d.org/wiki/World.getBodies)
---
---@return table
function World:getBodies() end

---Returns the number of bodies in the world.
---
---[Open in Browser](https://love2d.org/wiki/World.getBodyCount)
---
---@return number
function World:getBodyCount() end

---Returns functions for the callbacks during the world update.
---
---[Open in Browser](https://love2d.org/wiki/World.getCallbacks)
---
---@return function, function, function, function
function World:getCallbacks() end

---Returns the number of contacts in the world.
---
---[Open in Browser](https://love2d.org/wiki/World.getContactCount)
---
---@return number
function World:getContactCount() end

---Returns the function for collision filtering.
---
---[Open in Browser](https://love2d.org/wiki/World.getContactFilter)
---
---@return function
function World:getContactFilter() end

---Returns a table with all Contacts.
---
---[Open in Browser](https://love2d.org/wiki/World.getContacts)
---
---@return table
function World:getContacts() end

---Get the gravity of the world.
---
---[Open in Browser](https://love2d.org/wiki/World.getGravity)
---
---@return number, number
function World:getGravity() end

---Returns the number of joints in the world.
---
---[Open in Browser](https://love2d.org/wiki/World.getJointCount)
---
---@return number
function World:getJointCount() end

---Returns a table with all joints.
---
---[Open in Browser](https://love2d.org/wiki/World.getJoints)
---
---@return table
function World:getJoints() end

---Gets whether the World is destroyed. Destroyed worlds cannot be used.
---
---[Open in Browser](https://love2d.org/wiki/World.isDestroyed)
---
---@return boolean
function World:isDestroyed() end

---Returns if the world is updating its state.
---
---This will return true inside the callbacks from World:setCallbacks.
---
---[Open in Browser](https://love2d.org/wiki/World.isLocked)
---
---@return boolean
function World:isLocked() end

---Gets the sleep behaviour of the world.
---
---[Open in Browser](https://love2d.org/wiki/World.isSleepingAllowed)
---
---@return boolean
function World:isSleepingAllowed() end

---Calls a function for each fixture inside the specified area by searching for any overlapping bounding box (Fixture:getBoundingBox).
---
---[Open in Browser](https://love2d.org/wiki/World.queryBoundingBox)
---
---@param topLeftX number # The x position of the top-left point.
---@param topLeftY number # The y position of the top-left point.
---@param bottomRightX number # The x position of the bottom-right point.
---@param bottomRightY number # The y position of the bottom-right point.
---@param callback function # This function gets passed one argument, the fixture, and should return a boolean. The search will continue if it is true or stop if it is false.
function World:queryBoundingBox(topLeftX, topLeftY, bottomRightX, bottomRightY, callback) end

---Casts a ray and calls a function for each fixtures it intersects. 
---
---[Open in Browser](https://love2d.org/wiki/World.rayCast)
---
---@param x1 number # The x position of the starting point of the ray.
---@param y1 number # The x position of the starting point of the ray.
---@param x2 number # The x position of the end point of the ray.
---@param y2 number # The x value of the surface normal vector of the shape edge.
---@param callback function # A function called for each fixture intersected by the ray. The function gets six arguments and should return a number as a control value. The intersection points fed into the function will be in an arbitrary order. If you wish to find the closest point of intersection, you'll need to do that yourself within the function. The easiest way to do that is by using the fraction value.
function World:rayCast(x1, y1, x2, y2, callback) end

---Sets functions for the collision callbacks during the world update.
---
---Four Lua functions can be given as arguments. The value nil removes a function.
---
---When called, each function will be passed three arguments. The first two arguments are the colliding fixtures and the third argument is the Contact between them. The postSolve callback additionally gets the normal and tangent impulse for each contact point. See notes.
---
---If you are interested to know when exactly each callback is called, consult a Box2d manual
---
---[Open in Browser](https://love2d.org/wiki/World.setCallbacks)
---
---@param beginContact function # Gets called when two fixtures begin to overlap.
---@param endContact function # Gets called when two fixtures cease to overlap. This will also be called outside of a world update, when colliding objects are destroyed.
---@param preSolve function? # Gets called before a collision gets resolved. (Defaults to nil.)
---@param postSolve function? # Gets called after the collision has been resolved. (Defaults to nil.)
function World:setCallbacks(beginContact, endContact, preSolve, postSolve) end

---Sets a function for collision filtering.
---
---If the group and category filtering doesn't generate a collision decision, this function gets called with the two fixtures as arguments. The function should return a boolean value where true means the fixtures will collide and false means they will pass through each other.
---
---[Open in Browser](https://love2d.org/wiki/World.setContactFilter)
---
---@param filter function # The function handling the contact filtering.
function World:setContactFilter(filter) end

---Set the gravity of the world.
---
---[Open in Browser](https://love2d.org/wiki/World.setGravity)
---
---@param x number # The x component of gravity.
---@param y number # The y component of gravity.
function World:setGravity(x, y) end

---Sets the sleep behaviour of the world.
---
---[Open in Browser](https://love2d.org/wiki/World.setSleepingAllowed)
---
---@param allow boolean # True if bodies in the world are allowed to sleep, or false if not.
function World:setSleepingAllowed(allow) end

---Translates the World's origin. Useful in large worlds where floating point precision issues become noticeable at far distances from the origin.
---
---[Open in Browser](https://love2d.org/wiki/World.translateOrigin)
---
---@param x number # The x component of the new origin with respect to the old origin.
---@param y number # The y component of the new origin with respect to the old origin.
function World:translateOrigin(x, y) end

---Update the state of the world.
---
---[Open in Browser](https://love2d.org/wiki/World.update)
---
---@param dt number # The time (in seconds) to advance the physics simulation.
---@param velocityiterations number? # The maximum number of steps used to determine the new velocities when resolving a collision. (Defaults to 8.)
---@param positioniterations number? # The maximum number of steps used to determine the new positions when resolving a collision. (Defaults to 3.)
function World:update(dt, velocityiterations, positioniterations) end

--endregion World

---The types of a Body. 
---
---[Open in Browser](https://love2d.org/wiki/BodyType)
---
---@alias BodyType
---| "static" -- Static bodies do not move.
---| "dynamic" -- Dynamic bodies collide with all bodies.
---| "kinematic" -- Kinematic bodies only collide with dynamic bodies.

---Different types of joints.
---
---[Open in Browser](https://love2d.org/wiki/JointType)
---
---@alias JointType
---| "distance" -- A DistanceJoint.
---| "friction" -- A FrictionJoint.
---| "gear" -- A GearJoint.
---| "mouse" -- A MouseJoint.
---| "prismatic" -- A PrismaticJoint.
---| "pulley" -- A PulleyJoint.
---| "revolute" -- A RevoluteJoint.
---| "rope" -- A RopeJoint.
---| "weld" -- A WeldJoint.

---The different types of Shapes, as returned by Shape:getType.
---
---[Open in Browser](https://love2d.org/wiki/ShapeType)
---
---@alias ShapeType
---| "circle" -- The Shape is a CircleShape.
---| "polygon" -- The Shape is a PolygonShape.
---| "edge" -- The Shape is a EdgeShape.
---| "chain" -- The Shape is a ChainShape.

---Returns the two closest points between two fixtures and their distance.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.getDistance)
---
---@param fixture1 love.Fixture # The first fixture.
---@param fixture2 love.Fixture # The second fixture.
---@return number, number, number, number, number
function love.physics.getDistance(fixture1, fixture2) end

---Returns the meter scale factor.
---
---All coordinates in the physics module are divided by this number, creating a convenient way to draw the objects directly to the screen without the need for graphics transformations.
---
---It is recommended to create shapes no larger than 10 times the scale. This is important because Box2D is tuned to work well with shape sizes from 0.1 to 10 meters.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.getMeter)
---
---@return number
function love.physics.getMeter() end

---Creates a new body.
---
---There are three types of bodies. 
---
---* Static bodies do not move, have a infinite mass, and can be used for level boundaries. 
---
---* Dynamic bodies are the main actors in the simulation, they collide with everything. 
---
---* Kinematic bodies do not react to forces and only collide with dynamic bodies.
---
---The mass of the body gets calculated when a Fixture is attached or removed, but can be changed at any time with Body:setMass or Body:resetMassData.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newBody)
---
---@param world love.World # The world to create the body in.
---@param x number? # The x position of the body. (Defaults to 0.)
---@param y number? # The y position of the body. (Defaults to 0.)
---@param type love.BodyType? # The type of the body. (Defaults to 'static'.)
---@return love.Body
function love.physics.newBody(world, x, y, type) end

---Creates a new ChainShape.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newChainShape)
---
---@param loop boolean # If the chain should loop back to the first point.
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@vararg number # Additional point positions.
---@return love.ChainShape
---@overload fun(loop:boolean, points:table):love.ChainShape
function love.physics.newChainShape(loop, x1, y1, x2, y2, ...) end

---Creates a new CircleShape.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newCircleShape)
---
---@param x number # The x position of the circle.
---@param y number # The y position of the circle.
---@param radius number # The radius of the circle.
---@return love.CircleShape
---@overload fun(radius:number):love.CircleShape
function love.physics.newCircleShape(x, y, radius) end

---Creates a DistanceJoint between two bodies.
---
---This joint constrains the distance between two points on two bodies to be constant. These two points are specified in world coordinates and the two bodies are assumed to be in place when this joint is created. The first anchor point is connected to the first body and the second to the second body, and the points define the length of the distance joint.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newDistanceJoint)
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x1 number # The x position of the first anchor point (world space).
---@param y1 number # The y position of the first anchor point (world space).
---@param x2 number # The x position of the second anchor point (world space).
---@param y2 number # The y position of the second anchor point (world space).
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@return love.DistanceJoint
function love.physics.newDistanceJoint(body1, body2, x1, y1, x2, y2, collideConnected) end

---Creates a new EdgeShape.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newEdgeShape)
---
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@return love.EdgeShape
function love.physics.newEdgeShape(x1, y1, x2, y2) end

---Creates and attaches a Fixture to a body.
---
---Note that the Shape object is copied rather than kept as a reference when the Fixture is created. To get the Shape object that the Fixture owns, use Fixture:getShape.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newFixture)
---
---@param body love.Body # The body which gets the fixture attached.
---@param shape love.Shape # The shape to be copied to the fixture.
---@param density number? # The density of the fixture. (Defaults to 1.)
---@return love.Fixture
function love.physics.newFixture(body, shape, density) end

---Create a friction joint between two bodies. A FrictionJoint applies friction to a body.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newFrictionJoint)
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x1 number # The x position of the first anchor point.
---@param y1 number # The y position of the first anchor point.
---@param x2 number # The x position of the second anchor point.
---@param y2 number # The y position of the second anchor point.
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@return love.FrictionJoint
---@overload fun(body1:love.Body, body2:love.Body, x:number, y:number, collideConnected:boolean?):love.FrictionJoint
function love.physics.newFrictionJoint(body1, body2, x1, y1, x2, y2, collideConnected) end

---Create a GearJoint connecting two Joints.
---
---The gear joint connects two joints that must be either  prismatic or  revolute joints. Using this joint requires that the joints it uses connect their respective bodies to the ground and have the ground as the first body. When destroying the bodies and joints you must make sure you destroy the gear joint before the other joints.
---
---The gear joint has a ratio the determines how the angular or distance values of the connected joints relate to each other. The formula coordinate1 + ratio * coordinate2 always has a constant value that is set when the gear joint is created.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newGearJoint)
---
---@param joint1 love.Joint # The first joint to connect with a gear joint.
---@param joint2 love.Joint # The second joint to connect with a gear joint.
---@param ratio number? # The gear ratio. (Defaults to 1.)
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@return love.GearJoint
function love.physics.newGearJoint(joint1, joint2, ratio, collideConnected) end

---Creates a joint between two bodies which controls the relative motion between them.
---
---Position and rotation offsets can be specified once the MotorJoint has been created, as well as the maximum motor force and torque that will be be applied to reach the target offsets.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newMotorJoint)
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param correctionFactor number? # The joint's initial position correction factor, in the range of 1. (Defaults to 0.3.)
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@return love.MotorJoint
---@overload fun(body1:love.Body, body2:love.Body, correctionFactor:number?):love.MotorJoint
function love.physics.newMotorJoint(body1, body2, correctionFactor, collideConnected) end

---Create a joint between a body and the mouse.
---
---This joint actually connects the body to a fixed point in the world. To make it follow the mouse, the fixed point must be updated every timestep (example below).
---
---The advantage of using a MouseJoint instead of just changing a body position directly is that collisions and reactions to other joints are handled by the physics engine. 
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newMouseJoint)
---
---@param body love.Body # The body to attach to the mouse.
---@param x number # The x position of the connecting point.
---@param y number # The y position of the connecting point.
---@return love.MouseJoint
function love.physics.newMouseJoint(body, x, y) end

---Creates a new PolygonShape.
---
---This shape can have 8 vertices at most, and must form a convex shape.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newPolygonShape)
---
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@param x3 number # The x position of the third point.
---@param y3 number # The y position of the third point.
---@vararg number # You can continue passing more point positions to create the PolygonShape.
---@return love.PolygonShape
---@overload fun(vertices:table):love.PolygonShape
function love.physics.newPolygonShape(x1, y1, x2, y2, x3, y3, ...) end

---Creates a PrismaticJoint between two bodies.
---
---A prismatic joint constrains two bodies to move relatively to each other on a specified axis. It does not allow for relative rotation. Its definition and operation are similar to a  revolute joint, but with translation and force substituted for angle and torque.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newPrismaticJoint)
---
---@param body1 love.Body # The first body to connect with a prismatic joint.
---@param body2 love.Body # The second body to connect with a prismatic joint.
---@param x1 number # The x coordinate of the first anchor point.
---@param y1 number # The y coordinate of the first anchor point.
---@param x2 number # The x coordinate of the second anchor point.
---@param y2 number # The y coordinate of the second anchor point.
---@param ax number # The x coordinate of the axis unit vector.
---@param ay number # The y coordinate of the axis unit vector.
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@param referenceAngle number? # The reference angle between body1 and body2, in radians. (Defaults to 0.)
---@return love.PrismaticJoint
---@overload fun(body1:love.Body, body2:love.Body, x1:number, y1:number, x2:number, y2:number, ax:number, ay:number, collideConnected:boolean?):love.PrismaticJoint
---@overload fun(body1:love.Body, body2:love.Body, x:number, y:number, ax:number, ay:number, collideConnected:boolean?):love.PrismaticJoint
function love.physics.newPrismaticJoint(body1, body2, x1, y1, x2, y2, ax, ay, collideConnected, referenceAngle) end

---Creates a PulleyJoint to join two bodies to each other and the ground.
---
---The pulley joint simulates a pulley with an optional block and tackle. If the ratio parameter has a value different from one, then the simulated rope extends faster on one side than the other. In a pulley joint the total length of the simulated rope is the constant length1 + ratio * length2, which is set when the pulley joint is created.
---
---Pulley joints can behave unpredictably if one side is fully extended. It is recommended that the method  setMaxLengths  be used to constrain the maximum lengths each side can attain.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newPulleyJoint)
---
---@param body1 love.Body # The first body to connect with a pulley joint.
---@param body2 love.Body # The second body to connect with a pulley joint.
---@param gx1 number # The x coordinate of the first body's ground anchor.
---@param gy1 number # The y coordinate of the first body's ground anchor.
---@param gx2 number # The x coordinate of the second body's ground anchor.
---@param gy2 number # The y coordinate of the second body's ground anchor.
---@param x1 number # The x coordinate of the pulley joint anchor in the first body.
---@param y1 number # The y coordinate of the pulley joint anchor in the first body.
---@param x2 number # The x coordinate of the pulley joint anchor in the second body.
---@param y2 number # The y coordinate of the pulley joint anchor in the second body.
---@param ratio number? # The joint ratio. (Defaults to 1.)
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to true.)
---@return love.PulleyJoint
function love.physics.newPulleyJoint(body1, body2, gx1, gy1, gx2, gy2, x1, y1, x2, y2, ratio, collideConnected) end

---Shorthand for creating rectangular PolygonShapes. 
---
---By default, the local origin is located at the '''center''' of the rectangle as opposed to the top left for graphics.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newRectangleShape)
---
---@param x number # The offset along the x-axis.
---@param y number # The offset along the y-axis.
---@param width number # The width of the rectangle.
---@param height number # The height of the rectangle.
---@param angle number? # The initial angle of the rectangle. (Defaults to 0.)
---@return love.PolygonShape
---@overload fun(width:number, height:number):love.PolygonShape
function love.physics.newRectangleShape(x, y, width, height, angle) end

---Creates a pivot joint between two bodies.
---
---This joint connects two bodies to a point around which they can pivot.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newRevoluteJoint)
---
---@param body1 love.Body # The first body.
---@param body2 love.Body # The second body.
---@param x1 number # The x position of the first connecting point.
---@param y1 number # The y position of the first connecting point.
---@param x2 number # The x position of the second connecting point.
---@param y2 number # The y position of the second connecting point.
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@param referenceAngle number? # The reference angle between body1 and body2, in radians. (Defaults to 0.)
---@return love.RevoluteJoint
---@overload fun(body1:love.Body, body2:love.Body, x:number, y:number, collideConnected:boolean?):love.RevoluteJoint
function love.physics.newRevoluteJoint(body1, body2, x1, y1, x2, y2, collideConnected, referenceAngle) end

---Creates a joint between two bodies. Its only function is enforcing a max distance between these bodies.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newRopeJoint)
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x1 number # The x position of the first anchor point.
---@param y1 number # The y position of the first anchor point.
---@param x2 number # The x position of the second anchor point.
---@param y2 number # The y position of the second anchor point.
---@param maxLength number # The maximum distance for the bodies.
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@return love.RopeJoint
function love.physics.newRopeJoint(body1, body2, x1, y1, x2, y2, maxLength, collideConnected) end

---Creates a constraint joint between two bodies. A WeldJoint essentially glues two bodies together. The constraint is a bit soft, however, due to Box2D's iterative solver.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newWeldJoint)
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x1 number # The x position of the first anchor point (world space).
---@param y1 number # The y position of the first anchor point  (world space).
---@param x2 number # The x position of the second anchor point (world space).
---@param y2 number # The y position of the second anchor point (world space).
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@param referenceAngle number? # The reference angle between body1 and body2, in radians. (Defaults to 0.)
---@return love.WeldJoint
---@overload fun(body1:love.Body, body2:love.Body, x1:number, y1:number, x2:number, y2:number, collideConnected:boolean?):love.WeldJoint
---@overload fun(body1:love.Body, body2:love.Body, x:number, y:number, collideConnected:boolean?):love.WeldJoint
function love.physics.newWeldJoint(body1, body2, x1, y1, x2, y2, collideConnected, referenceAngle) end

---Creates a wheel joint.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newWheelJoint)
---
---@param body1 love.Body # The first body.
---@param body2 love.Body # The second body.
---@param x1 number # The x position of the first anchor point.
---@param y1 number # The y position of the first anchor point.
---@param x2 number # The x position of the second anchor point.
---@param y2 number # The y position of the second anchor point.
---@param ax number # The x position of the axis unit vector.
---@param ay number # The y position of the axis unit vector.
---@param collideConnected boolean? # Specifies whether the two bodies should collide with each other. (Defaults to false.)
---@return love.WheelJoint
---@overload fun(body1:love.Body, body2:love.Body, x:number, y:number, ax:number, ay:number, collideConnected:boolean?):love.WheelJoint
function love.physics.newWheelJoint(body1, body2, x1, y1, x2, y2, ax, ay, collideConnected) end

---Creates a new World.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.newWorld)
---
---@param xg number? # The x component of gravity. (Defaults to 0.)
---@param yg number? # The y component of gravity. (Defaults to 0.)
---@param sleep boolean? # Whether the bodies in this world are allowed to sleep. (Defaults to true.)
---@return love.World
function love.physics.newWorld(xg, yg, sleep) end

---Sets the pixels to meter scale factor.
---
---All coordinates in the physics module are divided by this number and converted to meters, and it creates a convenient way to draw the objects directly to the screen without the need for graphics transformations.
---
---It is recommended to create shapes no larger than 10 times the scale. This is important because Box2D is tuned to work well with shape sizes from 0.1 to 10 meters. The default meter scale is 30.
---
---[Open in Browser](https://love2d.org/wiki/love.physics.setMeter)
---
---@param scale number # The scale factor as an integer.
function love.physics.setMeter(scale) end

