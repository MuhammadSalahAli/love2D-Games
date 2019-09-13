CountDown = Class{__includes = BaseState}

COUNTDOWN_TIME = 1

function CountDown:init()
    self.count = 3
    self.timer = 0
end

function CountDown:update(dt)
    self.timer = self.timer + dt
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then 
            gStateMachine:change('play')
        end

    end
end

function CountDown:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
