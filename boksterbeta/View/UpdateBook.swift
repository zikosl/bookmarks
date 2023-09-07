//
//  AddBook.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//


import SwiftUI


struct UpdateBook: View {
    
    @State var values:Books
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm : PreviwLinkCustom
    @EnvironmentObject var collect : mycolors

    var body: some View {
        ZStack{
            Form{
                Section (header:Text("URL").padding(5)){
                    HStack{
                        Text(values.link)
                            .font(.custom("Poppins-Regular",size: 16))
                    }
                }
                
                Section (header:Text("title").padding(5)){
                    
                    TextField("",text:$values.title)
                        .font(.custom("Poppins-Regular",size: 16))
                    .placeholder(when: values.title.isEmpty, placeholder: {
                        Text("title ...")
                            .font(.custom("Poppins-Regular",size: 16))
                            .foregroundColor(Color("placeholder"))
                    })
                }
                
                Section (header:Text("detaille").padding(5)){
                    TextEditor(text:$values.detaille)
                        .font(.custom("Poppins-Regular",size: 16))
                        .padding(.vertical)
                        .multilineTextAlignment(.leading)
                        .frame(height:150,alignment: .top)
                        .lineLimit(5)
                }
                Section (header:Text("Image").padding(5)){
                    HStack{
                        Spacer()
                        Image(uiImage:values.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .cornerRadius(15)
                        Spacer()
                    }
                }
                
            }
            VStack(){
                HStack{
                    Spacer()
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        self.save()
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
    func save (){
        collect.update(item: LinkesItems(id: values.id, link: values.link, title: values.title, detaille: values.detaille, icon: values.link))
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
/*struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
            .environmentObject(PreviwLinkCustom())

    }
}
*/
