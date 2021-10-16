//
//  EditableTheme.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 9/4/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI

struct EditableTheme: View {
    @ObservedObject var theme: Theme
    @EnvironmentObject var store: EmojiMemoryGameStore
    @State private var showThemeEditor = false
    var isEditing: Bool

    var body: some View {
        HStack {
            if isEditing {
                Image(systemName: "pencil.circle.fill").imageScale(.large)
                    .foregroundColor(Color(theme.color))
                    .onTapGesture { self.showThemeEditor = true }
                    .sheet(isPresented: $showThemeEditor) {
                        ThemeEditor(theme: self.theme, isShowing: self.$showThemeEditor)
                            .environmentObject(self.store)
                            .frame(minWidth: 300, minHeight: 500)
                    }
            }
            VStack(alignment: .leading) {
                Text(theme.name).font(.title)
                    .foregroundColor(isEditing ? .accentColor : Color(theme.color))
                Text(subtext).font(.callout).lineLimit(1)
            }
        }
    }
    
    private var textsView: some View {
        VStack(alignment: .leading) {
            Text(theme.name).font(.title)
                .foregroundColor(Color(theme.color))
            Text(subtext).font(.callout).lineLimit(1)
        }
    }
    
    private var subtext: String {
        "\(isAllEmojis ? "All" : "\(theme.numberOfPairsOfCards)") of " + theme.emojis.joined()
    }
    
    private var isAllEmojis: Bool {
        return theme.emojis.count == theme.numberOfPairsOfCards
    }
}

struct ThemeEditor: View {
    @ObservedObject var theme: Theme
    @EnvironmentObject var store: EmojiMemoryGameStore
    @Binding var isShowing: Bool
    @State private var emojisToAdd: String = ""
    @State private var themeName: String
    @State private var numOfEmojis: Int
    
    init(theme: Theme, isShowing: Binding<Bool>) {
        self.theme = theme
        self._isShowing = isShowing
        self._themeName = State(initialValue: theme.name)
        self._numOfEmojis = State(initialValue: theme.numberOfPairsOfCards)
    }
    
    private var uiColors: [UIColor] = [
        .black, .systemRed, .systemBlue, .systemGreen, .systemOrange, .white, .systemPurple, .systemYellow, .systemGray, .systemPink, .systemIndigo, .systemTeal
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Theme Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(
                        action: {
                            self.isShowing = false
                            self.store.reset(theme: self.theme)
                    },
                        label: { Text("Done") }
                    ).padding()
                }
            }
            Divider()
            Form {
                Section() {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            self.theme.name = self.themeName
                        }
                    })
                }
                Section(header: Text("Add Emoji").font(.subheadline).bold()) {
                    ZStack {
                        TextField("Emoji", text: $emojisToAdd, onEditingChanged: { began in
                            if !began {
                                self.theme.add(emojis: self.emojisToAdd)
                                self.emojisToAdd = ""
                            }
                        })
                        HStack {
                            Spacer()
                            Button(
                                action: {
                                    self.theme.add(emojis: self.emojisToAdd)
                                    self.emojisToAdd = ""
                            }, label: { Text("Add") }
                            )
                        }
                    }
                }
                Section(header: HStack {
                    Text("Emojis").font(.subheadline).bold()
                    Spacer()
                    Text("tap emoiji to remove").font(.caption)
                }) {
                    Grid(theme.emojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.theme.remove(emoji: emoji)
                            }
                    }
                        .frame(height: self.height(theme.emojis.count))
                }
                Section(header: Text("Card Count")) {
                    Stepper(
                        "\(numOfEmojis) Pairs",
                        value: $numOfEmojis,
                        in: 2...max(2, theme.emojis.count),
                        onEditingChanged: { _ in self.theme.numberOfPairsOfCards = self.numOfEmojis }
                    )
                }
                Section(header: Text("Color")) {
                    Grid(uiColors, id: \.self) { color in
                        Image(systemName: self.colorImageName(color))
                            .font(.system(size: self.colorRectangleFontSize))
                            .foregroundColor(color == .white ? .gray : Color(color))
                            .onTapGesture {
                                self.theme.color = color
                            }
                    }
                    .frame(height: self.height(uiColors.count))
                }
            }
        }
    }
    
    private func colorImageName(_ color: UIColor) -> String {
        var imageName = ""
        if color == theme.color {
            imageName += "checkmark."
        }
        imageName += "rectangle"
        if color != .white {
            imageName += ".fill"
        }
        return imageName
    }

    // MARK: Drawing Constants
    private func height(_ itemCount: Int) -> CGFloat {
        CGFloat((itemCount - 1) / 6) * 70 + 70
    }

    let fontSize: CGFloat = 40
    let colorRectangleFontSize: CGFloat = 35
    let colorSquareLength: CGFloat = 20
}
