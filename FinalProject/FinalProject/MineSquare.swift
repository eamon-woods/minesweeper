//
//  MineSquare.swift
//  FinalProject
//
//  Created by Eamon Woods on 4/30/17.
//  Copyright © 2017 org.cuappdev. All rights reserved.
//

import UIKit

protocol MineSquareCollectionViewCellDelegate {
    func mineSquareWasLongPressed(indexPath: IndexPath, isFlagShowing: Bool)
}

class MineSquare: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var infoImageView: UIImageView!
    var flagImageView: UIImageView!
    var isMine: Bool?
    var numberAdjacentMines: Int?
    var isUncovered: Bool!
    var longPressRecognizer: UILongPressGestureRecognizer!
    var delegate: MineSquareCollectionViewCellDelegate?
    var flagShowing: Bool!
    
    override var description: String {
        if let numMines = numberAdjacentMines {
            return numMines.description
        }
        return ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        isUncovered = false
        
        infoImageView = UIImageView()
        flagImageView = UIImageView()
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(wasLongPressed))
        longPressRecognizer.delegate = self
    }
    
    func wasLongPressed() {
        if let theView = delegate as? ViewController {
            if let board = theView.board {
                if let path = board.indexPath(for: self) {
                    delegate?.mineSquareWasLongPressed(indexPath: path, isFlagShowing: flagShowing)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        infoImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        flagImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.contentView.addGestureRecognizer(longPressRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
