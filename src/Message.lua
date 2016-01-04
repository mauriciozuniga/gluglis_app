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
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, scrChat
local scene = composer.newScene()
local grpChat, grpTextField, grpBlocked

-- Variables
local posY 
local scrChatY
local scrChatH
local txtMessage
local poscList = 0
local lastDate = ""
local lastStatus = 0
local tmpList = {}
local lblDateTemp = {}
local itemsConfig = {}
local NoMessage

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

--cargamos los elementos del los mensajes
function setItemsMessages( items )
	for i = 1, #items, 1 do
		local item = items[i]
		local poscI = #tmpList + 1
		if item.changeDate == 1 then
			tmpList[poscI] = {date = item.fechaFormat, dateOnly = item.dateOnly}
			poscI = poscI + 1
		end
		tmpList[poscI] = {id = item.id, isMe = item.isMe, message = item.message, time = item.hora, isRead = item.status_message} 
	end
	buildChat(0)
end

--muestra un mensaje cuando no se encuentren chats
function notChatsMessages()
	tools:setLoading( false,screen )
	NoMessage = tools:NoMessages( true, scrChat, "No cuenta con mensajes en este momento" )
end

--muestra un mensaje cuando no exista conexion a internet
function noConnectionMessage(message)
	tools:noConnection( true, screen, message )
	tools:setLoading( false,screen )	
end

--envia el mensaje
function sentMessage()
	--verifica que ninguno este bloqueado
	if itemsConfig.blockMe == "open" and itemsConfig.blockYour == "open" then
		if txtMessage.text ~= "" then
			local dateM = RestManager.getDate()
			local poscD = #lblDateTemp + 1
			--displaysInList("quivole carnal", poscD, dateM[2])
			if NoMessage then
				tools:NoMessages( false, scrChat, "" )
				NoMessage:removeSelf()
				NoMessage = nil
			end
			local itemTemp = {message = txtMessage.text, posc = poscD, fechaFormat = dateM[2], hora = "Cargando"}
			displaysInList(itemTemp, true)
			RestManager.sendChat( itemsConfig.channelId, txtMessage.text, poscD )
			--RestManager.sendChat(itemsConfig.channelId, "quivole carnal", poscD)
			txtMessage.text = ""
			native.setKeyboardFocus( nil )
		end
	--si lo esta muenstra un mensaje de aviso
	elseif itemsConfig.blockMe == "closed" then
		blockedChatMsg('desbloquea a ' .. itemsConfig.display_name .. ' par enviarle un mensaje', true, false)
	elseif itemsConfig.blockYour == "closed" then
		blockedChatMsg('No se puede mandar mensaje, ' .. itemsConfig.display_name .. ' lo ha bloqueado', true, false)
	end
	return true
end

--prepara los datos para pintarlo en el scroll
function displaysInList(itemTemp, isMe)
	tmpList = nil
	tmpList = {}
	tmpList[1] = {isMe = isMe, message = itemTemp.message , time = itemTemp.hora}
	--verifica la fecha en que se mando
	if lastDate ~= itemTemp.fechaFormat then
		local bgDate = display.newRoundedRect( midW, posY, 300, 40, 20 )
		bgDate.anchorY = 0
		bgDate:setFillColor( 220/255, 186/255, 218/255 )
		scrChat:insert(bgDate)
		local lblDate = display.newText({
			text = itemTemp.fechaFormat,     
			x = midW, y = posY + 20,
			font = native.systemFont,   
			fontSize = 20, align = "center"
		})
		lblDate:setFillColor( .1 )
		scrChat:insert(lblDate)
		posY = posY + 70
		lastDate = itemTemp.fechaFormat
	end
	
	if isMe == true then
		buildChat(itemTemp.posc)
	else
		if itemsConfig.channelId == itemTemp.channel_id then
			buildChat(0)
		end
	end
end

--cambia la fecha del mensaje
function changeDateOfMSG(item, poscD)
	lblDateTemp[poscD].text = item.hora
	local titleScene = composer.getScene( "src.Messages" )
	if titleScene then
		movedChat(item, item.message, 0)
	end
end

function toBack()
    audio.play(fxTap)
    composer.gotoScene( "src.Messages", { time = 400, effect = "slideRight" } )
end

--muestra un aviso si se desea bloquear o desbloquear el chat
function blockedChat( event )
	if itemsConfig.blockMe == "closed" then
		blockedChatMsg('¿desea desbloquear a ' .. itemsConfig.display_name .. '? para enviarle mensajes', true, true)
	else
		blockedChatMsg('¿desea bloquear a ' .. itemsConfig.display_name .. '? ya no podras enviarle mensajes', true, true)
	end
end

--crea el aviso de chats bloqueado
function blockedChatMsg(message, isShow, isBlock)
	if isShow then
		grpBlocked = display.newGroup()
		
		local bgBlocked0 = display.newRect( midW, midH + h, intW, intH )
		bgBlocked0:setFillColor( 0, 0, 0, .5)
		grpBlocked:insert(bgBlocked0)
		bgBlocked0:addEventListener( 'tap', noAction )
		
		local bgBlocked1 = display.newRoundedRect( midW, midH + h, intW - 100, 300, 15 )
		bgBlocked1:setFillColor( 1 )
		grpBlocked:insert(bgBlocked1)
		
		local lblBlocked = display.newText({
			text = message,     
			x = midW, y = midH + h ,
			width = intW - 200, height = 200,
			font = native.systemFont,   
			fontSize = 30, align = "center"
		})
		lblBlocked:setFillColor( 0 )
		grpBlocked:insert(lblBlocked)
		
		local lblAccept = display.newText({
			text = "Aceptar",     
			x = midW, y = midH + h + 80 ,
			font = native.systemFontBold,   
			fontSize = 42, align = "center"
		})
		lblAccept:setFillColor( 129/255, 61/255, 153/255 )
		grpBlocked:insert(lblAccept)
		
		if isBlock then
			lblAccept.x = midW + 125
			lblAccept:addEventListener( 'tap', blocked )
			local lblCancel = display.newText({
				text = "Cancelar",     
				x = midW - 125, y = midH + h + 80 ,
				font = native.systemFontBold,   
				fontSize = 42, align = "center"
			})
			lblCancel:setFillColor( 129/255, 61/255, 153/255 )
			grpBlocked:insert(lblCancel)
			lblCancel:addEventListener( 'tap', blockedChatMsg )
		else
			lblAccept:addEventListener( 'tap', blockedChatMsg )
		end
		
	else
		grpBlocked:removeSelf()
		grpBlocked = nil
	end
end

--bloquea o desbloquea el chats
function blocked( event )
	event.target:removeEventListener( "tap", blocked )
	RestManager.blokedChat(itemsConfig.channelId, itemsConfig.blockMe)
end

function noAction( event )
	return true
end

--cambia el estatus del bloqueo personal
function changeStatusBlock(status)
	itemsConfig.blockMe = status
	blockedChatMsg("", false, false)
end

--elimina la burbuja de mensajes no leidos
function deleteNotBubble()
	local titleScene = composer.getScene( "src.Messages" )
	if titleScene then
		createNotBubble( poscList, 0 )
	end
end
	
--envento input del textbox
function onTxtFocus( event )
	local fieldOffset, fieldTrans
	fieldOffset = intH/3 + 100
	if string.sub(system.getInfo("model"),1,4) == "iPad" then
	end
	fieldTrans = 200
	if ( event.phase == "began" ) then
		scrChat.height = scrChatH - fieldOffset
		scrChat.anchorY = 0
		transition.to( scrChat, { time=fieldTrans, y=(130 + h)} )
		transition.to( grpTextField, { time=fieldTrans, y=(-fieldOffset)} )
		grpChat.y = (scrChatH - scrChat.height) / 2
		scrChat:setScrollHeight( posY + fieldOffset )
    elseif ( event.phase == "ended") then
		native.setKeyboardFocus( nil )
		scrChat.anchorY = .5
		scrChat.height = scrChatH
		transition.to( scrChat, { time=fieldTrans, y=(scrChatY)} )
		transition.to( grpTextField, { time=fieldTrans, y=(0)} )
		grpChat.y = 0
		scrChat:setScrollHeight( posY )
	elseif (event.phase == "submitted" ) then	
		sentMessage()
    elseif ( event.phase == "editing" ) then
		
    end
end

--contruye el los mensajes del chats
function buildChat(poscD)
    for z = 1, #tmpList do
        local i = tmpList[z]
        if i.date then
			lastDate = i.date
            local bgDate = display.newRoundedRect( midW, posY, 350, 40, 20 )
            bgDate.anchorY = 0
            bgDate:setFillColor( 220/255, 186/255, 218/255 )
            grpChat:insert(bgDate)
            
            local lblDate = display.newText({
                text = i.date,     
                x = midW, y = posY + 20,
                font = "Lato-Regular",   
                fontSize = 25, align = "center"
            })
            lblDate:setFillColor( .1 )
            grpChat:insert(lblDate)
            
            posY = posY + 70
        else
            local bgM0 = display.newRoundedRect( 20, posY, 502, 80, 20 )
            bgM0.anchorX = 0
            bgM0.anchorY = 0
            bgM0.alpha = .2
            bgM0:setFillColor( .3 )
            grpChat:insert(bgM0)
            
            local bgM = display.newRoundedRect( 20, posY, 500, 77, 20 )
            bgM.anchorX = 0
            bgM.anchorY = 0
            bgM:setFillColor( 1 )
            grpChat:insert(bgM)
            
            local lblM = display.newText({
                text = i.message,     
                x = 40, y = posY + 10,
                font = "Lato-Regular",   
                fontSize = 30, align = "left"
            })
            lblM.anchorX = 0
            lblM.anchorY = 0
            lblM:setFillColor( .1 )
            grpChat:insert(lblM)
            
            if lblM.contentWidth > 450 then
                lblM:removeSelf()
                
                lblM = display.newText({
                    text = i.message, 
                    width = 450,
                    x = 40, y = posY + 10,
                    font = "Lato-Regular",   
                    fontSize = 30, align = "left"
                })
                lblM.anchorX = 0
                lblM.anchorY = 0
                lblM:setFillColor( .1 )
                grpChat:insert(lblM)
                
                if i.isMe then
                    lblM.x = 270
                end
                
                bgM.height = lblM.contentHeight + 30
                bgM0.height = lblM.contentHeight + 31
            else
                bgM.width = lblM.contentWidth + 40
                bgM0.width = lblM.contentWidth + 42
				if lblM.contentWidth < 60 then
					 bgM.width = 120
					 bgM0.width = 122
				end
                lblM.anchorX = 0
                if i.isMe then
                    lblM.anchorX = 1
                    lblM.x = intW - 40
                end
            end
            
			if poscD ~= 0 then
				lblDateTemp[poscD] = display.newText({
					text = "Cargando",
					x = lblM.x, y = posY + lblM.contentHeight + 20,
					font = "Lato-Regular",   
					fontSize = 18, align = "left"
				})
				lblDateTemp[poscD].anchorX = lblM.anchorX
				lblDateTemp[poscD]:setFillColor( .5 )
				grpChat:insert(lblDateTemp[poscD])
				if lblM.anchorX == 1 then
					lblDateTemp[poscD].anchorX = 0
					lblDateTemp[poscD].x = intW - bgM.width
				end
			else
				local lblTime = display.newText({
					text = i.time,
					x = lblM.x, y = posY + lblM.contentHeight + 20,
					font = "Lato-Regular",   
					fontSize = 18, align = "left"
				})
				lblTime.anchorX = lblM.anchorX
				lblTime:setFillColor( .5 )
				grpChat:insert(lblTime)
				if lblM.anchorX == 1 then
					lblTime.anchorX = 0
					lblTime.x = intW - bgM.width
				end
			end
            
            if i.isMe then
                bgM0.x = intW - 20
                bgM.x = intW - 20
                bgM0.anchorX = 1
                bgM.anchorX = 1
                bgM0.alpha = .3
                bgM:setFillColor( 178/255, 255/255, 178/255 )
            end
            
            posY = posY + bgM.height + 30
            if z < #tmpList then
                if tmpList[z+1].isMe == i.isMe then 
                    posY = posY - 20
                end
            end
        end
		
		if i.isRead == '0' and i.isMe == false then
			lastStatus = i.id
		end
		
    end
    local point = display.newRect( 1, posY + 30, 1, 1 )
	grpChat:insert(point)
	if scrChat.height <= posY + 30 then
		scrChat:setScrollHeight( posY )
		scrChat:scrollTo( "bottom", { time=0 } )
	end
	if lastStatus ~= 0 then
		RestManager.changeStatusMessages(itemsConfig.channelId, lastStatus)
	end
end

function setImagePerfilMessage(item)
	local avatar = display.newImage(item.photo, system.TemporaryDirectory)
	avatar:translate(150, 50 + h)
	avatar.width = 80
	avatar.height = 80
	screen:insert( avatar )
	local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
	avatar:setMask( maskCircle80 )
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
    local item = event.params.item
	poscList = item.posc
	screen = self.view
    screen.y = h
    grpTextField = display.newGroup()
	screen:insert( grpTextField )
    
    local bg = display.newRect( midW, midH + h, intW, intH, 20 )
    bg:setFillColor( 1 )
    screen:insert(bg)
	
    local o = display.newRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	    
    local bgH = display.newRect( midW, 50 + h, display.contentWidth, 100 )
    bgH:setFillColor( 1 )
    screen:insert(bgH)
    
    local bgHBtn = display.newRect( intW - 55, 50 + h, 130, 100 )
    bgHBtn:setFillColor( .95 )
    screen:insert(bgHBtn)
    
    -- Back button
	local btnBack = display.newImage("img/icoBack.png")
	btnBack:translate(50, 50 + h)
    btnBack:addEventListener( 'tap', toBack)
    screen:insert( btnBack )
    -- Image
	local path = system.pathForFile( item.photo, system.TemporaryDirectory )
	local fhd = io.open( path )
	if fhd then
		local avatar = display.newImage(item.photo, system.TemporaryDirectory)
		avatar:translate(150, 50 + h)
		avatar.width = 80
		avatar.height = 80
		screen:insert( avatar )
		local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
		avatar:setMask( maskCircle80 )
	else
		item.image = item.photo
		local items = {}
		items[1] = item
		RestManager.getImagePerfilMessage(items)
	end
	
	--btn bloquear
	local btnBlock = display.newImage("img/cancel-icon-2.png")
    btnBlock:translate(intW - 55, 50 + h)
    btnBlock.width = 70
    btnBlock.height = 70
    screen:insert( btnBlock )
    btnBlock:addEventListener( 'tap', blockedChat )
	
    -- Name
    local lblName = display.newText({
        text = item.name,     
        x = midW + 130, y = 55 + h,
        width = 600,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( .3 )
    screen:insert(lblName)
    
   scrChat = widget.newScrollView
    {
        top = 130 + h,
        left = 0,
        width = intW,
        height = intH - 220 - h,
        scrollWidth = 600,
        scrollHeight = 800,
        hideBackground = true
    }
    screen:insert(scrChat)  
	grpChat = display.newGroup()
	scrChat:insert( grpChat )
    
    local bgSendField = display.newRect( midW, intH - 45, intW, 90 )
    bgSendField:setFillColor( .84 )
    grpTextField:insert(bgSendField)
    
    local bgSend = display.newRect( intW - 75, intH - 45, 150, 90 )
    bgSend:setFillColor( 68/255, 14/255, 98/255 )
	bgSend:addEventListener( 'tap', sentMessage )
    grpTextField:insert(bgSend)
    
    local lblSend = display.newText({
        text = "ENVIAR",     
        x = intW - 75, y = intH - 45, width = 150,
        font = "Lato-Regular",   
        fontSize = 30, align = "center"
    })
    lblSend:setFillColor( 1 )
    grpTextField:insert(lblSend)
    
    local bgField = display.newRoundedRect(  midW - 75, intH - 45, intW - 190, 60, 20 )
    bgField:setFillColor( 1 )
    grpTextField:insert(bgField)
	
	txtMessage = native.newTextField( midW - 75, intH - 45, intW - 200, 50 )
    txtMessage.inputType = "default"
    txtMessage.hasBackground = true
	--txtMessage.channelId = item.channelId
    txtMessage:addEventListener( "userInput", onTxtFocus )
	txtMessage:setReturnKey( "send" )
	grpTextField:insert( txtMessage )
	
	posY = 30
	scrChatY = scrChat.y
	scrChatH = scrChat.height
	
	itemsConfig = {blockYour = item.blockYour, blockMe = item.blockMe, channelId = item.channelId, display_name = item.name } 
	
	RestManager.getChatMessages(item.channelId)
	
	grpTextField:toFront()
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide scene
function scene:hide( event )
	native.setKeyboardFocus( nil )
end

-- Destroy scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene