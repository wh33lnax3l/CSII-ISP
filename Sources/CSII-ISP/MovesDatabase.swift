import SQLite
import Foundation

public class MovesDatabase{
    private let db : Connection
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
        self.db = try Connection("~/CSII-ISP/Sources/CSII-ISP/moves.sqlite3")
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
            print("Inserted in Moves at rowId: \(rowId)")
        }catch{
            print("Failed to insert: \(error)")
        }
    }

    public func queryDataGivenName(dataColumn:MovesQueryType, name:String) -> String{ // Consider throwing from query?        
        do {
            try db.run(moves.createIndex(name, unique: true, ifNotExists:true))
            switch dataColumn{
            case .idNumber:
                for move in try db.prepare(moves.select(self.name, idNumber).filter(self.name == name)){
                    return String(move[idNumber])
                }
            case .type:
                for move in try db.prepare(moves.select(self.name, type).filter(self.name == name)){
                    return move[type]
                }
            case .power:
                for move in try db.prepare(moves.select(self.name, power).filter(self.name == name)){
                    return String(move[power])
                }
            case .duration:
                for move in try db.prepare(moves.select(self.name, duration).filter(self.name == name)){
                    guard let result = move[duration] else{
                        fatalError("Queried move \(name), resulting in row at \(move[self.name]) does not have a duration")
                    }
                    return String(result)
                }
            case .accuracy:
                for move in try db.prepare(moves.select(self.name, accuracy).filter(self.name == name)){
                    guard let result = move[accuracy] else{
                        fatalError("Queried move \(name), resulting in row at \(move[self.name]) does not have an accuracy")
                    }
                    return String(result)
                }
            case .critical:
                for move in try db.prepare(moves.select(self.name, critical).filter(self.name == name)){
                    guard let result = move[critical] else{
                        fatalError("Queried move \(name), resulting in row at \(move[self.name]) does not have a critical")
                    }
                    return String(result)
                }
            case .energyChange:
                for move in try db.prepare(moves.select(self.name, energyChange).filter(self.name == name)){
                    return String(move[energyChange])
                }
            }
        }catch{
            fatalError("Did not successfully prepare db when attempting to query integer data with it.")
        }
        fatalError("Reached end of query without returning or failing. Ought to be impossible. Data column: \(dataColumn), Name: \(name)")
    }
}

public enum MovesQueryType{    
    case idNumber
    case type
    case power
    case duration
    case accuracy
    case critical
    case energyChange
}
