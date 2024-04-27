//
//  ViewController.swift
//  7WhitehousePetitions
//
//  Created by Satwika on 4/8/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
        dc.detailPetition = petitions[indexPath.row]
        navigationController?.pushViewController(dc, animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
        
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}

