import Curses

public func writeAtLocation(_ string: String, location: Point){
    cursor.pushPosition(newPosition: location)
    if string == ""{
        mainWindow.write("No value")
    }else{
        mainWindow.write(string)
    }
    cursor.popPosition()
}
