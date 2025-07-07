//
//  Button1.swift
//  SIGNify
//
//  Created by Sukanya Dhiman on 6/5/25.
//

import SwiftUI

struct Button1: View {
    // PROPERTIES
//    var card: HomeCardModel

    
    
    // BODY
    var body: some View {
        Button(action: {print("Exit on boarding")}) 
        {
            HStack(spacing:8) {
                Text("Say Hello")
                    .foregroundStyle(Color("smallText"))
                Image(systemName: "arrow.forward.circle.fill").foregroundColor(.white)
                
                    
                    .symbolEffect(.pulse)
                    //.foregroundColor()
                    .imageScale(.large)
            }.padding(.horizontal, 16)
                .padding(.vertical,10)
                .background(
                    Capsule().fill(Color.accentColor))
//                    .strokeBorder(lineWidth: 1.2)
            
        } // <-- Background color
            
    }
}

#Preview {
    Button1()
        .previewLayout(.sizeThatFits)
}
