//
//  CatItem.swift
//  Bookmarks
//
//  Created by ziko on 13/3/2022.
//

import SwiftUI

struct CatItem: View {
    var title = "Title"
    var color = "color0"
    var selected = true
    var id = 0
    var body: some View {
        HStack{
            
            HStack{
                ZStack{
                    Image(systemName: "flame.fill")
                        .font(.system(size: 21))
                        .foregroundColor(self.selected ? .white  : Color(color))
                    Image(systemName: "flame")
                        .font(.system(size: 21))
                        .foregroundColor(self.selected ? .white  : Color(color))
                }
                .frame(width: 34, height: 34, alignment: .center)
                .background(self.selected ? Color(color)  : Color("light"))
                .cornerRadius(8)
                .padding(.trailing,21)
                Text(title)
                    .foregroundColor(self.selected ? .white  : Color(color))
                    .font(.custom("Poppins-Medium",size: 14))
                    .kerning(0.7)
                Spacer()
            }
            .frame(maxWidth:.infinity)
            HStack{
                Text("\(id)")
                    .font(.custom("Poppins-SemiBold",size: 12))
                    .frame(width: 35, height: 22, alignment: .center)
                    .foregroundColor(self.selected ? .white  : Color("dark"))
                    .background(self.selected ? Color(color)  : Color("light"))
                    .cornerRadius(4)
                    Text("Selected")
            
                        .foregroundColor(.white)
                        .font(.custom("Poppins-Medium",size: 14))
                        .opacity(self.selected ? 1 : 0)
            }
            .frame(maxWidth:.infinity)
        }
        .padding(.vertical)
        .padding(.leading,12)
        .padding(.trailing,50)
        .background(self.selected ? Color(color)  : Color.white)
    }
}

struct CatItem_Previews: PreviewProvider {
    static var previews: some View {
        CatItem()
    }
}
