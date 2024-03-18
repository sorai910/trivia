//
//  triviaQuestionService.swift
//  Trivia
//
//  Created by Xiaoran Liu on 3/18/24.
//

import Foundation

class TriviaQuestionService {
    
    static func fetchQuestions(completion: (([Trivia]) -> Void)? = nil) {
        let amount = Int.random(in: 5...10)
        let parameters = "amount=\(amount)&type=multiple" // Ensuring multiple choice questions
        guard let url = URL(string: "https://opentdb.com/api.php?\(parameters)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response status code")
                return
            }
            
            if let questions = parse(data: data) {
                DispatchQueue.main.async {
                    completion?(questions)
                }
            }
        }
        
        task.resume()
    }
    
    private static func parse(data: Data) -> [Trivia]? {
        do {
            let decoded = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let questionsArray = decoded?["results"] as? [[String: Any]] else {
                print("JSON structure mismatch")
                return nil
            }
            
            var questions: [Trivia] = []
            for item in questionsArray {
                if let question = item["question"] as? String,
                   let correctAnswer = item["correct_answer"] as? String,
                   let incorrectAnswers = item["incorrect_answers"] as? [String] {
                    
                    var answers = incorrectAnswers
                    answers.append(correctAnswer)
                    answers.shuffle()
                    
                    let trivia = Trivia(question: question.htmlDecoded(), answers: answers, correctAnswer: correctAnswer.htmlDecoded())
                    questions.append(trivia)
                }
            }
            
            return questions
        } catch {
            print("Failed to parse JSON: \(error)")
            return nil
        }
    }
}

extension String {
    func htmlDecoded() -> String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        let decodedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil).string
        return decodedString ?? self
    }
}
