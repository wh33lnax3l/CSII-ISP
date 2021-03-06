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

// Defines function to write test at a given point
func writeAtLocation(_ string: String, location: Point){
    cursor.pushPosition(newPosition: location)
    if string == ""{
        mainWindow.write("No value")
    }else{
        mainWindow.write(string)
    }
    cursor.popPosition()
}

// Adds colors and color pairs
let white = Color.standard(.white)
let black = Color.standard(.black)
let blackOnWhite = colors.newPair(foreground:black, background:white)

// Adds label text
writeAtLocation("Enter the data of enemy pokemon",location: Point(x:0, y:0))
writeAtLocation("Pokemon:            ",location: Point(x:0, y:1))
writeAtLocation("CP:                 ",location: Point(x:0, y:2))
writeAtLocation("Attack IV:          ",location: Point(x:0, y:3))
writeAtLocation("Defense IV:         ",location: Point(x:0, y:4))
writeAtLocation("HP IV:              ",location: Point(x:0, y:5))
writeAtLocation("Quick Move:         ",location: Point(x:0, y:6))
writeAtLocation("1st Charge Move:    ",location: Point(x:0, y:7))
writeAtLocation("2nd Charge Move:    ",location: Point(x:0, y:8))
mainWindow.refresh()

let tempStorage = receiveInput()
writeAtLocation("I have a Pokemon!",location: Point(x:0, y:9))
// Close cleanly
screen.wait()
