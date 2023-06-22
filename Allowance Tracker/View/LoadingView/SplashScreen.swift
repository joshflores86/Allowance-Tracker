//
//  SplashScreen.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/28/23.
//

import SwiftUI

struct SplashScreen: View {
    @StateObject var dataViewModel: DataViewModel
    @State private var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    let allowanceColor = #colorLiteral(red: 0.9929426312, green: 0.7593198419, blue: 0.263358742, alpha: 1)
    let trackerColor = #colorLiteral(red: 0.5568627715, green: 0.5568627715, blue: 0.5568627715, alpha: 1)
    var body: some View {
        
        if isActive{
            MainView()
                .environmentObject(dataViewModel)
        }else {
            VStack{
                VStack{
                    
                    Image(uiImage: UIImage(named: "App logo")!)
                        .resizable()
                        .clipShape(Circle())
                        
//                        .backgroundStyle(.black)
                        .scaledToFit()
                    Text("Allowance")
                        .foregroundColor(Color(allowanceColor))
                    Text("Tracker")
                        .foregroundColor(Color(trackerColor))
                }
                .font(Font.custom("Lobster-Regular", size: 50))
                .scaleEffect(size)
                .opacity(opacity)
                
                .onAppear {
                    withAnimation(.easeIn(duration: 2.0)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
                Spacer()
                    .environment(\.colorScheme, .dark)
            }
            
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.isActive = true
                }
            }
            
            
        }
        
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static  private var dataViewModel =
    DataViewModel(usersInfo:
                    UserModel(id: UUID(), name: "",
                              amount: "", valueHolder: [], steps: 0))
    
    static var previews: some View {
        SplashScreen(dataViewModel: dataViewModel)
    }
}
