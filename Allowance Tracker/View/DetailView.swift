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
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack{
                Text(name)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                
                Text("\(currency)\(amount)")
                    .font(.system(size: 35, weight: .bold, design: .monospaced))
                    .padding()
            }
        }
        .frame(width: 600, alignment: .center)
        VStack{
            List{
                if let specificUser = dataViewModel.usersInfoArray.first(where: { $0.id == self.id }){
                    ForEach(0..<specificUser.steps) { num in
                        HStack{
                            Text(specificUser.valueHolder[num])
                            Spacer()
                            Text("$\(specificUser.initialValue[num])")
                        }
                    }
                    .listStyle(.plain)
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    
                }
                
            }
            .onAppear {
                try? dataViewModel.load()
                
            }
        }
        
    }
    
}

//    }

//}



struct DetailView_Previews: PreviewProvider {
    @EnvironmentObject var dataViewModel: DataViewModel
    
    static var previews: some View {
        DetailView(usersInfo: UsersInfo(id: UUID(), name: "Josh Flores", amount: "300.00", steps: 0))
            .environmentObject(DataViewModel(usersInfo: UsersInfo(id: UUID(), name: "", amount: "", steps: 0)))
    }
    
}

