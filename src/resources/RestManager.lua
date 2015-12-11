--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	
	local settings = DBManager.getSettings()
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	--obtiene la lista de los mensajes
	RestManager.getListMessageChat = function()
	
        local settings = DBManager.getSettings()
		
        -- Set url
        local url = settings.url
        url = url.."api/getListMessageChat/format/json"
        url = url.."/idApp/"..settings.idApp
	
        local function callback(event)
			
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							setItemsListMessages(data.items)
						else
							notListMessages()
						end
					else
						noConnectionMessages("Error con el servidor. Intentelo mas tarde")
					end
				else
					noConnectionMessages("Error con el servidor. Intentelo mas tarde")
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessages('No se detecto conexion a internet')
		end
    end
	
	--obtiene los mensajes del chat seleccionado
	RestManager.getChatMessages = function(channelId)
	
        local settings = DBManager.getSettings()
		
        -- Set url
        local url = settings.url
        url = url.."api/getChatMessages/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/channelId/".. channelId
		
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							setItemsMessages(data.items)
							--notChatsMessages()
						else
							notChatsMessages()
						end
					else
						noConnectionMessage('Error con el servidor. Intentelo mas tarde')
					end
				else
					noConnectionMessage('Error con el servidor. Intentelo mas tarde')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	--envia el chat
	RestManager.sendChat = function(channelId, message, poscM, dateM)
	
        local settings = DBManager.getSettings()
		
        -- Set url
        local url = settings.url
        url = url.."api/saveChat/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/message/" .. urlencode(message)
		url = url.."/dateM/" .. urlencode(dateM)
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							changeDateOfMSG(data.items[1],poscM)
						else
							noConnectionMessage('Error con el servidor')
						end
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	RestManager.blokedChat = function(channelId,status)
	
        local settings = DBManager.getSettings()
		
        -- Set url
        local url = settings.url
        url = url.."api/blokedChat/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/status/" .. status
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						changeStatusBlock(data.status)
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	--obtiene la fecha actual
	RestManager.getDate = function()
		local date = os.date( "*t" )    -- Returns table of date & time values
		local year = date.year
		local month = date.month
		local month2 = date.month
		local day = date.day
		local hour = date.hour
		local minute = date.min
		local segunds = date.sec 
		
		if month < 10 then
			month = "0" .. month
		end
		
		if day < 10 then
			day = "0" .. day
		end
		
		local date1 = year .. "-" .. month .. "-" .. day .. " " .. hour .. ":" .. minute .. ":" .. segunds
		
		local months = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'}
		date2 = day .. " de " .. months[month2] .. " del " .. year
		
		
		
		return {date1,date2}
	end
	
	--comprueba si existe conexion a internet
	function networkConnection()
		local netConn = require('socket').connect('www.google.com', 80)
		if netConn == nil then
			return false
		end
		netConn:close()
		return true
	end
	
return RestManager