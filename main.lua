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
composer.gotoScene("src.Login")

function DidReceiveRemoteNotification(message, additionalData, isActive)
	
    if isActive then
		
		if (additionalData) then
			if additionalData.type == "1" then
				
				local currScene = composer.getSceneName( "current" )
				if currScene == "src.Message" then
					local item = json.decode(additionalData.item)
					displaysInList(item[1], false )
				end
			else
				system.vibrate()
			end
		end
		
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

local OneSignal = require("plugin.OneSignal")
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("b7f8ee34-cf02-4671-8826-75d45b3aaa07", "203224641778", DidReceiveRemoteNotification)

function IdsAvailable(playerID, pushToken)
  --print("PLAYER_ID:" .. playerID)
	--Globals.playerIdToken = playerID
end

OneSignal.IdsAvailableCallback(IdsAvailable)