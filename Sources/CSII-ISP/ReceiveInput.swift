import Curses
func receiveInput() -> Pokemon{ // Outputs type Pokemon
    // Receive input    
    let pokemonName = mainWindow.getStringFromTextField(at: Point(x:21, y:1), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:1))
    let combatPoints = mainWindow.getStringFromTextField(at: Point(x:21, y:2), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:2))
    let attackIV = mainWindow.getStringFromTextField(at: Point(x:21, y:3), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:3))
    let defenseIV = mainWindow.getStringFromTextField(at: Point(x:21, y:4), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:4))
    let healthPointsIV = mainWindow.getStringFromTextField(at: Point(x:21, y:5), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:5))
    let quickMove = mainWindow.getStringFromTextField(at: Point(x:21, y:6), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:6))
    let firstChargeMove = mainWindow.getStringFromTextField(at: Point(x:21, y:7), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:7))
    let secondChargeMove = mainWindow.getStringFromTextField(at: Point(x:21, y:8), maxCharacters: 20, fieldColorPair: blackOnWhite)
    writeAtLocation("I have received your input", location: Point(x: 41, y:8))
    do{
        let enemyPokemon = try Pokemon(name: pokemonName, cp: Int(combatPoints), attack: Int(attackIV), defense: Int(defenseIV), health: Int(healthPointsIV), quick: quickMove, chargeOne: firstChargeMove, chargeTwo: secondChargeMove)
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
    }catch InputError.chargeMoveNotReal{
        fatalError("Charge Move Not Real")
    }catch{
        fatalError("Default catch")
        //Should never happen, exit program
    }
}
