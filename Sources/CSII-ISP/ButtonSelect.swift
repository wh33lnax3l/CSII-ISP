import Curses

public class ButtonSelect{

    public typealias ButtonPairArray = [(String, Point)]
    private let buttons : ButtonPairArray
    private let window : Window
    private var highlightedIndex = 0
    
    init(window:Window, buttonPairArray:ButtonPairArray){
        self.window = window
        self.buttons = buttonPairArray
    }

    public func renderButtons(){
        for i in 0..<buttons.count{
            if highlightedIndex == i{
                window.turnOn(blackOnWhite)
                writeAtLocation(buttons[i].0, location: buttons[i].1)
                window.turnOff(blackOnWhite)
            }else{
                writeAtLocation(buttons[i].0, location: buttons[i].1)
            }
        }
        window.refresh()
    }

    public func cycleSelectedButton(){
        highlightedIndex = (highlightedIndex + 1) % buttons.count
        renderButtons()
    }

    public func receiveButton() -> String{ 
        return buttons[highlightedIndex].0
    }
}
