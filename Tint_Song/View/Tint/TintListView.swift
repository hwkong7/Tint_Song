import SwiftUI

struct TintListView: View {
    let viewModel: TintViewModel

    var body: some View {
        List {
            ForEach(viewModel.tints) { tint in
                NavigationLink(value: tint) {
                    VStack(alignment: .leading) {
                        Text(tint.productName)
                            .font(.headline)
                        Text(tint.brand)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete { indexSet in
                Task {
                    for index in indexSet {
                        let tint = viewModel.tints[index]
                        await viewModel.deleteTint(tint)
                    }
                }
            }
        }
    }
}
