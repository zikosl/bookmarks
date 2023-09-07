//
//  SideMenu.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct SideMenu: View {
    
    @State var show = false
    @State var trash = false
    @Namespace var animation
    @EnvironmentObject var clrs :mycolors
    @State var draggedItem : collection?
    var proxy: GeometryProxy
    @Binding var isShow:Bool
    @State var ToRemove:Int = 0;
    @State var state:Bool = false
    @Binding var enable:Bool
    @State var selectedId:collection = collection(id: 0, title: "", color: 0);
    @State var isUpdate = false
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading,spacing: 0) {
                Text("GENERAL")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .kerning(2)
                    .foregroundColor(.white)
                    .padding(.leading,15)
                    .padding(.bottom,10)
            }
            .padding(.leading,-15)
            ScrollView(showsIndicators:false){
                VStack(alignment: .leading,spacing: 0) {
                    TabButton(id:-2,image: "bookmark.fill", title: "All bookmarks",badged: false,imaged: false, animation: animation){
                        self.enable = false
                        withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                            self.isShow = false
                        }
                    }
                    TabButton(id:-1,image: "star.fill", title: "Favorites",badged: false,imaged: false, animation: animation){
                        self.enable = false
                        withAnimation {
                            self.isShow = false
                        }
                    }
                    TabButton(id:0,image: "suit.heart.fill", title: "Default",badged: false,imaged: false, animation: animation){
                        self.enable = false
                        withAnimation {
                            self.isShow = false
                        }
                    }
                }
                .padding(.leading,-45)
                VStack(alignment: .leading,spacing:0){
                    HStack(alignment:.center){
                        Text("MY CATEGORIES")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .kerning(2)
                            .foregroundColor(.white)
                            .padding(.leading,15)
                        Spacer()
                        Button(action: {
                            self.enable.toggle()
                        }, label: {
                            Text("edit")
                                .font(.custom("Poppins-Medium",size: 14))
                                .kerning(2)
                                .foregroundColor(.white)
                                .padding(.horizontal,6)
                                .padding(.vertical,4)
                                .background(RoundedRectangle(cornerRadius:5).stroke(Color.white))
                        })
                        
                    }.padding(.trailing,74)
                    .padding(.bottom,10)
                
                    LazyVStack(alignment: .leading,spacing:0){
                        ForEach(clrs.Collections[1...]){
                            value in
                            if(self.enable)
                            {
                                VStack{
                                    ZStack{
                                        TabButton(id: clrs.Collections.firstIndex(where: {$0.id == value.id})! , title:value.title,badge: value.urls.count,color: clrs.colors[value.color], animation: animation,enable:enable,valueID: value.id,functions:{
                                            //self.enable = false
                                            withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                                                    self.ToRemove = value.id
                                                    self.state = true
                                                }
                                        }){
                                            self.selectedId = value;
                                            self.isUpdate = true
                                            }
                                        }
                                    .padding(.trailing,74)
                                    .padding(.leading)
                                }

                            }
                            else
                            {
                                VStack{
                                    ZStack{
                                        TabButton(id: clrs.Collections.firstIndex(where: {$0.id == value.id})! , title:value.title,badge: value.urls.count,color: clrs.colors[value.color], animation: animation,enable:enable,valueID: value.id,functions:{
                                            //self.enable = false
                                            withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                                                    self.ToRemove = value.id
                                                    self.state = true
                                                }
                                            })
                                        }
                                    .padding(.trailing,74)
                                    .padding(.leading)
                                }
                                .offset(x:value.offset)
                                .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                                    .onDrag({
                                        //self.draggedItem = value
                                        return NSItemProvider(contentsOf: URL(string:"\(value.id)")!)!
                                    }) .onDrop(of: [.url], delegate: MyDropDelegate(item: value, items: $clrs.Collections, draggedItem: $draggedItem,active:$clrs.selected))
                            }
                        }
                    }
                    .padding(.top,25)
                }
                .zIndex(99)

            }
            .padding(.leading,-15)
            .padding(.top,10)
            Spacer()
            VStack
            {
                
            }
            .frame(width: getRect().width - 120,height: 0.5)
            .background(Color("search").opacity(0.3))
            .padding(.horizontal,10)
            VStack(alignment: .leading){
                TabButton(title: "New Category ...",badged:false,add: true, animation: animation,functions: {
                    self.enable = false
                    self.show = true
                })
                TrashButton(functions: {
                    self.enable = false
                    self.trash = true
                })
                    .padding(.leading,-15)
                Text("App Version 1.0.0")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.6)
            }
        }
        .padding()
        .padding(.top,proxy.safeAreaInsets.top+5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $show) {
            AddCollection()
        }
        .sheet(isPresented: $trash) {
            Trash()
        }
        .sheet(isPresented: $isUpdate) {
            UpdateCollection(id:selectedId)
        }
    }
    func onChanged(value:DragGesture.Value)
    {
        
    }
    func onEnd(value:DragGesture.Value)
    {
        
    }
}

struct MyDropDelegate : DropDelegate {
    let item : collection
    @Binding var items : [collection]
    @Binding var draggedItem : collection?
    @Binding var active:Int
    //@EnvironmentObject var clrs :mycolors
    
    
    func performDrop(info: DropInfo) -> Bool {
        self.draggedItem = nil
        return true
    }
    func dropEntered(info: DropInfo) {
        
        if(self.draggedItem == nil ){
            self.draggedItem = item
        }
        guard let draggedItem = self.draggedItem else {
            return
        }
        if draggedItem.id != item.id {
            let from = items.firstIndex(where: {$0.id == draggedItem.id})!
            let to = items.firstIndex(where: {$0.id == item.id})!
            withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0)) {
                let fr = items[from]
                items[from] = items[to]
                items[to] = fr
                if(from == active)
                {
                    active = to
                }
            }
        }
    }
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
struct test:View{
    var body: some View{
        try! MainView()
            .environmentObject(mycolors())
    }
}
struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
