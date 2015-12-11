---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

Menu = {}
function Menu:new()
    -- Variables
    require('src.resources.Globals')
    local selfMenu = display.newGroup()
    local fxTap = audio.loadSound( "fx/click.wav")
    local Menu
    
    -- Bloquea cierre de menu
    function blockTap()
        return true;
    end
    
    -- Creamos la pantalla del menu
    function selfMenu:builScreen()
        Menu =  menu
        selfMenu.anchorY = 0
        selfMenu.y = h
        selfMenu.x = -500
        
        -- Background
        local background = display.newRect(250, midH, 500, intH )
        background:setFillColor( 37/255, 41/255, 49/255 )
        background:addEventListener( 'tap', blockTap)
        selfMenu:insert(background)
        
        -- Options
        local opt = {{'Filter', 'icoFilter', 'Filtrar'}, {'Profile', 'icoProfile', 'Mi Perfil'}}
        for i=1,2 do
            -- Opt
            local posc = (i * 110) - 55
            local bgOpt1 = display.newRect(250, posc, 500, 110 )
            bgOpt1:setFillColor( 37/255, 41/255, 49/255 )
            bgOpt1.screen = opt[i][1]
            bgOpt1:addEventListener( 'tap', toScreen)
            selfMenu:insert(bgOpt1)
            local imgOpt1 = display.newImage( selfMenu, "img/"..opt[i][2]..".png" )
            imgOpt1:translate( 60, posc )
            local lblOpt1 = display.newText({
                text = opt[i][3],     
                x = 310, y = posc,
                width = 400,
                font = native.systemFont,   
                fontSize = 30, align = "left"
            })
            lblOpt1:setFillColor( .9 )
            selfMenu:insert(lblOpt1)
            local bgSeparate = display.newRect(250, posc+52, 500, 4 )
            bgSeparate:setFillColor( .26 )
            selfMenu:insert(bgSeparate)
        end
        
        
        local bgExit = display.newRect(250, intH-h-55, 500, 110 )
        bgExit:setFillColor( 37/255, 41/255, 49/255 )
        bgExit.screen = "Login"
        bgExit:addEventListener( 'tap', toScreen)
        selfMenu:insert(bgExit)
        local imgExit = display.newImage( selfMenu, "img/icoExit.png" )
        imgExit:translate( 60, intH-h-55 )
        local lblExit = display.newText({
            text = "Cerrar Sesión", 
            x = 310, y = intH-h-55,
            width = 400,
            font = native.systemFont,   
            fontSize = 30, align = "left"
        })
        lblExit:setFillColor( .9 )
        selfMenu:insert(lblExit)
        local bgSeparate = display.newRect(250, intH-h-110, 500, 4 )
        bgSeparate:setFillColor( .26 )
        selfMenu:insert(bgSeparate)
        
        -- Border Right
        local borderRight = display.newRect( 498, midH, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .4, .4, .4, .2 },
            direction = "left"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        selfMenu:insert(borderRight)
    end

    return selfMenu
end