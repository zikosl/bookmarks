//
//  Home.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI

struct Home: View {
    
    var padding : CGFloat = 0;
    @Binding var showMenu:Bool
    init(padding:CGFloat,showMenu:Binding<Bool>){
        self.padding = padding
        self._showMenu = showMenu
    }
    var body: some View {
        VStack{
            HomePage(padding:padding,showMenu:$showMenu)
        }.background(Color.white.ignoresSafeArea(.all))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct History: View {
    
    var body: some View {
        
        NavigationView{
            
            Text("History")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("History")
        }
    }
}

struct Notifications: View {
    
    var body: some View {
        
        NavigationView{
            
            Text("Notifications")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Notifications")
        }
    }
}
struct Settings: View {
    
    var body: some View {
        
        NavigationView{
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Settings")
        }
    }
}

struct Help: View {
    
    var body: some View {
        
        NavigationView{
            
            Text("Help")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Help")
        }
    }
}
