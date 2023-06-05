//
//  EmptyListView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 6/3/23.
//

import SwiftUI

struct EmptyListView: View {
    
    @EnvironmentObject var dataViewModel: DataViewModel
    
    
    var body: some View {
        if $dataViewModel.usersInfoArray.isEmpty  {
            VStack{
                Text("Allowance Tacker")
                    .font(Font.custom("Lobster-Regular", size: 50))
                    .frame(width: .infinity, height: 50)
                    Spacer()
                Text("Click '+' to add new person name and amount")
                    .foregroundColor(Color(white: 0.0, opacity: 0.3))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                Spacer()
            }
            
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .environmentObject(DataViewModel(usersInfo: UsersInfo(id: UUID(), name: "", amount: "")))
    }
        
}
