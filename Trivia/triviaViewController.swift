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
        resetQuestions()
    }
    
    private func configure(with trivia: Trivia){
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        questionLabel.text = trivia.question;
        questionCountLabel.text = "\(selectedTriviaIndex + 1)/\(totalquestion)"
        
        // First, hide all answer buttons
        answerLabels.arrangedSubviews.forEach { $0.isHidden = true }

            // Then, configure and show only as many buttons as there are answers
        for (index, answer) in trivia.answers.enumerated() {
                if index < answerLabels.arrangedSubviews.count {
                    let button = answerLabels.arrangedSubviews[index] as? UIButton
                    button?.setTitle(answer, for: .normal)
                    button?.isHidden = false // Only unhide the button if there's an answer to show
                }
        }
        
    }
    
    
    private func showAlert(){
        let alert = UIAlertController(title: "Game Over!", message: "Final score: \(correctAnswerCount)/\(totalquestion)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
                    // Handle the button press
                    self.resetQuestions()
                    print("Restart button pressed")
                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetQuestions() {
        TriviaQuestionService.fetchQuestions() { questions in
            self.trivias = questions
            self.totalquestion = questions.count
            self.selectedTriviaIndex = 0
            self.correctAnswerCount = 0
            self.configure(with: questions[self.selectedTriviaIndex])
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func didTapAnswer(_ sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal), buttonTitle == trivias[self.selectedTriviaIndex].correctAnswer{
            correctAnswerCount += 1
        }
        if self.selectedTriviaIndex + 1 == totalquestion {
            showAlert()
        } else {
            self.selectedTriviaIndex += 1
            configure(with:trivias[self.selectedTriviaIndex])
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
