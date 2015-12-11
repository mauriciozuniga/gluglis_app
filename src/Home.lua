---------------------------------------------------------------------------------
-- Gluglis
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
local isCard = false
local direction = 0
local avaL = {}
local avaR = {}
local detail = {}
local borders = {}
local idxA, countA
local lblName, lblAge, lblInts

local loadUsers = {
    {id = 1, photo = "mariana.jpeg", name = 'Mariana Gomez',  edad = 24, desc = 'Amante de la musica',
        city='Cancun, Quitana Roo MX', lang='Español, Ingles', couch=1, car=0, available==1},
    {id = 2, photo = "marcos.jpg", name = 'Marcos Jimenez',   edad = 26, desc = 'Adoro los gatos y el café',
        city='Cancun, Quitana Roo MX', lang='Español, Ingles', couch=0, car=1, available==1},
    {id = 3, photo = "andrew.jpg", name = 'Andrew Patterson', edad = 24, desc = 'Aventurero y deportista extremo',
        city='Cancun, Quitana Roo MX', lang='Español, Frances', couch=1, car=1, available==0},
    {id = 4, photo = "janine.jpg", name = 'Janine Smith',     edad = 24, desc = 'Me encanta el olor a pasto mojado',
        city='Cancun, Quitana Roo MX', lang='Ingles, Aleman', couch=0, car=0, available==0},
    {id = 5, photo = "victoria.jpg", name = 'Victoria Beckham', edad = 24, desc = 'Hermosa y PetFriendly',
        city='Cancun, Quitana Roo MX', lang='Español, Frances', couch=1, car=1, available==1}
}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Creamos primera tanda de tarjetas
function firstCards()
    idxA = 1
    countA = #loadUsers
    
    for i = 1, countA, 1 do
        buildCard(loadUsers[i])
    end
    
    lblName.text = loadUsers[1].name
    lblAge.text = loadUsers[1].edad .. " años"
    lblInts.text = loadUsers[1].desc
    
    avaL[1].alpha = 1
    avaR[1].alpha = 1
    borders[4].alpha = 1
    borders[5].alpha = 1
    borders[6].alpha = 1
end

-- Muestra imagenes y mascaras
function buildCard(item)
    local idx = #avaL + 1
    local imgS = graphics.newImageSheet( "img/tmp/"..item.photo, { width = 275, height = 550, numFrames = 2 })
    
    avaL[idx] = display.newRect( midW, 176, 275, 550 )
    avaL[idx].alpha = 0
    avaL[idx].anchorY = 0
    avaL[idx].anchorX = 1
    avaL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    profiles:insert(avaL[idx])
    
    avaR[idx] = display.newRect( midW, 176, 275, 550 )
    avaR[idx].alpha = 0
    avaR[idx].anchorY = 0
    avaR[idx].anchorX = 0
    avaR[idx].fill = { type = "image", sheet = imgS, frame = 2 }
    profiles:insert(avaR[idx])
    
end

-- Asigna informacion del usuario actual
function setInfo(idx)
    lblName.text = loadUsers[idx].name
    lblAge.text = loadUsers[idx].edad
    lblInts.text = loadUsers[idx].desc
    detail[1].text = loadUsers[idx].city
    detail[2].text = loadUsers[idx].lang
    
end

-- Muestra borders de revista
function setBorder()
    -- Left
    if idxA == 1 then
        borders[1].alpha, borders[2].alpha, borders[3].alpha = 0, 0, 0
    elseif idxA == 2 then
        borders[1].alpha, borders[2].alpha, borders[3].alpha = 0, 0, 1
    elseif idxA == 3 then
        borders[1].alpha, borders[2].alpha, borders[3].alpha = 0, 1, 1
    elseif idxA >= 4 then
        borders[1].alpha, borders[2].alpha, borders[3].alpha = 1, 1, 1
    end
    -- Rigth
    if idxA == #loadUsers then
        borders[4].alpha, borders[5].alpha, borders[6].alpha = 0, 0, 0
    elseif (idxA+1) == #loadUsers then
        borders[4].alpha, borders[5].alpha, borders[6].alpha = 0, 0, 1
    elseif (idxA+2) == #loadUsers then
        borders[4].alpha, borders[5].alpha, borders[6].alpha = 0, 1, 1
    elseif (idxA+3) <= #loadUsers then
        borders[4].alpha, borders[5].alpha, borders[6].alpha = 1, 1, 1
    end
end

-- Listener Touch Screen
function touchScreen(event)
    if event.phase == "began" then
        if event.yStart > 140 and event.yStart < 820 then
            isCard = true
            direction = 0
        end
    elseif event.phase == "moved" and (isCard) then
        local x = (event.x - event.xStart)
        local xM = (x * 1.5)
        
        if direction == 0 then
            if x < -10 and idxA < #loadUsers then
                direction = 1
                avaR[idxA+1]:toBack()
                avaR[idxA+1].alpha = 1
                avaR[idxA+1].width = 275
            elseif x > 10 and idxA > 1 then
                direction = -1
                avaL[idxA-1]:toBack()
                avaL[idxA-1].alpha = 1
                avaL[idxA-1].width = 275
            end
        elseif direction == 1 and x <= 0 and xM >= -550 then
            if xM > -275 then
                if avaR[idxA].alpha == 0 then
                    avaL[idxA+1].alpha = 0
                    avaR[idxA].alpha = 1
                    avaR[idxA].width = 0
                end
                -- Move current to left
                avaR[idxA].width = 275 + xM
            else
                if avaL[idxA+1].alpha == 0 then
                    avaR[idxA].alpha = 0
                    avaL[idxA+1]:toFront()
                    avaL[idxA+1].alpha = 1
                    avaL[idxA+1].width = 0
                end
                -- Move new to left
                avaL[idxA+1].width = (xM*-1)-275
            end
        elseif direction == -1 and x >= 0 then
            if xM < 275 then
                if avaL[idxA].alpha == 0 then
                    avaR[idxA-1].alpha = 0
                    avaL[idxA].alpha = 1
                    avaL[idxA].width = 0
                end
                -- Move current to left
                avaL[idxA].width = 275 - xM
            elseif xM < 550 then
                if avaR[idxA-1].alpha == 0 then
                    avaL[idxA].alpha = 0
                    avaR[idxA-1]:toFront()
                    avaR[idxA-1].alpha = 1
                    avaR[idxA-1].width = 0
                end
                -- Move new to left
                avaR[idxA-1].width = xM - 275
            end
            
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local xM = ((event.x - event.xStart) * 3)
        -- To Rigth
        if direction == 1 and xM >= -550 then
            avaR[idxA].alpha = 1
            avaL[idxA+1].alpha = 0
            transition.to( avaR[idxA], { width = 275, time = 200, onComplete=function()
                avaR[idxA+1].alpha = 0
            end})
        elseif direction == 1 and xM < -550 then
            avaR[idxA].alpha = 0
            avaL[idxA+1].alpha = 1
            setInfo(idxA+1)
            transition.to( avaL[idxA+1], { width = 275, time = 200, onComplete=function()
                avaL[idxA].alpha = 0
                avaR[idxA].alpha = 0
                idxA = idxA + 1
                setBorder()
            end})
        end
        -- To Left
        if direction == -1 and xM <= 550 then
            avaL[idxA].alpha = 1
            avaR[idxA-1].alpha = 0
            transition.to( avaL[idxA], { width = 275, time = 200, onComplete=function()
                avaR[idxA-1].alpha = 0
            end})
        elseif direction == -1 and xM > 550 then
            avaL[idxA].alpha = 0
            avaR[idxA-1].alpha = 1
            setInfo(idxA-1)
            transition.to( avaR[idxA-1], { width = 275, time = 200, onComplete=function()
                avaL[idxA].alpha = 0
                avaR[idxA].alpha = 0
                idxA = idxA - 1
                setBorder()
            end})
        end
        
        isCard = false
        direction = 0
    end
end
    

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
-- Called immediately on create scene
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
    screen:insert(tools)
    
    -- Content profile
    local bgCard = display.newRoundedRect( midW, 150, intW - 160, 700, 10 )
    bgCard.anchorY = 0
    bgCard:setFillColor( 11/225, 163/225, 212/225 )
    screen:insert(bgCard)
    
    bgAvatar = display.newRect( midW, 172, 580, 558 )
    bgAvatar.anchorY = 0
    bgAvatar:setFillColor( 0, 193/225, 1 )
    screen:insert(bgAvatar)
    
    optB = {
        {x = midW-284, y = 178, c = .6}, {x = midW-280, y = 177, c = .75}, {x = midW-276, y = 176, c = .9}, 
        {x = midW+284, y = 178, c = .6}, {x = midW+280, y = 177, c = .75}, {x = midW+276, y = 176, c = .9}
    }
    for i = 1, #optB, 1 do
        borders[i] = display.newRect( optB[i].x, optB[i].y, 6, 550 )
        borders[i].anchorY = 0
        borders[i].alpha = 0
        borders[i]:setFillColor( optB[i].c )
        screen:insert(borders[i])
    end
    
    profiles = display.newGroup()
    screen:insert(profiles)
    
    -- Personal data
    lblName = display.newText({
        text = "", 
        x = 420, y = 760,
        width = 600,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( 1 )
    screen:insert(lblName)
    lblAge= display.newText({
        text = "", 
        x = 420, y = 795,
        width = 600,
        font = native.systemFont, 
        fontSize = 28, align = "left"
    })
    lblAge:setFillColor( 1 )
    screen:insert(lblAge)
    lblInts = display.newText({
        text = "", 
        x = 420, y = 820,
        width = 600,
        font = native.systemFont, 
        fontSize = 22, align = "left"
    })
    lblInts:setFillColor( 1 )
    screen:insert(lblInts)
    
    -- Position
    local posY = 870
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, posY, intW - 160, 390, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, posY, intW - 164, 386, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    screen:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, posY, intW - 160, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( .93 )
    screen:insert(bgTitle)
    local bgTitleX = display.newRect( midW, posY+60, intW - 160, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( .93 )
    screen:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "DETALLE:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    screen:insert(lblTitle)
    
    -- Options
    posY = posY + 55
    local opt = {
        {icon = 'icoFilterCity', label= 'Cancun, Quintana Roo Mexico'}, 
        {icon = 'icoFilterLanguage', label= 'Ingles, Español e Italiano'}, 
        {icon = 'icoFilterCheck', label= 'Ofrece Alojamiento'}, 
        {icon = 'icoFilterUnCheck', label= 'Cuenta con Vehiculo Propio'}, 
        {icon = 'icoFilterCheckAvailble', label= 'Disponible'}} 
    for i=1, #opt do
        posY = posY + 60
        
        local ico
        if opt[i].icon ~= '' then
            print("img/"..opt[i].icon..".png" )
            ico = display.newImage( screen, "img/"..opt[i].icon..".png" )
            ico:translate( 115, posY - 3 )
        end
        detail[i] = display.newText({
            text = opt[i].label, 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 25, align = "left"
        })
        detail[i]:setFillColor( 0 )
        screen:insert(detail[i])
    end
    
    --[[
    -- Buton
    local bgBtn = display.newRoundedRect( midW, 870, intW - 160, 70, 10 )
    bgBtn.anchorY = 0
    bgBtn:setFillColor({
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    })
    screen:insert(bgBtn)
    
    -- Circles
    local circle1 = display.newRoundedRect( midW - 50, 905, 25, 25, 13 )
    circle1:setFillColor( 1 )
    screen:insert(circle1)
    local circle2 = display.newRoundedRect( midW, 905, 25, 25, 13 )
    circle2:setFillColor( 1 )
    screen:insert(circle2)
    local circle3 = display.newRoundedRect( midW + 50, 905, 25, 25, 13 )
    circle3:setFillColor( 1 )
    screen:insert(circle3)
    ]]--
    
    firstCards()
    o:addEventListener( "touch", touchScreen )
    
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