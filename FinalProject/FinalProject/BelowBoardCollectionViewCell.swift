//
//  BelowBoardCollectionViewCell.swift
//  FinalProject
//
//  Created by Eamon Woods on 5/5/17.
//  Copyright © 2017 org.cuappdev. All rights reserved.
//

import UIKit

protocol BelowBoardCollectionViewCellDelegate {
    func belowBoardNewGameButtonWasTapped()
}

class BelowBoardCollectionViewCell: UICollectionViewCell {
    var over: UILabel!
    var newGame: UIButton!
    var win: UILabel!
    
    var delegate: BelowBoardCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        over = UILabel()
        over.text = "GAME OVER"
        over.font = UIFont(descriptor: over.font.fontDescriptor, size: 30)
        over.textColor = .red
        over.textAlignment = NSTextAlignment.center
        
        newGame = UIButton()
        newGame.backgroundColor = .orange
        newGame.setTitle("New Game", for: .normal)
        newGame.layer.cornerRadius = 5
        newGame.addTarget(self, action: #selector(newGameButtonWasTapped), for: .touchUpInside)
        
        win = UILabel()
        win.text = "YOU WIN"
        win.font = UIFont(descriptor: win.font.fontDescriptor, size: 30)
        win.textColor = .blue
        win.textAlignment = NSTextAlignment.center
        
        contentView.addSubview(newGame)
    }
    
    
    func newGameButtonWasTapped() {
        delegate?.belowBoardNewGameButtonWasTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        over.frame = CGRect(x: 0, y: 0, width: frame.width / 2.0, height: 60)
        over.center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        
        newGame.frame = CGRect(x: 0, y: 0, width: frame.width / 4.0, height: 30)
        newGame.center.x = over.center.x
        newGame.center.y = over.center.y - 60
        
        win.frame = CGRect(x: 0, y: 0, width: frame.width / 2.0, height: 60)
        win.center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)

    }
}
