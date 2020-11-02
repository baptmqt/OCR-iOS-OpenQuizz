//
//  QuestionView.swift
//  OpenQuiz
//
//  Created by Baptiste MAQUET on 14/10/2020.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    enum Style {
         case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    var title = String() {
        didSet {
            label.text = title
        }
    }
    
    private func setStyle(_ style: Style){
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.7837015986, green: 0.9239410758, blue: 0.6289841533, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9537943006, green: 0.527913332, blue: 0.5794941783, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
            break
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7483639121, green: 0.7705883384, blue: 0.7862138152, alpha: 1)
            icon.isHidden = true
            break
        }
    }
    
    

}
