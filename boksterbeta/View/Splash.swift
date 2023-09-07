//
//  Splash.swift
//  bokster
//
//  Created by ziko on 15/3/2022.
//

import SwiftUI

struct Splash: View {
    @State var fade = true
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                Spacer()
                Image("iconapp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150 , height: 150)
                Text("Bokster")
                    .font(.custom("Poppins-Bold", size: 30))
                    .foregroundColor(.white)
                Spacer()
            }
            .opacity(fade ? 1 : 0)
        }
        .onAppear {
            /*withAnimation(.easeInOut(duration: 0.7)){
                fade = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                withAnimation(.easeInOut(duration: 0.7)){
                    fade = false
                }
            }*/
        }
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
