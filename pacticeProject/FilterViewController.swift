//
//  FilterViewController.swift
//  pacticeProject
//
//  Created by apple on 18/05/24.
//

import UIKit
import Foundation


class FilterViewController: UIViewController {
    var CapturedImage : UIImage?
    var captionTextField: UITextField?
    @IBOutlet weak var modifiedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = CapturedImage {
            modifiedImage.image = image
        }
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    // MARK: - IBOutlet Actions
    @IBAction func applyFilterTapped(_ sender: UIButton) {
        guard let image = self.modifiedImage.image else { return  }
        applyFilter(to: image)
    }
    
    @IBAction func addCaptionTapped(_ sender: UIButton) {
        guard let image = self.modifiedImage.image else { return  }
//        addCaption(to: image)
        addCaptionStatic(to: image)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.modifiedImage.image = CapturedImage
        for sublayer in modifiedImage.layer.sublayers ?? [] {
            if sublayer is CATextLayer {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let image = self.modifiedImage.image else { return  }
        saveImage(image)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
            guard let image = modifiedImage.image else {
                return
            }
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
    }
}

extension FilterViewController {
    
    func applyFilter(to image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        
        let filter = CIFilter(name: "CIColorControls")
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(1.2, forKey: kCIInputContrastKey)
        if let outputImage = filter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let filteredImage = UIImage(cgImage: cgImage)
                modifiedImage.image = filteredImage
            }
        }
    }
    
    func addCaptionStatic(to image: UIImage) {
        
        // Add text using a CALayer
              let textLayer = CATextLayer()
              textLayer.string = "This is caption"
              textLayer.foregroundColor = UIColor.white.cgColor
//              textLayer.backgroundColor = UIColor.black.cgColor // Background color for the text (if needed)
              textLayer.font = CTFontCreateWithName(UIFont.boldSystemFont(ofSize: 20).fontName as CFString, 0, nil)
              textLayer.fontSize = 20
              textLayer.frame = CGRect(x: 50, y: 50, width: 200, height: 50) // Adjust position and size as needed
              textLayer.alignmentMode = .center
              textLayer.contentsScale = UIScreen.main.scale
              modifiedImage.layer.addSublayer(textLayer)
    }
    
    func addCaption(to image: UIImage) {
        captionTextField = UITextField(frame: CGRect(x: self.view.frame.origin.x + 25, y: modifiedImage.frame.origin.y + 50, width: self.view.frame.width - 50, height: 50))
        captionTextField?.backgroundColor =  UIColor.lightGray//UIColor.black.withAlphaComponent(0.5)
        captionTextField?.textColor = .white
        captionTextField?.layer.borderWidth = 1.0
        captionTextField?.layer.borderColor = UIColor.black.cgColor
        captionTextField?.layer.cornerRadius = 25.0
        captionTextField?.placeholder = "Add a caption..."
        captionTextField?.textAlignment = .center
        modifiedImage.addSubview(captionTextField!)
        captionTextField?.bringSubviewToFront(modifiedImage)
    }
    
    
    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle error saving image
            print("Error saving image: \(error.localizedDescription)")
            self.showToast(message: "Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            print("Image saved successfully")
            self.showToast(message: "Image saved successfully")
        }
    }
}
