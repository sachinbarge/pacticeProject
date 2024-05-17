//
//  ViewController.swift
//  pacticeProject
//
//  Created by apple on 18/05/24.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        checkCameraPermission { granted in
            if granted {
                print("Camera access is granted")
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    self.present(imagePicker, animated: true)
                }
                
            } else {
                print("Camera access is denied or restricted")
                self.showToast(message: "Camera access is denied or restricted")
            }
        }
        
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        if let image = imageView.image {
            self.navigateToEdit(img: image)
        }else {
            self.showToast(message: "Please capture Image")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func addEditButton() {
        let editButton = UIButton(frame: CGRect(x: 50, y: 500, width: 100, height: 50))
        editButton.setTitle("Edit Photo", for: .normal)
        editButton.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    @objc func editPhoto() {
        // Implement photo editing functionality
    }
}

// MARK: - Navigation
extension ViewController {
    
    func navigateToEdit(img : UIImage) {
        let vc = FilterViewController.instantiate(from: .Main)
        vc.CapturedImage = img
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Camera permission

extension ViewController {
    func showAlertToGetCameraAccess() {
        
        guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        let title = CameraLocal.opern_settings.rawValue
        let message = CameraLocal.opern_settings.rawValue
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: CameraLocal.cancel.rawValue, style: .default) {[weak self] _ in
            //            self?.dismissCamera()
        }
        
        let settingsAction = UIAlertAction(title: CameraLocal.opern_settings.rawValue, style: .cancel) { _ in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}


