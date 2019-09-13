WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VER_WIDTH = 432
VER_HEIGHT = 243

push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')--*
    push:setupScreen(VER_WIDTH, VER_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
    })
end

function love.keypressed(key)
    if key == "q" then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')
    love.graphics.printf(
        'Hello pong', 
        0,
        VER_HEIGHT / 2 - 6,
        VER_WIDTH,
        'center')

    push:apply('end')
end
