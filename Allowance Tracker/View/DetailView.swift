//
//  DetailView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

struct DetailView: View {
    
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var usersInfo: UserModel
    @State var name: String = ""
    @State var avatarImage: UIImage = UIImage()
    @State var amount: String = ""
    @State var id = UUID()
    @State var currency = ""
    //    @State var finalPay: String = ""
    
    //    @State var totalValueHolder: Double = 0.00
    //    @State var valueHolder: Double = 0.00
    //    @State var initialValue: Int = 0
    
    
    
    var body: some View {
        
        ZStack{
            VStack{
                Text(name)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                HStack{
                    Spacer()
                    Text(dataViewModel.showValue ? "$\(dataViewModel.finalAmount)" : "$\(amount)")
                        .font(.system(size: 35, weight: .bold, design: .monospaced))
                        .frame(alignment: .centerLastTextBaseline)
                        .padding(.bottom)
                        .padding(.trailing, 5)
                    if !dataViewModel.showValue {
                        Button("Final Payment", action: {
                            dataViewModel.addFinalPayment(index: dataViewModel.usersInfoArray.firstIndex(
                                where: { $0.id == self.id })!)
                            
                        })
                        .font(.system(size: 11))
                        .buttonStyle(.borderless)
                        .padding(10)
                        .background(Color(rawValue: textColor.rawValue))
                        .cornerRadius(25)
                        .foregroundColor(Color(rawValue: foregroundColor.rawValue))
                    }else{
                        Button("Save") {
                            dataViewModel.saveUpdateUserAmount(index: dataViewModel.usersInfoArray.firstIndex(
                                where: { $0.id == self.id })!)
                            try? dataViewModel.save()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: 20, weight: .medium))
                        .buttonStyle(.borderless)
                        .padding(15)
                        .background(Color(rawValue: textColor.rawValue))
                        .cornerRadius(25)
                        .foregroundColor(Color(rawValue: foregroundColor.rawValue))
                    }
                }
                .padding(.trailing, 15)
                List{
                    if let specificUser = dataViewModel.usersInfoArray.first(where: { $0.id == self.id }){
                        if specificUser.steps != 0 {
                            ForEach(0..<specificUser.steps) { num in
                                HStack{
                                    VStack{
                                        Text(specificUser.initialValue[num])
                                            .font(.system(size: 10))
                                        Text(specificUser.secondValue[num])
                                    }
                                    Spacer()
                                    Text("$\(specificUser.valueHolder[num])")
                                }
                                .listStyle(.plain)
                                .font(.system(size: 20, weight: .medium, design: .monospaced))
                            }
                        }
                    }
                }
                .onAppear {
                    try? dataViewModel.load()
                }
            }
            .background(Color.init(rawValue: backgroundColor.rawValue)?.ignoresSafeArea())
        }
    }
    //    func addFinalPayment() {
    //        if let index = dataViewModel.usersInfoArray.firstIndex(where: { $0.id == self.id }) {
    //            print(index)
    //            let specificUsers = dataViewModel.usersInfoArray[index]
    //            if specificUsers.amount != "" {
    //                if let amountValue = Double(specificUsers.amount.replacingOccurrences(of: ",", with: "")) {
    //                    for num in 0..<specificUsers.steps {
    //                        valueHolder = Double(specificUsers.valueHolder[num]) ?? 0.00
    //                        totalValueHolder += valueHolder
    //                    }
    //
    //                    let sum = amountValue - totalValueHolder
    //                    finalPay = dataViewModel.formatNumber(sum)
    //                    dataViewModel.finalAmount = finalPay
    //                    dataViewModel.usersInfoArray[index] = specificUsers
    //                    //                    try? dataViewModel.save()
    //                }
    //            }
    //        }
    //    }
    
    
}




struct DetailView_Previews: PreviewProvider {
    @EnvironmentObject var dataViewModel: DataViewModel
    
    static var previews: some View {
        DetailView(usersInfo:
                    UserModel(id: UUID(), name: "",
                              amount: "", valueHolder: [""], steps: 0))
        .environmentObject(DataViewModel(usersInfo:
                                            UserModel(id: UUID(), name: "", amount: "",
                                                      valueHolder: [], steps: 0
                                                     )))
    }
    
}

