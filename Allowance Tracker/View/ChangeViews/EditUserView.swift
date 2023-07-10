//
//  EditUserView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 6/25/23.
//

import SwiftUI
import UIKit

struct EditUserView: View {
    @StateObject var dataViewModel: DataViewModel
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @State var showImagePicker: Bool = false
    @State var showBillsRewardSheet: Bool = false
    @Binding var userName: String
    @State var givenAmount: String
    @Binding var avatarImage: UIImage
    @State var id: UUID
    @Binding var user: UserModel
    @State var showCustomTextAlert: Bool = false
    @State var showConfirmSheet: Bool = false
    @State var textFieldValue: String = ""
    var index: Array<UserModel>.Index {
        dataViewModel.usersInfoArray.firstIndex(where: {$0.id == self.id})!
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                backgroundColor
                    .ignoresSafeArea()
                VStack{
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .padding()
                        .onTapGesture {showImagePicker = true}
                    VStack{
                        TextField("Add name", text: $userName)
                            .autocapitalization(.words)
                        TextField("Enter Initial Amount", text: $givenAmount)
                            .padding(.bottom)
                            .keyboardType(.decimalPad)
                            .onChange(of: givenAmount) { newValue in
                                // Remove non-numeric characters
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                // Convert to a numeric value
                                if let amount = Int(filtered) {
                                    // Convert to decimal value
                                    let decimalAmount = Double(amount) / 100.0
                                    // Format as currency string
                                    let formatter = NumberFormatter()
                                    formatter.numberStyle = .currency
                                    formatter.currencyCode = "USD"
                                    formatter.currencySymbol = ""
                                    if let formattedString = formatter.string(from: NSNumber(value: decimalAmount)) {
                                        // Update the amountString with the formatted currency value
                                        givenAmount = formattedString
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .toolbar {
                                ToolbarItem(placement: .bottomBar) {
                                    Button {
                                        showConfirmSheet.toggle()
                                    } label: {
                                        Text("Save")
                                    }
                                }
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        dataViewModel.dismissKeyboard()
                                    }
                                }
                            }
                        
                        
                    }
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    Spacer()
                }
                .actionSheet(isPresented: $showConfirmSheet) {
                        dataViewModel.confirmUserEditActionSheet(index: index, userName: userName, userAmount: givenAmount, avatarImage: avatarImage)
                }
                
            }
        }
        
    }
}
        struct EditUserView_Previews: PreviewProvider {
            @State private static var userInfo = UserModel(id: UUID(),
                                                           name: "",
                                                           amount: "",
                                                           initialValue: [],
                                                           valueHolder: [],
                                                           steps: 0)
            @StateObject static var dataViewModel  = DataViewModel(usersInfo:
                                                                    UserModel(
                                                                        id: UUID(),
                                                                        name: "",
                                                                        amount: "",
                                                                        initialValue: [],
                                                                        valueHolder: []))
            static var previews: some View {
                NavigationView {
                    
                    EditUserView(dataViewModel: dataViewModel,
                                 userName: $userInfo.name,
                                 givenAmount: userInfo.amount,
                                 avatarImage: $userInfo.avatarImage,
                                 id: UUID(),
                                 user: $userInfo)
                    .environmentObject(DataViewModel(usersInfo: userInfo))
                }
                
                
                
                
            }
        }

