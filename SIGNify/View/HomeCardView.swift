//
//  HomeCardView.swift
//  SIGNify
//
//  Created by Sukanya Dhiman on 6/4/25.
//

import SwiftUI

struct HomeCardView: View {
    //MARK - PROPERTIES
    @State private var isAnimating: Bool = false
    
    var card: HomeCardModel
    
    //MARK - PROPERTIES
    
    

    var body: some View {
        ZStack () {
            VStack(spacing: 20) {
                Text(card.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 10)
                
                Image(card.image)
                    .resizable()
                    .scaledToFit()
                    //.cornerRadius(50)
                    .shadow(color: Color(red: 0, green:0, blue: 0, opacity:0.15), radius: 5, x:10, y:10)
                    .scaleEffect(isAnimating ? 1.0:0.6)
                    .padding(.horizontal, 20)
                
                
                Text(card.caption)
                    .foregroundStyle(Color(.white))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 480)
            }
            .padding(.vertical, 50.0)
            .frame(height: 500)
            
        }.onAppear {
            withAnimation(.bouncy(duration: 0.5)) {
                isAnimating = true //you have to change the variable!
            }
        }
        //.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [ Color("Secondary"), Color("Third")]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(40)
            .padding(.horizontal, 10)
            //.padding(.vertical, 100)
    }
    

}

//MARK - PREVIEW


#Preview {
    HomeCardView(card: homeCardData[1]).previewLayout(.sizeThatFits)
        //.previewLayout(.fixed(width: 320, height: 640))
}
