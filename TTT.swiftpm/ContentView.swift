//
//  ContentView.swift
//  Shared
//
//  Created by Yang Juheon on 13/10/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var logic = Logic(size: 4)
    var grids: [Grid] {return logic.grids}
    
    func myGrid(minimum: CGFloat) -> GridItem{
        var gridItem = GridItem(.adaptive(minimum: minimum, maximum: minimum))
        gridItem.spacing = 0
        return gridItem
    }
    
    var body: some View {
        
        
        VStack {
            if #available(iOS 15.0, *), #available(macOS 12.0, *) {
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.white)
                    .overlay {
                        GeometryReader {geometry in
                            let gridSideLength = geometry.size.height/(CGFloat(logic.size) + 0.1)
                            
                            LazyVGrid(columns: [myGrid(minimum: gridSideLength)], spacing: 0) {
                                ForEach(grids){grid in
                                    ZStack {
                                        Rectangle().padding(gridSideLength * 0.05).foregroundColor(.orange).aspectRatio(1, contentMode: .fit)
                                        if let state = grid.state {
                                            Text(state.rawValue).font(Font.system(size: gridSideLength * 0.8))
                                        }
                                    }
                                    .onTapGesture {
                                        logic.touch(coordinate: grid.id)
                                    }
                                }
                            }
                        }
                    }
            } else {
                Text("Update your device")
            }
            
            Spacer()
            
            Text(logic.turnAndWinner)
                .font(Font.system(size: 50)).onTapGesture {
                    logic.retry()
                }
        }
    }
}
