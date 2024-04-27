//
//  ViewController.swift
//  10NamesToFaces
//
//  Created by Satwika on 4/11/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    }
    
    @objc func addPerson(){
        let imagePickerCont = UIImagePickerController()
        imagePickerCont.allowsEditing = true
        imagePickerCont.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePickerCont.sourceType = .camera
//        } else{
//            imagePickerCont.sourceType = .photoLibrary
//        }
        present(imagePickerCont, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let name = UUID().uuidString
        let imagePath = getDocDir().appendingPathComponent(name)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(image: name, name: "Unknown")
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocDir() -> URL {
        let fmPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return fmPaths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            fatalError("unable to dequeue Person cell")
        }
        
        cell.name.text = people[indexPath.item].name
        
        let imagePath = getDocDir().appendingPathComponent(people[indexPath.item].image)
        cell.imageView.image = UIImage(contentsOfFile: imagePath.path)
        print(type(of: imagePath))
        print(type(of: imagePath.path))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.people[indexPath.item].name = newName
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            do{
                let imagePath = self?.getDocDir().appendingPathComponent((self?.people[indexPath.item].image)!)
                try FileManager.default.removeItem(at: imagePath!)
                self?.people.remove(at: indexPath.row)
                self?.collectionView.reloadData()
                
            } catch {
                print("Error in deleting")
            }
            
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}

