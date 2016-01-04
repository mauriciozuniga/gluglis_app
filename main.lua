---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

display.setStatusBar( display.TranslucentStatusBar )
local json = require("json")
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
display.setDefault( "background", 0 )
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

local isUser = DBManager.setupSquema()
composer.gotoScene("src.Home")

---------------------Notificaciones---------------------------

------------------------------------------------
-- evento cuando se recibe y abre una notificacion
-- @param message mensaje de la notificacion
-- @param additionalData identificador y tipo de mensaje
-- @param isActive indica si la app esta abierta
------------------------------------------------
function DidReceiveRemoteNotification(message, additionalData, isActive)
	--determina si la aplicacion esta activa
    if isActive then
		if (additionalData) then
			--define el tipo de notificacion
			if additionalData.type == "1" then
				local item = json.decode(additionalData.item)
				local currScene = composer.getSceneName( "current" )
				--si la scena actual es message pinta los nuevos mensajes 
				if currScene == "src.Message" then
					displaysInList(item[1], false )
				else
					system.vibrate()
				end
				--si la scena messages existe acomoda los chats
				local titleScene = composer.getScene( "src.Messages" )
				if titleScene then
					movedChat(item[1], item[1].message, item[1].NoRead)
				end
			end
		end
	--si no esta activa te manda al chat de la notificacion
	else
		if (additionalData) then
			if additionalData.type == "1" then
				local RestManager = require('src.resources.RestManager')
				local item = json.decode(additionalData.item)
				local tmpListMain = {}
				tmpListMain[1] = {id = item[1].id, photo = "mariana.jpeg", name = item[1].display_name, subject = item[1].message, channelId = item[1].channel_id}
				composer.removeScene( "src.Message" )
				composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = tmpListMain[1] } } )
			end
		end
	end
end

------------------------------------------------
-- inicializa el plugin de notificaciones
------------------------------------------------
local OneSignal = require("plugin.OneSignal")
OneSignal.Init("b7f8ee34-cf02-4671-8826-75d45b3aaa07", "203224641778", DidReceiveRemoteNotification)

------------------------------------------------
-- obtiene el token por telefono
------------------------------------------------
function IdsAvailable(playerID, pushToken)
  --print("PLAYER_ID:" .. playerID)
	--Globals.playerIdToken = playerID
end

------------------------------------------------
-- llama a la funcion para obtener el token del telefono
------------------------------------------------
OneSignal.IdsAvailableCallback(IdsAvailable)