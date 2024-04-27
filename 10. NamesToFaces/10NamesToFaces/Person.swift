//
//  Person.swift
//  10NamesToFaces
//
//  Created by Satwika on 4/11/24.
//

import UIKit

class Person: NSObject {
    var image: String
    var name: String
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
    }

}
