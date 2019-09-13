push = require "push"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIR_WIDTH = 432
VIR_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)

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
    
    ballX = VIR_WIDTH /2-2
    ballY = VIR_HEIGHT/2-2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)  

    gameState = "start"
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -PADDLE_SPEED*dt)
    elseif love.keyboard.isDown('s') then 
        player1Y = math.min(VIR_HEIGHT-20, player1Y + PADDLE_SPEED*dt)
    end
    
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED*dt)
    elseif love.keyboard.isDown('down') then 
        player2Y = math.min(VIR_HEIGHT-20, player2Y + PADDLE_SPEED*dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key =='enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ballX = VIR_WIDTH / 2-2
            ballY = VIR_HEIGHT /2-2
            
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    
    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIR_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIR_WIDTH, 'center')
    end    

    --player1
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    
    --player2
    love.graphics.rectangle('fill', VIR_WIDTH - 10, player2Y, 5, 20)
    
    --ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    push:apply('end')
end
