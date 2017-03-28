//
//  Pokemon.swift
//  Pokedex
//
//  Created by Patrick Polomsky on 3/15/17.
//  Copyright © 2017 Patrick Polomsky. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {

    private var _name: String!
    private var _pokedexID: Int!
    private var _pokeDesc: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolTxt: String!
    private var _nextEvolName: String!
    private var _nextEvolID: String!
    private var _nextEvolLvl: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var nextEvolTxt: String {
        if _nextEvolTxt == nil {
            _nextEvolTxt = ""
        }
        return _nextEvolTxt
    }
    
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var pokeDesc: String {
        if _pokeDesc == nil {
            _pokeDesc = ""
        }
        return _pokeDesc
    }
    
    var nextEvolName: String {
        if _nextEvolName == nil {
            _nextEvolName = ""
        }
        return _nextEvolName
    }
    
    var nextEvolID: String {
        if _nextEvolID == nil {
            _nextEvolID = ""
        }
        return _nextEvolID
    }
    
    var nextEvolLvl: String {
        if _nextEvolLvl == nil {
            _nextEvolLvl = ""
        }
        return _nextEvolLvl
    }
    
    
    init(name:String, pokedexId: Int) {
        self._name = name
        self._pokedexID = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON {(response) in
            
            //print(response.result.value!)
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let type = dict["type"] as? String {
                    self._type = type
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let type = dict ["types"] as? [Dictionary<String, String>] , type.count > 0  {
                    
                    if let name = type[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if type.count > 1 {
                     
                        for x in 1..<type.count {
                            if let name = type[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                    }
                        }
                    }
                    
                    } else {
                        
                        self._type = ""
                }
                
            
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let desc = descDict["description"] as? String {
                                 
                                    let newDesc = desc.replacingOccurrences(of: "POKEMON", with: "Pokemon")
                                    
                                    self._pokeDesc = newDesc
                       
                                }
                            }
                            
                            completed()
                            
                        })
                    }
                    
                } else {
                    
                    self._pokeDesc = ""
                    
                }
                
             
                
                if let evolution = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolution.count > 0 {
                    
                    if let nextEvo = evolution[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolName = nextEvo
                            
                            if let uri = evolution[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                
                                let nextEvolID = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolID = nextEvolID
                                
                                if let lvlExist = evolution[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvolLvl = "\(lvl)"
                                    }
                                } else {
                                    
                                    self._nextEvolLvl = ""
                                }
                            }
                        }
                    }
                    
                }
            
               
                
            }
            
            
                completed()
    
            
                
                
        
        }
        
        
    }
    
}
