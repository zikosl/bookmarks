//
//  AddButton.swift
//  Bookmarks
//
//  Created by ziko on 2/2/2022.
//

import SwiftUI

struct AddButton: View {
    
    @State var show:Bool = false
    @State var value = "www."
    var body: some View {
        VStack{
                Button(action: {
                    self.show = true
                }, label: {ZStack{
                    Image(systemName: "link.badge.plus")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color("dark")))
                .padding(25)
                .padding(.bottom,35)
            
            
                })
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        
        .sheet(isPresented: $show) {
            AddBook(value:value)
                .environmentObject(PreviwLinkCustom())

        }
        .onChange(of: show, perform: { newValue in
            if(!newValue)
            {
                self.value = "www."
            }
        })
        .onChange(of: value, perform: { newValue in
            if(self.show == false){
                self.show = true
            }
        })
        .onOpenURL { url in
            if let scheme = url.scheme,
                scheme.caseInsensitiveCompare("bokster") == .orderedSame,
                let page = url.host {

                var parameters: [String: String] = [:]
                URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                    parameters[$0.name] = $0.value
                }
                for parameter in parameters where parameter.key.caseInsensitiveCompare("url") == .orderedSame {
                    self.value = parameter.value
                }
                //print("redirect(to: \(page), with: \(parameters))")
            }

        }
        
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
