---------------------------------------------------------------------------------
-- Gluglis Rex
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local composer = require( "composer" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    screen.y = h
    
    local o = display.newRoundedRect( midW, midH + 30, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, 160, 650, 730, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, 160, 646, 727, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    screen:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, 160, 650, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( .93 )
    screen:insert(bgTitle)
    local bgTitleX = display.newRect( midW, 220, 650, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( .93 )
    screen:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "BUSQUEDA AVANZADA", 
        x = 310, y = 195,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    screen:insert(lblTitle)
    
    -- Options
    local posY = 205
    local opt = {
        {icon = 'icoFilterCity', label= 'Ciudad:', wField = 410}, 
        {icon = 'icoFilterAvailable', label= 'Disponible entre:', wField = 140}, 
        {label= 'Genero:'}, 
        {label= 'Edad Entre:', wField = 140},
        {icon = 'icoFilterHome', label= 'Ofrece Alojamiento:', wField = 60}, 
        {icon = 'icoFilterVehicle', label= 'Cuenta con Vehiculo:', wField = 60}, 
        {icon = 'icoFilterLanguage', label= 'Idioma(s):'}}
    for i=1, #opt do
        posY = posY + 90
        if opt[i].fixM then posY = posY - 85 end
        
        local ico
        if opt[i].icon then
            ico = display.newImage( screen, "img/"..opt[i].icon..".png" )
            ico:translate( 115, posY - 5 )
        end
        local lbl = display.newText({
            text = opt[i].label, 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        screen:insert(lbl)
        
        if opt[i].wField then
            local bg1 = display.newRoundedRect( 660, posY, opt[i].wField, 50, 5 )
            bg1.anchorX = 1
            bg1:setFillColor( .93 )
            screen:insert(bg1)
            local bg2 = display.newRoundedRect( 658, posY, opt[i].wField - 4, 46, 5 )
            bg2.anchorX = 1
            bg2:setFillColor( 1 )
            screen:insert(bg2)
        end
        
        -- Fix Mujer
        if opt[i].fixM then 
            ico.x = 350 
            lbl.x = 590 
        end
    end
    
    -- Fields
    xFields = {
        {label = "y", x = 540, y = -450},
        {w = 140, x = 470, y = -450},
        {label = "HOMBRE", x = 430, y = -360},
        {label = "MUJER", x = 630, y = -360},
        {label = "y", x = 540, y = -270},
        {w = 140, x = 470, y = -270},
        {label = "SI", x = 460, y = -180},
        {label = "NO", x = 600, y = -180},
        {w = 60, x = 510, y = -180},
        {label = "SI", x = 460, y = -90},
        {label = "NO", x = 600, y = -90},
        {w = 60, x = 510, y = -90}}
    for i=1, #xFields do
        if  xFields[i].label then
            local lbl = display.newText({
                text = xFields[i].label, 
                x = xFields[i].x, y = posY + xFields[i].y,
                width = 100,
                font = native.systemFont,   
                fontSize = 22, align = "left"
            })
            lbl:setFillColor( .5 )
            screen:insert(lbl)
        else
            local bg1 = display.newRoundedRect( xFields[i].x, posY + xFields[i].y, xFields[i].w, 50, 5 )
            bg1.anchorX = 1
            bg1:setFillColor( .93 )
            screen:insert(bg1)
            local bg2 = display.newRoundedRect( xFields[i].x - 2, posY + xFields[i].y, xFields[i].w - 4, 46, 5 )
            bg2.anchorX = 1
            bg2:setFillColor( 1 )
            screen:insert(bg2)
        end
    end
    
    -- Genero
    local genH = display.newImage( screen, "img/icoFilterH.png" )
    genH:translate( 350, posY - 360 )
    local genM = display.newImage( screen, "img/icoFilterM.png" )
    genM:translate( 548, posY - 360 )
    
    -- Idiomas
    local lbl = display.newText({
        text = "INGLES, ESPAÑOL, ITALIANO", 
        x = 520, y = posY,
        width = 500,
        font = native.systemFont,   
        fontSize = 22, align = "left"
    })
    lbl:setFillColor( .5 )
    screen:insert(lbl)
    local editLang = display.newImage( screen, "img/icoEditLang.png" )
    editLang:translate( 600, posY - 5 )
    
    -- Search Button
    posY = posY + 140
    local btnSearch = display.newRoundedRect( midW, posY, 650, 80, 10 )
    btnSearch:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    screen:insert(btnSearch)
    local lblSearch = display.newText({
        text = "BUSCAR", 
        x = midW, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSearch:setFillColor( 1 )
    screen:insert(lblSearch)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide scene
function scene:hide( event )
end

-- Destroy scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene