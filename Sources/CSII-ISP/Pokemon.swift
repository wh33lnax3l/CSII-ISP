public struct Pokemon{
    private let name : String // Might change later? Make subtype with attributes like moveset, type etc.
    private let combatPoints : Int
    private let attack : Int
    private let defense : Int
    private let health : Int
    private let quick : String // Change to "Move" type, will at least need functionality, could be subtype of the name subtype?
    private let chargeOne : String
    private let chargeTwo : String
    
    public init(name: String, cp: Int?, attack: Int?, defense: Int?, health: Int?, quick: String, chargeOne: String, chargeTwo: String) throws{
        self.name = name
        if cp == nil{
            throw InputError.combatPointsNotNum
        }else{
            self.combatPoints = cp!
        }
        if attack == nil{
            throw InputError.attackIVNotNum
        }else if !(0...15).contains(attack!){
            throw InputError.attackIVNotInRange
        }else{
            self.attack = attack!
        }
        if defense == nil{
            throw InputError.defenseIVNotNum
        }else if !(0...15).contains(defense!){
            throw InputError.defenseIVNotInRange
        }else{
            self.defense = defense!
        }
        if health == nil{
            throw InputError.healthPointsIVNotNum
        }else if !(0...15).contains(health!){
            throw InputError.healthPointsIVNotInRange
        }else{   
            self.health = health!
        }
        self.quick = quick
        self.chargeOne = chargeOne
        self.chargeTwo = chargeTwo
    }
}
