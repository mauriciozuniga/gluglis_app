---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------


---------------------------------- OBJETOS Y VARIABLES ----------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
RestManager = require('src.resources.RestManager')
local composer = require( "composer" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local topCmp, bottomCmp, profiles, grpBtnDetail, grpDetail
local container


-- Variables
local isCard = false
local direction = 0
local avaL = {}
local avaR = {}
local detail = {}
local borders = {}
local idxA, countA
local lblName, lblAge, lblInts
local loadUsers
local btnViewProfile

---------------------------------- FUNCIONES ----------------------------------

-------------------------------------
-- Creamos primera tanda de tarjetas
------------------------------------
function getFirstCards(items)
    loadUsers = items
    idxA = 1
    countA = #loadUsers
    
    for i = 1, countA, 1 do
        buildCard(loadUsers[i])
    end
    
    setInfo(1)
    avaL[1].alpha = 1
    avaR[1].alpha = 1
    borders[4].alpha = 1
    borders[5].alpha = 1
    borders[6].alpha = 1
    screen:addEventListener( "touch", touchScreen )
	btnViewProfile:addEventListener( 'tap', showProfiles )
end

-------------------------------------
-- Muestra imagenes y mascaras
-- @param item registro que incluye el nombre de la imagen
------------------------------------
function buildCard(item)
    local idx = #avaL + 1
    local imgS = graphics.newImageSheet( item.image, system.TemporaryDirectory, { width = 275, height = 550, numFrames = 2 })
    avaL[idx] = display.newRect( midW, 176, 275, 550 )
    avaL[idx].alpha = 0
    avaL[idx].anchorY = 0
    avaL[idx].anchorX = 1
	avaL[idx].id = item.id
    avaL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    profiles:insert(avaL[idx])
    
    avaR[idx] = display.newRect( midW, 176, 275, 550 )
    avaR[idx].alpha = 0
    avaR[idx].anchorY = 0
    avaR[idx].anchorX = 0
	avaR[idx].id = item.id
    avaR[idx].fill = { type = "image", sheet = imgS, frame = 2 }
    profiles:insert(avaR[idx])
    
end

function showProfiles( event )
	event.target.item.isMe = false
	composer.removeScene( "src.Profile" )
	composer.gotoScene( "src.Profile", { time = 400, effect = "fade", params = { item = event.target.item }})
end

--muestra detalles cuando la pantalla es chica
function showDetail( event )
	if event.target.flag == 0 then
		topCmp.y = -850
		grpBtnDetail.y = grpBtnDetail.y - 350
		bottomCmp.alpha = 1
		event.target.flag = 1
		screen:removeEventListener( "touch", touchScreen )
	else
		bottomCmp.alpha = 0
		topCmp.y =  -500
		grpBtnDetail.y = 0
		event.target.flag = 0
		screen:addEventListener( "touch", touchScreen )
	end
end

-------------------------------------
-- Asigna informacion del usuario actual
-- @param idx posicion del registro
------------------------------------
function setInfo(idx)
    -- Hide Icons
    for i=3, 5 do
        detail[i].icon.alpha = 0
        detail[i].icon2.alpha = 0
    end
    -- Set info
    lblName.text = loadUsers[idx].userName
    lblAge.text = loadUsers[idx].edad
    detail[1].lbl.text = loadUsers[idx].residencia
    if loadUsers[idx].edad then lblAge.text=lblAge.text.." años" end
    -- Hobbies
    if loadUsers[idx].hobbies then
        local max = 4
        if #loadUsers[idx].hobbies < max then 
            max = #loadUsers[idx].hobbies 
        end
        for i=1, max do
            if i == 1 then
                lblInts.text = loadUsers[idx].hobbies[i]
            else
                lblInts.text = lblInts.text..', '..loadUsers[idx].hobbies[i]
            end
        end
        if #loadUsers[idx].hobbies > max then 
            lblInts.text = lblInts.text..'...'
        end
    else
        lblInts.text = ''
    end
    -- Idiomas
    if loadUsers[idx].idiomas then
        for i=1, #loadUsers[idx].idiomas do
            if i == 1 then
                detail[2].lbl.text = loadUsers[idx].idiomas[i]
            else
                detail[2].lbl.text = detail[2].lbl.text..', '..loadUsers[idx].idiomas[i]
            end
        end
    else
        detail[2].lbl.text = ''
    end
    -- Alojamiento
    if loadUsers[idx].alojamiento and loadUsers[idx].alojamiento == 'Sí' then
        detail[3].icon.alpha = 1
        detail[3].lbl.text = 'Ofrece alojamiento'
    else 
        detail[3].icon2.alpha = 1
        detail[3].lbl.text = 'No ofrece alojamiento'
    end 
    -- Alojamiento
    if loadUsers[idx].vehiculo and loadUsers[idx].vehiculo == 'Sí' then
        detail[4].icon.alpha = 1
        detail[4].lbl.text = 'Cuenta con vehiculo propio'
    else 
        detail[4].icon2.alpha = 1
        detail[4].lbl.text = 'No cuenta con vehiculo propio'
    end 
    -- Disponibilidad
    if loadUsers[idx].diponibilidad and loadUsers[idx].diponibilidad == 'Siempre' then
        detail[5].icon.alpha = 1
        detail[5].lbl.text = 'Disponible'
    else 
        detail[5].icon2.alpha = 1
        detail[5].lbl.text = 'No disponible'
    end 
	
	btnViewProfile.item = loadUsers[idx]
    --
    --Cuenta con vehiculo propio
    
end

-------------------------------------
-- Muestra borders de revista
------------------------------------
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

-------------------------------------
-- Listener para el flip del avatar
-- @param event objeto evento
------------------------------------
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


-------------------------------------
-- Mostramos el detalle en recuadro fijo
------------------------------------
function showInfoDisplay()
    -- Position
    local posY = 830 + h
    
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
    bgTitle:setFillColor( 68/255, 14/255, 98/255 )
    screen:insert(bgTitle)
    local bgTitleX = display.newRect( midW, posY+60, intW - 160, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( 68/255, 14/255, 98/255 )
    screen:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "DETALLE:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 1 )
    screen:insert(lblTitle)
    
    -- Options
    posY = posY + 55
    local opt = {
        {icon = 'icoFilterCity'},
        {icon = 'icoFilterLanguage'}, 
        {icon = 'icoFilterCheck', icon2= 'icoFilterUnCheck'}, 
        {icon = 'icoFilterCheck', icon2= 'icoFilterUnCheck'}, 
        {icon = 'icoFilterCheckAvailble', icon2= 'icoFilterUnCheck'}} 
    
    for i=1, 5 do
        detail[i] = {}
        posY = posY + 60
        
        detail[i].icon = display.newImage( "img/"..opt[i].icon..".png" )
        detail[i].icon:translate( 115, posY )
        screen:insert(detail[i].icon)
        if opt[i].icon2 then
            detail[i].icon2 = display.newImage( "img/"..opt[i].icon2..".png" )
            detail[i].icon2:translate( 115, posY )
            screen:insert(detail[i].icon2)
        end
        
        detail[i].lbl = display.newText({
            text = "", 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 25, align = "left"
        })
        detail[i].lbl:setFillColor( 0 )
        screen:insert(detail[i].lbl)
    end
	
	posY = posY + 50
	
	--btn perfil
	btnViewProfile = display.newRoundedRect( midW, posY, intW - 160, 70, 10 )
    btnViewProfile.anchorY = 0
	btnViewProfile.id = 0
    btnViewProfile:setFillColor( 68/255, 14/255, 98/255 )
    screen:insert(btnViewProfile)
	btnViewProfile:addEventListener( 'tap', showProfiles )
	local lblViewProfile = display.newText({
        text = "Ver perfil",
        x = midW, y = posY + 32,
        font = native.systemFontBold,
        fontSize = 32, align = "left"
    })
    lblViewProfile:setFillColor( 1 )
    screen:insert(lblViewProfile)
	
end

-------------------------------------
-- Mostramos el detalle en recuadro dinamico
------------------------------------
function showInfoButton()

	local posY = 830 + h
	
	grpBtnDetail = display.newGroup()
    screen:insert( grpBtnDetail )
	
    -- Title
    local bgTitle = display.newRoundedRect( midW, posY, intW - 160, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( 68/255, 14/255, 98/255 )
	bgTitle.flag = 0
    grpBtnDetail:insert(bgTitle)
	bgTitle:addEventListener( 'tap', showDetail )
    local Circle1 = display.newCircle( 320, posY + 35, 12 )
	Circle1:setFillColor( 1 )
	grpBtnDetail:insert(Circle1)
	local Circle2 = display.newCircle( 384, posY + 35, 12 )
	Circle2:setFillColor( 1 )
	grpBtnDetail:insert(Circle2)
	local Circle3 = display.newCircle( 448, posY + 35, 12 )
	Circle3:setFillColor( 1 )
	grpBtnDetail:insert(Circle3)

	-------

    local posY = 570
	
	-- BG Component
    local bgComp1 = display.newRoundedRect( midW, posY + 10, intW - 160, 390, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    bottomCmp:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, posY + 10, intW - 164, 386, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    bottomCmp:insert(bgComp2)
    
    -- Options
    posY = posY + 55
    local opt = {
        {icon = 'icoFilterCity'}, 
        {icon = 'icoFilterLanguage'}, 
        {icon = 'icoFilterCheck', icon2= 'icoFilterUnCheck'}, 
        {icon = 'icoFilterCheck', icon2= 'icoFilterUnCheck'}, 
        {icon = 'icoFilterCheckAvailble', icon2= 'icoFilterUnCheck'}} 
    
    for i=1, 5 do
        detail[i] = {}
        posY = posY + 60
        
        detail[i].icon = display.newImage( "img/"..opt[i].icon..".png" )
        detail[i].icon:translate( 115, posY )
        bottomCmp:insert(detail[i].icon)
        if opt[i].icon2 then
            detail[i].icon2 = display.newImage( "img/"..opt[i].icon2..".png" )
            detail[i].icon2:translate( 115, posY )
            bottomCmp:insert(detail[i].icon2)
        end
        
        detail[i].lbl = display.newText({
            text = "", 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 25, align = "left"
        })
        detail[i].lbl:setFillColor( 0 )
        bottomCmp:insert(detail[i].lbl)
    end
    bottomCmp.alpha = 0
	
	posY = posY + 75
	
	--btn perfil
	btnViewProfile = display.newRoundedRect( midW, posY, intW - 160, 70, 10 )
    btnViewProfile.anchorY = 0
	btnViewProfile.id = 0
    btnViewProfile:setFillColor( 68/255, 14/255, 98/255 )
    bottomCmp:insert(btnViewProfile)
	local lblViewProfile = display.newText({
        text = "Ver perfil",
        x = midW, y = posY + 32,
        font = native.systemFontBold,
        fontSize = 32, align = "left"
    })
    lblViewProfile:setFillColor( 1 )
    bottomCmp:insert(lblViewProfile)
	
	
    
end

---------------------------------- DEFAULT SCENE METHODS ----------------------------------

-------------------------------------
-- Se llama antes de mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:create( event )
	screen = self.view
    screen.y = h
    local isH = (intH - h) >  1300
	print(intH - h)
	
    local o = display.newRoundedRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
    
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	container = display.newContainer( intW - 160, 700 )
	container:translate( midW , 110 + h)
	container.anchorY = 0
    screen:insert(container)
	
    topCmp = display.newGroup()
    container:insert(topCmp)
	topCmp.x = - 384
	topCmp.y = - 500
    
    -- Content profile
    local bgCard = display.newRoundedRect( midW, 150, intW - 160, 700, 10 )
    bgCard.anchorY = 0
    bgCard:setFillColor( 11/225, 163/225, 212/225 )
    topCmp:insert(bgCard)
    
    bgAvatar = display.newRect( midW, 172, 580, 558 )
    bgAvatar.anchorY = 0
    bgAvatar:setFillColor( 0, 193/225, 1 )
    topCmp:insert(bgAvatar)
    
    local tmpAvatar = display.newImage("img/avatar.png")
    tmpAvatar.anchorY = 0
    tmpAvatar.alpha = .5
    tmpAvatar:translate(midW, 197)
    topCmp:insert( tmpAvatar )
    
    optB = {
        {x = midW-284, y = 178, c = .6}, {x = midW-280, y = 177, c = .75}, {x = midW-276, y = 176, c = .9}, 
        {x = midW+284, y = 178, c = .6}, {x = midW+280, y = 177, c = .75}, {x = midW+276, y = 176, c = .9}
    }
    for i = 1, #optB, 1 do
        borders[i] = display.newRect( optB[i].x, optB[i].y, 6, 550 )
        borders[i].anchorY = 0
        borders[i].alpha = 0
        borders[i]:setFillColor( optB[i].c )
        topCmp:insert(borders[i])
    end
    
    profiles = display.newGroup()
    topCmp:insert(profiles)
    
    -- Personal data
    lblName = display.newText({
        text = "", 
        x = 420, y = 760,
        width = 600,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( 1 )
    topCmp:insert(lblName)
    lblAge= display.newText({
        text = "", 
        x = 420, y = 795,
        width = 600,
        font = native.systemFont, 
        fontSize = 28, align = "left"
    })
    lblAge:setFillColor( 1 )
    topCmp:insert(lblAge)
    lblInts = display.newText({
        text = "", 
        x = 420, y = 820,
        width = 600,
        font = native.systemFont, 
        fontSize = 22, align = "left"
    })
    lblInts:setFillColor( 1 )
    topCmp:insert(lblInts)
    
    -- Mediante alto de la pantalla determinamos recuadro del detalle
    if isH then
        showInfoDisplay()
    else
        bottomCmp = display.newGroup()
        screen:insert(bottomCmp)
        showInfoButton()
    end
	
    RestManager.getUsersByCity()
end	

-------------------------------------
-- Se llama al mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:show( event )
end

-------------------------------------
-- Se llama al cambiar la escena
-- @param event objeto evento
------------------------------------
function scene:hide( event )
end

-------------------------------------
-- Se llama al destruirse la escena
-- @param event objeto evento
------------------------------------
function scene:destroy( event )
end

-- Listeners de la Escena
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene