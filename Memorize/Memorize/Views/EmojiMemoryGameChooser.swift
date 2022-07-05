//
//  EmojiMemoryGameChooser.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 9/3/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI

struct EmojiGameMemoryGameChooser: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.emojiMemoryGames) { emojiMemoryGame in
                    NavigationLink(destination: EmojiMemoryGameView(emojiMemoryGame: emojiMemoryGame)
                        .navigationBarTitle(emojiMemoryGame.themeName)
                        .navigationBarItems(trailing: Button(action: {
                            withAnimation(.easeInOut) {
                                emojiMemoryGame.resetGame()
                            }
                        }, label:  { Text("New Game") } ))
                    ) {
                        EditableTheme(theme: emojiMemoryGame.theme, isEditing: self.editMode.isEditing)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        self.store.remove(at: index)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(self.store.name)
            .navigationBarItems(
                leading: Button(
                    action: { self.store.add() },
                    label: { Image(systemName: "plus").imageScale(.large) }
                ),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
