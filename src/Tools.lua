---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local scrMenu, filtroGdacs, bgShadow, headLogo, bottomCheck, grpLoading, grpConnection, grpNoMessages
    local h = display.topStatusBarContentHeight
    local fxTap = audio.loadSound( "fx/click.wav")
    self.y = h
    
    -- Creamos la el toolbar
    function self:buildHeader()
        bgShadow = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
        bgShadow.alpha = 0
        bgShadow.anchorX = 0
        bgShadow.anchorY = 0
        bgShadow:setFillColor( 0 )
        self:insert(bgShadow)
        
        -- Icons
        local iconLogo = display.newImage("img/iconLogo.png")
        iconLogo:translate(display.contentWidth/2, 45)
        self:insert( iconLogo )
        
        if composer.getSceneName( "current" ) == "src.Home" then
            -- Iconos Home
            local iconMenu = display.newImage("img/iconMenu.png")
            iconMenu:translate(45, 45)
            iconMenu:addEventListener( 'tap', showMenu)
            self:insert( iconMenu )
            local iconChat = display.newImage("img/iconChat.png")
            iconChat:translate(display.contentWidth-45, 45)
            iconChat.screen = 'Messages'
            iconChat:addEventListener( 'tap', toScreen)
            self:insert( iconChat )
            -- Get Menu
            scrMenu = Menu:new()
            scrMenu:builScreen()
        else
            local icoBack = display.newImage("img/icoBack.png")
            icoBack:translate(45, 45)
            icoBack.screen = 'Home'
            icoBack:addEventListener( 'tap', toScreen)
            self:insert( icoBack )
        end
    end
    
    -- Creamos loading
    function self:setLoading(isLoading, parent)
        if isLoading then
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
            grpLoading = display.newGroup()
            parent:insert(grpLoading)
            
            local bg = display.newRect( (display.contentWidth / 2), (parent.height / 2), 
                display.contentWidth, parent.height )
            bg:setFillColor( .95 )
            bg.alpha = .3
            grpLoading:insert(bg)
            local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
            local loading = display.newSprite(sheet, Sprites.loading.sequences)
            loading.x = display.contentWidth / 2
            loading.y = parent.height / 2 
            grpLoading:insert(loading)
            loading:setSequence("play")
            loading:play()
            local titleLoading = display.newText({
                text = "Loading...",     
                x = (display.contentWidth / 2) + 5, y = (parent.height / 2) + 60,
                font = native.systemFontBold,   
                fontSize = 18, align = "center"
            })
            titleLoading:setFillColor( .3, .3, .3 )
            grpLoading:insert(titleLoading)
        else
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
        end
    end
	
	--creamos mensaje de problema con la conexion
	function self:noConnection(isConnection, parent, message)
		if isConnection then
            if grpConnection then
                grpConnection:removeSelf()
                grpConnection = nil
            end
            grpConnection = display.newGroup()
            parent:insert(grpConnection)
			
			local bgNoConection = display.newRect( midW, 150 + h, display.contentWidth, 80 )
			bgNoConection:setFillColor( 236/255, 151/255, 31/255, .7 )
			grpConnection:insert(bgNoConection)
			
			local lblNoConection = display.newText({
				text = message, 
				x = midW, y = 150 + h,
				font = native.systemFont,   
				fontSize = 34, align = "center"
			})
			lblNoConection:setFillColor( 1 )
			grpConnection:insert(lblNoConection)
            
        else
            if grpConnection then
                grpConnection:removeSelf()
                grpConnection = nil
            end
        end
	end
	
	--creamos mensaje cuando no se encuentren mensajes o canales
	function self:NoMessages(isMesage, parent, message)
	
		if isMesage then
            if grpNoMessages then
                grpNoMessages:removeSelf()
                grpNoMessages = nil
            end
            grpNoMessages = display.newGroup()
            parent:insert(grpNoMessages)
			
			local titleNoMessages = display.newText({
				text = message,     
				x = midW, y = midH - 200,
				font = native.systemFontBold, width = intW - 50, 
				fontSize = 34, align = "center"
			})
			titleNoMessages:setFillColor( 0 )
			grpNoMessages:insert( titleNoMessages )
            
        else
            if grpNoMessages then
                grpNoMessages:removeSelf()
                grpNoMessages = nil
            end
        end
	end
	
    -- Cambia pantalla
    function toScreen(event)
        -- Hide Menu
        if bgShadow.alpha > 0 then
            showMenu()
        end
        -- Animate    
        local t = event.target
        audio.play(fxTap)
        t.alpha = 0
        timer.performWithDelay(200, function() t.alpha = 1 end, 1)
        -- Change Screen
        if t.isReturn then
            composer.gotoScene("src."..t.screen, { time = 400, effect = "fade" } )
        else
            composer.removeScene( "src."..t.screen )
            composer.gotoScene("src."..t.screen, { time = 400, effect = "fade" } )
        end
        return true
    end
    
    -- Cerramos o mostramos shadow
    function showMenu(event)
        if bgShadow.alpha == 0 then
            self:toFront()
            bgShadow:addEventListener( 'tap', showMenu)
            transition.to( bgShadow, { alpha = .3, time = 400, transition = easing.outExpo })
            transition.to( scrMenu, { x = 0, time = 400, transition = easing.outExpo } )
        else
            bgShadow:removeEventListener( 'tap', showMenu)
            transition.to( bgShadow, { alpha = 0, time = 400, transition = easing.outExpo })
            transition.to( scrMenu, { x = -500, time = 400, transition = easing.outExpo })
        end
        return true;
    end
    
    return self
end







