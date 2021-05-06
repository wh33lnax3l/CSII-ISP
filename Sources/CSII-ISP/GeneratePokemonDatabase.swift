import Foundation

func generatePokemonDatabase(pokemon:inout PokemonDatabase, textStack:TextStack){

    // The JSON file is constructed of many layered JSONs, in order to decode these each new dict must be its own struct that conforms to Decodable and is explicitly keyed
    // ALL properties are optional, as parts of the JSON are families and not individual pokemon, and thus do not contain any needed properties. Easier to sort in code and will be better for long term use
    
    struct PokemonEntry : Decodable{        
        let data : DataDictionary?        
    }

    struct DataDictionary : Decodable{        
        let templateId : String?
        let pokemon : PokemonDictionary?
    }

    struct PokemonDictionary : Decodable{
        let uniqueId : String?
        let type1 : String?
        let type2 : String?
        let stats : StatsDictionary?
        let quickMoves : [String]?
        let cinematicMoves : [String]?
    }

    struct StatsDictionary : Decodable{
        let baseStamina : Int?
        let baseAttack : Int?
        let baseDefense : Int?
    }

    struct MoveEntry : Decodable{
        let name : String
        let idNumber : Int
        let type : String
        let power : Int
        let duration : Int?
        let accuracy : Int?
        let critical : Int?
        let energyChange : Int
    }

    let pokemonEntries : [PokemonEntry] = try! JSONDecoder().decode([PokemonEntry].self, from:rawJSONData)
    for entry in pokemonEntries{

        // For each entry, take the data as Pokemon Go formats it and make it conform to how it ought to be stored
        var name : String
        var dexNumber : Int
        var primaryType : String
        var secondaryType : String?
        var baseStamina : Int
        var baseAttack : Int
        var baseDefense : Int
        var quickMoves : String = ""
        var chargeMoves : String = ""
        
        if let dataDict = entry.data{
            
            if let templateId = dataDict.templateId{
                if !(templateId.count >= 5){
                    textStack.appendText("templateId \(templateId) was not greater than 5 characters, where the dex number is in the assumed format")
                    continue
                }                
                if let num = Int(templateId[templateId.index(templateId.startIndex, offsetBy: 1)...templateId.index(templateId.startIndex, offsetBy: 4)]){
                    dexNumber = num                    
                }else{
                    textStack.appendText("Dex Number from templateId \(templateId) did not conform to assumed format, and thus returned null when stripped and cast as an Int")
                    continue
                }
                
            }else{
                textStack.appendText("Could not find templateId")
                continue
            }
            
            if let pokemonDict = dataDict.pokemon{
                
                if let uniqueId = pokemonDict.uniqueId{
                    name = uniqueId
                }else{
                    textStack.appendText("Could not find name")
                    continue
                }
                
                if let type1 = pokemonDict.type1{
                    if !(type1.count >= 14){
                        textStack.appendText("Type string \(type1) of length \(type1.count) not of expected length of at least 14 characters")
                        continue
                    }
                    if String(type1[type1.startIndex...type1.index(type1.startIndex, offsetBy:12)]) != "POKEMON_TYPE_"{
                        textStack.appendText("Primary type \(type1) does not follow assumed format")
                        continue
                    }                    
                    primaryType = String(type1[type1.index(type1.startIndex, offsetBy: 13)..<type1.endIndex])
                }else{
                    textStack.appendText("Could not find primary type")
                    continue
                }
                
                if let type2 = pokemonDict.type2{
                    if !(type2.count >= 14){
                        textStack.appendText("Type string \(type2) of length \(type2.count) not of expected length of at least 14 characters")
                        continue
                    }
                    if String(type2[type2.startIndex...type2.index(type2.startIndex, offsetBy:12)]) != "POKEMON_TYPE_"{
                        textStack.appendText("Primary type \(type2) does not follow assumed format")
                        continue
                    }                    
                    secondaryType = String(type2[type2.index(type2.startIndex, offsetBy: 13)..<type2.endIndex])
                }
                
                if let statsDict = pokemonDict.stats{

                    // Using `if let` statements would write over variable in this scope
                    if statsDict.baseStamina != nil{
                        baseStamina = statsDict.baseStamina!
                    }else{
                        textStack.appendText("Could not find base stamina")
                        continue
                    }

                    if statsDict.baseAttack != nil{
                        baseAttack = statsDict.baseAttack!
                    }else{
                        textStack.appendText("Could not find base attack")
                        continue
                    }

                    if statsDict.baseDefense != nil{
                        baseDefense = statsDict.baseDefense!
                    }else{
                        textStack.appendText("Could not find base defense")
                        continue
                    }
                    
                }else{
                    textStack.appendText("Could not find stats dictionary")
                    continue
                }
                
                if let quickMoveArray = pokemonDict.quickMoves{
                    for move in quickMoveArray{
                        quickMoves += "\(move),"            
                    }
                    quickMoves.removeLast()
                }else{
                    textStack.appendText("Could not find quick moves")
                    continue
                }
                
                if let chargeMoveArray = pokemonDict.cinematicMoves{
                    for move in chargeMoveArray{
                        chargeMoves += "\(move),"
                    }
                    chargeMoves.removeLast()
                }else{
                    textStack.appendText("Could not find charge moves")
                    continue
                }
                
            }else{
                textStack.appendText("Could not find pokemon dictionary")
                continue
            }
            
        }else{
            textStack.appendText("Could not find data dictionary")
            continue
        }
        
        pokemon.insertData(name:name,
                           dexNumber:dexNumber,
                           primaryType:primaryType,
                           secondaryType:secondaryType,
                           baseStamina:baseStamina,
                           baseAttack:baseAttack,
                           baseDefense:baseDefense,
                           quickMoves:quickMoves,
                           chargeMoves:chargeMoves)
    }        
}
