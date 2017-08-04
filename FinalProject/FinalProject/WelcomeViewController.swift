//
//  WelcomeViewController.swift
//  FinalProject
//
//  Created by Eamon Woods on 5/8/17.
//  Copyright © 2017 org.cuappdev. All rights reserved.
//

import UIKit

protocol WelcomeViewControllerDelegate {
    func welcomeViewControllerPlayGameButtonWasTapped(rows: Int, cols: Int)
}

class WelcomeViewController: UIViewController {

    var infoLabel: UILabel!
    var playButton: UIButton!
    var numRowsTextField: UITextField!
    var numRowsLabel: UILabel!
    var numColsTextField: UITextField!
    var numColsLabel: UILabel!
    var delegate: WelcomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        playButton.backgroundColor = .blue
        playButton.setTitle("Play", for: .normal)
        playButton.layer.cornerRadius = 5
        playButton.center = view.center
        playButton.addTarget(self, action: #selector(playGameButtonWasTapped), for: UIControlEvents.touchUpInside)
        
        title = "Welcome"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blue]
        
        numRowsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        numRowsLabel.text = "Number of rows:"
        numRowsLabel.center.x = view.center.x - 100
        numRowsLabel.center.y = view.center.y - 100
        numRowsTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        numRowsTextField.borderStyle = UITextBorderStyle.roundedRect
        numRowsTextField.center.x = numRowsLabel.center.x + 130
        numRowsTextField.center.y = numRowsLabel.center.y
        
        numColsLabel = UILabel(frame: CGRect(x: numRowsLabel.frame.origin.x, y: numRowsLabel.frame.origin.y + 40, width: 170, height: 40))
        numColsLabel.text = "Number of columns:"
        numColsTextField = UITextField(frame: CGRect(x: numRowsTextField.frame.origin.x, y: numRowsTextField.frame.origin.y + 40, width: 50, height: 30))
        numColsTextField.borderStyle = UITextBorderStyle.roundedRect
        
        infoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        infoLabel.center.x = view.center.x
        infoLabel.center.y = view.center.y - 200
        infoLabel.text = "Please keep the numbers positive and less than 20, and the number of rows less than or equal to the number of columns."
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.numberOfLines = 4
        
        view.addSubview(infoLabel)
        view.addSubview(playButton)
        view.addSubview(numRowsLabel)
        view.addSubview(numRowsTextField)
        view.addSubview(numColsLabel)
        view.addSubview(numColsTextField)
    }
    
    func playGameButtonWasTapped() {
        let viewController = ViewController()
        delegate = viewController
        if let rows = numRowsTextField.text {
            if let cols = numColsTextField.text {
                if let numRows = Int(rows) {
                    if let numCols = Int(cols) {
                        if numRows > 0 && numCols > 0 && numRows <= 20 && numCols <= 20 && numRows <= numCols {
                            delegate?.welcomeViewControllerPlayGameButtonWasTapped(rows: numRows, cols: numCols)
                            navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
            }
        }
    }
}
