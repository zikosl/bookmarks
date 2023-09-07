//
//  Category.swift
//  Bookmarks
//
//  Created by ziko on 10/3/2022.
//

import SwiftUI

struct Category: View {
    
    @EnvironmentObject var collect : mycolors
    @Environment(\.presentationMode) var hide
    @Binding var values:[Int]
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button{
                    self.hide.wrappedValue.dismiss()
                } label:{
                    Text("Done")
                        .font(.custom("Poppins-Regular",size: 16))
                }
            }
            .padding(.horizontal)
            .padding([.vertical],30)
            Text("Category")
                .font(.custom("Poppins-Bold",size: 25))
                .fontWeight(.bold)
                .padding(.bottom,56)
            ScrollView(showsIndicators:false){
                VStack(spacing:1){
                    ForEach(collect.Collections){
                        value in
                        Button(action: {
                            if(values.contains(value.id))
                            {
                                values.removeAll(where: {$0 == value.id})
                            }
                            else{
                                values.append(value.id)
                            }
                        }, label: {
                            CatItem(title: value.title, color: collect.colors[value.color], selected: values.contains(value.id), id: value.urls.count)
                        })
                    }
                }
                .cornerRadius(8)
            }
        }
        .padding(.horizontal,21)
        .navigationBarHidden(true)
        .background(Color(UIColor.systemGray5))
    }
}

/**struct MyView:View{
    var body:some View{
        try! Category()
                .environmentObject(mycolors())
    }
}

struct Category_Previews: PreviewProvider {
    static var previews: some View {
       MyView()
    }
}
**/
