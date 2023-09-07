//
//  Trash.swift
//  bokster
//
//  Created by ziko on 21/3/2022.
//


import SwiftUI

struct Trash: View {
    
    @State var value:String = "";
    var padding:CGFloat = 0;
    @EnvironmentObject var data:mycolors
    var body: some View {
        ZStack{
            VStack{

            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing:12){
                    ForEach(data.Trash ){
                        item in
                        if(item.title.lowercased().contains(value.lowercased()) || item.detaille.lowercased().contains(value.lowercased()) || value.isEmpty)
                            {
                            TrashItem(item: item)
                            }
                    }
                }
                //.frame(height:CGFloat(data.selected > -1 ? data.getCategorie(index: data.selected).urls.count * 70 : data.getAll().count * 70))
            }
            .frame(maxHeight:.infinity)
            }
            .frame(maxHeight:.infinity)
            .padding(.top,padding == 0 ? 70 : padding+30)
        }
    }
}

