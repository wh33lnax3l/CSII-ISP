import SQLite
import Foundation

public class MovesDatabase{
    private let db : Connection // Effectively just a connection to sqlite3 
    let moves = Table("moves")

    let name = Expression<String>("name")
    let idNumber = Expression<Int>("id_number")
    let type = Expression<String>("type")
    let power = Expression<Int>("power")
    let duration = Expression<Int?>("duration")
    let accuracy = Expression<Int?>("accuracy")
    let critical = Expression<Int?>("critical")
    let energyChange = Expression<Int>("energy_change")

    init() throws{
        self.db = try Connection("/home/ethan-forbes/CSII-ISP/Sources/CSII-ISP/pokemon.db")
        try db.run(moves.create(ifNotExists: true) { t in
                       t.column(name, primaryKey: true)
                       t.column(idNumber, unique: true)
                       t.column(type)
                       t.column(power)
                       t.column(duration)
                       t.column(accuracy)
                       t.column(critical)
                       t.column(energyChange)
                   })
    }

    public func insertData(name:String, idNumber:Int, type:String, power:Int, duration:Int?, accuracy:Int?, critical:Int?, energyChange:Int){
        do{
            let rowId = try db.run(moves.insert(or: .replace,
                                                self.name <- name,
                                                self.idNumber <- idNumber,
                                                self.type <- type,
                                                self.power <- power,
                                                self.duration <- duration,
                                                self.accuracy <- accuracy,
                                                self.critical <- critical,
                                                self.energyChange <- energyChange))
            globalTextStack.appendText("Inserted in Moves at rowId: \(rowId)")
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

    public func queryDataGivenName(dataColumn:MoveQueryType, name:String) -> String{
        do {
            try db.run(moves.createIndex(self.name, unique: true, ifNotExists:true))
            switch dataColumn{
                // When finding nothing, an empty string is returned, which is handled in initialization
            case .name:
                for move in try db.prepare(moves.select(self.name).filter(self.name == name)){
                    return move[self.name]
                }
                return ""
            case .idNumber:
                for move in try db.prepare(moves.select(self.name, idNumber).filter(self.name == name)){
                    return String(move[idNumber])
                }
                return ""
            case .type:
                for move in try db.prepare(moves.select(self.name, type).filter(self.name == name)){
                    return move[type]
                }
                return ""
            case .power:
                for move in try db.prepare(moves.select(self.name, power).filter(self.name == name)){
                    return String(move[power])
                }
                return ""
            case .duration:
                for move in try db.prepare(moves.select(self.name, duration).filter(self.name == name)){
                    guard let result = move[duration] else{
                        return ""
                    }
                    return String(result)
                }
                return ""
            case .accuracy:
                for move in try db.prepare(moves.select(self.name, accuracy).filter(self.name == name)){
                    guard let result = move[accuracy] else{
                        return ""
                    }
                    return String(result)
                }
                return ""
            case .critical:
                for move in try db.prepare(moves.select(self.name, critical).filter(self.name == name)){
                    guard let result = move[critical] else{
                        return ""
                    }
                    return String(result)
                }
                return ""
            case .energyChange:
                for move in try db.prepare(moves.select(self.name, energyChange).filter(self.name == name)){
                    return String(move[energyChange])
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
            fatalError("Did not successfully prepare db when attempting to query integer data with it.")
        }        
    }
}

public enum MoveQueryType{
    case name
    case idNumber
    case type
    case power
    case duration
    case accuracy
    case critical
    case energyChange
}
