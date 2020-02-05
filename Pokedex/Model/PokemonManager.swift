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
            for pokemon in 0 ..< data.results.count{
                let name = data.results[pokemon].name.replacingOccurrences(of: "-", with: " ")
                var id = data.results[pokemon].url.replacingOccurrences(of: Constants.pokemonListUrl, with: "")
                id.removeLast()
                let frontImage = Constants.baseDefaultSprite + id + Constants.endDefaultSprite
                id = String(format: "%03d", Int(id)!)
                let pokemon = PokemonModel(name: name, image: frontImage, id: id)
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


