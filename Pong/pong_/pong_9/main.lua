push = require 'push'
Class = require 'class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIR_WIDTH = 432
VIR_HEIGHT = 243

PADDLE_SPEED = 200

--[[
    Start Function 
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(VIR_WIDTH, VIR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIR_WIDTH - 10, VIR_HEIGHT - 30, 5, 20)
    ball = Ball(VIR_WIDTH / 2 - 2, VIR_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 1

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end
--[[
    Update function
]]
function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1  then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then
        
        if  ball:Collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end

        if ball:Collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y >= VIR_HEIGHT -4 then
            ball.y = VIR_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
    end

    if ball.x < 0 then
        servingPlayer = 2
        player2Score = player2Score + 1
        sounds['score']:play()
        if player2Score >= 10 then 
            winningPlayer = 2
            gameState = 'done'
            ball:reset()
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    if ball.x > VIR_WIDTH then
        servingPlayer = 1
        player1Score = player1Score + 1
        sounds['score']:play()
        if player1Score >= 10 then
            winningPlayer = 1
            gameState = 'done'
            ball:reset()
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    --[[
        players movement
    ]]
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

--[[
    event Handler function
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == "enter" or key == 'return' then
        if gameState == "start" then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            
            ball:reset()
            
            player1Score = 0
            player2Score = 0
            
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

--[[
    render function 
]]
function love.draw()
    push:apply('start')
    
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setFont(scoreFont)
    
    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong', 0, 10, VIR_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin', 0, 20, VIR_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player'..tostring(servingPlayer)..'s serve!', 0, 10, VIR_WIDTH, 'center')
        love.graphics.printf('Press enter to serve!', 0, 20, VIR_WIDTH, 'center')
    elseif gameState == 'play' then
        -- nothing
    elseif gameState == 'done'then
        love.graphics.setFont(smallFont)
        love.graphics.printf('player'..tostring(winningPlayer)..'wins!', 0 ,10, VIR_WIDTH, 'center')
        love.graphics.printf('Press enter to restart', 0, 30, VIR_WIDTH, 'center')
    end


    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push:apply('end')
end

--[[
    Game FPS function
]]
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS:'.. tostring(love.timer.getFPS(), 10, 10))
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIR_WIDTH / 2 - 50, VIR_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIR_WIDTH / 2 + 50, VIR_HEIGHT / 3)
end