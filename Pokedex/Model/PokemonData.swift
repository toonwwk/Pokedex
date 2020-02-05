//
//  PokemonData.swift
//  Pokedex
//
//  Created by Kanokporn Wongwaitayakul on 6/2/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import Foundation
struct PokemonData : Decodable{
    let results : [NameURL]
}

struct NameURL : Decodable{
    let name:String
    let url:String
}
