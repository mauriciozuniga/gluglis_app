---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.resources.Globals')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpMain, grpNew, grpLogIn
local scene = composer.newScene()

-- Variables
local newH = 0
local h = display.topStatusBarContentHeight
local txtEmail, txtPass, txtRePass, txtEmailS, txtPassS


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function moveBack(event)
    if (grpNew.x < -100) then
        transition.to( grpNew, { x = 768, time = 400 })
    else
        transition.to( grpLogIn, { x = 768, time = 400 })
    end
    transition.to( grpMain, { x = 0, time = 400 } )
end

function moveNew(event)
    local t = event.target
    t.alpha = .5
    grpNew.alpha = 1
    grpLogIn.alpha = 0
    transition.to( grpMain, { x = -768, time = 400 } )
    transition.to( grpNew, { x = 0, time = 400, onComplete = function() t.alpha = .01 end })
    
end

function moveLogIn(event)
    local t = event.target
    t.alpha = .5
    grpNew.alpha = 0
    grpLogIn.alpha = 1
    transition.to( grpMain, { x = -768, time = 400 } )
    transition.to( grpLogIn, { x = 0, time = 400, onComplete = function() t.alpha = .01 end })
end

function logInFB(event)
    txtEmail:removeSelf()
    txtPass:removeSelf()
    txtRePass:removeSelf()
    txtEmailS:removeSelf()
    txtPassS:removeSelf()
    composer.gotoScene("src.Home", { time = 400, effect = "fade" } )
end

function onTxtFocus(event)
end

function getLine(parent, x, y)
    local line = display.newRect( x, y, intW, 6 )
    line:setFillColor( {
        type = 'gradient',
        color1 = { 1, .5 }, 
        color2 = { .3, .2 },
        direction = "top"
    } ) 
    parent:insert(line)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    screen.y = h
    
    local o = display.newRect( midW, midH + 30, intW, intH )
    o:setFillColor( 232/255 )   
    screen:insert(o)
    
    -- Logo on circle
    local circle1 = display.newCircle( screen, midW, (midH*.45), 160 )
    circle1:setFillColor( .84 )
    local circle2 = display.newCircle( screen, midW, (midH*.45), 145 )
    circle2:setFillColor( 1 )    
    local logo = display.newImage( screen, "img/logo.png" )
    logo:translate( midW, (midH*.45) )
    
    -- Text Descrip
    newH = circle1.y + (circle1.height / 2) + 50
    local lblTitle = display.newText({
        text = "Gluglis",     
        x = midW, y = newH,
        font = native.systemFont,   
        fontSize = 35, align = "center"
    })
    screen:insert(lblTitle)
    local lblSubTitle = display.newText({
        text = "an app to travel free",     
        x = midW, y = newH + 35,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    lblSubTitle:setFillColor( 69/255, 189/255, 222/255 )
    screen:insert(lblSubTitle)
    
    -- Main options
    grpMain = display.newGroup()
    screen:insert(grpMain)
    -- Set Lines
    getLine(grpMain, midW, midH)
    getLine(grpMain, midW, midH + 100)
    getLine(grpMain, midW, midH + 210)
    getLine(grpMain, midW, midH + 310)
    getLine(grpMain, midW, midH + 410)
    -- Set FB
    local btnFB = display.newRect( midW, midH + 50, intW, 100 )
    btnFB:setFillColor( .7 )
    btnFB.alpha = .01
    btnFB:addEventListener( 'tap', logInFB)
    grpMain:insert(btnFB)
    local lblFB = display.newText({
        text = "Entrar con Facebook",     
        x = midW + 80, y = midH + 50,
        width = 400,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblFB:setFillColor( 0/255, 56/255, 114/255 )
    grpMain:insert(lblFB)
    local logoFB = display.newImage(grpMain, "img/logoFaceBook.png" )
    logoFB:translate( midW - 160, midH + 50 )
    -- Set link New
    local btnNewW = display.newRect( midW, midH + 260, intW, 100 )
    btnNewW:setFillColor( .7 )
    btnNewW.alpha = .01
    btnNewW:addEventListener( 'tap', moveNew)
    grpMain:insert(btnNewW)
    local lblNew = display.newText({
        text = "Registrarte",     
        x = midW + 80, y = midH + 260,
        width = 400,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblNew:setFillColor( .52 )
    grpMain:insert(lblNew)
    local icoNew = display.newImage( grpMain, "img/icoNew.png" )
    icoNew:translate( midW - 165, midH + 260 )
    -- Set link SignIn
    local btnEmail = display.newRect( midW, midH + 360, intW, 100 )
    btnEmail:setFillColor( .7 )
    btnEmail.alpha = .01
    btnEmail:addEventListener( 'tap', moveLogIn)
    grpMain:insert(btnEmail)
    local lblSignIn = display.newText({
        text = "Acceder con E-mail",     
        x = midW + 80, y = midH + 360,
        width = 400,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblSignIn:setFillColor( .52 )
    grpMain:insert(lblSignIn)
    local icoSignIn = display.newImage( grpMain, "img/icoSignIn.png" )
    icoSignIn:translate( midW - 165, midH + 360 )
    
    
    -- Create New
    local midR = midW + 768
    grpNew = display.newGroup()
    grpMain:insert(grpNew)
    local btnBack = display.newImage( grpNew, "img/btnBack.png" )
    btnBack:translate( midR - 335, midH - 45 )
    btnBack:addEventListener( 'tap', moveBack)
    -- Set Lines
    getLine(grpNew, midR, midH)
    getLine(grpNew, midR, midH + 100)
    getLine(grpNew, midR, midH + 200)
    getLine(grpNew, midR, midH + 300)
    -- Set text email
    local lblEmail = display.newText({
        text = "E-mail:",     
        x = midR - 190, y = midH + 50,
        width = 240,
        font = native.systemFont,   
        align = "left",
        fontSize = 30
    })
    lblEmail:setFillColor( .52 )
    grpNew:insert(lblEmail)
    txtEmail = native.newTextField( midR + 100, midH + 50, 400, 70 )
    txtEmail.inputType = "email"
    txtEmail.hasBackground = false
    txtEmail:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtEmail)
    -- Set text password
    local lblPass = display.newText({
        text = "Contraseña:",     
        x = midR - 190, y = midH + 150,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblPass:setFillColor( .52 )
    grpNew:insert(lblPass)
    txtPass = native.newTextField( midR + 100, midH + 150, 400, 70 )
    txtPass.inputType = "password"
    txtPass.hasBackground = false
    txtPass:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtPass)
    -- Set text re-password
    local lblRePass = display.newText({
        text = "Re-Contraseña:",     
        x = midR - 190, y = midH + 250,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRePass:setFillColor( .52 )
    grpNew:insert(lblRePass)
    txtRePass = native.newTextField( midR + 100, midH + 250, 400, 70 )
    txtRePass.inputType = "password"
    txtRePass.hasBackground = false
    txtRePass:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtRePass)
    -- Button
    local btnNew = display.newRect( midR, midH + 450, intW, 100 )
    btnNew:setFillColor( 128/255, 72/255, 149/255 )
    btnNew:addEventListener( 'tap', logInFB)
    grpNew:insert(btnNew)
    local lblRegistrar = display.newText({
        text = "Registrarme",     
        x = midR + 70, y = midH + 450,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRegistrar:setFillColor( 217/255, 200/255, 223/255 )
    grpNew:insert(lblRegistrar)
    local icoRegistrar = display.newImage( grpNew, "img/icoRegistrar.png" )
    icoRegistrar:translate( midR - 80, midH + 450 )
    
    
    -- LogIn
    grpLogIn = display.newGroup()
    grpMain:insert(grpLogIn)
    local btnBack2 = display.newImage( grpLogIn, "img/btnBack.png" )
    btnBack2:translate( midR - 335, midH - 45 )
    btnBack2:addEventListener( 'tap', moveBack)
    -- Set Lines
    getLine(grpLogIn, midR, midH)
    getLine(grpLogIn, midR, midH + 100)
    getLine(grpLogIn, midR, midH + 200)
    -- Set text email
    local lblEmailS = display.newText({
        text = "E-mail:",     
        x = midR - 190, y = midH + 50,
        width = 240,
        font = native.systemFont,   
        align = "left",
        fontSize = 30
    })
    lblEmailS:setFillColor( .52 )
    grpLogIn:insert(lblEmailS)
    txtEmailS = native.newTextField( midR + 100, midH + 50, 400, 70 )
    txtEmailS.inputType = "email"
    txtEmailS.hasBackground = false
    txtEmailS:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtEmailS)
    -- Set text password
    local lblPassS = display.newText({
        text = "Contraseña:",     
        x = midR - 190, y = midH + 150,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblPassS:setFillColor( .52 )
    grpLogIn:insert(lblPassS)
    txtPassS = native.newTextField( midR + 100, midH + 150, 400, 70 )
    txtPassS.inputType = "password"
    txtPassS.hasBackground = false
    txtPassS:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtPassS)
    -- Button
    local btnSignIn = display.newRect( midR, midH + 350, intW, 100 )
    btnSignIn:setFillColor( 128/255, 72/255, 149/255 )
    btnSignIn:addEventListener( 'tap', logInFB)
    grpLogIn:insert(btnSignIn)
    local lblSignIn = display.newText({
        text = "Acceder",     
        x = midR + 70, y = midH + 350,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblSignIn:setFillColor( 220/255, 186/255, 218/255 )
    grpLogIn:insert(lblSignIn)
    local icoLogIn = display.newImage( grpLogIn, "img/icoLogIn.png" )
    icoLogIn:translate( midR - 80, midH + 350 )
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide Scene
function scene:hide( event )
end

-- Remove Scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene