//
//  ViewController.swift
//  Pokedex
//
//  Created by Patrick Polomsky on 3/14/17.
//  Copyright © 2017 Patrick Polomsky. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.showsCancelButton = false
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func parsePokemonCSV() {
        
     let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
             
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke =  Pokemon(name: name, pokedexId: pokeID)
                pokemon.append(poke)
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
            
        }
        
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            
            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
                
            }
            
                return cell
        } else {
         
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }
        
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2
            
        
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            
            if let detailsVC = segue.destination as? PokemonDetailVC {
                
                if let poke = sender as? Pokemon {
                    
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        if searchBar.text == nil || searchBar.text == "" || searchText.characters.count == 0 {
            
            inSearchMode = false
            searchBar.showsCancelButton = false
            collection.reloadData()
            view.endEditing(true)
            
            
            
            
            
        } else {
        
            inSearchMode = true
            
            searchBar.showsCancelButton = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
            
       
        }
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        inSearchMode = false
        collection.reloadData()
        view.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
    
    
   
    @IBAction func releaseSearch(_ sender: Any) {
        
        inSearchMode = false
        collection.reloadData()
        view.endEditing(true)
        searchBar.text = nil
        
    }
  
    

}











