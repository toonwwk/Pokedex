//
//  PokemonInfoData.swift
//  Pokedex
//
//  Created by Kanokporn Wongwaitayakul on 8/2/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import Foundation
struct PokemonInfoData : Decodable{
    let height: Double
    let weight: Double
    let species: SpeciesUrl
    let types: [Type]
    let stats: [Stats]
}

struct Stats: Decodable{
    let base_stat: Int
    let stat: StatsName
}

struct StatsName: Decodable{
    let name: String
}

struct Type: Decodable{
    let type: TypeName
}

struct TypeName: Decodable{
    let name: String
}

struct SpeciesUrl : Decodable{
    let url: URL
}
