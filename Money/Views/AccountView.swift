//
//  AccountView.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var launchScreenStateManager: LaunchScreenStateManager
    @StateObject private var viewModel = AccountViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            if (viewModel.accountBalance.isEmpty){
                Text("No Data")
                    .font(.subheadline)
                    .bold()
                    .multilineTextAlignment(.center)
              
            } else {
               
                List{
                    Section(){
                        Text("Account Balance")
                            .font(.subheadline)
                            .bold()
                        
                        // Display Balance
                        HStack {
                            if viewModel.isBusy {
                                ProgressView()
                            } else {
                                Text(viewModel.accountBalance)
                                    .font(.largeTitle)
                                    .bold()
                            }
                        }
                        .animation(.default, value: viewModel.isBusy)
                    }.listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())

                    Section(){
                        ForEach(viewModel.transactionList, id:  \.id){item in
                            TransactionRow(item: item)
                                .listRowInsets(EdgeInsets())
                                .listSectionSeparator(.hidden, edges: .top)
                                .listRowSeparatorTint(Color(red: 217 / 255, green: 231 / 255, blue: 255 / 255))
                            
                        }.scrollContentBackground(.hidden)
                            .listStyle(.plain)
                    }
                    
                    Section(){
                        HStack {
                            Image(viewModel.getIsPaidUserStatus() ? "Check_mark_icon" : "Info_icon")
                                .frame(width: 24.0, height: 24.0)
                                .padding(.leading, 16)
                            VStack(spacing: 5) {
                                Text(GetPaymentTitleText())
                                    .font(.subheadline).bold()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)
                                    .padding(.top, 16)
                                Text(GetPaymentText())
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)
                                    .padding(.bottom, 16)
                                    .padding(.trailing, 16)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .background(GetPaymentBackgroundColor())
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .fixedSize(horizontal: false, vertical: true)
                    .onTapGesture {
                        if viewModel.getIsPaidUserStatus() == true {
                            return
                        }
                        Task {
                            await viewModel.fetchAccountAdvice()
                        }
                        viewModel.setPaidUserDefault()
                    }
                }.listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .trailing], 28)
        .padding(.top)
        .task {
            // Workaround to overcome the limitations of SwiftUI's launch screen feature.
            try? await Task.sleep(nanoseconds: 1000)
            launchScreenStateManager.dismissLaunchScreen()

            Task {
                await viewModel.fetchAccountData()
            }
        }
    }
    
    func GetPaymentText () -> String {
        var paymentText = "Get insights on how to save money using premium advice"
        if viewModel.getIsPaidUserStatus() {
            paymentText = viewModel.transactionAdviceDescription
        }
        return paymentText
    }

    func GetPaymentTitleText () -> String {
        var paymentTitleText = "Go Pro!"
        if viewModel.getIsPaidUserStatus() {
            paymentTitleText = viewModel.transactionAdviceTitle
        }
        return paymentTitleText
    }
    
    func GetPaymentBackgroundColor() -> Color {
        return viewModel.getIsPaidUserStatus() ? Color(red: 231 / 255, green: 244 / 255, blue: 232 / 255)  : Color(red: 234 / 255, green: 242 / 255, blue: 255 / 255)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LaunchScreenStateManager())
    }
}

