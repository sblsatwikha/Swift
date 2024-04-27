//
//  Person.swift
//  10NamesToFaces
//
//  Created by Satwika on 4/11/24.
//

import UIKit

class Person: NSObject, NSCoding {
    
    var image: String
    var name: String
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "Image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(image, forKey: "Image")
    }

}
