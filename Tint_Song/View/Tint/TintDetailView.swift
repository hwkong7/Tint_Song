import SwiftUI

struct TintDetailView: View {
    let tint: Tint

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // MARK: 이름 + 브랜드
                Text(tint.productName)
                    .font(.largeTitle)
                    .bold()

                Text(tint.brand)
                    .font(.title3)
                    .foregroundColor(.secondary)

                // MARK: 컬러칩
                if let family = tint.colorFamily,
                   let chipColor = tintColors[family] {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(chipColor)
                            .frame(width: 32, height: 32)
                            .shadow(radius: 2)

                        Text(family)
                            .font(.headline)
                    }
                    .padding(.top, 4)
                }

                // MARK: 평점
                Text("⭐️ \(tint.rating)점")
                    .font(.title2)
                    .foregroundColor(.pink)

                // MARK: 설명
                Text(tint.description ?? "(설명 없음)")
                    .font(.body)
                    .padding(.top, 12)
            }
            .padding()
        }
    }
}
