import Foundation

func calculateTeam(enemy:Pokemon, textStack:TextStack) -> [(Double, Pokemon)]{ 
    // Would only be necessary for PVP
    // let quickMoveEnergy = abs(enemy.quick.energyChange)
    // let chargeMoveEnergy = abs(enemy.chargeOne.energyChange)  
    // let totalMovesNeeded = chargeMoveEnergy % quickMoveEnergy == 0 ? chargeMoveEnergy / quickMoveEnergy : (chargeMoveEnergy / quickMoveEnergy) + 1
    // guard let quickDuration = enemy.quick.duration else{
    //     fatalError("Unable to calculate DPS without quick move duration")
    // }
    // let chargeDuration = enemy.chargeOne.duration ?? 0 // Assumes that if no duration is found, charge moves aren't used
    // let periodOfChargeMove = (quickDuration * totalMovesNeeded) + chargeDuration
    // let enemyDPS = Double((enemy.quick.power * totalMovesNeeded) + enemy.chargeOne.power) / (Double(periodOfChargeMove) / 100.0) // Invariable of defending pokemon

    var pokemonTeam = Dictionary<Double, Pokemon>()
    for pokemonName in pokemonDatabase.queryAllNames(){
        do{
            guard let baseAttack = Double(pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.baseAttack, name: pokemonName)) else{
                textStack.appendText("Base attack for \(pokemonName) not found, trying next pokemon")
                continue
            }
            guard let baseDefense = Double(pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.baseDefense, name: pokemonName)) else{
                textStack.appendText("Base defense for \(pokemonName) not found, trying next pokemon")
                continue
            }
            guard let baseStamina = Double(pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.baseStamina, name: pokemonName)) else{
                textStack.appendText("Base stamina for \(pokemonName) not found, trying next pokemon")
                continue
            }
            let maxCP = ((baseAttack + 15.0) * pow(baseDefense + 15.0, 0.5) * pow(baseStamina + 15, 0.5) * pow(0.7903001, 2)) / 10
            let quickMoveset = pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.quickMoves, name:pokemonName).components(separatedBy: ",")
            let chargeMoveset = pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.chargeMoves, name:pokemonName).components(separatedBy: ",")
            for quick in quickMoveset{
                for charge in chargeMoveset{
                    let pokemon = try Pokemon(name: pokemonName,
                                              cp: Int(maxCP),
                                              attack: 15,
                                              defense: 15,
                                              health: 15,
                                              quick: String(quick[quick.startIndex..<quick.index(quick.endIndex, offsetBy:-5)]),
                                              chargeOne: charge,
                                              chargeTwo: "")
                    let quickMoveEnergy = abs(pokemon.quick.energyChange)
                    let chargeMoveEnergy = abs(pokemon.chargeOne.energyChange)  
                    let totalMovesNeeded = chargeMoveEnergy % quickMoveEnergy == 0 ? chargeMoveEnergy / quickMoveEnergy : (chargeMoveEnergy / quickMoveEnergy) + 1
                    guard let quickDuration = pokemon.quick.duration else{
                        textStack.appendText("Quick move duration for \(pokemonName) with quick move \(quick) not found, trying next pokemon")
                        continue
                    }
                    let chargeDuration = pokemon.chargeOne.duration ?? 0
                    let periodOfChargeMove = (quickDuration * totalMovesNeeded) + chargeDuration
                    let quickTypeBonus = typeEffectiveness(attackingType:pokemon.quick.type, defendingType:enemy.species.primaryType) * typeEffectiveness(attackingType:pokemon.quick.type, defendingType:enemy.species.secondaryType)
                    let chargeTypeBonus = typeEffectiveness(attackingType:pokemon.chargeOne.type, defendingType:enemy.species.primaryType) * typeEffectiveness(attackingType:pokemon.chargeOne.type, defendingType:enemy.species.secondaryType)
                    let quickSTABBonus = pokemon.quick.type == pokemon.species.primaryType || pokemon.quick.type == pokemon.species.secondaryType ? 1.2 : 1.0
                    let chargeSTABBonus = pokemon.chargeOne.type == pokemon.species.primaryType || pokemon.chargeOne.type == pokemon.species.secondaryType ? 1.2 : 1.0
                    let multipliedQuickMove = Double(pokemon.quick.power) * quickTypeBonus * quickSTABBonus
                    let multipliedChargeMove = Double(pokemon.chargeOne.power) * chargeTypeBonus * chargeSTABBonus
                    let pokemonDPS = ((multipliedQuickMove * Double(totalMovesNeeded)) + multipliedChargeMove) / (Double(periodOfChargeMove) / 100.0)
                    if pokemonTeam.count < 6{
                        pokemonTeam[pokemonDPS] = pokemon
                        textStack.appendText("New team member found! \(pokemonName) with quick move \(quick) and charge move \(charge)")
                    }else{
                        var smallest = pokemonDPS
                        for (dps, _) in pokemonTeam{
                            smallest = Double.minimum(smallest, dps)
                        }
                        if smallest != pokemonDPS{
                            pokemonTeam[smallest] = nil
                            pokemonTeam[pokemonDPS] = pokemon
                            textStack.appendText("New team member found! \(pokemonName) with quick move \(quick) and charge move \(charge)")
                        }
                    }                    
                }
            }
        }catch InputError.nameNotReal{
            textStack.appendText("Name not found for \(pokemonName)")
            continue
        }catch InputError.combatPointsNotNum{
            textStack.appendText("CP didn't unwrap as an integer for \(pokemonName)")
            continue
        }catch InputError.attackIVNotNum{
            textStack.appendText("Attack IV dind't unwrap as an integer for \(pokemonName)")
            continue
        }catch InputError.attackIVNotInRange{            
            textStack.appendText("Attack IV not in the range 0-15 for \(pokemonName)")
            continue
        }catch InputError.defenseIVNotNum{
            textStack.appendText("Defense IV dind't unwrap as an integer for \(pokemonName)")
            continue
        }catch InputError.defenseIVNotInRange{
            textStack.appendText("Defense IV not in the range 0-15 for \(pokemonName)")
            continue
        }catch InputError.healthPointsIVNotNum{
            textStack.appendText("HP IV dind't unwrap as an integer for \(pokemonName)")
            continue
        }catch InputError.healthPointsIVNotInRange{
            textStack.appendText("HP IV not in the range 0-15 for \(pokemonName)")
            continue
        }catch InputError.quickMoveNotReal{
            textStack.appendText("Quick move not found in database for \(pokemonName)")
            continue
        }catch InputError.quickMoveNotInMoveset{
            textStack.appendText("Quick move found but not in \(pokemonName)'s moveset")
            continue
        }catch InputError.chargeMoveNotReal{
            textStack.appendText("Charge move not found in database for \(pokemonName)")
            continue
        }catch InputError.chargeMoveNotInMoveset{
            textStack.appendText("Charge move found but not in \(pokemonName)'s moveset")
            continue
        }catch{
            textStack.appendText("Pokemon object \(pokemonName) could not be tested, trying next pokemon")
            continue
        }
    }
    var result = [(Double, Pokemon)]()
    for (dps, pokemon) in pokemonTeam{
        result.append((dps,pokemon))
    }
    return result
}
