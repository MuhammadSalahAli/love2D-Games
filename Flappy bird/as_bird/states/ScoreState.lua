ScoreState = Class{__includes = BaseState}

GOLDEN_COIN = love.graphics.newImage('assets/gold.png')
SILVER_COIN = love.graphics.newImage('assets/silver.png')
BRONZE_COIN = love.graphics.newImage('assets/bronze.png')

function ScoreState:init()
    self.score = 0
    self.preformance = 'standerd'
    self.coins = {
        ['gold'] = GOLDEN_COIN,
        ['silver'] = SILVER_COIN,
        ['bronze'] = BRONZE_COIN,
    }
end

function ScoreState:enter(params)
    self.score = params.score
    if self.score >= 0 then
        self.preformance = 'bronze'
        if self.score >= 1 then
            self.preformance = 'silver'
            if self.score >= 2 then
                self.preformance = 'gold'
            end
        end
    end
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('count')
    end
end

function ScoreState:render()
    love.graphics.draw(self.coins[self.preformance], VIRTUAL_WIDTH / 2 - 55 , VIRTUAL_HEIGHT / 2 )
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Oof you lost !', 0, 10, VIRTUAL_WIDTH, 'center')    
    love.graphics.printf('Your Score:'..tostring(self.score), 0, 40, VIRTUAL_WIDTH, 'center')    
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to play Again', 0, 80, VIRTUAL_WIDTH, 'center')    
end
