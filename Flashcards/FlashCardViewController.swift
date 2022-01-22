//
//  FlashCardViewController.swift
//  Flashcards
//
//  Created by Omar Diab on 1/9/22.
//

import UIKit
import CoreData

class FlashCardViewController: UIViewController {

    @IBOutlet weak var QuestionTextView: UITextView!
    @IBOutlet weak var AnswerTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    
    var mangedObjectContext: NSManagedObjectContext!
    var listOfCards = [FlashCard]()
    var currentCard : FlashCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mangedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func SaveCardAction(_ sender: Any) {
        guard let question = QuestionTextView.text,
              let answer = AnswerTextView.text,
              let subject = subjectTextField.text
                
                else { return }
        saveCardToDataBase(subject: subject, question: question, answer: answer)
    }
    
    func saveCardToDataBase(subject: String, question:String, answer:String) {
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "FlashCard", into: mangedObjectContext) as! FlashCard
        newCard.question = question
        newCard.answer = answer
        newCard.subject = subject
        do{
            try mangedObjectContext.save()
        }catch{
            print("fail to save card")
        }
    }
}
