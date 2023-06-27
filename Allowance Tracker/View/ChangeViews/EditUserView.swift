//
//  EditUserView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 6/25/23.
//

import SwiftUI

struct EditUserView: View {
    
    
    @StateObject var dataViewModel: DataViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @State var showImagePicker = false
    @State var showBillsRewardSheet = false
    @Binding var userName: String
    @Binding var givenAmount: String
    @State var avatarImage: UIImage
    @State var step = 2
    @State var id: UUID
    @State var showCustomTextAlert = false
    @State var textFieldValue: String = ""
    
    var body: some View {
        
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
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    dataViewModel.dismissKeyboard()
                                }
                            }
                        }
                    Spacer()
                    Button("Save") {
                        if let specificUser = dataViewModel
                            .usersInfoArray.firstIndex(where: {$0.id == self.id}){
                            dataViewModel.saveUpdatedUserInfo(index: specificUser,
                                                              name: userName,
                                                              amount: givenAmount)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
}





struct EditUserView_Previews: PreviewProvider {
    @State private static var userInfo = UserModel(id: UUID(), name: "", amount: "",
                                                   valueHolder: [], steps: 0)
    @StateObject static var dataViewModel  = DataViewModel(usersInfo:
                                                            UserModel(id: UUID(),
                                                                      name: "",
                                                                      amount: "",
                                                                      valueHolder: []))
    static var previews: some View {
        NavigationView {
            
            EditUserView(dataViewModel: dataViewModel,
                         userName: $userInfo.name,
                         givenAmount: $userInfo.amount,
                         avatarImage: UIImage(),
                         id: UUID())
            .environmentObject(DataViewModel(usersInfo: userInfo))
        }
        
        
        
        
    }
}
