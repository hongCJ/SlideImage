//
//  SettingViewController.swift
//  SlideImage
//
//  Created by 郑红 on 2018/10/24.
//  Copyright © 2018 ZhengHong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var stpperColumn: UIStepper!
    
    @IBOutlet var stpperRow: UIStepper!
    @IBOutlet var columnLabel: UILabel!
    @IBOutlet var rowLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func choosePic(_ sender: Any) {
        let alertVC = UIAlertController.init(title: "选择图片", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction.init(title: "camera", style: .default) { (_) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let library = UIAlertAction.init(title: "library", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertVC.addAction(camera)
        alertVC.addAction(library)
        present(alertVC, animated: true, completion: nil)
    }
    
    func pickImageFinish(image: UIImage?) {
        Config.shared.image = image
        Config.shared.refresh = true
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func columnChanged(_ sender: Any) {
        guard let stpper = sender as? UIStepper else {
            return
        }
        columnLabel.text = "Column: \(stpper.value)"
        Config.shared.column = Int(stpper.value)
        Config.shared.refresh = true
        
    }
    @IBAction func rowChanged(_ sender: Any) {
        guard let stpper = sender as? UIStepper else {
            return
        }
        rowLabel.text = "Row: \(stpper.value)"
        Config.shared.row = Int(stpper.value)
        Config.shared.refresh = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SettingViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            weakSelf?.pickImageFinish(image: image)
        }
    }
}
