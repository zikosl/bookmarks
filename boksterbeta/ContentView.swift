//
//  ContentView.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI

struct ContentView: View {
    @State var started = false
    var body: some View {
        ZStack{
            
                try! MainView()
                    .preferredColorScheme(.light)
                    .environmentObject(mycolors())
           
            if(!started){
                Splash()
            }
        }
        .onAppear {
            //let value = UserDefaults.standard.integer(forKey: "value_preference")
            
            DispatchQueue.main.asyncAfter(deadline: .now() +  1.4) {
                withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                    started = true
                }
            }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
