//
//  AddBook.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI

struct AddCollection: View {
    @State var title:String = "Hello"
    @EnvironmentObject var mclr :mycolors
    @State var active:Int = 0;
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Form{
                
                Section (header:Text("Categorie title")                                .font(.custom("Poppins-Regular",size: 16))
                            .padding(0)){
                    HStack{
                        TextField("",text:$title)
                            .font(.custom("Poppins-Regular",size: 16))
                            .placeholder(when: title.isEmpty, placeholder: {
                                Text("Title ...")
                                    .font(.custom("Poppins-Regular",size: 16))
                                    .foregroundColor(Color("placeholder"))
                            })
                    }
                }
                .padding()
                Section (header:Text("Categorie Color")                                .font(.custom("Poppins-Regular",size: 16)).padding()){
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            ForEach(0..<mclr.colors.count){
                                value in
                                    Button(action: {
                                        withAnimation(.spring()){
                                            self.active = value
                                        }
                                    }, label: {
                                        ZStack{
                                            if(self.active == value)
                                            {
                                                Color.black.opacity(0.15).frame(width: 40, height: 40)
                                                    .cornerRadius(5)
                                            }
                                        }
                                        .frame(width: 40, height: 40)
                                        .background(Color(mclr.colors[value]))
                                        .cornerRadius(20)
                                        .padding(3)
                                        .background(active == value ? Color.black : Color.white)
                                        .scaleEffect(active == value ? 1.5 : 1)
                                        .cornerRadius(25)
                                        .padding(.horizontal,10)
                                    })
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            VStack(){
                HStack{
                    Spacer()
                    Button{
                        add()
                        presentationMode.wrappedValue.dismiss()
                    } label:{
                        Text("Save")
                            .font(.custom("Poppins-Regular",size: 16))
                            .padding([.trailing])
                            .padding([.top])
                    }
                }
                Spacer()
            }
        }
        
    }
    func add(){
        mclr.addCategorie(title: title, color: active)
    }
}

struct AddCollection_Previews: PreviewProvider {
    static var previews: some View {
        AddCollection()
    }
}
