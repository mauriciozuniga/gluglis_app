--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	
	local settings = DBManager.getSettings()
	local site = settings.url

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
        -- Set url
        local url = site
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
        -- Set url
        local url = site
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
        -- Set url
        local url = site
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
        -- Set url
        local url = site
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




    ---------------------------------- Pantalla HOME ----------------------------------
    -------------------------------------
    -- Obtiene los usuarios por ubicacion
    -------------------------------------
    RestManager.getUsersByCity = function()
        local url = site.."api/getUsersByCity/format/json"
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end


    ---------------------------------- Metodos Comunes ----------------------------------
    -------------------------------------
    -- Redirije al metodo de la escena
    -- @param obj registros de la consulta
    -------------------------------------
    function goToMethod(obj)
        if obj.name == "HomeAvatars" then
            getFirstCards(obj.items)
        end
    end 

    -------------------------------------
    -- Carga de la imagen del servidor o de TemporaryDirectory
    -- @param obj registros de la consulta con la propiedad image
    ------------------------------------- 
    function loadImage(obj)
        -- Next Image
        if obj.idx < #obj.items then
            -- actualizamos index
            obj.idx = obj.idx + 1
            -- Determinamos si la imagen existe
            local img = obj.items[obj.idx].image
            local path = system.pathForFile( img, system.TemporaryDirectory )
            local fhd = io.open( path )
            if fhd then
                -- Existe la imagen
                fhd:close()
                loadImage(obj)
            else
                local function imageListener( event )
                    if ( event.isError ) then
                    else
                        -- Eliminamos la imagen creada
                        event.target:removeSelf()
                        event.target = nil
                        loadImage(obj)
                    end
                end
                -- Descargamos de la nube
                display.loadRemoteImage( site..obj.path..img,"GET", imageListener, img, system.TemporaryDirectory ) 
            end
        else
            -- Dirigimos al metodo pertinente
            goToMethod(obj)
        end
    end


	
return RestManager