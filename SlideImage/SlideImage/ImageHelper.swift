//
//  ImageHelper.swift
//  SlideImage
//
//  Created by 郑红 on 2018/10/23.
//  Copyright © 2018 ZhengHong. All rights reserved.
//

import UIKit

extension UIImage {
    func cropTo(row: Int, column: Int) -> [[UIImage]] {
        var result: [[UIImage]] = []
        let width = size.width / CGFloat(column)
        let height = size.height / CGFloat(row)
        
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
        
        guard let cgImage = cgImage else {
            return result
        }
        
        for r in 0..<row {
            var temp = [UIImage]()
            for c in 0..<column {
                ctx.saveGState()
                let x = CGFloat(-c) * width
                let y = CGFloat(-r) * height
                ctx.draw(cgImage, in: CGRect.init(x: x, y: y, width: size.width, height: size.height))
                if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                    temp.append(newImage)
                }
                ctx.restoreGState()
            }
            result.append(temp)
        }
        return result
    }
}
