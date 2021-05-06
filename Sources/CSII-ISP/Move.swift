import Foundation

public class Move{

    public let name : String
    public let idNumber : Int
    public let type : PokemonType
    public let power : Int
    public let duration : Int?
    public let accuracy : Int?
    public let critical : Int?
    public let energyChange : Int
    
    public init(quickMove:String) throws{       
        if movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.name, name:"\(quickMove)_FAST") == "\(quickMove)_FAST"{            
            self.name = quickMove
            self.idNumber = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.idNumber, name:"\(quickMove)_FAST")) ?? 0
            self.type = PokemonType(rawValue: movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.type, name:"\(quickMove)_FAST"))!
            self.power = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.power, name:"\(quickMove)_FAST")) ?? 0
            if let duration = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.duration, name:"\(quickMove)_FAST")){
                self.duration = duration
            }else{
                self.duration = nil
            }
            if let accuracy = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.accuracy, name:"\(quickMove)_FAST")){
                self.accuracy = accuracy
            }else{
                self.accuracy = nil
            }
            if let critical = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.critical, name:"\(quickMove)_FAST")){
                self.critical = critical // Critical is usually empty, but will fail the if let when cast to Int if so
            }else{
                self.critical = nil
            }
            self.energyChange = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.energyChange, name:"\(quickMove)_FAST")) ?? 0
        }else{
            throw InputError.quickMoveNotReal
        }
    }

    public init(chargeMove:String) throws{
        if movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.name, name:chargeMove) == chargeMove{
            self.name = chargeMove
            self.idNumber = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.idNumber, name:chargeMove)) ?? 0
            self.type = PokemonType(rawValue: movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.type, name:chargeMove))!
            self.power = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.power, name:chargeMove)) ?? 0
            if let duration = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.duration, name:chargeMove)){
                self.duration = duration
            }else{
                self.duration = nil
            }
            if let accuracy = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.accuracy, name:chargeMove)){
                self.accuracy = accuracy
            }else{
                self.accuracy = nil
            }
            if let critical = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.critical, name:chargeMove)){
                self.critical = critical // Critical is usually empty, but will fail the if let when cast to Int if so
            }else{
                self.critical = nil
            }
            self.energyChange = Int(movesDatabase.queryDataGivenName(dataColumn:MoveQueryType.energyChange, name:chargeMove)) ?? 0
        }else{
            throw InputError.chargeMoveNotReal
        }
    }
}
