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
    @State var usersInfo: UsersInfo
    @State var name: String = ""
    @State var avatarImage: UIImage = UIImage()
    @State var amount: String = ""
    @State var id = UUID()
    @State var currency = ""
    @State var finalPay: Int = 0
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
                    Text("\(currency)\(amount)")     //"\(currency)\(amount)"
                        .font(.system(size: 35, weight: .bold, design: .monospaced))
                        .frame(alignment: .centerLastTextBaseline)
                        .padding(.bottom)
                        .padding(.trailing, 10)
                    
                    Button("Final Pay") {
                        dataViewModel.addFinalPayment()
                    }
                    
                    .buttonStyle(.borderless)
                    .padding()
                    .background(Color(rawValue: textColor.rawValue))
                    .cornerRadius(25)
                    .foregroundColor(Color(rawValue: foregroundColor.rawValue))
                }
                .padding(.trailing, 10)
                
                List{
                    if let specificUser = dataViewModel.usersInfoArray.first(where: { $0.id == self.id }){
                        if specificUser.steps != 0 {
                            ForEach(0..<specificUser.steps) { num in
                                HStack{
                                    Text(specificUser.valueHolder[num])
                                    Spacer()
                                    Text("$\(specificUser.initialValue[num])")
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
}




struct DetailView_Previews: PreviewProvider {
    @EnvironmentObject var dataViewModel: DataViewModel
    
    static var previews: some View {
        DetailView(usersInfo: UsersInfo(id: UUID(), name: "Josh Flores", amount: "300.00", steps: 0))
            .environmentObject(DataViewModel(usersInfo: UsersInfo(id: UUID(), name: "", amount: "", steps: 0)))
    }
    
}

