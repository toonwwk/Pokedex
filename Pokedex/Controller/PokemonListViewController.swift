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
    var filterPokemonList: [PokemonModel] = []
    var selectedPokemonId: Int!
    var isSearching = false
//    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonListManeger.delegate = self
        searchBar.delegate = self
        pokemonListManeger.fetchData()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCell")
        collectionView.decelerationRate = .normal
//        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
//        collectionView.refreshControl = refreshControl
        
        searchBar.rx.text.orEmpty.asObservable().subscribe(
                onNext: { pokemonName in
                    let name = pokemonName.lowercased()
                    self.filterPokemon(name: name)
            }
        )
        
    }
//    @objc func loadData() {
//        isSearching = false
//        collectionView.reloadData()
//
//    }
    
    func filterPokemon(name: String){
        if name != "" {
            filterPokemonList = pokemonList.filter({
                $0.name.contains(name)
            })
            isSearching = true
        }
        else{
            isSearching = false

        }
        collectionView.reloadData()
    }
    
}

extension PokemonListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
    }
}



extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching{
            return filterPokemonList.count
        }
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! CollectionViewCell
        if isSearching{
            let imagePath = self.filterPokemonList[indexPath.row].image
            cell.imageView.load(url: imagePath!)
            cell.pokemonName.text = self.filterPokemonList[indexPath.row].name
        }
        else{
            let imagePath = self.pokemonList[indexPath.row].image
            cell.imageView.load(url: imagePath!)
            cell.pokemonName.text = self.pokemonList[indexPath.row].name
        }
        return cell
    }
}

extension PokemonListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPokemonId = indexPath.row
        self.performSegue(withIdentifier: "ShowPokemonData", sender: self)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension PokemonListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPokemonData" {
            let destinationVC = segue.destination as! PokemonInfoController
            if isSearching{
                destinationVC.pokemon = filterPokemonList[selectedPokemonId]
            }
            else{
                destinationVC.pokemon = pokemonList[selectedPokemonId]
            }
        }
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

extension PokemonListViewController: PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemonList: [PokemonModel]) {
        self.pokemonList = pokemonList
        self.collectionView.reloadData()
        self.collectionView.scrollsToTop = false
    }
    
    func didFailWithError(error: AFError) {
        print("error")
    }
    
    
}
