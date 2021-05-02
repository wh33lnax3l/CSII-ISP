import SQLite
import Foundation

public class PokemonDatabase{
    private let db : Connection // Effectively just a connection to sqlite3 
    let pokemon = Table("pokemon")
    
    let name = Expression<String>("name")
    let dexNumber = Expression<Int>("dex_number")
    let primaryType = Expression<String>("primary_type")
    let secondaryType = Expression<String?>("secondary_type")
    let baseStamina = Expression<Int>("base_stamina")
    let baseAttack = Expression<Int>("base_attack")
    let baseDefense = Expression<Int>("base_defense")
    let quickMoves = Expression<String>("quick_moves")
    let chargeMoves = Expression<String>("charge_moves")
        
    init() throws{
        self.db = try Connection("~/CSII-ISP/Sources/CSII-ISP/pokemon.sqlite3")
        try db.run(pokemon.create(ifNotExists: true) { t in
                       t.column(name, primaryKey: true)
                       t.column(dexNumber, unique: true)
                       t.column(primaryType)
                       t.column(secondaryType)
                       t.column(baseStamina)
                       t.column(baseAttack)
                       t.column(baseDefense)
                       t.column(quickMoves)
                       t.column(chargeMoves)
                   })
    }

    public func insertData(name:String, dexNumber:Int, primaryType:String, secondaryType:String?, baseStamina:Int, baseAttack:Int, baseDefense:Int, quickMoves:String, chargeMoves:String){        
        do{                     
            let rowId = try db.run(pokemon.insert(self.name <- name,
                                                  self.dexNumber <- dexNumber,
                                                  self.primaryType <- primaryType,
                                                  self.secondaryType <- secondaryType,
                                                  self.baseStamina <- baseStamina,
                                                  self.baseAttack <- baseAttack,
                                                  self.baseDefense <- baseDefense,
                                                  self.quickMoves <- quickMoves,
                                                  self.chargeMoves <- chargeMoves))
            print("Inserted in Pokemon at rowId: \(rowId)")
        }catch let Result.error(message, _, statement){
            // This is supposed to occur any time a duplicate name is attempted to be inserted
            // This is kinda a botch job. The signature *should* be catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT, but it doesn't understand the error literal
            precondition(statement != nil, "Statement in error \(message) was null")
            print("Constraint failed: \(message), in \(statement!)")            
        }catch let error{
            print("Failed to insert: \(error)")
        }
    }

    public func queryDataGivenName(dataColumn:PokemonQueryType, name:String) -> String{ // Consider throwing from query?        
        do {
            try db.run(pokemon.createIndex(name, unique: true, ifNotExists:true))
            switch dataColumn{          
            case .dexNumber:
                for monster in try db.prepare(pokemon.select(self.name, dexNumber).filter(self.name == name)){
                    return String(monster[dexNumber])
                }
            case .primaryType:
                for monster in try db.prepare(pokemon.select(self.name, primaryType).filter(self.name == name)){
                    return monster[primaryType]
                }
            case .secondaryType:
                for monster in try db.prepare(pokemon.select(self.name, dexNumber).filter(self.name == name)){
                    guard let result = monster[secondaryType] else{
                        fatalError("Queried pokemon \(name), resulting in row at \(monster[self.name]) does not have secondry type.") // Make this throw an error or a functionally negligible type                        
                    }
                    return result
                }
            case .baseStamina:
                for monster in try db.prepare(pokemon.select(self.name, baseStamina).filter(self.name == name)){
                    return String(monster[baseStamina])
                }
            case .baseAttack:
                for monster in try db.prepare(pokemon.select(self.name, baseAttack).filter(self.name == name)){
                    return String(monster[baseAttack])
                }
            case .baseDefense:
                for monster in try db.prepare(pokemon.select(self.name, baseDefense).filter(self.name == name)){
                    return String(monster[baseDefense])
                }
            case .quickMoves:
                for monster in try db.prepare(pokemon.select(self.name, quickMoves).filter(self.name == name)){
                    return String(monster[quickMoves])
                }
            case .chargeMoves:
                for monster in try db.prepare(pokemon.select(self.name, chargeMoves).filter(self.name == name)){
                    return String(monster[chargeMoves])
                }
            }
        }catch{
            fatalError("Did not successfully prepare db when attempting to query integer data with it.")
        }
        fatalError("Reached end of query without returning or failing. Ought to be impossible. Data column: \(dataColumn), Name: \(name)")
    }
}

public enum PokemonQueryType{    
    case dexNumber
    case primaryType
    case secondaryType
    case baseStamina
    case baseAttack
    case baseDefense
    case quickMoves
    case chargeMoves
}
