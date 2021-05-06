import Foundation

public struct Pokemon{
    public let species : Species
    public let combatPoints : Int    
    private let multiplier : Double
    public let attack : Int
    public let defense : Int
    public let health : Int
    public let quick : Move 
    public let chargeOne : Move
    public let chargeTwo : Move?
    
    public init(name: String, cp: Int?, attack: Int?, defense: Int?, health: Int?, quick: String, chargeOne: String, chargeTwo: String) throws{
        
        try self.species = Species(name:name.uppercased())
        
        if cp == nil{
            throw InputError.combatPointsNotNum
        }else{
            self.combatPoints = cp!
        }

        if attack == nil{
            throw InputError.attackIVNotNum
        }else if !(0...15).contains(attack!){
            throw InputError.attackIVNotInRange
        }
        
        if defense == nil{
            throw InputError.defenseIVNotNum
        }else if !(0...15).contains(defense!){
            throw InputError.defenseIVNotInRange
        }
        
        if health == nil{
            throw InputError.healthPointsIVNotNum
        }else if !(0...15).contains(health!){
            throw InputError.healthPointsIVNotInRange
        }
        
        let unmultipliedAttack = Double(attack! + self.species.baseAttack)
        let unmultipliedDefense = Double(defense! + self.species.baseDefense)
        let unmultipliedStamina = Double(health! + self.species.baseStamina)
        self.multiplier = pow((Double(combatPoints) * 10.0) / (unmultipliedAttack * pow(unmultipliedDefense, 0.5) * pow(unmultipliedStamina, 0.5)), 0.25) 
        self.attack = Int(unmultipliedAttack * multiplier)
        self.defense = Int(unmultipliedDefense * multiplier)
        self.health = Int(unmultipliedStamina * multiplier)
                        
        if species.quickMoveset.contains("\(quick.uppercased().replacingOccurrences(of: " ", with: "_"))_FAST"){
            try self.quick = Move(quickMove:quick.uppercased().replacingOccurrences(of: " ", with: "_"))
        }else{
            throw InputError.quickMoveNotInMoveset
        }

        if species.chargeMoveset.contains(chargeOne.uppercased().replacingOccurrences(of: " ", with: "_")){
            try self.chargeOne = Move(chargeMove:chargeOne.uppercased().replacingOccurrences(of: " ", with: "_"))
        }else{
            throw InputError.chargeMoveNotInMoveset
        }

        if species.chargeMoveset.contains(chargeTwo.uppercased().replacingOccurrences(of: " ", with: "_")){
            try self.chargeTwo = Move(chargeMove:chargeTwo.uppercased().replacingOccurrences(of: " ", with: "_"))
        }else if chargeTwo != ""{
            throw InputError.chargeMoveNotInMoveset
        }else{
            self.chargeTwo = nil
        }
    }
}
