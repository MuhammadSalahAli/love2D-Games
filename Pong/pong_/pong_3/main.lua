push = require "push"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIR_WIDTH = 432
VIR_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)
    push:setupScreen(VIR_WIDTH, VIR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscren=false,
        resizable=false,
        vsync=true,
    })

    player1score = 0
    player2score = 0

    player1Y = 30
    player2Y = VIR_HEIGHT - 50
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    end
    
    if love.keyboard.isDown('s') then 
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then 
        player2Y = player2Y + -PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIR_WIDTH, 'center')
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1score), VIR_WIDTH/2-50, VIR_HEIGHT/3)--*
    love.graphics.print(tostring(player2score), VIR_WIDTH / 2 + 30, VIR_HEIGHT / 3)--*
    
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', VIR_WIDTH - 10, player2Y, 5, 20)
    love.graphics.rectangle('fill', VIR_WIDTH / 2 - 2, VIR_HEIGHT / 2 - 2, 4, 4)

    push:apply('end')
end
