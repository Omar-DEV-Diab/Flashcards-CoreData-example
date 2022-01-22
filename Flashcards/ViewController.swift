//
//  ViewController.swift
//  Flashcards
//
//  Created by Omar Diab on 1/3/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    
    enum displayMode {
        case answerFirst
        case qustionFirt
    }
    var currentDisplayMode: displayMode = .qustionFirt
    var mangedObjectContext: NSManagedObjectContext!
    var listOfCards = [FlashCard]()
    var currentCard : FlashCard?
    var listOfSubjects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mangedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCards()
    }
    
    func fetchCards(){
        let fetchRequest:NSFetchRequest<FlashCard> = FlashCard.fetchRequest()
        do {
            listOfCards = try
            mangedObjectContext.fetch(fetchRequest)
            guard !listOfCards.isEmpty else{return}
            for card in listOfCards {
                if !listOfSubjects.contains(card.subject!){
                    listOfSubjects.append(card.subject!)
                }
            }
        }catch{
            print("could not fetch data")
        }
    }
    
    @IBAction func selectDisbalyModeAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentDisplayMode = .answerFirst
        case 1:
            currentDisplayMode = .qustionFirt
        default:
            currentDisplayMode = .answerFirst
        }
    }
    
    func dispalyCard() {
        guard listOfCards.count > 0 else {
            return
        }
        let randomIndex = Int(arc4random_uniform(UInt32(listOfCards.count)))
        currentCard = listOfCards[randomIndex]
        if let displayCard = currentCard{
            guard let subject = subjectTextField.text else {return}
            if subjectTextField.text == "" {
                displayCardContent(card: displayCard)
                return
            }else if !listOfSubjects.contains(subject){
                cardLbl.text = "no crads with that subject"
            }else if currentCard?.subject == subject{
                displayCardContent(card: displayCard)
            }else{
                self.dispalyCard()
            }
        }
    }
    
    func displayCardContent(card:FlashCard) {
        switch currentDisplayMode {
        case .answerFirst:
            cardLbl.text = card.answer
        case .qustionFirt:
            cardLbl.text = card.question
        }
    }
    
    @IBAction func deleteCardAction(_ sender: Any) {
        guard (currentCard != nil) else {
            return
        }
        mangedObjectContext.delete(currentCard!)
        do{
            try mangedObjectContext.save()
            fetchCards()
            dispalyCard()
        }catch{
            print("could not be delted, mangedObjectContext save error")
        }
    }
    
    @IBAction func rightSwipeAction(_ sender: Any) {
        dispalyCard()
    }
    
    @IBAction func upSwipeAction(_ sender: Any) {
        if let card = currentCard {
            cardLbl.text = card.question
        }
    }
    
    @IBAction func downSwipeAction(_ sender: Any) {
        if let card = currentCard {
            cardLbl.text = card.answer
        }
    }
}

