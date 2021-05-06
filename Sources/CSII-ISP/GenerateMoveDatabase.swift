import Foundation

func generateMovesDatabase(moves:inout MovesDatabase, textStack:TextStack){

    struct MoveEntry : Decodable{
        let data : DataDictionary?
    }

    struct DataDictionary : Decodable{
        let templateId : String?
        let move : MoveDictionary?
    }

    struct MoveDictionary : Decodable{
        let uniqueId : String?
        let type : String?
        let power : Double?
        let accuracyChance : Double?
        let criticalChance : Double?
        let durationMs : Int?
        let energyDelta : Int?
    }
    
    let moveEntries : [MoveEntry] = try! JSONDecoder().decode([MoveEntry].self, from:rawJSONData)
    for entry in moveEntries{
        var name : String
        var idNumber : Int
        var type : String
        var power : Int
        var duration : Int?
        var accuracy : Int?
        var critical : Int?
        var energyChange : Int
        
        if let dataDict = entry.data{
            
            if let templateId = dataDict.templateId{
                if !(templateId.count >= 5){
                    textStack.appendText("templateId \(templateId) was not greater than 5 characters, where the dex number is in the assumed format")
                    continue
                }
                if let num = Int(templateId[templateId.index(templateId.startIndex, offsetBy: 1)...templateId.index(templateId.startIndex, offsetBy: 4)]){
                    idNumber = num                    
                }else{
                    textStack.appendText("ID Number from templateId \(templateId) did not conform to assumed format, and thus returned null when stripped and cast as an Int")
                    continue
                }
                
            }else{
                textStack.appendText("Could not find templateId in data dictionary \(dataDict) in entry \(entry)")
                continue
            }

            if let moveDict = dataDict.move{
                
                if let uniqueId = moveDict.uniqueId{
                    name = uniqueId
                }else{
                    textStack.appendText("Could not find uniqueId in move dictionary \(moveDict) in data dictionary \(dataDict) in entry \(entry)")
                    continue
                }
                
                if let typeData = moveDict.type{
                    if !(typeData.count >= 14){
                        textStack.appendText("Type string \(typeData) of length \(typeData.count) not of expected length of at least 14 characters")
                        continue
                    }
                    if String(typeData[typeData.startIndex...typeData.index(typeData.startIndex, offsetBy:12)]) != "POKEMON_TYPE_"{
                        textStack.appendText("Primary type \(typeData) does not follow assumed format")
                        continue
                    }                    
                    type = String(typeData[typeData.index(typeData.startIndex, offsetBy: 13)..<typeData.endIndex])
                }else{
                    textStack.appendText("Could not find type in move dictionary \(moveDict) in data dictionary \(dataDict) in entry \(entry)")
                    continue
                }
                
                if let powerData = moveDict.power{
                    power = Int(powerData) // It is ASSUMED that power is always a whole number, as I have never seen to the contrary
                }else{
                    textStack.appendText("Could not find power in move dictionary \(moveDict) in data dictionary \(dataDict) in entry \(entry)")
                    continue
                }

                if let durationMs = moveDict.durationMs{
                    duration = durationMs
                }

                if let accuracyChance = moveDict.accuracyChance{
                    accuracy = Int(100.0 * accuracyChance)
                }

                if let criticalChance = moveDict.criticalChance{
                    critical = Int(100.0 * criticalChance)
                }

                if let energyDelta = moveDict.energyDelta{
                    energyChange = energyDelta
                }else{
                    textStack.appendText("Could not find energy change in move dictionary \(moveDict) in data dictionary \(dataDict) in entry \(entry)")
                    continue
                }
                
            }else{
                textStack.appendText("Could not find move dictionary in data dictionary \(dataDict) in entry \(entry)")
                continue
            }
            
        }else{
            textStack.appendText("Could not find data dictionary in entry \(entry)")
            continue
        }
        
        moves.insertData(name:name,
                         idNumber:idNumber,
                         type:type,
                         power:power,
                         duration:duration,
                         accuracy:accuracy,
                         critical:critical,
                         energyChange:energyChange)
    }
}
