public class Species{

    public let name : String
    public let primaryType : PokemonType
    public let secondaryType : PokemonType?
    public let baseAttack : Int
    public let baseDefense : Int
    public let baseStamina : Int
    public let quickMoveset : [String]
    public let chargeMoveset : [String]
    
    init(name:String) throws{
        if pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.name, name:name) == name{
            self.name = name
            self.primaryType = PokemonType(rawValue: pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.primaryType, name:name))!
            self.secondaryType = PokemonType(rawValue: pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.secondaryType, name:name))
            self.baseAttack = Int(pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.baseAttack, name:name)) ?? 0
            self.baseDefense = Int(pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.baseDefense, name:name)) ?? 0
            self.baseStamina = Int(pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.baseStamina, name:name)) ?? 0
            let quickMoveString = pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.quickMoves, name:name)
            self.quickMoveset = quickMoveString.components(separatedBy:",")
            let chargeMoveString = pokemonDatabase.queryDataGivenName(dataColumn:PokemonQueryType.chargeMoves, name:name)
            self.chargeMoveset = chargeMoveString.components(separatedBy:",")
        }else{
            throw InputError.nameNotReal
        }
    }    
}
