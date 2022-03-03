//
//  ViewController.swift
//  myMatch
//
//  Created by ling nie on 2/27/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    let model = CardModel()
    var cardsArray = [Card]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()

        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    var soundPlayer = SoundManager()
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }

    // MARK: - Collection View Delegate Methods
    //how many to draw
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return number of cards
        return cardsArray.count
    }
    //how to recycle cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) //as! CardCollectionViewCell
        return cell

    }
    //show content based on card property
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Finish configuring the cell
        cardCell?.configureCell(card: card)

    }
    
    var firstFlippedCardIndex:IndexPath?

    
    //when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get a reference to the cell that was tapped

        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
            soundPlayer.playSound(effect: .flip)
            cell?.flipUp()
            // Check if this is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                
                // This is the first card flipped over
                
                firstFlippedCardIndex = indexPath
                
            }else {
                
                // Second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }

        }
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            soundPlayer.playSound(effect: .match)
            // Play match sound
            //soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was that the last pair?
            //checkForGameEnd()
        }
        else {
            
            // It's not a match
            soundPlayer.playSound(effect: .nomatch)
            // Play sound
            //soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
}

