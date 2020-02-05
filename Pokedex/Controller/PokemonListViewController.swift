//
//  PokemonListController.swift
//  Pokedex
//
//  Created by Kanokporn Wongwaitayakul on 5/2/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var pokemonListManeger = PokemonManager()
    var pokemonList: [PokemonModel] = []
    var pokemonCellList: [CollectionViewCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonListManeger.delegate = self
        pokemonListManeger.fetchData()
        
        searchBar.rx.text.orEmpty.asObservable()
        .subscribe(
            onNext: { (pokemonName) in
            //code here
        },onCompleted: {
             print("Completed !!!!")
        })
    }


}

extension PokemonListViewController: PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemonList: [PokemonModel]) {
        self.pokemonList = pokemonList
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCell")
    }
    
    func didFailWithError(error: AFError) {
        print("error")
    }
    
        
}



extension PokemonListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0 - 2.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imagePath = pokemonList[indexPath.row].image
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! CollectionViewCell
        
        let url = URL(string: imagePath!)
        
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.imageView.image = image
            cell.pokemonName.text = pokemonList[indexPath.row].name
        }
        pokemonCellList.append(cell)
        return cell
    }
 
}

extension PokemonListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pokemonCellList[indexPath.item].isHidden = true
        
    }
}
