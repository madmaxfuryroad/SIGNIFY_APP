//
//  ContentView.swift
//  SIGNify
//
//  Created by Sukanya Dhiman on 4/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // MARK: – Home Tab
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            // MARK: – Search / Gallery Tab
            NavigationView {
                VStack {
                    Text("Search or Gallery")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Explore")
            }

            // MARK: – Profile / Settings Tab
            NavigationView {
                VStack {
                    Text("Profile & Settings")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
        }
    }
}



struct HomeView: View {
    var body: some View {
        ZStack {
            //            LinearGradient(gradient: Gradient(colors: [Color.mint, Color.green]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/) //BACKGROUND COLOR
            ScrollView {
                VStack {
                    Spacer()
                    
                    Text("SIGNIFY")
                        .font(.system(size:50))
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(LinearGradient(colors: [.accentColor, Color("Secondary"), Color("Third")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
            
                
                    
                
                    Spacer()

                    
                    Text("Bridge the communication gap, once sign at a time.").padding(10)
                          
                    
                    Spacer()

                    //NAVBAR
                    TabView {
                        ForEach(homeCardData) { item in
                            HomeCardView(card: item).frame(height: 500) 
                        }
                    }.tabViewStyle(PageTabViewStyle())
                        .frame(height:500).padding(.horizontal, 20.0)
                        
                    Spacer()

                
                }
                .frame(maxHeight: .infinity)
                .safeAreaInset(edge: .top, spacing: 0) {
                    Color.clear.frame(height: 60)
                }
             
                Spacer()
                
            }
            
                
            
                
            }.ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
