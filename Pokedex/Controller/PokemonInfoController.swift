//
//  PokemonInfoController.swift
//  Pokedex
//
//  Created by Kanokporn Wongwaitayakul on 7/2/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
class PokemonInfoController : UIViewController{
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameNumberLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageForm: UISegmentedControl!
    
    var pokemon: PokemonModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPokemonInfo()
    }
    
    func setupPokemonInfo(){
        pokemonImageView.load(url: pokemon.image)
        pokemonImageView.layer.cornerRadius = pokemonImageView.frame.size.width / 2
        pokemonImageView.clipsToBounds = true
        let id = String(format: "%03d", Int(pokemon.id))
        nameNumberLabel.text = id + " " + pokemon.name
        fetchBasicInfoData()
    }
    @IBAction func imageFormChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            pokemonImageView.load(url: pokemon.image)
        case 1:
            pokemonImageView.load(url: pokemon.shinyImage)
        default:
            break
        }
    }
    
}
// MARK: - for pokemon descripton
extension PokemonInfoController{
    func fetchDescriptionAndEvoData(_ url: URL){
        AF.request(url).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                self.parseDesAndEvoJSON(response.data!)
            }
        }
    }
    func parseDesAndEvoJSON(_ pokemonData: Data){
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(PokemonDescriptionData.self, from: pokemonData)
            for text in data.flavor_text_entries{
                let language = NSLinguisticTagger.dominantLanguage(for: text.flavor_text)
                if language == "en"{
                    let description = text.flavor_text.replacingOccurrences(of: "\n", with: " ")
                    descriptionLabel.text = description
                    break
                }
            }
        }catch {
            print(error)
        }
    }
}
// MARK: - for pokemon base stats
extension PokemonInfoController{
    func fetchBasicInfoData(){
        let url = Constants.basePokemonUrl + String(pokemon.id) + "/"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                self.parseBasicInfoJSON(response.data!)
            }
        }
    }
    
    func parseBasicInfoJSON(_ pokemonData: Data){
        
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(PokemonInfoData.self, from: pokemonData)
            let weight = String(format: "%.1f", data.weight/10.0)
            let height = String(format: "%.1f", data.height/10.0)
            
            var types = "Type : "
            
            for type in data.types{
                types += type.type.name
                types += " "
            }
            
            for stat in data.stats{
                switch stat.stat.name {
                case "hp":
                    hpLabel.text = "hp : " + String(stat.base_stat)
                case "defense":
                    defenseLabel.text = "defense : " + String(stat.base_stat)
                case "attack":
                    attackLabel.text  = "attack : " + String(stat.base_stat)
                default:
                    break
                }
                
            }
            weightLabel.text = "weight : " + weight + " kg"
            heightLabel.text = "height : " + height + " m"
            typeLabel.text = types
            fetchDescriptionAndEvoData(data.species.url)
            
        } catch {
            print(error)
        }
    }
}

