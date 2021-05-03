import Curses

class TextStack{
    private var stack = [String]()
    private let stackSize : Int
    private let window : Window
    
    public init(window:Window){
        self.window = window
        stackSize = window.size.height
    }

    public func appendText(_ text:String){    
        stack.append(text)
        if stack.count > stackSize{
            stack.removeFirst()
        }
        for i in 0..<stack.count{
            writeAtLocation(stack[i],location: Point(x:0, y:i))
        }
        window.refresh()
    }
    
}
