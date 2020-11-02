//
//  ViewController.swift
//  OpenQuiz
//
//  Created by Baptiste MAQUET on 13/10/2020.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
        
    }
 
    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame(){
        newGameButton.isHidden = true
        activityIndicator.isHidden = false
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        scoreLabel.text = "0 / 10"
        
        game.refresh()
        
    }

    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer){
        
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
        
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionView)
        let transformTransform = CGAffineTransform(translationX: translation.x, y: 0)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWidth/2)
        let roationAngle = (CGFloat.pi / 6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: roationAngle)
        
        let transform = transformTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion(){
        var isCorrect = false;
        
        switch questionView.style {
        case .correct:
            isCorrect = game.answerCurrentQuestion(with: true)
        case .incorrect:
            isCorrect = game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform

        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        scoreLabel.text = "\(game.score) / 10"
        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (success) in
            if (success) {
                self.animResult(isCorrect)
            }
        }
        

    }
    
    private func animResult(_ isCorrect: Bool) {
        UIView.animate(withDuration: 0.8) {
            let backgroundColor = self.mainView.backgroundColor
            if isCorrect == true {
                self.mainView.backgroundColor = #colorLiteral(red: 0.7837015986, green: 0.9239410758, blue: 0.6289841533, alpha: 1)
            } else {
                self.mainView.backgroundColor = #colorLiteral(red: 0.9537943006, green: 0.527913332, blue: 0.5794941783, alpha: 1)
            }
            self.mainView.backgroundColor = backgroundColor
            
        } completion: { (success) in
            self.scoreLabel.textColor = .white
            self.showQuestionView()
        }

    }
    
    private func showQuestionView(){
        
        
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                            self.questionView.transform = .identity
                       },
                       completion: nil)

        
        questionView.style = .standard
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
    }

}

