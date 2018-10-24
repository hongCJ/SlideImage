//
//  GameView.swift
//  SlideImage
//
//  Created by 郑红 on 2018/10/23.
//  Copyright © 2018 ZhengHong. All rights reserved.
//

import UIKit
import SpriteKit

struct Point: CustomStringConvertible {
    var row: Int
    var column: Int
    
    func distance(toAnother point: Point) -> Int {
        let x = (row - point.row) * (row - point.row)
        let y = (column - point.column) * (column - point.column)
        return x + y
    }
    
    var description: String {
        return "row: \(row), column: \(column)"
    }
}

struct Node {
    var point: Point
    var node: SKNode
    var index: Int
    
    mutating func setPoint(newPoint: Point) {
        point = newPoint
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        return "index: \(index),point: \(point)"
    }
}

protocol GameProtocol: NSObjectProtocol {
    func GameWin() -> Void
}


class GameScene: SKScene {
    weak var gameDelegate: GameProtocol?
    
    var nodes: [Node] = []
    var emptyNode: Node? {
        return nodes.filter({
            $0.index == Config.shared.row * Config.shared.column - 1
        }).first
    }
    
    var playing = false
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor.white
        scaleMode = .aspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func successCheck() -> Bool{
        for (index, value) in nodes.enumerated() {
            if index != value.index {
                return false
            }
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard playing else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        var touchNode: Node?
        for n in nodes {
            if n.node.frame.contains(location) {
                touchNode = n
                break
            }
        }
        guard let t = touchNode, let empty = emptyNode else {
            return
        }
        
        if t.point.distance(toAnother: empty.point) != 1 {
            return
        }
        changeNodePosition(one: t.node, to: empty.node)
        
        let indexT = t.point.row * Config.shared.column + t.point.column
        let indexE = empty.point.row * Config.shared.column + empty.point.column
        
        exchangeNode(at: indexT, to: indexE)
        if successCheck() {
            gameDelegate?.GameWin()
        }
        
    }
    
    //MARK: - 改变位置
    private func changeNodePosition(one: SKNode, to another: SKNode) {
        let moveActiona = SKAction.move(to: another.position, duration: 0.2)
        let moveActionb = SKAction.move(to: one.position, duration: 0.2)
        one.run(moveActiona) {
            
        }
        another.run(moveActionb) {
            
        }
    }
    
    func exchangeNode(at one: Int, to another: Int) {
        var nodeOne = nodes[one]
        var nodeAno = nodes[another]
        let pointOne = nodeOne.point
        let pointAno = nodeAno.point
        nodeOne.point = pointAno
        nodeAno.point = pointOne
        nodes[one] = nodeAno
        nodes[another] = nodeOne
    }
    //MARK: - clear
    func clear() {
        removeAllChildren()
        nodes.removeAll()
    }
    //MARK: - 加载数据
    func reload(data: [[UIImage]]) {
        clear()
        let margin = Config.shared.margin
        let row = Config.shared.row
        let column = Config.shared.column

        let width = (size.width - margin * CGFloat(column + 2) ) / CGFloat(column)
        let height = (size.height - margin * CGFloat(row + 2)) / CGFloat(row)
        
        for r in 0..<row {
            for c in 0..<column {
                let x = margin + (width + margin) * CGFloat(c) + width / 2.0
                let y = margin + (height + margin) * CGFloat(r) + height / 2.0
                var node: SKNode!
                if r == row - 1 && c == column - 1 {
                    node = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: width, height: height))
                } else {
                    let image = data[r][c]
                    let texture = SKTexture.init(image: image)
                    node = SKSpriteNode.init(texture: texture, size: CGSize.init(width: width, height: height))
                }
                node.position = convertPoint(toLocal: CGPoint.init(x: x, y: y))
                addChild(node)
                let value = Node.init(point: Point.init(row: r, column: c), node: node, index: r * column + c)
                nodes.append(value)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.beginGame()
        }
    }
    
    func beginGame() {
        let count = nodes.count
        let random1 = Int(arc4random_uniform(UInt32(count)))
        let random2 = Int(arc4random_uniform(UInt32(count)))
        exchangeNode(at: random1, to: random2)
        changeNodePosition(one: nodes[random1].node, to: nodes[random2].node)
        playing = true
    }
    
    //MARK: - 坐标转换
    func convertPoint(toLocal point: CGPoint) -> CGPoint {
        return CGPoint.init(x: point.x, y: size.height -  point.y)
    }
}




