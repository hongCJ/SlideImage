//
//  Config.swift
//  SlideImage
//
//  Created by 郑红 on 2018/10/23.
//  Copyright © 2018 ZhengHong. All rights reserved.
//

import UIKit

class Config: NSObject {
    static let shared = Config()
    
    var row = 3
    var column = 3
    
    var margin: CGFloat = 5.0
    
}
