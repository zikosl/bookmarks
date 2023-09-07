//
//  TrashButton.swift
//  bokster
//
//  Created by ziko on 21/3/2022.
//

import SwiftUI

struct TrashButton: View {
    var title: String = "Trash"
    @EnvironmentObject var items : mycolors
    var functions:()->() = {}
    var body: some View {
        Button(action: {
            self.functions()
        }) {
            HStack(spacing:10){
                ZStack{
                    Image(systemName: "trash.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 35)
                .background(Color.white.ignoresSafeArea(.all).opacity(0))
                .cornerRadius(8)
                Text(title)
                    .font(.custom("Poppins-Medium",size: 14))
                    .fontWeight(.regular)
                    .foregroundColor( .white)
                Spacer()
                
            }
            .foregroundColor(.white)
            .padding(.vertical,0)
            .padding(.horizontal,15)
            .frame(maxWidth:getRect().width - 90 ,alignment: .leading)
            .padding(.bottom)
        }
    }
}
