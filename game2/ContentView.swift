//
//  ContentView.swift
//  game2
//
//  Created by Riley Shinnick on 4/19/24.
//

import SwiftUI
import SpriteKit
import CoreMotion

struct ContentView: View {
    
    @State var game = Game(size: UIScreen.main.bounds.size)
    
    
    var body: some View {
        SpriteView(scene: game)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .statusBarHidden(true)
    }
}

#Preview {
    ContentView()
}

