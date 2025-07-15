//
//  Dictionary.swift
//  SIGNify
//
//  Created by Sukanya Dhiman on 7/9/25.
//

import SwiftUI

struct Dictionary: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Dictionary")
                    .font(.system(size:50))
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(LinearGradient(colors: [.accentColor, Color("Secondary"), Color("Third")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(DictionaryData) { item in
                            DicionaryCardView(card: item).frame(height: 120)
                        }
                    }
                }
            }
        }
    }

#Preview {
    Dictionary()
}
