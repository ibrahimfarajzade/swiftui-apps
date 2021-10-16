//
//  SetGameView.swift
//  SetGame
//
//  Created by Ibrahim Farajzade on 7/12/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel = SetGameViewModel()
    
    var body: some View {
        VStack {
            Text("Set")
                .font(.largeTitle)
                .layoutPriority(1)
            Spacer()
            HStack {
                Text("Score:")
                Text("\(viewModel.score)")
            }
            .padding(.horizontal, 20)
            
            GeometryReader { geometry in
                Grid(self.viewModel.cards) { card in
                    CardView(card: card)
                        .zIndex(card.isSelected ? 2 : 1)
                        .padding(max(0, CGFloat(-self.viewModel.cards.count)))
                        .onTapGesture {
                            withAnimation {
                                self.viewModel.choose(card)
                            }
                        }
                    .transition(AnyTransition.offset(self.randomLocationGenerator(onCanvas: geometry.size)))
                    .animation(.easeInOut(duration: 0.5))
                }
                .onAppear {
                    withAnimation(.easeOut) {
                        self.newGame()
                    }
                }
            }
            
            HStack {
                Button(action: newGame) {
                    Text("New Game")
                        .padding()
                }
                
                Spacer()
                Button(action: dealMoreCards) {
                    Text("Deal Cards")
                        .padding()
                }
                .disabled(viewModel.cardsRemaining == 0)
            }
        }
    }
    
    func randomLocationGenerator(onCanvas size: CGSize) -> CGSize{
        let widthRangeArr = [-Int(size.width*1.5) ..< -Int(size.width*1.25), Int(size.width*1.25) ..< Int(size.width*1.5)]
        let heightRangeArr = [-Int(size.height*1.5) ..< -Int(size.height*1.25), Int(size.height*1.25) ..< Int(size.height*1.5)]
        var rangeChooser:Int {
            get {
                Int.random(in: 0...1)
            }
        }
        return CGSize(width: Int.random(in: widthRangeArr[rangeChooser]), height: Int.random(in: heightRangeArr[rangeChooser]))
    }
    
    func dealMoreCards() {
        withAnimation {
            self.viewModel.drawCard(3)
        }
    }
    
    func newGame() {
        withAnimation(.easeOut) {
            self.viewModel.newGame()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
