//
//  GameViewController.swift
//  SlideImage
//
//  Created by 郑红 on 2018/10/22.
//  Copyright © 2018 ZhengHong. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {

    var image: UIImage?
    var imagePicker: UIImagePickerController!
    
    var game: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as! SKView? {
            game = GameScene.init(size: view.bounds.size)
            skView.presentScene(game)
            skView.ignoresSiblingOrder = true
            
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
        
        imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

    }
    
    @IBAction func choosePic(_ sender: Any) {
        navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
   
    
    func pickerDone() {
        guard let img = image else {
            return
        }
        let images = img.cropTo(row: Config.shared.row, column: Config.shared.column)
        game.reload(data: images.reversed())
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
