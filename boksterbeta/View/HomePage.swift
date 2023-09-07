//
//  HomePage.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI

struct HomePage: View {
    
    @State var value:String = "";
    var padding:CGFloat = 0;
    @EnvironmentObject var data:mycolors
    @Binding var showMenu:Bool
    

    var body: some View {
        ZStack{
            VStack{
                HStack{
                    TextField("",text:$value)
                        .font(.custom("Poppins-Regular",size: 14))
                        .placeholder(when: value.isEmpty, placeholder: {
                            Text("Search ...")
                                .font(.custom("Poppins-Regular",size: 14))
                                .foregroundColor(Color("placeholder"))
                        })
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("placeholder"))
                        .font(.system(size: 15))
                }
                .padding(.horizontal,25)
                .padding(.vertical,12)
                
                .background(Color("search"))
                .cornerRadius(40)
                .padding()
                .padding(.top,getRect().height>720 ? 25 : 0)
                ScrollView(.vertical,showsIndicators: false){
                    VStack(spacing:12){
                        ForEach(data.selected > -1 ? data.getCategorie(index: data.selected).urls : data.selected == -1 ? data.getAllFavorite() : data.getAll() ){
                            item in
                            if(item.title.lowercased().contains(value.lowercased()) || item.detaille.lowercased().contains(value.lowercased()) || value.isEmpty)
                                {
                                    ListItems(item: item)
                                }
                        }
                    }
                    //.frame(height:CGFloat(data.selected > -1 ? data.getCategorie(index: data.selected).urls.count * 70 : data.getAll().count * 70))
                }
                .frame(maxHeight:.infinity)
            }
            .frame(maxHeight:.infinity)
            .padding(.top,padding == 0 ? 70 : padding+30)
            
            AddButton()
        }
        
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
