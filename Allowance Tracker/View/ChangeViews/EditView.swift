//
//  EditView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

struct EditView: View {
    @StateObject var viewModel: DataViewModel
    @Binding var name: String
    @Binding var amount: String
    @Binding var avatarImage: UIImage
    @State var id: UUID
    @State var steps: Int
    var specificUser: Binding<UserModel> {
        Binding<UserModel> {
            return self.viewModel.usersInfoArray.first(where: {$0.id == self.id}) ?? viewModel.usersInfo
        } set: { newValue in
            
        }
        
        
    }
    
    var body: some View {
        NavigationView {
            Text("Edit User Info")
                .navigationBarTitle("Title")
                .font(.custom("Lobster-Regular", fixedSize: 30))
            TabView {
                EditUserView(dataViewModel:
                                viewModel,
                             userName: $name,
                             givenAmount: $amount,
                             avatarImage: avatarImage, id: id)
                .tabItem {Label("Edit User", systemImage: "person.fill")}
                
                EditBillsRewardsView(dataViewModel: viewModel, steps: steps, id: id, specificUser: specificUser)
                    .tabItem {Label("Edit bills / rewards", systemImage: "dollarsign.circle")
                            
                    }
            }
            
            .font(.system(size: 20, design: .monospaced))
        }
        
    }
}

struct EditView_Previews: PreviewProvider {
    @State private static var userInfo = UserModel(id: UUID(), name: "", amount: "",
                                                   valueHolder: [], steps: 0)
    
    static var previews: some View {
        EditView(viewModel:
                    DataViewModel(usersInfo:
                                    UserModel(id: UUID(),
                                              name: "",
                                              amount: "",
                                              valueHolder: [])),
                 name: $userInfo.amount,
                 amount: $userInfo.amount,
                 avatarImage: $userInfo.avatarImage,
                 id: UUID(), steps: userInfo.steps)
    }
}
