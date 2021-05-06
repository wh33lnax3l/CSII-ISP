import Curses

func receiveInput(window:Window) -> Pokemon{
    window.clear()
    writeAtLocation("Enter the data of enemy pokemon. Press enter to advance text fields.",location: Point(x:0, y:0))
    writeAtLocation("Pokemon:            ",location: Point(x:0, y:1))
    writeAtLocation("CP:                 ",location: Point(x:0, y:2))
    writeAtLocation("Attack IV:          ",location: Point(x:0, y:3))
    writeAtLocation("Defense IV:         ",location: Point(x:0, y:4))
    writeAtLocation("HP IV:              ",location: Point(x:0, y:5))
    writeAtLocation("Quick Move:         ",location: Point(x:0, y:6))
    writeAtLocation("1st Charge Move:    ",location: Point(x:0, y:7))
    writeAtLocation("2nd Charge Move:    ",location: Point(x:0, y:8))
    window.refresh()
    let pokemonName = window.getStringFromTextField(at: Point(x:21, y:1), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let combatPoints = window.getStringFromTextField(at: Point(x:21, y:2), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let attackIV = window.getStringFromTextField(at: Point(x:21, y:3), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let defenseIV = window.getStringFromTextField(at: Point(x:21, y:4), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let healthPointsIV = window.getStringFromTextField(at: Point(x:21, y:5), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let quickMove = window.getStringFromTextField(at: Point(x:21, y:6), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let firstChargeMove = window.getStringFromTextField(at: Point(x:21, y:7), maxCharacters: 20, fieldColorPair: blackOnWhite)
    let secondChargeMove = window.getStringFromTextField(at: Point(x:21, y:8), maxCharacters: 20, fieldColorPair: blackOnWhite)
    do{
        let enemyPokemon = try Pokemon(name: pokemonName,
                                       cp: Int(combatPoints),
                                       attack: Int(attackIV),
                                       defense: Int(defenseIV),
                                       health: Int(healthPointsIV),
                                       quick: quickMove,
                                       chargeOne: firstChargeMove,
                                       chargeTwo: secondChargeMove)
        return enemyPokemon
    }catch InputError.nameNotReal{
        fatalError("Name Not Real")
    }catch InputError.combatPointsNotNum{
        fatalError("Combat Points Not Num")
    }catch InputError.attackIVNotNum{
        fatalError("Attack IV Not Num")
    }catch InputError.attackIVNotInRange{
        fatalError("Attack IV Not In Range")
    }catch InputError.defenseIVNotNum{
        fatalError("Defense IV Not Num")
    }catch InputError.defenseIVNotInRange{
        fatalError("Defense IV Not In Range")
    }catch InputError.healthPointsIVNotNum{
        fatalError("Health Points IV Not Num")
    }catch InputError.healthPointsIVNotInRange{
        fatalError("Health Points IV Not In Range")
    }catch InputError.quickMoveNotReal{
        fatalError("Quick Move Not Real")
    }catch InputError.quickMoveNotInMoveset{
        fatalError("Quick Move Not In Moveset")
    }catch InputError.chargeMoveNotReal{
        fatalError("Charge Move Not Real")
    }catch InputError.chargeMoveNotInMoveset{
        fatalError("Charge Move Not In Moveset")
    }catch{
        fatalError("Default catch")        
    }
}
