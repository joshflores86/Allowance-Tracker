//
//  EditView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

struct EditView: View {
    @StateObject var viewModel: DataViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var selectedTab = 0
    @Binding var name: String
    @Binding var amount: String
    @Binding var avatarImage: UIImage
    @State var firstValue: [String]
    @Binding var secondValue: [String]
    @Binding var mainValue: [String]
    @State var new1stValue: [String] = []
    @State var id: UUID
    @Binding var steps: Int
    var specificUser: Binding<UserModel> {
        Binding<UserModel> {
            return self.viewModel.usersInfoArray.first(where: {$0.id == self.id}) ?? viewModel.usersInfo
        } set: { newValue in
            
        }
    }
    
    var body: some View {
        NavigationView {
            
            TabView(selection: $selectedTab) {
                EditUserView(dataViewModel: viewModel,
                             userName: $name,
                             givenAmount: amount,
                             avatarImage: $avatarImage,
                             id: id,
                             user: specificUser)
                .tabItem {
                    Label("Edit User", systemImage: "person.fill")
                    
                }
                .tag(0)
                
                EditBillsRewardsView(dataViewModel: viewModel,
                                     steps: steps,
                                     firstValue: firstValue,
                                     secondValue: secondValue,
                                     mainValue: mainValue,
                                     id: id,
                                     specificUser: specificUser)
                    .tabItem {Label("Edit bills / rewards", systemImage: "dollarsign.circle")
                    }
                    .tag(1)
            }
            .font(.system(size: 20, design: .monospaced))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if selectedTab == 0  {
                        Text("Edit User")
                            .font(Font.custom("Lobster-Regular", size: 40))
                            .navigationBarTitleDisplayMode(.large)
                            .padding(.top)
                    }else if selectedTab == 1 {
                        Text("Bills And Rewards")
                            .font(Font.custom("Lobster-Regular", size: 40))
                            .navigationBarTitleDisplayMode(.large)
                            .padding(.top)
                    }
                    
                }
            }
            .onChange(of: selectedTab) { _ in
                print(selectedTab)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    @State private static var userInfo = UserModel(id: UUID(), name: "", amount: "",
                                                   initialValue: [], valueHolder: [], steps: 0)
    @StateObject static var dataViewModel  = DataViewModel(usersInfo:
                                                            UserModel(id: UUID(),
                                                                      name: "",
                                                                      amount: "",
                                                                      initialValue: [], valueHolder: []))
    static var previews: some View {
        EditView(viewModel: dataViewModel,
                 name: $userInfo.name,
                 amount: $userInfo.amount,
                 avatarImage: $userInfo.avatarImage,
                 firstValue: userInfo.initialValue,
                 secondValue: $userInfo.secondValue,
                 mainValue: $userInfo.valueHolder,
                 new1stValue: [],
                 id: userInfo.id,
                 steps: $userInfo.steps)
        
    }
}
