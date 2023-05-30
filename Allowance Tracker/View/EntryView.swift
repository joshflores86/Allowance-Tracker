//
//  EntryView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

struct EntryView: View {
    
    @EnvironmentObject var dataViewModel: DataViewModel
    
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
     @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
     @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @State var showImagePicker = false
    @State var userName: String = ""
    @State var givenAmount: String = ""
    @State var avatarImage = UIImage(named: "default-avatar")!
    @State var step = 0
    @State var currency: String = ""
    
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor(backgroundColor))
                .opacity(0.3)
                .ignoresSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack{
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .padding()
                        .onTapGesture {showImagePicker = true}
                    TextField("Add name", text: $userName)
                    
                    TextField("Enter Initial Amount", text: $givenAmount)
                        .padding(.bottom)
                    VStack{
                        Stepper(value: $step, in: 0...dataViewModel.billsArray.count) {
                            Picker("Currency", selection: $currency) {
                                ForEach(dataViewModel.usersCurrency, id: \.self) {i in
                                    Text(i)
                                }
                            }
                        }
                        ForEach(0..<step, id: \.self) { index in
                            HStack{
                                Picker("Bills Selector", selection: $dataViewModel.valuePlacer[index]) {
                                    ForEach(dataViewModel.billsArray, id: \.self ) { value in
                                        Text(value).tag(index) }}
                                TextField("Enter Amount", text: $dataViewModel.initValue[index])
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $avatarImage )
                }
                VStack{
                    Button("Save") {
                        dataViewModel.addValueToArray()
                        dataViewModel.addInitialValue()
                        dataViewModel.steps = step
                        dataViewModel.saveInfo(name: userName, amount: givenAmount, selectImage: avatarImage, initialArray: dataViewModel.usersInfo.initialValue, valueArray: dataViewModel.usersInfo.valueHolder, steps: dataViewModel.steps, selectedCurrency: currency)
                        print(dataViewModel.steps)
                        print(step)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 25))
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(15)
                    .tint(textColor)
                }
            }
            .foregroundColor(foregroundColor)
        }
    }
}


struct AddUserView_Previews: PreviewProvider {
    @State private static var userInfo = UsersInfo(id: UUID(), name: "", amount: "", steps: 0)
    
    static var previews: some View {
        
        EntryView()
        
            .environmentObject(DataViewModel(usersInfo: userInfo))
        
    }
}

