//
//  MainView.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI
import LinkPresentation

struct MainView: View {
    
    @State var showMenu = true
    @State var active = false
    @State var enable = false

    var body: some View {
        GeometryReader { proxy in
            
                ZStack{
                    Color("blue")
                        .ignoresSafeArea()
                    if(active)
                    {
                        VStack{
                            ScrollView(getRect().height < 750 ? .vertical : .init() ,showsIndicators: false){
                                SideMenu(proxy: proxy,isShow:$showMenu,enable: $enable)
                            }
                        }
                        .padding(.top,getRect().height < 750 ? 50 : 0)
                    }
                    ZStack{
                        Color.white
                            .opacity(0.5)
                            .cornerRadius(showMenu ? 15 : 0)
                            .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                            .offset(x:showMenu ? -25 : 0)
                            .padding(.vertical,30)
                        
                        Color.white
                            .opacity(0.5)
                            .cornerRadius(showMenu ? 15 : 0)
                            .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                            .offset(x:showMenu ? -50 : 0)
                            .padding(.vertical,60)
                        
                        Home(padding: proxy.safeAreaInsets.top,showMenu:$showMenu)
                            .cornerRadius(showMenu ? 15 : 0)
                    }
                    .onTapGesture {
                        self.enable = false
                        if(showMenu)
                        {
                            withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                                self.showMenu = false
                            }
                        }
                    }
                    .scaleEffect(showMenu ? 0.84 : 1)
                    .offset(x:showMenu ? getRect().width - 60 : 0,y: showMenu ? getRect().height*0.08 : 0)
                    .ignoresSafeArea()
                    VStack{
                        HStack{
                            ZStack{
                                VStack(spacing:5){
                                    Capsule()
                                        .fill(showMenu ? Color.white : Color("placeholder"))
                                        .frame(width: showMenu ? 20 : 10, height: showMenu ? 4 : 10)
                                        .rotationEffect(.init(degrees: -45))
                                        .offset(y: 0)
                                    Capsule()
                                        .fill(showMenu ? Color.white : Color("placeholder"))
                                        .frame(width: showMenu ? 20 : 10, height: showMenu ? 4 : 10)
                                        .rotationEffect(.init(degrees: 45))
                                        .offset(y: showMenu ? 0 : 0)
                                }
                                .offset(x: 15)
                                 VStack (spacing:5){
                                     Capsule()
                                         .fill(showMenu ? Color.white : Color("placeholder"))
                                         .frame(width: showMenu ? 20 : 10, height: showMenu ? 4 : 10)
                                         .rotationEffect(.init(degrees: 45))
                                         .offset(y: 0)
                                     Capsule()
                                         .fill(showMenu ? Color.white : Color("placeholder"))
                                         .frame(width: showMenu ? 20 : 10, height: showMenu ? 4 : 10)
                                         .rotationEffect(.init(degrees: -45))
                                         .offset(y: showMenu ? 0 : 0)
                                 }
                                 .offset(x: showMenu ? 5 : 0)
                            }
                            .frame(width: 40, height: 30,alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 0).fill(Color.red.opacity(0.0005)))
                            .padding(10)
                            .padding(.trailing)
                            .background(Color.white.opacity(showMenu ? 0 : 0.05))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                                    showMenu.toggle()
                                }
                            }
                            Spacer()
                            
                        }
                        .padding([.top],proxy.safeAreaInsets.top)

                        Spacer()
                    }
                    .ignoresSafeArea()
                }
            
        }
        .onTapGesture {
            if(self.enable == true)
            {
                self.enable = false
            }
        }
        .onAppear {
            //DispatchQueue.main.asyncAfter(deadline:.now()+0.2) {
                self.active = true
            //}
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
/**VStack (spacing:5){
 Capsule()
     .fill(showMenu ? Color.white : Color.primary)
     .frame(width: 30, height: 3)
     .rotationEffect(.init(degrees: showMenu ? -45 : 0))
     .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)
 VStack (spacing:5){
     Capsule()
         .fill(showMenu ? Color.white : Color.primary)
         .frame(width: 30, height: 3)
     Capsule()
         .fill(showMenu ? Color.white : Color.primary)
         .frame(width: 30, height: 3)
         .offset(y: showMenu ? -8 : 0)
 }
 .rotationEffect(.init(degrees: showMenu ? 45 : 0))
 
 ZStack{
     VStack(spacing:5){
         Capsule()
             .fill(showMenu ? Color.white : Color.red)
             .frame(width: showMenu ? 15 : 10, height: 10)
             .rotationEffect(.init(degrees: -45))
         Capsule()
             .fill(showMenu ? Color.white : Color.primary)
             .frame(width: showMenu ? 15 : 10, height: 10)
             .rotationEffect(.init(degrees: 45))
     }
     .offset(x: 15, y: 0)
      VStack (spacing:5){
          Capsule()
              .fill(showMenu ? Color.white : Color.red)
              .frame(width: showMenu ? 15 : 10, height: 10)
              .rotationEffect(.init(degrees: 45))
          Capsule()
              .fill(showMenu ? Color.white : Color.primary)
              .frame(width: showMenu ? 15 : 10, height: 10)
              .rotationEffect(.init(degrees: -45))
      }
 }
}*/
extension View{
    func getRect ()->CGRect{
        return UIScreen.main.bounds
    }
}
