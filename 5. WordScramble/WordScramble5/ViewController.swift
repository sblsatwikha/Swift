//
//  ViewController.swift
//  WordScramble5
//
//  Created by Satwika on 4/4/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["NO Words"]
        }
        
        print(allWords)
        
        let defaults = UserDefaults.standard
        if let currentRecordData = defaults.object(forKey: "CurrentRecord") as? Data {
            let decoder = JSONDecoder()
            if let currentRecord = try? decoder.decode(CurrentRecord.self, from: currentRecordData) {
                title = currentRecord.CurrentWord
                usedWords = currentRecord.CurrentEntries
            }
            tableView.reloadData()
            return
        }
        startGame()
        
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll()
        save()
        tableView.reloadData()
    }
    
    func save(){
        let currentRecord = CurrentRecord(CurrentWord: title ?? "", CurrentEntries: usedWords)
        let encoder = JSONEncoder()
        do{
            let currentData = try encoder.encode(currentRecord) as Data
            let defaults = UserDefaults.standard
            defaults.set(currentData, forKey: "CurrentRecord")
        } catch{
            print("error loading")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func addTapped(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] action in
            guard let answerEntered = ac?.textFields?[0].text else { return }
            self?.submitAnswer(answerEntered)
        }
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    func submitAnswer(_ answer: String){
        print(answer)
        let answerLowered = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        if isPossible(answer: answerLowered){
            if isOriginal(answer: answerLowered){
                if isReal(answer: answerLowered){
                    usedWords.insert(answer, at: 0)
                    tableView.reloadData()
                    save()
                    return
                } else{
                    errorTitle = "Not real word"
                    errorMessage = "Enter a real english word"
                }
            } else{
                errorTitle = "Duplicate word"
                errorMessage = "This word already repeated"
            }
        } else{
            errorTitle = "Not possible"
            errorMessage = "Word not possible from \(title!)"
        }
        showError(errorTitle, errorMessage)
    }
    
    func isPossible(answer: String) -> Bool{
        var fullWord = title?.lowercased()
        for letter in answer{
            if let position = fullWord?.firstIndex(of: letter){
                fullWord?.remove(at: position)
            } else{
                return false
            }
        }
        return true
    }
    
    func isOriginal(answer: String) -> Bool{
        return !usedWords.contains(answer)
    }
    
    func isReal(answer: String) -> Bool{
        guard let fullWord = title?.lowercased() else { return false }

        if answer.count<3 || fullWord.hasPrefix(answer){
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: answer.count)
        let missSpelledRange = checker.rangeOfMisspelledWord(in: answer, range: range, startingAt: 0, wrap: false, language: "en")
        return NSNotFound == missSpelledRange.location
    }
    
    func showError(_ errorTitle: String, _ errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

