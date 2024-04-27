//
//  CurrentWord.swift
//  WordScramble5
//
//  Created by Satwika on 4/15/24.
//

import UIKit

class CurrentRecord: NSObject, Codable {
    var CurrentWord: String
    var CurrentEntries: [String]
    
    init(CurrentWord: String, CurrentEntries: [String]) {
        self.CurrentWord = CurrentWord
        self.CurrentEntries = CurrentEntries
    }

}
