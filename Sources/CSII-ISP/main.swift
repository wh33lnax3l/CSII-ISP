import Curses
import Foundation

let screen = Screen.shared

//Definition of Handler class necessary to exit. 
class Handler : CursesHandlerProtocol{
    func interruptHandler(){
        screen.shutDown()
        print("Exited cleanly")
        exit(0)
    }

    func windowChangedHandler(){
    }
}

// Initializes All Curses Functionalities
screen.startUp(handler:Handler())
let mainWindow = screen.window
let cursor = mainWindow.cursor
let colors = Colors.shared
precondition(colors.areSupported, "This terminal doesn't support colors")
colors.startUp()
let keyboard = Keyboard.shared

// Adds colors and color pairs
let white = Color.standard(.white)
let black = Color.standard(.black)
let blackOnWhite = colors.newPair(foreground:black, background:white)

// Initializes databases
var globalTextStack = TextStack(window:mainWindow) // Displays messages thrown on right side of screen
var pokemonDatabase : PokemonDatabase
do{
    pokemonDatabase = try PokemonDatabase()    
}catch{
    fatalError("The Pokemon Database could not be initialized")
}
var movesDatabase : MovesDatabase
do{
    movesDatabase = try MovesDatabase()
}catch{
    fatalError("The Moves Database could not be initialized")
}

writeAtLocation("Press any key to move the cursor and ENTER to progress.", location: Point(x:0, y:0))

let databaseOrEnemy = ButtonSelect(window:mainWindow, buttonPairArray:[("Enter Enemy Pokemon", Point(x:0, y:1)),
                                                                       ("Update Database Tables", Point(x:0, y:2))])
databaseOrEnemy.renderButtons()
while true{
    let keyPress = keyboard.getKey(window:mainWindow)    
    if keyPress.keyType != .isControl{
        databaseOrEnemy.cycleSelectedButton()       
    }else if keyPress.control! == 10{
        if databaseOrEnemy.receiveButton() == "Update Database Tables"{
            generatePokemonDatabase(pokemon:&pokemonDatabase, textStack:globalTextStack)
            generateMovesDatabase(moves:&movesDatabase, textStack:globalTextStack)
            mainWindow.clear()
            writeAtLocation("Finished populating databases!", location: Point(x:0, y:0))
            mainWindow.refresh()
            sleep(5) // Used to allow time to show that it has concluded
        }
        break
    }
}

// Receive the enemy button
let enemyPokemon = receiveInput(window:mainWindow)
mainWindow.clear()
writeAtLocation("Processing...", location: Point(x:0, y:0))
mainWindow.refresh()
let pokemonTeam = calculateTeam(enemy:enemyPokemon, textStack:globalTextStack)
let leftOrRight = ButtonSelect(window:mainWindow, buttonPairArray:[("<--", Point(x:0, y:9)),
                                                                   ("-->", Point(x:4, y:9))])
var teamIndex = 0
writePokemon(index:teamIndex, window:mainWindow)
while true{
    let keyPress = keyboard.getKey(window:mainWindow)
    if keyPress.keyType != .isControl{
        leftOrRight.cycleSelectedButton()
    }else if keyPress.control! == 10{
        if leftOrRight.receiveButton() == "<--"{
            teamIndex = (teamIndex + 5) % 6
        }else if leftOrRight.receiveButton() == "-->"{
            teamIndex = (teamIndex + 1) % 6
        }
        writePokemon(index:teamIndex, window:mainWindow)
    }
}

func writePokemon(index:Int, window:Window){
    window.clear()
    writeAtLocation("Pokemon \(index + 1)/6", location: Point(x:0, y:0))
    writeAtLocation("Calculated DPS:\(pokemonTeam[index].0)", location: Point(x:0, y:1))
    writeAtLocation("Pokemon:\(pokemonTeam[index].1.species.name)",location: Point(x:0, y:2))
    writeAtLocation("CP:\(pokemonTeam[index].1.combatPoints)",location: Point(x:0, y:3))
    writeAtLocation("Attack:\(pokemonTeam[index].1.attack)",location: Point(x:0, y:4))
    writeAtLocation("Defense:\(pokemonTeam[index].1.defense)",location: Point(x:0, y:5))
    writeAtLocation("HP:\(pokemonTeam[index].1.health)",location: Point(x:0, y:6))
    writeAtLocation("Quick Move:\(pokemonTeam[index].1.quick.name)",location: Point(x:0, y:7))
    writeAtLocation("1st Charge Move:\(pokemonTeam[index].1.chargeOne.name)",location: Point(x:0, y:8))
    leftOrRight.renderButtons()
    writeAtLocation("Press CTRL + C to quit, Enter to switch pokemon, or any other button to move the cursor",location: Point(x:0, y:10))
    window.refresh()
}
