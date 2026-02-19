---@meta
---@namespace love

---Provides an interface to create noise with the user's speakers.
love.audio = {}

--region RecordingDevice

---Represents an audio input device capable of recording sounds.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice)
---
---@class RecordingDevice : Object
local RecordingDevice = {}
---Gets the number of bits per sample in the data currently being recorded.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.getBitDepth)
---
---@return number
function RecordingDevice:getBitDepth() end

---Gets the number of channels currently being recorded (mono or stereo).
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.getChannelCount)
---
---@return number
function RecordingDevice:getChannelCount() end

---Gets all recorded audio SoundData stored in the device's internal ring buffer.
---
---The internal ring buffer is cleared when this function is called, so calling it again will only get audio recorded after the previous call. If the device's internal ring buffer completely fills up before getData is called, the oldest data that doesn't fit into the buffer will be lost.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.getData)
---
---@return love.SoundData
function RecordingDevice:getData() end

---Gets the name of the recording device.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.getName)
---
---@return string
function RecordingDevice:getName() end

---Gets the number of currently recorded samples.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.getSampleCount)
---
---@return number
function RecordingDevice:getSampleCount() end

---Gets the number of samples per second currently being recorded.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.getSampleRate)
---
---@return number
function RecordingDevice:getSampleRate() end

---Gets whether the device is currently recording.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.isRecording)
---
---@return boolean
function RecordingDevice:isRecording() end

---Begins recording audio using this device.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.start)
---
---@param samplecount number # The maximum number of samples to store in an internal ring buffer when recording. RecordingDevice:getData clears the internal buffer when called.
---@param samplerate number? # The number of samples per second to store when recording. (Defaults to 8000.)
---@param bitdepth number? # The number of bits per sample. (Defaults to 16.)
---@param channels number? # Whether to record in mono or stereo. Most microphones don't support more than 1 channel. (Defaults to 1.)
---@return boolean
function RecordingDevice:start(samplecount, samplerate, bitdepth, channels) end

---Stops recording audio from this device. Any sound data currently in the device's buffer will be returned.
---
---[Open in Browser](https://love2d.org/wiki/RecordingDevice.stop)
---
---@return love.SoundData
function RecordingDevice:stop() end

--endregion RecordingDevice

--region Source

---A Source represents audio you can play back.
---
---You can do interesting things with Sources, like set the volume, pitch, and its position relative to the listener. Please note that positional audio only works for mono (i.e. non-stereo) sources.
---
---The Source controls (play/pause/stop) act according to the following state table.
---
---[Open in Browser](https://love2d.org/wiki/Source)
---
---@class Source : Object
local Source = {}
---Creates an identical copy of the Source in the stopped state.
---
---Static Sources will use significantly less memory and take much less time to be created if Source:clone is used to create them instead of love.audio.newSource, so this method should be preferred when making multiple Sources which play the same sound.
---
---[Open in Browser](https://love2d.org/wiki/Source.clone)
---
---@return love.Source
function Source:clone() end

---Gets a list of the Source's active effect names.
---
---[Open in Browser](https://love2d.org/wiki/Source.getActiveEffects)
---
---@return table
function Source:getActiveEffects() end

---Gets the amount of air absorption applied to the Source.
---
---By default the value is set to 0 which means that air absorption effects are disabled. A value of 1 will apply high frequency attenuation to the Source at a rate of 0.05 dB per meter.
---
---[Open in Browser](https://love2d.org/wiki/Source.getAirAbsorption)
---
---@return number
function Source:getAirAbsorption() end

---Gets the reference and maximum attenuation distances of the Source. The values, combined with the current DistanceModel, affect how the Source's volume attenuates based on distance from the listener.
---
---[Open in Browser](https://love2d.org/wiki/Source.getAttenuationDistances)
---
---@return number, number
function Source:getAttenuationDistances() end

---Gets the number of channels in the Source. Only 1-channel (mono) Sources can use directional and positional effects.
---
---[Open in Browser](https://love2d.org/wiki/Source.getChannelCount)
---
---@return number
function Source:getChannelCount() end

---Gets the Source's directional volume cones. Together with Source:setDirection, the cone angles allow for the Source's volume to vary depending on its direction.
---
---[Open in Browser](https://love2d.org/wiki/Source.getCone)
---
---@return number, number, number
function Source:getCone() end

---Gets the direction of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getDirection)
---
---@return number, number, number
function Source:getDirection() end

---Gets the duration of the Source. For streaming Sources it may not always be sample-accurate, and may return -1 if the duration cannot be determined at all.
---
---[Open in Browser](https://love2d.org/wiki/Source.getDuration)
---
---@param unit love.TimeUnit? # The time unit for the return value. (Defaults to 'seconds'.)
---@return number
function Source:getDuration(unit) end

---Gets the filter settings associated to a specific effect.
---
---This function returns nil if the effect was applied with no filter settings associated to it.
---
---[Open in Browser](https://love2d.org/wiki/Source.getEffect)
---
---@param name string # The name of the effect.
---@param filtersettings table? # An optional empty table that will be filled with the filter settings. (Defaults to {}.)
---@return {volume:number, highgain:number, lowgain:number}
function Source:getEffect(name, filtersettings) end

---Gets the filter settings currently applied to the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getFilter)
---
---@return {type:love.FilterType, volume:number, highgain:number, lowgain:number}
function Source:getFilter() end

---Gets the number of free buffer slots in a queueable Source. If the queueable Source is playing, this value will increase up to the amount the Source was created with. If the queueable Source is stopped, it will process all of its internal buffers first, in which case this function will always return the amount it was created with.
---
---[Open in Browser](https://love2d.org/wiki/Source.getFreeBufferCount)
---
---@return number
function Source:getFreeBufferCount() end

---Gets the current pitch of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getPitch)
---
---@return number
function Source:getPitch() end

---Gets the position of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getPosition)
---
---@return number, number, number
function Source:getPosition() end

---Returns the rolloff factor of the source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getRolloff)
---
---@return number
function Source:getRolloff() end

---Gets the type of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getType)
---
---@return love.SourceType
function Source:getType() end

---Gets the velocity of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getVelocity)
---
---@return number, number, number
function Source:getVelocity() end

---Gets the current volume of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getVolume)
---
---@return number
function Source:getVolume() end

---Returns the volume limits of the source.
---
---[Open in Browser](https://love2d.org/wiki/Source.getVolumeLimits)
---
---@return number, number
function Source:getVolumeLimits() end

---Returns whether the Source will loop.
---
---[Open in Browser](https://love2d.org/wiki/Source.isLooping)
---
---@return boolean
function Source:isLooping() end

---Returns whether the Source is playing.
---
---[Open in Browser](https://love2d.org/wiki/Source.isPlaying)
---
---@return boolean
function Source:isPlaying() end

---Gets whether the Source's position, velocity, direction, and cone angles are relative to the listener.
---
---[Open in Browser](https://love2d.org/wiki/Source.isRelative)
---
---@return boolean
function Source:isRelative() end

---Pauses the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.pause)
---
function Source:pause() end

---Starts playing the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.play)
---
---@return boolean
function Source:play() end

---Queues SoundData for playback in a queueable Source.
---
---This method requires the Source to be created via love.audio.newQueueableSource.
---
---[Open in Browser](https://love2d.org/wiki/Source.queue)
---
---@param sounddata love.SoundData # The data to queue. The SoundData's sample rate, bit depth, and channel count must match the Source's.
---@return boolean
function Source:queue(sounddata) end

---Sets the currently playing position of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.seek)
---
---@param offset number # The position to seek to.
---@param unit love.TimeUnit? # The unit of the position value. (Defaults to 'seconds'.)
function Source:seek(offset, unit) end

---Sets the amount of air absorption applied to the Source.
---
---By default the value is set to 0 which means that air absorption effects are disabled. A value of 1 will apply high frequency attenuation to the Source at a rate of 0.05 dB per meter.
---
---Air absorption can simulate sound transmission through foggy air, dry air, smoky atmosphere, etc. It can be used to simulate different atmospheric conditions within different locations in an area.
---
---[Open in Browser](https://love2d.org/wiki/Source.setAirAbsorption)
---
---@param amount number # The amount of air absorption applied to the Source. Must be between 0 and 10.
function Source:setAirAbsorption(amount) end

---Sets the reference and maximum attenuation distances of the Source. The parameters, combined with the current DistanceModel, affect how the Source's volume attenuates based on distance.
---
---Distance attenuation is only applicable to Sources based on mono (rather than stereo) audio.
---
---[Open in Browser](https://love2d.org/wiki/Source.setAttenuationDistances)
---
---@param ref number # The new reference attenuation distance. If the current DistanceModel is clamped, this is the minimum attenuation distance.
---@param max number # The new maximum attenuation distance.
function Source:setAttenuationDistances(ref, max) end

---Sets the Source's directional volume cones. Together with Source:setDirection, the cone angles allow for the Source's volume to vary depending on its direction.
---
---[Open in Browser](https://love2d.org/wiki/Source.setCone)
---
---@param innerAngle number # The inner angle from the Source's direction, in radians. The Source will play at normal volume if the listener is inside the cone defined by this angle.
---@param outerAngle number # The outer angle from the Source's direction, in radians. The Source will play at a volume between the normal and outer volumes, if the listener is in between the cones defined by the inner and outer angles.
---@param outerVolume number? # The Source's volume when the listener is outside both the inner and outer cone angles. (Defaults to 0.)
function Source:setCone(innerAngle, outerAngle, outerVolume) end

---Sets the direction vector of the Source. A zero vector makes the source non-directional.
---
---[Open in Browser](https://love2d.org/wiki/Source.setDirection)
---
---@param x number # The X part of the direction vector.
---@param y number # The Y part of the direction vector.
---@param z number # The Z part of the direction vector.
function Source:setDirection(x, y, z) end

---Applies an audio effect to the Source.
---
---The effect must have been previously defined using love.audio.setEffect.
---
---[Open in Browser](https://love2d.org/wiki/Source.setEffect)
---
---@param name string # The name of the effect previously set up with love.audio.setEffect.
---@param enable boolean? # If false and the given effect name was previously enabled on this Source, disables the effect. (Defaults to true.)
---@return boolean
---
---Applies the given previously defined effect to this Source, and applies a filter to the Source which affects the sound fed into the effect.
---
---Audio effect functionality is not supported on iOS.
---@overload fun(self:Source, name:string, filtersettings:{type:love.FilterType, or volume:number, or highgain:number, or lowgain:number}):boolean
function Source:setEffect(name, enable) end

---Sets a low-pass, high-pass, or band-pass filter to apply when playing the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.setFilter)
---
---@param settings {type:love.FilterType, or volume:number, or highgain:number, or lowgain:number} # The filter settings to use for this Source, with the following fields:
---@return boolean
---
---Disables filtering on this Source.
---
---
---@overload fun(self:Source):nil
function Source:setFilter(settings) end

---Sets whether the Source should loop.
---
---[Open in Browser](https://love2d.org/wiki/Source.setLooping)
---
---@param loop boolean # True if the source should loop, false otherwise.
function Source:setLooping(loop) end

---Sets the pitch of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.setPitch)
---
---@param pitch number # Calculated with regard to 1 being the base pitch. Each reduction by 50 percent equals a pitch shift of -12 semitones (one octave reduction). Each doubling equals a pitch shift of 12 semitones (one octave increase). Zero is not a legal value.
function Source:setPitch(pitch) end

---Sets the position of the Source. Please note that this only works for mono (i.e. non-stereo) sound files!
---
---[Open in Browser](https://love2d.org/wiki/Source.setPosition)
---
---@param x number # The X position of the Source.
---@param y number # The Y position of the Source.
---@param z number # The Z position of the Source.
function Source:setPosition(x, y, z) end

---Sets whether the Source's position, velocity, direction, and cone angles are relative to the listener, or absolute.
---
---By default, all sources are absolute and therefore relative to the origin of love's coordinate system 0, 0. Only absolute sources are affected by the position of the listener. Please note that positional audio only works for mono (i.e. non-stereo) sources. 
---
---[Open in Browser](https://love2d.org/wiki/Source.setRelative)
---
---@param enable boolean? # True to make the position, velocity, direction and cone angles relative to the listener, false to make them absolute. (Defaults to false.)
function Source:setRelative(enable) end

---Sets the rolloff factor which affects the strength of the used distance attenuation.
---
---Extended information and detailed formulas can be found in the chapter '3.4. Attenuation By Distance' of OpenAL 1.1 specification.
---
---[Open in Browser](https://love2d.org/wiki/Source.setRolloff)
---
---@param rolloff number # The new rolloff factor.
function Source:setRolloff(rolloff) end

---Sets the velocity of the Source.
---
---This does '''not''' change the position of the Source, but lets the application know how it has to calculate the doppler effect.
---
---[Open in Browser](https://love2d.org/wiki/Source.setVelocity)
---
---@param x number # The X part of the velocity vector.
---@param y number # The Y part of the velocity vector.
---@param z number # The Z part of the velocity vector.
function Source:setVelocity(x, y, z) end

---Sets the current volume of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.setVolume)
---
---@param volume number # The volume for a Source, where 1.0 is normal volume. Volume cannot be raised above 1.0.
function Source:setVolume(volume) end

---Sets the volume limits of the source. The limits have to be numbers from 0 to 1.
---
---[Open in Browser](https://love2d.org/wiki/Source.setVolumeLimits)
---
---@param min number # The minimum volume.
---@param max number # The maximum volume.
function Source:setVolumeLimits(min, max) end

---Stops a Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.stop)
---
function Source:stop() end

---Gets the currently playing position of the Source.
---
---[Open in Browser](https://love2d.org/wiki/Source.tell)
---
---@param unit love.TimeUnit? # The type of unit for the return value. (Defaults to 'seconds'.)
---@return number
function Source:tell(unit) end

--endregion Source

---The different distance models.
---
---Extended information can be found in the chapter "3.4. Attenuation By Distance" of the OpenAL 1.1 specification.
---
---[Open in Browser](https://love2d.org/wiki/DistanceModel)
---
---@alias DistanceModel
---| "none" -- Sources do not get attenuated.
---| "inverse" -- Inverse distance attenuation.
---| "inverseclamped" -- Inverse distance attenuation. Gain is clamped. In version 0.9.2 and older this is named '''inverse clamped'''.
---| "linear" -- Linear attenuation.
---| "linearclamped" -- Linear attenuation. Gain is clamped. In version 0.9.2 and older this is named '''linear clamped'''.
---| "exponent" -- Exponential attenuation.
---| "exponentclamped" -- Exponential attenuation. Gain is clamped. In version 0.9.2 and older this is named '''exponent clamped'''.

---The different types of effects supported by love.audio.setEffect.
---
---[Open in Browser](https://love2d.org/wiki/EffectType)
---
---@alias EffectType
---| "chorus" -- Plays multiple copies of the sound with slight pitch and time variation. Used to make sounds sound "fuller" or "thicker".
---| "compressor" -- Decreases the dynamic range of the sound, making the loud and quiet parts closer in volume, producing a more uniform amplitude throughout time.
---| "distortion" -- Alters the sound by amplifying it until it clips, shearing off parts of the signal, leading to a compressed and distorted sound.
---| "echo" -- Decaying feedback based effect, on the order of seconds. Also known as delay; causes the sound to repeat at regular intervals at a decreasing volume.
---| "equalizer" -- Adjust the frequency components of the sound using a 4-band (low-shelf, two band-pass and a high-shelf) equalizer.
---| "flanger" -- Plays two copies of the sound; while varying the phase, or equivalently delaying one of them, by amounts on the order of milliseconds, resulting in phasing sounds.
---| "reverb" -- Decaying feedback based effect, on the order of milliseconds. Used to simulate the reflection off of the surroundings.
---| "ringmodulator" -- An implementation of amplitude modulation; multiplies the source signal with a simple waveform, to produce either volume changes, or inharmonic overtones.

---The different types of waveforms that can be used with the '''ringmodulator''' EffectType.
---
---[Open in Browser](https://love2d.org/wiki/EffectWaveform)
---
---@alias EffectWaveform
---| "sawtooth" -- A sawtooth wave, also known as a ramp wave. Named for its linear rise, and (near-)instantaneous fall along time.
---| "sine" -- A sine wave. Follows a trigonometric sine function.
---| "square" -- A square wave. Switches between high and low states (near-)instantaneously.
---| "triangle" -- A triangle wave. Follows a linear rise and fall that repeats periodically.

---Types of filters for Sources.
---
---[Open in Browser](https://love2d.org/wiki/FilterType)
---
---@alias FilterType
---| "lowpass" -- Low-pass filter. High frequency sounds are attenuated.
---| "highpass" -- High-pass filter. Low frequency sounds are attenuated.
---| "bandpass" -- Band-pass filter. Both high and low frequency sounds are attenuated based on the given parameters.

---Types of audio sources.
---
---A good rule of thumb is to use stream for music files and static for all short sound effects. Basically, you want to avoid loading large files into memory at once.
---
---[Open in Browser](https://love2d.org/wiki/SourceType)
---
---@alias SourceType
---| "static" -- The whole audio is decoded.
---| "stream" -- The audio is decoded in chunks when needed.
---| "queue" -- The audio must be manually queued by the user.

---Units that represent time.
---
---[Open in Browser](https://love2d.org/wiki/TimeUnit)
---
---@alias TimeUnit
---| "seconds" -- Regular seconds.
---| "samples" -- Audio samples.

---Gets a list of the names of the currently enabled effects.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getActiveEffects)
---
---@return table
function love.audio.getActiveEffects() end

---Gets the current number of simultaneously playing sources.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getActiveSourceCount)
---
---@return number
function love.audio.getActiveSourceCount() end

---Returns the distance attenuation model.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getDistanceModel)
---
---@return love.DistanceModel
function love.audio.getDistanceModel() end

---Gets the current global scale factor for velocity-based doppler effects.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getDopplerScale)
---
---@return number
function love.audio.getDopplerScale() end

---Gets the settings associated with an effect.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getEffect)
---
---@param name string # The name of the effect.
---@return table
function love.audio.getEffect(name) end

---Gets the maximum number of active effects supported by the system.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getMaxSceneEffects)
---
---@return number
function love.audio.getMaxSceneEffects() end

---Gets the maximum number of active Effects in a single Source object, that the system can support.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getMaxSourceEffects)
---
---@return number
function love.audio.getMaxSourceEffects() end

---Returns the orientation of the listener.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getOrientation)
---
---@return number, number, number, number, number, number
function love.audio.getOrientation() end

---Returns the position of the listener. Please note that positional audio only works for mono (i.e. non-stereo) sources.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getPosition)
---
---@return number, number, number
function love.audio.getPosition() end

---Gets a list of RecordingDevices on the system.
---
---The first device in the list is the user's default recording device. The list may be empty if there are no microphones connected to the system.
---
---Audio recording is currently not supported on iOS.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getRecordingDevices)
---
---@return table
function love.audio.getRecordingDevices() end

---Returns the velocity of the listener.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getVelocity)
---
---@return number, number, number
function love.audio.getVelocity() end

---Returns the master volume.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.getVolume)
---
---@return number
function love.audio.getVolume() end

---Gets whether audio effects are supported in the system.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.isEffectsSupported)
---
---@return boolean
function love.audio.isEffectsSupported() end

---Creates a new Source usable for real-time generated sound playback with Source:queue.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.newQueueableSource)
---
---@param samplerate number # Number of samples per second when playing.
---@param bitdepth number # Bits per sample (8 or 16).
---@param channels number # 1 for mono or 2 for stereo.
---@param buffercount number? # The number of buffers that can be queued up at any given time with Source:queue. Cannot be greater than 64. A sensible default (~8) is chosen if no value is specified. (Defaults to 0.)
---@return love.Source
function love.audio.newQueueableSource(samplerate, bitdepth, channels, buffercount) end

---Creates a new Source from a filepath, File, Decoder or SoundData.
---
---Sources created from SoundData are always static.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.newSource)
---
---@param filename string # The filepath to the audio file.
---@param type love.SourceType # Streaming or static source.
---@return love.Source
---@overload fun(data:love.FileData, type:love.SourceType):love.Source
---@overload fun(decoder:love.Decoder, type:love.SourceType):love.Source
---@overload fun(file:love.File, type:love.SourceType):love.Source
---@overload fun(data:love.SoundData):love.Source
function love.audio.newSource(filename, type) end

---Pauses specific or all currently played Sources.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.pause)
---
---@param source love.Source # The first Source to pause.
---@vararg love.Source # Additional Sources to pause.
---
---Pauses the given Sources.
---@overload fun(sources:table):nil
---
---Pauses all currently active Sources and returns them.
---@overload fun():table
function love.audio.pause(source, ...) end

---Plays the specified Source.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.play)
---
---@param source1 love.Source # The first Source to play.
---@param source2 love.Source # The second Source to play.
---@vararg love.Source # Additional Sources to play.
---
---Starts playing multiple Sources simultaneously.
---@overload fun(sources:table):nil
---@overload fun(source:love.Source):nil
function love.audio.play(source1, source2, ...) end

---Sets the distance attenuation model.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setDistanceModel)
---
---@param model love.DistanceModel # The new distance model.
function love.audio.setDistanceModel(model) end

---Sets a global scale factor for velocity-based doppler effects. The default scale value is 1.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setDopplerScale)
---
---@param scale number # The new doppler scale factor. The scale must be greater than 0.
function love.audio.setDopplerScale(scale) end

---Defines an effect that can be applied to a Source.
---
---Not all system supports audio effects. Use love.audio.isEffectsSupported to check.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setEffect)
---
---@param name string # The name of the effect.
---@param settings {type:love.EffectType, or volume:number, or ...:number} # The settings to use for this effect, with the following fields:
---@return boolean
---@overload fun(name:string, enabled:boolean?):boolean
function love.audio.setEffect(name, settings) end

---Sets whether the system should mix the audio with the system's audio.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setMixWithSystem)
---
---@param mix boolean # True to enable mixing, false to disable it.
---@return boolean
function love.audio.setMixWithSystem(mix) end

---Sets the orientation of the listener.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setOrientation)
---
---@param fx number # Forward vector of the listener orientation.
---@param fy number # Forward vector of the listener orientation.
---@param fz number # Forward vector of the listener orientation.
---@param ux number # Up vector of the listener orientation.
---@param uy number # Up vector of the listener orientation.
---@param uz number # Up vector of the listener orientation.
function love.audio.setOrientation(fx, fy, fz, ux, uy, uz) end

---Sets the position of the listener, which determines how sounds play.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setPosition)
---
---@param x number # The x position of the listener.
---@param y number # The y position of the listener.
---@param z number # The z position of the listener.
function love.audio.setPosition(x, y, z) end

---Sets the velocity of the listener.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setVelocity)
---
---@param x number # The X velocity of the listener.
---@param y number # The Y velocity of the listener.
---@param z number # The Z velocity of the listener.
function love.audio.setVelocity(x, y, z) end

---Sets the master volume.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.setVolume)
---
---@param volume number # 1.0 is max and 0.0 is off.
function love.audio.setVolume(volume) end

---Stops currently played sources.
---
---[Open in Browser](https://love2d.org/wiki/love.audio.stop)
---
---@param source1 love.Source # The first Source to stop.
---@param source2 love.Source # The second Source to stop.
---@vararg love.Source # Additional Sources to stop.
---
---Simultaneously stops all given Sources.
---@overload fun(sources:table):nil
---
---This function will only stop the specified source.
---@overload fun(source:love.Source):nil
---
---This function will stop all currently active sources.
---@overload fun():nil
function love.audio.stop(source1, source2, ...) end

