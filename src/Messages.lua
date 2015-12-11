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
local widget = require( "widget" )
local composer = require( "composer" )
local fxTap = audio.loadSound( "fx/click.wav")
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, scrMs
local scene = composer.newScene()
local noMessages
--local itemsMessage

-- Variables
local tmpList = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function setItemsListMessages( items )
	for i = 1, #items, 1 do
		tmpList[i] = {id = items[i].id, photo = "mariana.jpeg", name = items[i].display_name, subject = items[i].message, channelId = items[i].channel_id,
			blockMe = items[i].blockMe, blockYour = items[i].blockYour}
	end
	buildListMsg()
	tools:setLoading( false,screen )
end

--mensaje no lista de mensajes
function notListMessages()
	tools:setLoading( false,screen )
	tools:NoMessages( true, scrMs, "No cuenta con mensajes en este momento" )
end

--mensaje no hay conexion
function noConnectionMessages(message)
	tools:noConnection( true, screen, message )
	tools:setLoading( false,screen )
end

--llama a la scena del los mensajes por canal
function tapMessage(event)
    local t = event.target
    t:setFillColor( 89/255, 31/255, 103/255 )
    timer.performWithDelay(200, function() t:setFillColor( 1 ) end, 1)
    audio.play(fxTap)
    composer.removeScene( "src.Message" )
    composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = t.item } } )
end

function buildListMsg()
    local posY = -50
    for i = 1, #tmpList do
        -- Bg
        posY = posY + 150
        local bg0 = display.newRect( midW, posY, intW, 148 )
        bg0:setFillColor( .5 )
        bg0.alpha = .05
        scrMs:insert(bg0)
        local bg = display.newRect( midW, posY, intW, 140 )
        bg:setFillColor( 1 )
        bg.item = tmpList[i]
        bg:addEventListener( 'tap', tapMessage)
        scrMs:insert(bg)
        -- Image
        local avatar = display.newImage("img/tmp/"..tmpList[i].photo)
        avatar:translate(90, posY)
        avatar.width = 130
        avatar.height = 130
        scrMs:insert( avatar )
        
        local maskMA = display.newImage("img/maskCircle130.png")
        maskMA:translate(90, posY)
        scrMs:insert( maskMA )
        -- Name
        local lblName = display.newText({
            text = tmpList[i].name,     
            x = midW + 90, y = posY - 20,
            width = 600,
            font = native.systemFontBold,   
            fontSize = 35, align = "left"
        })
        lblName:setFillColor( 0 )
        scrMs:insert(lblName)
        -- Subject
        local lblSubject = display.newText({
            text = tmpList[i].subject,     
            x = midW + 90, y = posY + 20,
            width = 600,
            font = native.systemFont,   
            fontSize = 25, align = "left"
        })
        lblSubject:setFillColor( .3 )
        scrMs:insert(lblSubject)
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    screen.y = h
    
    local o = display.newRoundedRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)   
	tools:setLoading( true,screen )
    
	scrMs = widget.newScrollView
    {
        top = 150,
        left = 0,
        width = intW,
        height = intH - 150,
        scrollWidth = 600,
        scrollHeight = 800,
		hideBackground = true,
    }
    screen:insert(scrMs)
	
	RestManager.getListMessageChat()
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide scene
function scene:hide( event )
	tools:noConnection( false, screen, "" )
end

-- Destroy scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene