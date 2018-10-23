//
//  GameViewController.swift
//  SlideImage
//
//  Created by 郑红 on 2018/10/22.
//  Copyright © 2018 ZhengHong. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var choosePicButton: UIButton!
    
    @IBOutlet var stack3: UIStackView!
    @IBOutlet var stack2: UIStackView!
    @IBOutlet var stack1: UIStackView!
    var image: UIImage?
    
    var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing =
    }

    @IBAction func choosePic(_ sender: Any) {
        navigationController?.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func pickerDone() {
        guard let img = image else {
            return
        }
        let images = cropImage(image: img)
        var imageViews: [UIView] = []
        
        imageViews.append(contentsOf: stack3.subviews)
        imageViews.append(contentsOf: stack2.subviews)
        imageViews.append(contentsOf: stack1.subviews)
        
        guard imageViews.count == images.count else {
            return
        }
        for i in 0..<images.count {
            if let imgView = imageViews[i] as? UIImageView {
                imgView.image = images[i]
            }
        }
        
    }
    
    func cropImage(image: UIImage) -> [UIImage] {
        var result: [UIImage] = []
        let width = image.size.width / 3.0
        let height = image.size.height / 3.0
        
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return result
        }
        // 顺时针旋转180度
        ctx.rotate(by: CGFloat(Double.pi))
        // 沿X轴对称处理
        ctx.scaleBy(x: -1, y: 1)
        // 把偏移掉的位置调整回来
        ctx.translateBy(x: 0, y: CGFloat(-height))

        guard let cgImage = image.cgImage else {
            return result
        }
        
        for row in 0...2 {
            for column in 0...2 {
                ctx.saveGState()
                let x = CGFloat(-column) * width
                let y = CGFloat(-row) * height
                ctx.draw(cgImage, in: CGRect.init(x: x, y: y, width: image.size.width, height: image.size.height))
                if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                    result.append(newImage)
                }
                ctx.restoreGState()
            }
        }
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GameViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        pickerDone()
        picker.dismiss(animated: true, completion: nil)
    }
}
