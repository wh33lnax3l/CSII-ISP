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
        self.db = try Connection("/home/ethan-forbes/CSII-ISP/Sources/CSII-ISP/pokemon.db")
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
            globalTextStack.appendText("Inserted in Pokemon at rowId: \(rowId)")
        }catch let Result.error(message, _, statement){
            // This is supposed to occur any time a duplicate name is attempted to be inserted
            // This is kinda a botch job. The signature *should* be catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT, but it doesn't understand the error literal
            if statement != nil{
                globalTextStack.appendText("Constraint failed: \(message), in \(statement!)")
            }else{
                globalTextStack.appendText("Constraint failed: \(message)")
            }
        }catch let error{
            globalTextStack.appendText("Failed to insert: \(error)")
        }
    }

    public func queryAllNames() -> [String]{
        do{
            var allNames = [String]()
            for monster in try db.prepare(pokemon.select(self.name)){
                allNames.append(monster[self.name])
            }
            return allNames
        }catch{
            fatalError("Could not prepare database when selecting all names")
        }
    }
    
    public func queryDataGivenName(dataColumn:PokemonQueryType, name:String) -> String{       
        do {
            try db.run(pokemon.createIndex(self.name, unique: true, ifNotExists:true))
            switch dataColumn{
                // When finding nothing, an empty string is returned, which is handled in initialization
            case .name:                
                for monster in try db.prepare(pokemon.select(self.name).filter(self.name == name)){
                    return monster[self.name]
                }
                return ""
            case .dexNumber:
                for monster in try db.prepare(pokemon.select(self.name, dexNumber).filter(self.name == name)){
                    return String(monster[dexNumber])
                }
                return ""
            case .primaryType:                
                for monster in try db.prepare(pokemon.select(self.name, primaryType).filter(self.name == name)){
                    return monster[primaryType]
                }
                return ""
            case .secondaryType:
                for monster in try db.prepare(pokemon.select(self.name, secondaryType).filter(self.name == name)){
                    guard let result = monster[secondaryType] else{
                        return ""
                    }
                    return result
                }
                return ""
            case .baseStamina:
                for monster in try db.prepare(pokemon.select(self.name, baseStamina).filter(self.name == name)){
                    return String(monster[baseStamina])
                }
                return ""
            case .baseAttack:
                for monster in try db.prepare(pokemon.select(self.name, baseAttack).filter(self.name == name)){
                    return String(monster[baseAttack])
                }
                return ""
            case .baseDefense:
                for monster in try db.prepare(pokemon.select(self.name, baseDefense).filter(self.name == name)){
                    return String(monster[baseDefense])
                }
                return ""
            case .quickMoves:
                for monster in try db.prepare(pokemon.select(self.name, quickMoves).filter(self.name == name)){
                    return String(monster[quickMoves])
                }
                return ""
            case .chargeMoves:
                for monster in try db.prepare(pokemon.select(self.name, chargeMoves).filter(self.name == name)){
                    return String(monster[chargeMoves])
                }
                return ""
            }
        }catch let Result.error(message, _, statement){
            if statement != nil{
                fatalError("Query error \(message), \(statement!)")
            }else{
                fatalError("Query error \(message)")
            }
        }catch{
            fatalError("Other unknown query error")
        }
    }
}

public enum PokemonQueryType{
    case name
    case dexNumber
    case primaryType
    case secondaryType
    case baseStamina
    case baseAttack
    case baseDefense
    case quickMoves
    case chargeMoves
}
