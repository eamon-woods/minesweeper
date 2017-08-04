//
//  ViewController.swift
//  FinalProject
//
//  Created by Eamon Woods on 4/30/17.
//  Copyright © 2017 org.cuappdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BelowBoardCollectionViewCellDelegate, WelcomeViewControllerDelegate, MineSquareCollectionViewCellDelegate {
    
    var numOnLevel: Int!
    var levels: Int!
    var pictures: [UIImage]!
    var board: UICollectionView!
    var underlyingBoard: [[Int]] = [[Int]]()
    var visited: [Int] = []
    let separator: CGFloat = 2.0
    
    var isGameOver: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictures = [#imageLiteral(resourceName: "bomb"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "8")]
        
        isGameOver = false

        board = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        board.register(MineSquare.self, forCellWithReuseIdentifier: "Reuse")
        board.register(BelowBoardCollectionViewCell.self, forCellWithReuseIdentifier: "Reuse1")
        board.dataSource = self
        board.delegate = self
        board.backgroundColor = .clear
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blue]
        title = "Minesweeper"
        
        view.addSubview(board)
        
        makeUnderlyingBoard()
    }
    
    func welcomeViewControllerPlayGameButtonWasTapped(rows: Int, cols: Int) {
        numOnLevel = cols
        levels = rows
    }
    
    func belowBoardNewGameButtonWasTapped() {
        navigationController?.popViewController(animated: true)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if !isGameOver {
            if let cell = board.cellForItem(at: indexPath) as? MineSquare {
                if let isMine = cell.isMine {
            
                    if isMine {
                    //if it's a mine, show all mines and print game over and lock board
                        isGameOver = true
                        cell.contentView.addSubview(cell.infoImageView)
                        for cell2 in board.visibleCells {
                            if let square = cell2 as? MineSquare {
                                if let isMine2 = square.isMine {
                                    if isMine2 && square != cell {
                                        square.contentView.addSubview(square.infoImageView)
                                    }
                                }
                            } else {
                                if let below = cell2 as? BelowBoardCollectionViewCell {
                                    below.contentView.addSubview(below.over)
                                }
                            }
                        }
                    } else {
                    //if it's not a mine, uncover all appropriate squares
                        visited = []
                        dfs(index: indexPath.row)
                        if (didYouWin(cells: board.visibleCells)) {
                            isGameOver = true
                            if let below = board.cellForItem(at: IndexPath(row: 0, section: 1)) as? BelowBoardCollectionViewCell {
                                below.contentView.addSubview(below.win)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func didYouWin(cells: [UICollectionViewCell]) -> Bool {
        for cell in cells {
            if let mineSquare = cell as? MineSquare {
                if let isItMine = mineSquare.isMine {
                    if (!isItMine) && (!mineSquare.isUncovered) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func dfs(index: Int) {
        if let cell = board.cellForItem(at: IndexPath(row: index, section: 0)) as? MineSquare {
            if let numMines = cell.numberAdjacentMines {
                // Now, whether cell has surrounding mines or not, consider cell uncovered.
                cell.isUncovered = true
                if numMines != 0 {
                    cell.contentView.addSubview(cell.infoImageView)
                    return
                }
                if visited.contains(index) {
                    //we've already protected this square by calling dfs on surrounding squares
                    return
                }
                visited.append(index)
                if index % numOnLevel == 0 {
                //leftmost column of board
                    if index == 0 {
                        dfs(index: index + 1)
                        dfs(index: index + numOnLevel)
                        dfs(index: index + numOnLevel + 1)
                    } else if index == numOnLevel * (levels - 1) {
                        dfs(index: index + 1)
                        dfs(index: index - numOnLevel)
                        dfs(index: index - numOnLevel + 1)
                    } else {
                        dfs(index: index - numOnLevel)
                        dfs(index: index - numOnLevel + 1)
                        dfs(index: index + 1)
                        dfs(index: index + numOnLevel)
                        dfs(index: index + numOnLevel + 1)
                    }
                } else if (index + 1) % numOnLevel == 0 {
                //rightmost column of board
                    if index == numOnLevel - 1 {
                        dfs(index: index - 1)
                        dfs(index: index + numOnLevel)
                        dfs(index: index + numOnLevel - 1)
                    } else if index == numOnLevel * levels - 1 {
                        dfs(index: index - 1)
                        dfs(index: index - numOnLevel)
                        dfs(index: index - numOnLevel - 1)
                    } else {
                        dfs(index: index - numOnLevel)
                        dfs(index: index - numOnLevel - 1)
                        dfs(index: index - 1)
                        dfs(index: index + numOnLevel)
                        dfs(index: index + numOnLevel - 1)
                    }
                } else if index < numOnLevel {
                //top row of board
                    dfs(index: index - 1)
                    dfs(index: index + numOnLevel - 1)
                    dfs(index: index + numOnLevel)
                    dfs(index: index + numOnLevel + 1)
                    dfs(index: index + 1)
                } else if index >= numOnLevel * (levels - 1) {
                //bottom row of board
                    dfs(index: index - 1)
                    dfs(index: index - numOnLevel - 1)
                    dfs(index: index - numOnLevel)
                    dfs(index: index - numOnLevel + 1)
                    dfs(index: index + 1)
                } else {
                //somewhere in middle of board
                    dfs(index: index - numOnLevel)
                    dfs(index: index - numOnLevel + 1)
                    dfs(index: index + 1)
                    dfs(index: index + numOnLevel + 1)
                    dfs(index: index + numOnLevel)
                    dfs(index: index + numOnLevel - 1)
                    dfs(index: index - 1)
                    dfs(index: index - numOnLevel - 1)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return levels * numOnLevel
        } else {
            return 1
        }
    }
    
    func makeUnderlyingBoard() {
        underlyingBoard = Array(repeating: Array(repeating: 0, count: numOnLevel), count: levels)
        for i in 0..<levels {
            for j in 0..<numOnLevel {
                let random: UInt32 = arc4random_uniform(100)
                if random <= UInt32(15) { // this is where you change the percentage of mines placed
                    underlyingBoard[i][j] = 1
                }
            }
        }
    }
    
    func mineSquareWasLongPressed(indexPath: IndexPath, isFlagShowing: Bool) {
        if !isGameOver {
            if let cell = board.cellForItem(at: indexPath) as? MineSquare {
                if cell.longPressRecognizer.state == UIGestureRecognizerState.began {
                    if isFlagShowing {
                        cell.flagImageView.removeFromSuperview()
                        cell.flagShowing = false
                        return
                    }
                    cell.flagImageView.image = #imageLiteral(resourceName: "flag")
                    cell.contentView.addSubview(cell.flagImageView)
                    cell.flagShowing = true
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            if let cell = board.dequeueReusableCell(withReuseIdentifier: "Reuse", for: indexPath) as? MineSquare {
                let row: Int = indexPath.row / numOnLevel
                let col: Int = indexPath.row - row * numOnLevel
                if underlyingBoard[row][col] == 1 {
                    cell.isMine = true
                    cell.infoImageView.image = pictures[0]
                } else {
                    cell.isMine = false
                    let numMines: Int = numSurroundingMines(array2d: underlyingBoard, row: row, col: col)
                    cell.numberAdjacentMines = numMines //this is used in dfs()
                    if numMines != 0 {
                        cell.infoImageView.image = pictures[numMines]
                    }
                }
                cell.delegate = self
                cell.flagShowing = false
                return cell
            }
        } else {
            if let cell = board.dequeueReusableCell(withReuseIdentifier: "Reuse1", for: indexPath) as? BelowBoardCollectionViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func numSurroundingMines(array2d: [[Int]], row: Int, col: Int) -> Int {
        var numMines: Int = 0
        //one row down
        if row - 1 >= 0 {
            numMines = array2d[row-1][col]
            if col - 1 >= 0 {
                numMines = numMines + array2d[row-1][col-1]
            }
            if col + 1 < array2d[row-1].count {
                numMines = numMines + array2d[row-1][col+1]
            }
        }
        //row index is obviously legal
        if col - 1 >= 0 {
            numMines = numMines + array2d[row][col-1]
        }
        if col + 1 < array2d[row].count {
            numMines = numMines + array2d[row][col+1]
        }
        //one row up
        if row + 1 < array2d.count {
            numMines = numMines + array2d[row+1][col]
            if col - 1 >= 0 {
                numMines = numMines + array2d[row+1][col-1]
            }
            if col + 1 < array2d[row+1].count {
                numMines = numMines + array2d[row+1][col+1]
            }
        }
        return numMines
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = CGFloat(numOnLevel - 1) * separator
        let width = (view.frame.width - space) / CGFloat(numOnLevel)
        if indexPath.section == 0 {
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.height - (separator * CGFloat(levels + 1) + width * CGFloat(levels)))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return separator
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: separator, left: 0, bottom: separator, right: 0)
        }
        return UIEdgeInsets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        board.reloadData()
    }
}

