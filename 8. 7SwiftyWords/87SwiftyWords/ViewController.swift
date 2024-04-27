//
//  ViewController.swift
//  87SwiftyWords
//
//  Created by Satwika on 4/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var clueslabel: UILabel!
    var answerslabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Your Score: \(score)"
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        
        clueslabel = UILabel()
        clueslabel.translatesAutoresizingMaskIntoConstraints = false
        clueslabel.text = "Clues"
        clueslabel.font = UIFont.systemFont(ofSize: 24)
        clueslabel.numberOfLines = 0
        view.addSubview(clueslabel)
        clueslabel.backgroundColor = .green
        clueslabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        answerslabel = UILabel()
        answerslabel.translatesAutoresizingMaskIntoConstraints = false
        answerslabel.text = "Answers Label"
        answerslabel.font = UIFont.systemFont(ofSize: 24)
        answerslabel.numberOfLines = 0
        answerslabel.textAlignment = .right
        view.addSubview(answerslabel)
        answerslabel.backgroundColor = .brown
        answerslabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 40)
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.isUserInteractionEnabled =  false
        view.addSubview(currentAnswer)
        
        let submit = UIButton()
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.backgroundColor = .black
        view.addSubview(submit)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        let clear = UIButton()
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        view.addSubview(clear)
        clear.backgroundColor = .black
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
//        buttonsView.backgroundColor = .cyan
        
        let width = 150
        let height = 80
        
        for row in 0...3{
            for col in 0...4{
                
                let letterButton = UIButton()
                letterButton.setTitle("HWHHW", for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                letterButton.backgroundColor = .lightGray
                letterButton.layer.borderWidth = 10
                letterButton.layer.borderColor = UIColor.purple.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
            }
        }

    
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            clueslabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            clueslabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            clueslabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerslabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerslabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerslabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerslabel.heightAnchor.constraint(equalTo: clueslabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.topAnchor.constraint(equalTo: clueslabel.bottomAnchor, constant: 100),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            
            submit.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 25),
            submit.widthAnchor.constraint(equalToConstant: 70),
            
            clear.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.widthAnchor.constraint(equalToConstant: 70),
            
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    
                    let clue = parts[1]
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let answer = parts[0]
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
                
            }
        }
        clueslabel.text = clueString
        answerslabel.text = solutionString
        
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count{
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }
    
    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else{return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.alpha = 0.3
        sender.isUserInteractionEnabled = false
    }
    
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAnswer.text else { return }
        if let position = solutions.firstIndex(of: answerText) {
            var splitAnswersLabel = answerslabel.text?.components(separatedBy: "\n")
            splitAnswersLabel?[position] = answerText
            answerslabel.text = splitAnswersLabel?.joined(separator: "\n")
            
            activatedButtons.removeAll()
            currentAnswer.text = ""
            
            score += 1
            print(score)
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well Done", message: "Are you ready for the next Level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Wrong Answer", message: "No matchings found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            clearTapped(sender)
        }
        
    }
    
    func levelUp(action: UIAlertAction){
        level += 1
        solutions.removeAll()
        for btn in activatedButtons{
            btn.alpha = 1
            btn.isUserInteractionEnabled = true
        }
        
        loadLevel()
    }
    
    @objc func clearTapped(_ sender: UIButton){
        currentAnswer.text = ""
        for btn in activatedButtons {
            btn.alpha = 1
            btn.isUserInteractionEnabled = true
        }
        activatedButtons.removeAll()
    }

    
}

