push = require 'push'
Class = require 'class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIR_WIDTH = 432
VIR_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIR_WIDTH, VIR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        fullscreen = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIR_WIDTH - 10, VIR_HEIGHT - 30, 5, 20)
    
    ball = Ball(VIR_WIDTH / 2 - 2, VIR_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

--[[
    A Game state concept added
]]
function love.update(dt)
    if gameState == 'play' then
        
        if ball:Collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:Collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
    end
    
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    if ball.y >= VIR_HEIGHT - 4 then
        ball.y = VIR_HEIGHT - 4
        ball.dy = -ball.dy
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end


    if gameState == "play" then
        ball:update(dt)
    end
    
    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == "enter" or key == 'return' then
        if gameState == "start" then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(smallFont)
    
    if gameState == 'start' then
        love.graphics.printf('Hello Play State', 0, 20, VIR_WIDTH, 'center')
    else
        love.graphics.printf('Hello Start State', 0, 20, VIR_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIR_WIDTH / 2 - 50, VIR_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIR_WIDTH / 2 + 30, VIR_HEIGHT / 3)


    player1:render()
    player2:render()

    ball:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS:'.. tostring(love.timer.getFPS(), 10, 10))
end