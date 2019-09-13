PlayState = Class{__includes = BaseState}

PIPE_HEIGHT = 288
PIPE_WIDTH = 70
PIPE_SPEED = 60

lastY = -PIPE_HEIGHT - math.random(80) + 20

function PlayState:init()
    self.bird = Bird()
    self.timer = 0
    self.PipePairs = {}
    self.score = 0
end

function PlayState:update(dt)
    if not PAUSE then
        self.timer = self.timer + dt
        local y = math.max(-PIPE_HEIGHT + 5, math.min(lastY + math.random(-10, 10),
         VIRTUAL_HEIGHT - 150 - PIPE_HEIGHT))
        lastY = y

        if self.timer >= math.random(3, 6) then
            self.timer = 0
            table.insert(self.PipePairs, PairPipe(y))
        end

        for key, pair in pairs(self.PipePairs) do 
            pair:update(dt)
        end

        for key, pair in pairs(self.PipePairs) do
            for i, pipe in pairs(pair.pipes) do
                if self.bird.x > pipe.x + PIPE_WIDTH then
                    if pair.scored then
                        --nothing
                    else
                        self.score = self.score + 1
                        sounds['score']:play()
                        pair.scored = true
                    end
                end
            end
        end

        for key, pair in pairs(self.PipePairs) do 
            if pair.remove then 
                table.remove(self.PipePairs, key)
            end
        end

        for k, pair in pairs(self.PipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()
                    gStateMachine:change('score', {score=self.score})
                end
            end
        end

        if self.bird.y + self.bird.height >= VIRTUAL_HEIGHT then
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {score=self.score})
        end

        self.bird:update(dt)
    else
        --game paued
    end
end

function PlayState:render()
    for key, pair in pairs(self.PipePairs) do 
        pair:render()
    end
    self.bird:render()
    if not PAUSE then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('SCORE IS '..tostring(self.score), 0, 10,
         VIRTUAL_WIDTH, 'left')
    else
        love.graphics.setFont(flappyFont)
        love.graphics.printf('II', 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')
    end
end
