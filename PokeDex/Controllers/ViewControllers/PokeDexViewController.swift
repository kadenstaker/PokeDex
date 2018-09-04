//
//  PokeDexViewController.swift
//  PokeDex
//
//  Created by Kaden Staker on 9/4/18.
//  Copyright © 2018 Kaden Staker. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        imageView.image = #imageLiteral(resourceName: "pokeball")
        imageView.spin()
        guard let pokemonText = searchBar.text?.lowercased() else {return}
        PokemonController.shared.fetchPokemon(by: pokemonText) { (pokemon) in
            guard let unwrappedPokemon = pokemon else {self.presentAlert(); return}
            DispatchQueue.main.async {
                self.nameLabel.text = unwrappedPokemon.name.capitalized
                self.idLabel.text = "\(String(describing: unwrappedPokemon.id))"
                self.abilitiesLabel.text = "Abilities: \(unwrappedPokemon.abilitiesName.joined(separator: ", ").capitalized)"
            }
            PokemonController.shared.fetchImage(pokemon: unwrappedPokemon, completion: { (image) in
                DispatchQueue.main.async {
                    if image != nil {
                        self.imageView.layer.removeAllAnimations()
                        self.imageView.image = image
                    } else {
                        self.presentAlert()
                    }
                }
            })
        }
        // Dismisses the keyboard
        searchBar.resignFirstResponder()
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Pokemon not found", message: "😢", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(dismiss)
    }
}

extension UIImageView {
    func spin() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.25 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        DispatchQueue.main.async {
            self.layer.add(rotation, forKey: "rotationAnimation")
        }
    }
}
