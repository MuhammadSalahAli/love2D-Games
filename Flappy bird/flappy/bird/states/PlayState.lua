PlayState = Class{__includes = BaseState}

--[[
    try removeing StateSpesific variables
]]
PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt

    if self.timer > 2 then
        --[[
            randomize prosidual generation
            by change the y axis based on the last pipe y axis
        ]]
        local y = math.max(
            -PIPE_HEIGHT - 10, --[[the smallest value  for the y axis]]
            math.min(self.lastY + math.random(-20, 20), 
            VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT -- the largest pipe y value (95)
            )
        )
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))

        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do 
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                sounds['score']:play()
                self.score = self.score + 1
                pair.scored = true
            end
        end
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do 
        for i, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {score=self.score})
                sounds['explosion']:play()
                sounds['hurt']:play()
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score',{score=self.score})
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end