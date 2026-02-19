---@meta
---@namespace love

---Allows you to work with fonts.
love.font = {}

--region GlyphData

---A GlyphData represents a drawable symbol of a font Rasterizer.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData)
---
---@class GlyphData : Data, Object
local GlyphData = {}
---Gets glyph advance.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getAdvance)
---
---@return number
function GlyphData:getAdvance() end

---Gets glyph bearing.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getBearing)
---
---@return number, number
function GlyphData:getBearing() end

---Gets glyph bounding box.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getBoundingBox)
---
---@return number, number, number, number
function GlyphData:getBoundingBox() end

---Gets glyph dimensions.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getDimensions)
---
---@return number, number
function GlyphData:getDimensions() end

---Gets glyph pixel format.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getFormat)
---
---@return love.PixelFormat
function GlyphData:getFormat() end

---Gets glyph number.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getGlyph)
---
---@return number
function GlyphData:getGlyph() end

---Gets glyph string.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getGlyphString)
---
---@return string
function GlyphData:getGlyphString() end

---Gets glyph height.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getHeight)
---
---@return number
function GlyphData:getHeight() end

---Gets glyph width.
---
---[Open in Browser](https://love2d.org/wiki/GlyphData.getWidth)
---
---@return number
function GlyphData:getWidth() end

--endregion GlyphData

--region Rasterizer

---A Rasterizer handles font rendering, containing the font data (image or TrueType font) and drawable glyphs.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer)
---
---@class Rasterizer : Object
local Rasterizer = {}
---Gets font advance.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getAdvance)
---
---@return number
function Rasterizer:getAdvance() end

---Gets ascent height.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getAscent)
---
---@return number
function Rasterizer:getAscent() end

---Gets descent height.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getDescent)
---
---@return number
function Rasterizer:getDescent() end

---Gets number of glyphs in font.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getGlyphCount)
---
---@return number
function Rasterizer:getGlyphCount() end

---Gets glyph data of a specified glyph.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getGlyphData)
---
---@param glyph string # Glyph
---@return love.GlyphData
---@overload fun(self:Rasterizer, glyphNumber:number):love.GlyphData
function Rasterizer:getGlyphData(glyph) end

---Gets font height.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getHeight)
---
---@return number
function Rasterizer:getHeight() end

---Gets line height of a font.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.getLineHeight)
---
---@return number
function Rasterizer:getLineHeight() end

---Checks if font contains specified glyphs.
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer.hasGlyphs)
---
---@param glyph1 string # Glyph
---@vararg string # Additional glyphs
---@return boolean
function Rasterizer:hasGlyphs(glyph1, ...) end

--endregion Rasterizer

---True Type hinting mode.
---
---[Open in Browser](https://love2d.org/wiki/HintingMode)
---
---@alias HintingMode
---| "normal" -- Default hinting. Should be preferred for typical antialiased fonts.
---| "light" -- Results in fuzzier text but can sometimes preserve the original glyph shapes of the text better than normal hinting.
---| "mono" -- Results in aliased / unsmoothed text with either full opacity or completely transparent pixels. Should be used when antialiasing is not desired for the font.
---| "none" -- Disables hinting for the font. Results in fuzzier text.

---Creates a new BMFont Rasterizer.
---
---[Open in Browser](https://love2d.org/wiki/love.font.newBMFontRasterizer)
---
---@param imageData love.ImageData # The image data containing the drawable pictures of font glyphs.
---@param glyphs string # The sequence of glyphs in the ImageData.
---@param dpiscale number? # DPI scale. (Defaults to 1.)
---@return love.Rasterizer
---@overload fun(fileName:string, glyphs:string, dpiscale:number?):love.Rasterizer
function love.font.newBMFontRasterizer(imageData, glyphs, dpiscale) end

---Creates a new GlyphData.
---
---[Open in Browser](https://love2d.org/wiki/love.font.newGlyphData)
---
---@param rasterizer love.Rasterizer # The Rasterizer containing the font.
---@param glyph number # The character code of the glyph.
function love.font.newGlyphData(rasterizer, glyph) end

---Creates a new Image Rasterizer.
---
---[Open in Browser](https://love2d.org/wiki/love.font.newImageRasterizer)
---
---@param imageData love.ImageData # Font image data.
---@param glyphs string # String containing font glyphs.
---@param extraSpacing number? # Font extra spacing. (Defaults to 0.)
---@param dpiscale number? # Font DPI scale. (Defaults to 1.)
---@return love.Rasterizer
function love.font.newImageRasterizer(imageData, glyphs, extraSpacing, dpiscale) end

---Creates a new Rasterizer.
---
---[Open in Browser](https://love2d.org/wiki/love.font.newRasterizer)
---
---@param fileName string # Path to font file.
---@param size number? # The font size. (Defaults to 12.)
---@param hinting love.HintingMode? # True Type hinting mode. (Defaults to 'normal'.)
---@param dpiscale number? # The font DPI scale. (Defaults to love.window.getDPIScale().)
---@return love.Rasterizer
---
---Create a TrueTypeRasterizer with custom font.
---@overload fun(fileData:love.FileData, size:number?, hinting:love.HintingMode?, dpiscale:number?):love.Rasterizer
---
---Creates a new BMFont Rasterizer.
---@overload fun(imageData:love.ImageData, glyphs:string, dpiscale:number?):love.Rasterizer
---
---Creates a new BMFont Rasterizer.
---@overload fun(fileName:string, glyphs:string, dpiscale:number?):love.Rasterizer
---
---Create a TrueTypeRasterizer with the default font.
---@overload fun(size:number?, hinting:love.HintingMode?, dpiscale:number?):love.Rasterizer
---@overload fun(data:love.FileData):love.Rasterizer
---@overload fun(filename:string):love.Rasterizer
function love.font.newRasterizer(fileName, size, hinting, dpiscale) end

---Creates a new TrueType Rasterizer.
---
---[Open in Browser](https://love2d.org/wiki/love.font.newTrueTypeRasterizer)
---
---@param fileData love.FileData # File data containing font.
---@param size number? # The font size. (Defaults to 12.)
---@param hinting love.HintingMode? # True Type hinting mode. (Defaults to 'normal'.)
---@param dpiscale number? # The font DPI scale. (Defaults to love.window.getDPIScale().)
---@return love.Rasterizer
---
---Create a TrueTypeRasterizer with custom font.
---@overload fun(fileName:string, size:number?, hinting:love.HintingMode?, dpiscale:number?):love.Rasterizer
---
---Create a TrueTypeRasterizer with the default font.
---@overload fun(size:number?, hinting:love.HintingMode?, dpiscale:number?):love.Rasterizer
function love.font.newTrueTypeRasterizer(fileData, size, hinting, dpiscale) end

