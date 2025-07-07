//
//  HomeCardModel.swift
//  SIGNify
//
//  Created by Sukanya Dhiman on 6/9/25.
//

import SwiftUI
// HOME CARD DATA MODEL

struct HomeCardModel: Identifiable {
    var id = UUID()
    var title: String
    var image: String
    var caption: String
    var buttonText: String
    var gradientColors: [Color]
}
