CountdownState = Class{__includes=BaseState}

function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer >= 1 then
        self.count = self.count - 1
        self.timer = 0
        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(mediumFont)
    love.graphics.printf(tostring(self.count), 0, VIRTUAL_HEIGHT / 2 - 16 , VIRTUAL_WIDTH, 'center')    
end