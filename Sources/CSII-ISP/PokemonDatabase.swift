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
                       t.column(name, primaryKey: true) // Can't say primary key and unique?
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
            let rowId = try db.run(pokemon.insert(or: .replace,
                                                  self.name <- name,
                                                  self.dexNumber <- dexNumber,
                                                  self.primaryType <- primaryType,
                                                  self.secondaryType <- secondaryType,
                                                  self.baseStamina <- baseStamina,
                                                  self.baseAttack <- baseAttack,
                                                  self.baseDefense <- baseDefense,
                                                  self.quickMoves <- quickMoves,
                                                  self.chargeMoves <- chargeMoves))
            print("Inserted at rowId: \(rowId)")
        }catch{
            print("Failed to insert: \(error)")
        }
    }
}
