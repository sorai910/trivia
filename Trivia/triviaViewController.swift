//
//  triviaViewController.swift
//  Trivia
//
//  Created by Xiaoran Liu on 3/7/24.
//

import UIKit

class triviaViewController: UIViewController {
    
    @IBOutlet weak var questionCountLabel: UILabel!
    
   
    @IBOutlet weak var answerLabels: UIStackView!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    private var trivias = [Trivia]()
    private var selectedTriviaIndex = 0
    private var correctAnswerCount = 0
    private var totalquestion = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trivias = createMockData()
        totalquestion = trivias.count
        configure(with: trivias[selectedTriviaIndex])
        // Do any additional setup after loading the view.
    }
    
    private func configure(with trivia: Trivia){
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        questionLabel.text = trivia.question;
        questionCountLabel.text = "\(selectedTriviaIndex + 1)/\(totalquestion)"
        
        for (index, subview) in answerLabels.arrangedSubviews.enumerated() {
            if let button = subview as? UIButton, index < trivia.answers.count {
                // Update the button's title based on its index
                button.setTitle(trivia.answers[index], for: .normal)
            }
        }
        
        
    }
    
    private func createMockData()-> [Trivia]{
        let mock1 = Trivia(question: "In what country did the first Starbucks open outside of North America?",
                           answers: ["Japan", "France", "United Kingdom", "Brazil"],
                           correctAnswer: "Japan"
        )
        let mock2 = Trivia(question: "Which company's slogan is \"You're in good hands?\" ?", 
                           answers: ["Allstates","progressive", "StateFarm", "Liberty Mutual"]
                           , correctAnswer: "Allstates")
        let mock3 = Trivia(question: "Originally, Amazon only sold what kind of product?",
                           answers: ["Clothing", "Grocery", "Electronics", "Books"],
                           correctAnswer: "Books")
        return [mock1, mock2, mock3]
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Game Over!", message: "Final score: \(correctAnswerCount)/\(totalquestion)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
                    // Handle the button press
                    self.selectedTriviaIndex = 0
                    self.correctAnswerCount = 0
                    self.configure(with: self.trivias[self.selectedTriviaIndex])
                    print("Restart button pressed")
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapAnswer(_ sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal), buttonTitle == trivias[selectedTriviaIndex].correctAnswer{
            correctAnswerCount += 1
        }
        if selectedTriviaIndex + 1 == totalquestion {
            showAlert()
        } else {
            selectedTriviaIndex += 1
            configure(with:trivias[selectedTriviaIndex])
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
