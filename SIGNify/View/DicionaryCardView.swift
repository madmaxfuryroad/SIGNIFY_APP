//
//  DicionaryCardView.swift
//  SIGNify
//
//  Created by Sukanya Dhiman on 7/9/25.
//

import SwiftUI


struct DicionaryCardView: View {
    
    var card: DictionaryModel

    var body: some View {
        ZStack () {
            HStack(spacing: 10) {
    
                Image(card.image)
                    .resizable()
                    .scaledToFit()
                    //.cornerRadius(50)
                    .shadow(color: Color(red: 0, green:0, blue: 0, opacity:0.15), radius: 5, x:10, y:10)
                    //.padding(.horizontal, 20)
                
                Text(card.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 10)
                
            }
            //.padding(.vertical, 20.0)
            .frame(width: 170, height: 130)
            
        }.onAppear {
            withAnimation(.bouncy(duration: 0.5)) {
            }
        }.padding(.vertical, 20.0)
        //.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [ Color("Secondary"), Color("Third")]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(40)
            .padding(.horizontal, 10)
            //.padding(.vertical, 100)
    }
}

#Preview {
    DicionaryCardView(card: DictionaryData[4]).previewLayout(.sizeThatFits)
}
