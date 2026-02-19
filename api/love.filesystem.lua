---@meta
---@namespace love

---Provides an interface to the user's filesystem.
love.filesystem = {}

--region DroppedFile

---Represents a file dropped onto the window.
---
---Note that the DroppedFile type can only be obtained from love.filedropped callback, and can't be constructed manually by the user.
---
---[Open in Browser](https://love2d.org/wiki/DroppedFile)
---
---@class DroppedFile : File, Object
local DroppedFile = {}
--endregion DroppedFile

--region File

---Represents a file on the filesystem. A function that takes a file path can also take a File.
---
---[Open in Browser](https://love2d.org/wiki/File)
---
---@class File : Object
local File = {}
---Closes a File.
---
---[Open in Browser](https://love2d.org/wiki/File.close)
---
---@return boolean
function File:close() end

---Flushes any buffered written data in the file to the disk.
---
---[Open in Browser](https://love2d.org/wiki/File.flush)
---
---@return boolean, string
function File:flush() end

---Gets the buffer mode of a file.
---
---[Open in Browser](https://love2d.org/wiki/File.getBuffer)
---
---@return love.BufferMode, number
function File:getBuffer() end

---Gets the filename that the File object was created with. If the file object originated from the love.filedropped callback, the filename will be the full platform-dependent file path.
---
---[Open in Browser](https://love2d.org/wiki/File.getFilename)
---
---@return string
function File:getFilename() end

---Gets the FileMode the file has been opened with.
---
---[Open in Browser](https://love2d.org/wiki/File.getMode)
---
---@return love.FileMode
function File:getMode() end

---Returns the file size.
---
---[Open in Browser](https://love2d.org/wiki/File.getSize)
---
---@return number
function File:getSize() end

---Gets whether end-of-file has been reached.
---
---[Open in Browser](https://love2d.org/wiki/File.isEOF)
---
---@return boolean
function File:isEOF() end

---Gets whether the file is open.
---
---[Open in Browser](https://love2d.org/wiki/File.isOpen)
---
---@return boolean
function File:isOpen() end

---Iterate over all the lines in a file.
---
---[Open in Browser](https://love2d.org/wiki/File.lines)
---
---@return function
function File:lines() end

---Open the file for write, read or append.
---
---[Open in Browser](https://love2d.org/wiki/File.open)
---
---@param mode love.FileMode # The mode to open the file in.
---@return boolean, string
function File:open(mode) end

---Read a number of bytes from a file.
---
---[Open in Browser](https://love2d.org/wiki/File.read)
---
---@param container love.ContainerType # What type to return the file's contents as.
---@param bytes number? # The number of bytes to read. (Defaults to all.)
---@return love.FileData | string, number
---@overload fun(self:File, bytes:number?):string, number
function File:read(container, bytes) end

---Seek to a position in a file
---
---[Open in Browser](https://love2d.org/wiki/File.seek)
---
---@param pos number # The position to seek to
---@return boolean
function File:seek(pos) end

---Sets the buffer mode for a file opened for writing or appending. Files with buffering enabled will not write data to the disk until the buffer size limit is reached, depending on the buffer mode.
---
---File:flush will force any buffered data to be written to the disk.
---
---[Open in Browser](https://love2d.org/wiki/File.setBuffer)
---
---@param mode love.BufferMode # The buffer mode to use.
---@param size number? # The maximum size in bytes of the file's buffer. (Defaults to 0.)
---@return boolean, string
function File:setBuffer(mode, size) end

---Returns the position in the file.
---
---[Open in Browser](https://love2d.org/wiki/File.tell)
---
---@return number
function File:tell() end

---Write data to a file.
---
---[Open in Browser](https://love2d.org/wiki/File.write)
---
---@param data string # The string data to write.
---@param size number? # How many bytes to write. (Defaults to all.)
---@return boolean, string
---
---'''Writing to multiple lines''': In Windows, some text editors (e.g. Notepad before Windows 10 1809) only treat CRLF ('\r\n') as a new line.
---
-----example
---
---f = love.filesystem.newFile('note.txt')
---
---f:open('w')
---
---for i = 1, 10 do
---
---    f:write('This is line '..i..'!\r\n')
---
---end
---
---f:close()
---@overload fun(self:File, data:love.Data, size:number?):boolean, string
function File:write(data, size) end

--endregion File

--region FileData

---Data representing the contents of a file.
---
---[Open in Browser](https://love2d.org/wiki/FileData)
---
---@class FileData : Data, Object
local FileData = {}
---Gets the extension of the FileData.
---
---[Open in Browser](https://love2d.org/wiki/FileData.getExtension)
---
---@return string
function FileData:getExtension() end

---Gets the filename of the FileData.
---
---[Open in Browser](https://love2d.org/wiki/FileData.getFilename)
---
---@return string
function FileData:getFilename() end

--endregion FileData

---Buffer modes for File objects.
---
---[Open in Browser](https://love2d.org/wiki/BufferMode)
---
---@alias BufferMode
---| "none" -- No buffering. The result of write and append operations appears immediately.
---| "line" -- Line buffering. Write and append operations are buffered until a newline is output or the buffer size limit is reached.
---| "full" -- Full buffering. Write and append operations are always buffered until the buffer size limit is reached.

---How to decode a given FileData.
---
---[Open in Browser](https://love2d.org/wiki/FileDecoder)
---
---@alias FileDecoder
---| "file" -- The data is unencoded.
---| "base64" -- The data is base64-encoded.

---The different modes you can open a File in.
---
---[Open in Browser](https://love2d.org/wiki/FileMode)
---
---@alias FileMode
---| "r" -- Open a file for read.
---| "w" -- Open a file for write.
---| "a" -- Open a file for append.
---| "c" -- Do not open a file (represents a closed file.)

---The type of a file.
---
---[Open in Browser](https://love2d.org/wiki/FileType)
---
---@alias FileType
---| "file" -- Regular file.
---| "directory" -- Directory.
---| "symlink" -- Symbolic link.
---| "other" -- Something completely different like a device.

---Append data to an existing file.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.append)
---
---@param name string # The name (and path) of the file.
---@param data string # The string data to append to the file.
---@param size number? # How many bytes to write. (Defaults to all.)
---@return boolean, string
---@overload fun(name:string, data:love.Data, size:number?):boolean, string
function love.filesystem.append(name, data, size) end

---Gets whether love.filesystem follows symbolic links.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.areSymlinksEnabled)
---
---@return boolean
function love.filesystem.areSymlinksEnabled() end

---Recursively creates a directory.
---
---When called with 'a/b' it creates both 'a' and 'a/b', if they don't exist already.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.createDirectory)
---
---@param name string # The directory to create.
---@return boolean
function love.filesystem.createDirectory(name) end

---Returns the application data directory (could be the same as getUserDirectory)
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getAppdataDirectory)
---
---@return string
function love.filesystem.getAppdataDirectory() end

---Gets the filesystem paths that will be searched for c libraries when require is called.
---
---The paths string returned by this function is a sequence of path templates separated by semicolons. The argument passed to ''require'' will be inserted in place of any question mark ('?') character in each template (after the dot characters in the argument passed to ''require'' are replaced by directory separators.) Additionally, any occurrence of a double question mark ('??') will be replaced by the name passed to require and the default library extension for the platform.
---
---The paths are relative to the game's source and save directories, as well as any paths mounted with love.filesystem.mount.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getCRequirePath)
---
---@return string
function love.filesystem.getCRequirePath() end

---Returns a table with the names of files and subdirectories in the specified path. The table is not sorted in any way; the order is undefined.
---
---If the path passed to the function exists in the game and the save directory, it will list the files and directories from both places.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getDirectoryItems)
---
---@param dir string # The directory.
---@param callback function # A function which is called for each file and folder in the directory. The filename is passed to the function as an argument.
---@return table
---@overload fun(dir:string):table
function love.filesystem.getDirectoryItems(dir, callback) end

---Gets the write directory name for your game. 
---
---Note that this only returns the name of the folder to store your files in, not the full path.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getIdentity)
---
---@return string
function love.filesystem.getIdentity() end

---Gets information about the specified file or directory.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getInfo)
---
---@param path string # The file or directory path to check.
---@param filtertype love.FileType # Causes getInfo to only return the info table if the item at the given path matches the specified file type.
---@param info table # A table which will be filled in with info about the specified path.
---@return {type:love.FileType, size:number, modtime:number}
---
---This variant accepts an existing table to fill in, instead of creating a new one.
---@overload fun(path:string, info:table):{type:love.FileType, size:number, modtime:number}
---@overload fun(path:string, filtertype:love.FileType?):{type:love.FileType, size:number, modtime:number}
function love.filesystem.getInfo(path, filtertype, info) end

---Gets the platform-specific absolute path of the directory containing a filepath.
---
---This can be used to determine whether a file is inside the save directory or the game's source .love.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getRealDirectory)
---
---@param filepath string # The filepath to get the directory of.
---@return string
function love.filesystem.getRealDirectory(filepath) end

---Gets the filesystem paths that will be searched when require is called.
---
---The paths string returned by this function is a sequence of path templates separated by semicolons. The argument passed to ''require'' will be inserted in place of any question mark ('?') character in each template (after the dot characters in the argument passed to ''require'' are replaced by directory separators.)
---
---The paths are relative to the game's source and save directories, as well as any paths mounted with love.filesystem.mount.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getRequirePath)
---
---@return string
function love.filesystem.getRequirePath() end

---Gets the full path to the designated save directory.
---
---This can be useful if you want to use the standard io library (or something else) to
---
---read or write in the save directory.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getSaveDirectory)
---
---@return string
function love.filesystem.getSaveDirectory() end

---Returns the full path to the the .love file or directory. If the game is fused to the LÖVE executable, then the executable is returned.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getSource)
---
---@return string
function love.filesystem.getSource() end

---Returns the full path to the directory containing the .love file. If the game is fused to the LÖVE executable, then the directory containing the executable is returned.
---
---If love.filesystem.isFused is true, the path returned by this function can be passed to love.filesystem.mount, which will make the directory containing the main game (e.g. C:\Program Files\coolgame\) readable by love.filesystem.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getSourceBaseDirectory)
---
---@return string
function love.filesystem.getSourceBaseDirectory() end

---Returns the path of the user's directory
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getUserDirectory)
---
---@return string
function love.filesystem.getUserDirectory() end

---Gets the current working directory.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.getWorkingDirectory)
---
---@return string
function love.filesystem.getWorkingDirectory() end

---Initializes love.filesystem, will be called internally, so should not be used explicitly.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.init)
---
---@param appname string # The name of the application binary, typically love.
function love.filesystem.init(appname) end

---Gets whether the game is in fused mode or not.
---
---If a game is in fused mode, its save directory will be directly in the Appdata directory instead of Appdata/LOVE/. The game will also be able to load C Lua dynamic libraries which are located in the save directory.
---
---A game is in fused mode if the source .love has been fused to the executable (see Game Distribution), or if '--fused' has been given as a command-line argument when starting the game.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.isFused)
---
---@return boolean
function love.filesystem.isFused() end

---Iterate over the lines in a file.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.lines)
---
---@param name string # The name (and path) of the file
---@return function
function love.filesystem.lines(name) end

---Loads a Lua file (but does not run it).
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.load)
---
---@param name string # The name (and path) of the file.
---@return function, string
function love.filesystem.load(name) end

---Mounts a zip file or folder in the game's save directory for reading.
---
---It is also possible to mount love.filesystem.getSourceBaseDirectory if the game is in fused mode.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.mount)
---
---@param data love.Data # The Data object in memory to mount.
---@param archivename string # The name to associate the mounted data with, for use with love.filesystem.unmount. Must be unique compared to other mounted data.
---@param mountpoint string # The new path the archive will be mounted to.
---@param appendToPath boolean? # Whether the archive will be searched when reading a filepath before or after already-mounted archives. This includes the game's source and save directories. (Defaults to false.)
---@return boolean
---
---Mounts the contents of the given FileData in memory. The FileData's data must contain a zipped directory structure.
---@overload fun(filedata:love.FileData, mountpoint:string, appendToPath:boolean?):boolean
---@overload fun(archive:string, mountpoint:string, appendToPath:boolean?):boolean
function love.filesystem.mount(data, archivename, mountpoint, appendToPath) end

---Creates a new File object. 
---
---It needs to be opened before it can be accessed.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.newFile)
---
---@param filename string # The filename of the file.
---@param mode love.FileMode # The mode to open the file in.
---@return love.File, string
---
---Please note that this function will not return any error message (e.g. if you use an invalid filename) because it just creates the File Object. You can still check if the file is valid by using File:open which returns a boolean and an error message if something goes wrong while opening the file.
---@overload fun(filename:string):love.File
function love.filesystem.newFile(filename, mode) end

---Creates a new FileData object from a file on disk, or from a string in memory.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.newFileData)
---
---@param contents string # The contents of the file in memory represented as a string.
---@param name string # The name of the file. The extension may be parsed and used by LÖVE when passing the FileData object into love.audio.newSource.
---@return love.FileData
---
---Creates a new FileData object from a Data object in memory.
---@overload fun(originaldata:love.Data, name:string):love.FileData
---
---Creates a new FileData from a file on the storage device.
---@overload fun(filepath:string):love.FileData, string
function love.filesystem.newFileData(contents, name) end

---Read the contents of a file.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.read)
---
---@param container love.ContainerType # What type to return the file's contents as.
---@param name string # The name (and path) of the file
---@param size number? # How many bytes to read (Defaults to all.)
---@return love.FileData | string, number, nil, string
---@overload fun(name:string, size:number?):string, number, nil, string
function love.filesystem.read(container, name, size) end

---Removes a file or empty directory.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.remove)
---
---@param name string # The file or directory to remove.
---@return boolean
function love.filesystem.remove(name) end

---Sets the filesystem paths that will be searched for c libraries when require is called.
---
---The paths string returned by this function is a sequence of path templates separated by semicolons. The argument passed to ''require'' will be inserted in place of any question mark ('?') character in each template (after the dot characters in the argument passed to ''require'' are replaced by directory separators.) Additionally, any occurrence of a double question mark ('??') will be replaced by the name passed to require and the default library extension for the platform.
---
---The paths are relative to the game's source and save directories, as well as any paths mounted with love.filesystem.mount.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.setCRequirePath)
---
---@param paths string # The paths that the ''require'' function will check in love's filesystem.
function love.filesystem.setCRequirePath(paths) end

---Sets the write directory for your game. 
---
---Note that you can only set the name of the folder to store your files in, not the location.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.setIdentity)
---
---@param name string # The new identity that will be used as write directory.
---@overload fun(name:string):nil
function love.filesystem.setIdentity(name) end

---Sets the filesystem paths that will be searched when require is called.
---
---The paths string given to this function is a sequence of path templates separated by semicolons. The argument passed to ''require'' will be inserted in place of any question mark ('?') character in each template (after the dot characters in the argument passed to ''require'' are replaced by directory separators.)
---
---The paths are relative to the game's source and save directories, as well as any paths mounted with love.filesystem.mount.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.setRequirePath)
---
---@param paths string # The paths that the ''require'' function will check in love's filesystem.
function love.filesystem.setRequirePath(paths) end

---Sets the source of the game, where the code is present. This function can only be called once, and is normally automatically done by LÖVE.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.setSource)
---
---@param path string # Absolute path to the game's source folder.
function love.filesystem.setSource(path) end

---Sets whether love.filesystem follows symbolic links. It is enabled by default in version 0.10.0 and newer, and disabled by default in 0.9.2.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.setSymlinksEnabled)
---
---@param enable boolean # Whether love.filesystem should follow symbolic links.
function love.filesystem.setSymlinksEnabled(enable) end

---Unmounts a zip file or folder previously mounted for reading with love.filesystem.mount.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.unmount)
---
---@param archive string # The folder or zip file in the game's save directory which is currently mounted.
---@return boolean
function love.filesystem.unmount(archive) end

---Write data to a file in the save directory. If the file existed already, it will be completely replaced by the new contents.
---
---[Open in Browser](https://love2d.org/wiki/love.filesystem.write)
---
---@param name string # The name (and path) of the file.
---@param data string # The string data to write to the file.
---@param size number? # How many bytes to write. (Defaults to all.)
---@return boolean, string
---
---If you are getting the error message 'Could not set write directory', try setting the save directory. This is done either with love.filesystem.setIdentity or by setting the identity field in love.conf.
---
---'''Writing to multiple lines''': In Windows, some text editors (e.g. Notepad) only treat CRLF ('\r\n') as a new line.
---@overload fun(name:string, data:love.Data, size:number?):boolean, string
function love.filesystem.write(name, data, size) end

