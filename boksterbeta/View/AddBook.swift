//
//  AddBook.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//


import SwiftUI

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}
struct CString:Identifiable{
    var id = UUID().uuidString
    var title:String
}
struct AddBook: View {
    
    @State var value:String = ""
    @State var title:String = ""
    @ObservedObject var detaille = TextBindingManager(limit: 150)

    @State var image:UIImage = UIImage(imageLiteralResourceName: "icapp")
    
    @State var toggle:Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm : PreviwLinkCustom
    @EnvironmentObject var collect : mycolors
    @State var selected:[Int] = []
    @State var alert:CString?
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(){
                    HStack{
                        Button{
                            self.presentationMode.wrappedValue.dismiss()
                        } label:{
                            Text("Cancel")
                                .font(.custom("Poppins-Regular",size: 16))
                        }
                        Spacer()
                        Button{
                            self.save()
                        } label:{
                            Text("Save")
                                .font(.custom("Poppins-Regular",size: 16))

                        }
                    }
                    .padding(.horizontal)
                    .padding([.vertical])

                    Text("Bookmarks")
                        .font(.custom("Poppins-Bold",size: 25))
                        .fontWeight(.bold)
                }
                Form{
                    Section{
                        TextField("",text:$value)
                            .font(.custom("Poppins-Medium",size: 16))
                            .placeholder(when: value.isEmpty, placeholder: {
                                Text("URL ...")
                                    .font(.custom("Poppins-Medium",size: 16))
                                    .foregroundColor(Color("color9"))
                            })
                            .padding(.vertical,8)
                        HStack{
                            if(image != UIImage(imageLiteralResourceName: "icapp"))
                            {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:30,height: 30)
                            }
                            TextField("",text:$title)
                                .font(.custom("Poppins-Medium",size: 16))
                            .placeholder(when: title.isEmpty, placeholder: {
                                Text("Title ...")
                                    .font(.custom("Poppins-Medium",size: 16))
                                    .foregroundColor(Color("color9"))
                            })
                        }
                        .padding(.vertical,8)
                        TextEditor(text:$detaille.text)
                            .font(.custom("Poppins-Medium",size: 16))
                            .placeholder(when: detaille.text.isEmpty, placeholder: {
                                Text("Description ...")
                                    .font(.custom("Poppins-Medium",size: 16))
                                    .foregroundColor(Color("color9"))
                                    .frame(maxHeight:.infinity)
                                Spacer()
                            })
                            .padding(.vertical)
                            .multilineTextAlignment(.leading)
                            .frame(height:150,alignment: .top)
                            .lineLimit(5)
                    }
                    Section{
                        NavigationLink {
                            Category(values:$selected)
                        } label: {
                            HStack{
                                Text("Categorie")
                                    .font(.custom("Poppins-Medium",size: 16))
                                Spacer()
                                ScrollView(.horizontal,showsIndicators: false){
                                    HStack{
                                        Spacer()
                                        ForEach(selected,id:\.self){
                                            value in
                                            Text(collect.getCategorieById(index: value).title+",")
                                                .font(.system(size: 10))
                                                .padding(0)
                                        }
                                    }
                                    .frame(maxWidth:.infinity,alignment: .trailing)
                                }
                            }
                            .padding(.vertical,14)
                        }

                        

                        if #available(iOS 15.0, *) {
                            Toggle("Favorite",isOn:$toggle)
                                .font(.custom("Poppins-Medium",size: 16))
                                .tint(.blue)
                                .padding(.vertical,7)
                        } else {
                            Toggle("Favorite",isOn:$toggle)
                                .padding(.vertical,7)
                        }
                    }
                    
                    /*Section (header:Text("Image").padding(5)){
                        HStack{
                            Spacer()
                            if let uiImage = vm.image{
                                Image(uiImage:uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(15)
                            }
                            else{
                                ZStack{
                                    Image(systemName: "plus")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 60, height: 60, alignment: .center)
                                .background(Color.gray)
                                .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }*/
                    
                }

                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color(.systemGray6))

        }
        .onChange(of: value) { newValue in
            print(self.value)
            self.value = newValue.trimmingCharacters(in: .whitespaces)
            if URL(string:newValue.trimmingCharacters(in: .whitespaces)) != nil{
                self.vm.load(link: newValue.trimmingCharacters(in: .whitespaces))
            }else{
                print("bad url")
            }
        }
        .onChange(of: vm.title) { newValue in
            title = vm.title ?? ""
            if let value = vm.detaille{
                detaille.text = String(value[..<value.index(value.startIndex,offsetBy: min(value.count-5,150))])
            }
    
        }
        .onChange(of: vm.image) { newValue in
            image = newValue ?? image
        }
        .alert(item: $alert) { item in
            Alert(title: Text(item.title), dismissButton: .cancel())
        }

    }
    func save (){
        if URL(string:self.value) == nil{
            self.alert = CString(title: "Invalid URL")
        }
        else if(title.count == 0 && selected.count > 0 )
        {
            collect.addToCategorie(link: value,title: value, detaille: detaille.text, image: image ,favorit: toggle,id: selected)
            presentationMode.wrappedValue.dismiss()
            self.value = "www."
            self.title = ""
            self.selected = []
        }
        else if(selected.count == 0)
        {
            collect.addToCategorie(link: value,title: title, detaille: detaille.text, image: image ,favorit: toggle,id:  [0])
            presentationMode.wrappedValue.dismiss()
            self.value = "www."
            self.title = ""
            self.selected = []
        }
        else{
            collect.addToCategorie(link: value,title: title, detaille: detaille.text, image: image ,favorit: toggle,id: selected)
            presentationMode.wrappedValue.dismiss()
            self.value = "www."
            self.title = ""
            self.selected = []
        }
        
    }
}
/**struct AddBook: View {
 @State var value:String = ""
 @State var title:String = ""
 @State var detaille:String = ""
 @State var image:String = "stackoverflow"
 var body: some View {
     VStack{
         HStack{
             VStack{
                 ZStack{
                     TextField("",text:$value)
                         .placeholder(when: value.isEmpty, placeholder: {
                             Text("URL ...")
                                 .foregroundColor(Color("placeholder"))
                         })
                 }.padding()
                     .background(Capsule().stroke(Color("search"),lineWidth: 0.5)
                                     .shadow(color: Color("search"), radius: 1,x: 2,y:5)
                     )
                     .padding([.vertical,.trailing])
                 ZStack{
                     TextField("",text:$title)
                         .placeholder(when: title.isEmpty, placeholder: {
                             Text("Title: ")
                                 .foregroundColor(Color("placeholder"))
                         })
                 }.padding()
                     .background(Capsule().stroke(Color("search"),lineWidth: 0.5)
                                     .shadow(color: Color("search"), radius: 1,x: 2,y:5)
                     )
                     .padding([.vertical,.trailing])
             }
             Image(image)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: 70, height: 70)
                 .cornerRadius(15)
                 
         }
         .padding()
         ZStack{
             TextEditor(text:$detaille)
                 .placeholder(when: title.isEmpty, placeholder: {
                     Text("Title: ")
                         .foregroundColor(Color("placeholder"))
                 })
         }.padding()
             .background(RoundedRectangle(cornerRadius: 15).stroke(Color("search"),lineWidth: 0.5)
                             .shadow(color: Color("search"), radius: 1,x: 2,y:5)
             )
             .padding()
         Spacer()
     }
 }
}*/
struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
            .environmentObject(PreviwLinkCustom())

    }
}
