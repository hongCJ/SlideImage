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
    var game: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as! SKView? {
            game = GameScene.init(size: view.bounds.size)
            game.gameDelegate = self
            skView.presentScene(game)
            skView.ignoresSiblingOrder = true
            
            skView.showsFPS = true
            skView.showsNodeCount = true
        } 
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        game.size = CGSize.init(width: view.bounds.width, height: view.bounds.height - 64)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let img = Config.shared.image, Config.shared.refresh == true {
            let images = img.cropTo(row: Config.shared.row, column: Config.shared.column)
            game.reload(data: images.reversed())
            Config.shared.refresh = false
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GameViewController: GameProtocol {
    func GameWin() {
        let alertVc = UIAlertController.init(title: "Congratulation", message: "YOU WIN", preferredStyle: .alert)
        let OKAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
//            self.dismiss(animated: true, completion: nil)
        }
        alertVc.addAction(OKAction)
        present(alertVc, animated: true, completion: nil)
    }
}


