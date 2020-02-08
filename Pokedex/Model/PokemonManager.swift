//
//  PokemonManager.swift
//  Pokedex
//
//  Created by Kanokporn Wongwaitayakul on 6/2/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import Foundation
import Alamofire

protocol PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemonList: [PokemonModel])
    func didFailWithError(error: AFError)
}

struct PokemonManager {
    var delegate: PokemonManagerDelegate?
    
    func fetchData(){
        
        AF.request(Constants.pokemonListLimitedUrl).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                self.parseJSON(response.data!)
            }
            
        }
    }
    
    func parseJSON(_ pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        
        do {
            let data = try decoder.decode(PokemonData.self, from: pokemonData)
            var pokemonList: [PokemonModel] = []
            for i in 0 ..<  data.results.count{
                let name = data.results[i].name.replacingOccurrences(of: "-", with: " ")
                let id = i+1
                let frontImage = URL(string: Constants.baseDefaultSprite + String(id) + Constants.endSprite)
                let shinyImage = URL(string: Constants.baseShinySprite + String(id) + Constants.endSprite)
                let pokemon = PokemonModel(name: name, image: frontImage!, shinyImage: shinyImage!, id: id)
                pokemonList.append(pokemon)
            }
            delegate?.didUpdatePokemon(self, pokemonList: pokemonList)
            return pokemonList
            
        } catch {
            delegate?.didFailWithError(error: error as! AFError)
            return nil
        }
    }
    
}


