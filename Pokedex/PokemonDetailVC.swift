//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Patrick Polomsky on 3/25/17.
//  Copyright © 2017 Patrick Polomsky. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var pokedexID: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evolLbl: UILabel!
    @IBOutlet weak var currentEvolImg: UIImageView!
    @IBOutlet weak var nextEvolImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        
        let img = UIImage(named: "\(pokemon.pokedexID)")
        
        mainImg.image = img
        currentEvolImg.image = img
        pokedexID.text = "\(pokemon.pokedexID)"
        
        
        
        pokemon.downloadPokemonDetails() {
            
            //what only be called after the network call is complete!
            self.updateUI()
            
        }
   
    }
    
    func updateUI() {
        
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        descLbl.text = pokemon.pokeDesc
        typeLbl.text = pokemon.type
        
        if pokemon.nextEvolID == "" {
            evolLbl.text = "No Evolutions"
            nextEvolImg.isHidden = true
        }
        else {
            
            nextEvolImg.isHidden = false
            nextEvolImg.image = UIImage(named: pokemon.nextEvolID)
            let str = "Next Evolution: \(pokemon.nextEvolName) - LVL \(pokemon.nextEvolLvl)"
            evolLbl.text = str
        }
        
        
        
        
    }


    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
