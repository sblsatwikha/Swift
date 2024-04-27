//
//  ViewController.swift
//  StormViewer1
//
//  Created by Satwika on 4/1/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var pictureClicked = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try!fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasSuffix("jpeg") || item.hasSuffix("png"){
                pictures.append(item)
            }
        }
        
        print(pictures)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }


}

