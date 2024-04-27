//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Satwika on 4/2/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var noOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, Error) in
            if granted {
                print("Authenticated")
                
                
                // when
                var dateComp = DateComponents()
                dateComp.hour = 6
                dateComp.minute = 30
                let trigger  = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                
                // what
                let content = UNMutableNotificationContent()
                content.title = "Guess the Flag"
                content.body = "Increase your knowledge in country flags"
                content.sound = UNNotificationSound.default
                
                // req
                let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(req)
                
            } else {
                print("Error")
            }
        }
        
        countries.append("Estonia")
        countries.append("France")
        countries.append("Germany")
        countries.append("Ireland")
        countries.append("Monaco")
        countries.append("Nigeria")
                
        button2.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderWidth = 2
        button1.layer.borderColor = UIColor.black.cgColor
        button1.layer.borderWidth = 2
        button3.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderWidth = 2
        
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: "highestScore")
        askQuestion()
        
        
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        noOfQuestions += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer] + " - Score: \(score)"
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }

    @IBAction func button1Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { finished in
            sender.transform = .identity
        }
        
        if correctAnswer == sender.tag {
            score += 1
            title = "Correct!!!"
        } else {
            score -= 1
            title = "Wrong! That's the flag of \(countries[sender.tag])"
        }
        
        if noOfQuestions < 10 {
            let ac = UIAlertController(title: title, message: "your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        } else{
            let alertTitle: String
            let alertMessage: String
            
            let defaults = UserDefaults.standard
            let highest = defaults.object(forKey: "highestScore") as? Int ?? 0
            
            if highest < score {
                defaults.set(score, forKey: "highestScore")
                alertTitle = "Highest Score"
                alertMessage = "New Highest Score: \(score)"
            } else{
                alertTitle = "Final Score"
                alertMessage = "Your Final score is \(score)"
            }
                
            
            let finalAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            finalAlert.addAction(UIAlertAction(title: "Start Over", style: .default){ [weak self] _ in
                self?.score = 0
                self?.noOfQuestions = 0
                self?.askQuestion()
            })
            present(finalAlert, animated: true)
            
        }
        
        
    }

    
    
    
}

