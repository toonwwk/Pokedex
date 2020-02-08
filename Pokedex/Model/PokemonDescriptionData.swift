//
//  PokemonDescriptionAndEvoData.swift
//  Pokedex
//
//  Created by Kanokporn Wongwaitayakul on 8/2/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import Foundation
struct PokemonDescriptionData: Decodable{
    let flavor_text_entries: [Description]
}

struct Description: Decodable{
    let flavor_text: String
}
