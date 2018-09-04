//
//  Pokemon.swift
//  PokeDex
//
//  Created by Kaden Staker on 9/4/18.
//  Copyright © 2018 Kaden Staker. All rights reserved.
//

// Spell CodingKeys with an "s" at the end

import UIKit

struct Pokemon: Decodable {
    let abilities: [AbilitiesDictionary]
    let name: String
    let id: Int
    let spritesDictionary: SpritesDictionary
    
    // Key to match JSON
    private enum CodingKeys: String, CodingKey {
        case abilities
        case name
        case id
        case spritesDictionary = "sprites"
    }
    
    var abilitiesName: [String] {
        return abilities.compactMap({$0.ability.name})
    }
    
    struct AbilitiesDictionary: Decodable {
        let ability: Ability
        struct Ability: Decodable {
            let name: String
        }
    }
}



struct Ability: Decodable {
    let name: String
}

struct SpritesDictionary: Decodable {
    let image: URL
    private enum CodingKeys: String, CodingKey {
        case image = "front_default"
    }
}

