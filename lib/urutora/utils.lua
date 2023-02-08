local utils = {
  default_font = love.graphics.newFont(14),
  nodeTypes = {
    LABEL 	= 1,
    BUTTON 	= 2,
    SLIDER 	= 3,
    TOGGLE 	= 4,
    TEXT 	  = 5,
    MULTI 	= 6,
    PANEL 	= 7,
    JOY 	  = 8,
    IMAGE   = 9,
    ANIMATION = 10
  },
  alignments = {
    LEFT	= 'left',
    CENTER 	= 'center',
    RIGHT 	= 'right'
  },
  mouseButtons = {
    LEFT = 1,
    RIGHT = 2
  },
  sx = 1,
  sy = 1,
  scroll_speed = 0.1,
}

function utils.isLabel(node) return node.type == utils.nodeTypes.LABEL end
function utils.isPanel(node) return node.type == utils.nodeTypes.PANEL end
function utils.isMulti(node) return node.type == utils.nodeTypes.MULTI_OPTION end
function utils.isImage(node) return node.type == utils.nodeTypes.IMAGE end
function utils.isAnimation(node) return node.type == utils.nodeTypes.ANIMATION end
function utils.isToggle(node) return node.type == utils.nodeTypes.TOGGLE end
function utils.isSlider(node) return node.type == utils.nodeTypes.SLIDER end
function utils.isButton(node) return node.type == utils.nodeTypes.BUTTON end
function utils.isTextField(node) return node.type == utils.nodeTypes.TEXT end
function utils.isJoy(node) return node.type == utils.nodeTypes.JOY end

function utils.textWidth(node)
  if not node.text then return 0 end
  local font = node.style.font or utils.default_font
  return font:getWidth(tostring(node.text))
end

function utils.textHeight(node)
  if not node.text then return 0 end
  local font = node.style.font or utils.default_font
  return font:getHeight()
end

function utils.darker(color, amount)
  amount = 1 - (amount or 0.2)
  local r, g, b = color[1], color[2], color[3]
  r = r * amount
  g = g * amount
  b = b * amount

  return { r, g, b, color[4] }
end

function utils.brighter(color, amount)
  amount = amount or 0.2
  local r, g, b = color[1], color[2], color[3]
  r = r + ((1 - r) * amount)
  g = g + ((1 - g) * amount)
  b = b + ((1 - b) * amount)

  return { r, g, b, color[4] }
end

utils.colors = {
  BLACK           = { love.math.colorFromBytes(0, 0, 0) },
  WHITE           = { love.math.colorFromBytes(222, 238, 214) },
  GRAY            = { love.math.colorFromBytes(78, 74, 78) },
  DARK_GRAY       = { love.math.colorFromBytes(20, 12, 28) },
  LOVE_BLUE       = { love.math.colorFromBytes(89, 157, 220) },
  LOVE_BLUE_LIGHT = { love.math.colorFromBytes(99, 175, 245) },
  RED             = { love.math.colorFromBytes(208, 70, 72) },
}

utils.style = {
  padding = utils.default_font:getHeight() / 2,
  bgColor = utils.colors.LOVE_BLUE,
  fgColor = utils.colors.WHITE,
  disablebgColor = utils.colors.GRAY,
  disablefgColor = utils.colors.DARK_GRAY,
}

function utils.withOpacity(color, alpha)
  local newColor = { unpack(color) }
  table.insert(newColor, alpha)

  return newColor
end

function utils.needsBase(node)
  return not (
    utils.isAnimation(node) or
    utils.isPanel(node) or
    utils.isLabel(node) or
    utils.isTextField(node) or
    utils.isJoy(node) or
    utils.isImage(node)
  )
end

function utils.print(text, x, y)
  love.graphics.print(text, math.floor(x), math.floor(y))
end

function utils.prettyPrint(text, x, y, data)
  love.graphics.setColor(data.bgColor or {0, 0, 0})
  love.graphics.print(text, math.floor(x - 1), math.floor(y + 1))
  love.graphics.setColor(data.fgColor or {1, 1, 1})
  love.graphics.print(text, math.floor(x), math.floor(y))
end

function utils.rect(mode, x, y, w, h, rx, ry, segments)
  love.graphics.rectangle(mode,
    math.floor(x),
    math.floor(y),
    math.floor(w),
    math.floor(h),
    rx, ry, segments
  )
end

function utils.line(a, b, c, d)
  love.graphics.line(math.floor(a), math.floor(b), math.floor(c), math.floor(d))
end

function utils.circ(mode, x, y, r)
  love.graphics.circle(mode, math.floor(x), math.floor(y), math.floor(r))
end

function utils.getMouse()
  return love.mouse.getX() / utils.sx, love.mouse.getY() / utils.sy
end

function utils.pointInsideRect(px, py, x, y, w, h)
  return not (
    px < (x) or
    px > (x + w) or
    py < (y) or
    py > (y + h)
  )
end

utils.disabledImgShader = love.graphics.newShader([[
  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(texture, texture_coords);
    number average = (pixel.r + pixel.b + pixel.g) / 3.0;
    pixel.r = average * 0.5;
    pixel.g = average * 0.5;
    pixel.b = average * 0.5;
    return pixel;
  }
]])

return utils
