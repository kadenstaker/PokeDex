//
//  PokemonController.swift
//  PokeDex
//
//  Created by Kaden Staker on 9/4/18.
//  Copyright © 2018 Kaden Staker. All rights reserved.
//

import UIKit

class PokemonController {
    static let shared = PokemonController()
    // private init() {} helps to prevent memory leaks
    private init() {}
    //MARK: - Properties
    // Add "s" to the end of http to avoid security problems
    var baseURL = URL(string: "https://pokeapi.co/api/v2")
    // @escaping means that the function (closure) will escape out of the function and complete at a later time
    func fetchPokemon(by pokemonName: String, completion: @escaping (Pokemon?) -> Void) {
        // 1. Know what you want to display (complete) to the user
        // 2. Call URLSession - so you can work backwards
        // 3. We need the base url
        guard let unwrappedBaseURL = baseURL else {
            fatalError("bad base url")
        }
        //Use components if you want to use query items
//        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let requestURL = unwrappedBaseURL.appendingPathComponent("pokemon").appendingPathComponent(pokemonName)
        // 4. Build your url
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            // 1. Handle error
            // 2. Handle data
            // 3. Do try catch
            // 4. JSONDecoder
            // 5. Decode and Complete with your object
            do {
                if let error = error { throw error }
                guard let data = data else { throw NSError() }
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(pokemon)
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }.resume()
    }
    
    func fetchImage(pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
        let imageURL = pokemon.spritesDictionary.image
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            
            do {
                if let error = error { throw error }
                guard let data = data else { throw NSError() }
                guard let image = UIImage(data: data) else { completion(nil) ; return }
                completion(image)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
