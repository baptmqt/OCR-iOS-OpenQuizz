//
//  Game.swift
//  OpenQuiz
//
//  Created by Baptiste MAQUET on 13/10/2020.
//

import Foundation


class Game {
    var score = 0

    private var questions = [Question]()
    private var currentIndex = 0

    var state: State = .ongoing

    enum State {
        case ongoing, over
    }

    var currentQuestion: Question {
        return questions[currentIndex]
    }

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        questions.append(Question(title: "2020 est une bonne année.", isCorrect: false))
        questions.append(Question(title: "Le 1er confinement à commencé le mardi 17 mars.", isCorrect: true))
        questions.append(Question(title: "La Covid-19 est une simple grippe.", isCorrect: false))
        questions.append(Question(title: "La Covid-19 signifie Coronavirus Disease of 2019.", isCorrect: true))
        questions.append(Question(title: "Les enfants ne peuvent pas être touchés par la Covid-19.", isCorrect: false))
        questions.append(Question(title: "Les personnes agées ne sont pas des personne à riques pour la Covid-19.", isCorrect: false))
        questions.append(Question(title: "Donald Trump a eu le Coronavirus.", isCorrect: true))
        questions.append(Question(title: "Le premier pays touché par le Coronavirus est la Suisse.", isCorrect: false))
        questions.append(Question(title: "Le papier toilette était une ressource rare au début du 1er confinement.", isCorrect: true))
        questions.append(Question(title: "Beaucoup de français ont fait tu pains mainson durant le 1er confinement.", isCorrect: true))
        
        
        self.state = .ongoing
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
        
        
        // J'ai désactivé le question manager car j'ai fais une partie du cours dans le train et je n'avais pas de connection
        // internet, je me suis donc permis de mettre quelques questions :)
        
        /*QuestionManager.shared.get {(questions) in
            self.questions = questions
            self.state = .ongoing
            
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }*/
    }
    
    
    //  J'ai ajouter un Bool de retour afin de faire l'animation en fonction du result de la reponse
    func answerCurrentQuestion(with answer: Bool) -> Bool {
        var isCorrect = false;
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
            isCorrect = true;
        }
        goToNextQuestion()
        return isCorrect;
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }
}


