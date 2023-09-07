//
//  TabButton.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI

struct TabButton: View {
    var id:Int = -3
    var image:String?
    var title: String
    var badge : Int = 5
    var badged : Bool = true
    var imaged : Bool = true
    var add : Bool = false
    var color : String = "add"
    @EnvironmentObject var items : mycolors
    var animation:Namespace.ID
    
    var enable:Bool = false
    var valueID:Int = -1
    var functions:()->() = {}
    var doubleTap:()->() = {}
    

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                if(id != -3){
                    items.selected = id
                }
            }
            self.functions()
            if(self.enable){
                self.doubleTap()
            }
        }, label: {
            VStack{
                HStack(spacing:10){
                    if(imaged)
                    {
                        ZStack{
                            if(add)
                            {
                                Image(systemName: "plus")
                                    .font(.system(size: 14))
                            }
                            else
                            {
                                ZStack{
                                    Image("iconapp")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(items.selected == id ? .white  : Color(color))
                                }
                            }
                        }
                        .frame(width: 35, height: 35)
                        .background(items.selected == id ? Color(color) : .white.opacity(0))
                        .cornerRadius(8)
                    }
                    else{
                        Image(systemName: image!)
                            .font(.system(size: 16))
                            .foregroundColor(items.selected == id ? Color("secondary") : .white )
                    }
                    Text(title)
                        .font(.custom("Poppins-Medium",size: 14))
                        .fontWeight(.regular)
                        .foregroundColor(items.selected == id ? Color("dark") : .white)
                    Spacer()
                    if(badged)
                    {
                        if(enable)
                        {
                            Button(action: {
                                items.RemoveCategorie(id: valueID)
                                if(items.selected == id){
                                    items.selected = -2
                                }
                            }, label: {
                                Text(String("delete"))
                                    .font(.custom("Poppins-Regular",size: 11))
                                    .foregroundColor(.white)
                                    .padding([.horizontal],5)
                                    .padding([.vertical],5)
                                    .background(Color("color0"))
                                    .cornerRadius(5)
                                    .frame(width:45)
                            })
                        }
                        else{
                            Text(String(badge))
                                .font(.custom("Poppins-SemiBold",size: 14))
                                .foregroundColor(.white)
                                .padding([.horizontal],5)
                                .padding([.vertical],5)
                                .background(items.selected == id ? Color(color) : Color.white.opacity(0))
                                .cornerRadius(5)
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.vertical,add ? 0 : 10)
                .padding(.horizontal,15)
                .frame(height:60)
                .frame(maxWidth:getRect().width - 90,alignment: .leading)
                .background(
                    ZStack{
                        if items.selected == id
                        {
                            Color(.white)
                                .opacity(items.selected == id ? 1 : 0)
                                .clipShape(CustomCorners(corners: [.allCorners], radius: 12))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                        else if(id>0)
                        {
                            Color(.white)
                                .opacity(0)
                                .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                .padding(1)
                                                    }
                    }
                )
                .padding(.vertical,add ? 0 : 5)
            }
        })
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
