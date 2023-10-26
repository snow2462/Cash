//
//  TransactionRow.swift
//  Money
//
//  Created by Katie Barrow on 8/24/23.
//

import SwiftUI

struct TransactionRow: View {
    let item : TransactionData
    var body: some View {
        HStack {
            Text(item.title)
                .font(.system(size: 18))
                .bold()
            Spacer()
            Text(String(format: "%.2f", item.amount))
                .font(.system(size: 14))
                .multilineTextAlignment(.trailing)
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(item: TransactionData(title: "", id: "", currency: "", amount: 0))
    }
}
