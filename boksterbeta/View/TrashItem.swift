//
//  ListItem.swift
//  Bookmarks
//
//  Created by ziko on 1/2/2022.
//

import SwiftUI

struct TrashItem: View {
    
    @State private var backgroundColor: Color = .clear
    var item:Books
    var size:CGFloat = 44
    

    @EnvironmentObject var data:mycolors
    
    func getDate() -> Int{
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: item.date)

        let components = calendar.dateComponents([.day], from: date2, to: date1)
        print("\(date1 )     \(date2)" )
        return components.day ?? 0
    }
    var body: some View {
            HStack(alignment: .center){

                ZStack{
                    Image(uiImage: item .icon)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                }
                .frame(width: size * 2 - 10 , height: size*2 - 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.trailing,10)
                VStack(alignment: .leading, spacing: 6){
                    HStack(alignment:.top){
                        Text(item.title)
                            .font(.custom("Poppins-Medium",size: 17))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Text(item.detaille)
                        .font(.custom("Poppins-Medium",size: 13))
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                .padding(.vertical)
                Spacer()
                VStack(alignment: .trailing){
                    ZStack{
                        VStack{
                            
                            Button(action: {
                                data.UnRemoveFromCategorie(id: item.id)
                            }, label: {
                                Image(systemName: "trash.slash")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("color6"))
                            })
                            Spacer()
                        }
                        .padding(.vertical,18)
                    }
                    Spacer()
                    Text("Left \(30-getDate()) days")
                        .font(.custom("Poppins-Regular",size: 11))
                        .foregroundColor(Color.gray)
                        .padding(.bottom)
                    
                }
            }
            .frame(height:150)
            .padding(.horizontal,20)
            .padding(.vertical,1)
            .background(Color("light"))
            .cornerRadius(20)
            .padding(.horizontal,8)
            .onAppear {
                        self.setAverageColor()
            }
    }
    private func setAverageColor() {
        let uiColor = item.icon.firstColor ?? .clear
        backgroundColor = Color(uiColor)
    }
}

struct TrashItem_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
