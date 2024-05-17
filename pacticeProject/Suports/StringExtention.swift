//
//  StringExtention.swift
//  pacticeProject
//
//  Created by apple on 18/05/24.
//

import Foundation


extension String {
    func capitalFirstLetter() -> String {
        guard self.count > 0 else { return "" }
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
}


enum CameraLocal: String {
    
    case photo = "Photo"
    case flip = "Flip"
    case flash = "Flash"
    case ok = "OK"
    case success = "Success"
    case error = "Error"
    case cancel = "Cancel"
    case opern_settings = "Open Settings"
    case preview = "Preview"
    case Done = "Done"
    case Save = "Save"
    case undo = "Undo"
    case exit = "Exit"
    case yes = "Yes"
    case no = "No"
    
}
