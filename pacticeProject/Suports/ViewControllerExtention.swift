//
//  Extension+ViewController.swift
//  CodingTest
//
//  Created by sanjay on 24/02/24.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(from appStoryboard : StoryboardExtension) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
        
    }
    
    enum StoryboardExtension : String {
        
        case Main
        
        var instance : UIStoryboard {
            return UIStoryboard(name: self.rawValue.capitalFirstLetter(), bundle: Bundle.main)
        }
        
        func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
            let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
            return instance.instantiateViewController(withIdentifier: storyboardID) as! T
        }
        
        func initialViewController() -> UIViewController? {
            return instance.instantiateInitialViewController()
        }
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 15)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


extension UIViewController {
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            completion(true)
        case .notDetermined:
            // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            // The user has previously denied or restricted camera access.
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}


