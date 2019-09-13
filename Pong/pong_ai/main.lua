WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIR_WIDTH = 432
VIR_HEIGHT = 243

push = require 'push'
Class = require 'class'
require 'Ball'
require 'Paddle'

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIR_WIDTH, VIR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen=false, 
        resizable=true,
        vsync=true
    })

    sounds = {
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static')
    }

    player1 = Paddle(10, 50, 5, 20)
    player2 = Paddle(VIR_WIDTH-10, VIR_HEIGHT-50, 5, 20)
    ball = Ball(VIR_WIDTH/2-2, VIR_HEIGHT/2-2, 4, 4)

    GameState = 'start'
    serving_player = 1
    player1Score = 0
    player2Score = 0
end

function love.update(dt)

    if GameState == 'play' then
        ball:update(dt)
        --[[
            Score Tracing
        ]]
        if ball.x < 0 then
            sounds['score']:play()
            GameState = 'serve'
            player2Score = player2Score + 1
            --[[
                winning player
            ]]
            if player2Score >= 10 then
                sounds['score']:play()
                winningPlayer = 2
                GameState = "done"
            end

            serving_player = 1

        elseif ball.x > VIR_WIDTH then    
            sounds['score']:play()
            GameState = 'serve'
            player1Score = player1Score + 1
            --[[
                winning player
            ]]
            if player1Score >= 10 then
                winningplayer = 1
                GameState = 'done'
            end
            serving_player = 2
        end
        --[[
            Wall Bounce
        ]]
        if ball.y >= VIR_HEIGHT then 
            sounds['wall_hit']:play()

            ball.y = VIR_HEIGHT
            ball.dy = -ball.dy
        elseif ball.y <= 0 then
            sounds['wall_hit']:play()
            ball.y = 0
            ball.dy = -ball.dy
        end

        --[[
            Ball Collision
        ]]
        if ball:Collides(player1) then
            sounds['paddle_hit']:play()
            ball.x = player1.x + ball.width
            ball.dx = ball.dx * 1.05
            ball.dx = -ball.dx
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:Collides(player2) then
            sounds['paddle_hit']:play()
            ball.x = player2.x - ball.width
            ball.dx = -ball.dx
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        
    elseif GameState == 'serve' then
        ball:reset()
        if serving_player == 1 then
            ball.dx = ball.dx
        elseif serving_player == 2 then
            ball.dx = ball.dx
        end
    elseif GameState == 'done' then
        player1Score = 0
        player2Score = 0
        ball:reset()
    end
    --[[
        players movement
    ]]

    
    try_catch(ball, player2)
    try_catch(ball, player1)
    
    player1:update(dt)
    player2:update(dt)
end

--[[
    Game Hot keys
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if GameState == 'start' then
            GameState = 'serve'
        elseif GameState == 'serve' then
            GameState = 'play'
        elseif GameState == "done" then
            GameState = 'serve'
        end
    else
        --nothing
    end
end

--[[
    drawing game
]]
function love.draw()
    push:apply('start')

    displayScore()

    if GameState == 'play' then
        love.graphics.printf('Playing Pong', 0, 10, VIR_WIDTH, 'center')
    elseif GameState == 'start' then
        love.graphics.printf('Press enter to Play', 0, 15, VIR_WIDTH, 'center')
    elseif GameState == 'serve' then
        love.graphics.printf('Serving ball to Player'..tostring(serving_player), 0, 10, VIR_WIDTH, 'center')
        love.graphics.printf('Press enter to serve', 0, 20, VIR_WIDTH, 'center')
    elseif GameState == 'done' then
        love.graphics.printf('Player'..tostring(winningPlayer)..'Won !!!', 0, 10, VIR_WIDTH, 'center')        
    end

    player1:render()
    player2:render()
    ball:render()

    push:apply('end')
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIR_WIDTH/2-50, 50)
    love.graphics.print(tostring(player2Score), VIR_WIDTH/2+30, 50)
    love.graphics.setFont(smallFont)
end

function love.resize(w , h)
    push:resize(w, h)
end

function try_catch(ball, p)
    if ball.y < p.y -1 then
        --p.dy = -200
        p.y = ball.y
    end
    
    
    if ball.y > p.y + 1 then    
        if ball.y < p.y + p.height then
            --p.dy = 0
            p.y = ball.y
        else
             --p.dy = 200
             p.y = ball.y
        end
    end
end

