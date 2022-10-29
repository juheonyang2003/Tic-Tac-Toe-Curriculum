//
//  Logic.swift
//  TTT
//
//  Created by Yang Juheon on 13/10/2021.
//

import Foundation

class Logic: ObservableObject {
    
    var grids: [Grid] = []
    let size: Int
    
    enum Turn {
        case O, X
        mutating func toggle() {
            if self == .O {
                self = .X
            } else {
                self = .O
            }
        }
    }
    
    @Published private var turn: Turn = .O
    
    init(size: Int) {
        grids = []
        self.size = size
        for y in 1...size{
            for x in 1...size{
                grids.append(Grid(coordinate: (x, size - y + 1)))
            }
        }
    }
    
    
    func touch(coordinate: String) {
        for i in 0...grids.count - 1 {
            if grids[i].id == coordinate {
                tabbed(i)
            }
        }
    }
    
    
    var turnAndWinner: String = "Turn: O"
    
    
    
    
    private func tabbed(_ tabbedIndex: Int) {
        let ChosenCoordinate = grids[tabbedIndex].coordinate
        print(ChosenCoordinate)
        
        if grids[tabbedIndex].state == nil{
            if turn == .X {
                grids[tabbedIndex].state = .X
            }   else{
                grids[tabbedIndex].state = .O
            }
            turn.toggle()
        }
        
        turnAndWinner = "Turn: \(turn)"
        
        /*
         Make logics here
         
         This function runs whenever the user tabs a grid.
         
         The array (list) of grids are in the variable called "grids," it contain 9 grids, and each grid is an instance of a struct called "Grid." What you need to know about "Grid" is that it has two properties that you want to use: "coordinate" and "state."
         
         Access each number in the coordinate like this: "coordinate.0" for x coordinate and "coordinate.1" for y coordinate.
         
         "state" is an instance of an enum with two cases: ".O" and ".X". At start, every grid's state is "nil," which means there is no value. Please use ".X,".O", and "nil" to complete the logic.
         
         the variable "turnAndWinner" is a string. It should display the turn when the game is playing (like this: "Turn: X"), and it should display the winner when there is one (like this: "Winner: X")
         
         Finally, use the variable "turn." "turn" is an instance of an enum with two cases ".X" and ".O," and it will be toggled every time before this function runs. Meaning it simulates how "X" player and "O" player take turn.
         */
        
        var straightLines: [[Grid]] = []
        var diagonalLines: [[Grid]] = [[],[]]
        for i in 1...size {
            straightLines.append(grids.filter{$0.coordinate.0 == i})
            straightLines.append(grids.filter{$0.coordinate.1 == i})
            
            diagonalLines[0].append(grids[grids.firstIndex{$0.coordinate.0 == i && $0.coordinate.1 == i}!])
            diagonalLines[1].append(grids[grids.firstIndex{$0.coordinate.0 == size + 1 - i && $0.coordinate.1 == i}!])
        }
        straightLines.append(contentsOf: diagonalLines)
        
        var allGridsAreTabbed = true
        for grid in grids {
            guard let _ = grid.state else {
                allGridsAreTabbed = false
                break
            }
        }
        if allGridsAreTabbed {
            turnAndWinner = "New Game"
        }
        
        func winner(straightLine: [Grid]) -> Turn?{
            var xCount = 0
            var oCount = 0
            for grid in straightLine {
                if grid.state == .O {
                    oCount += 1
                } else if grid.state == .X {
                    xCount += 1
                }
            }
            if xCount == size {
                return .X
            } else if oCount == size {
                return .O
            } else {
                return nil
            }
        }
        
        for straightLine in straightLines {
            if let winner = winner(straightLine: straightLine) {
                turnAndWinner = (winner == .X ? "Winner: X" : "Winner: O") + "\n New Game"
            }
        }
    }
    
    
    
    
    func retry() {
        for i in 0..<grids.count {
            grids[i].state = nil
        }
        turn = .O
        turnAndWinner = "Turn: O"
    }
}

struct Grid: Identifiable {
    
    let coordinate: (Int, Int)
    let id: String
    var state: State?
    
    init(coordinate: (Int, Int)) {
        self.coordinate = coordinate
        id = "\(coordinate.0)@\(coordinate.1)"
    }
    
    init(coordinate: (Int, Int), state: State) {
        self.init(coordinate: coordinate)
        self.state = state
    }
    
    enum State: String {
        case X, O
    }
}
