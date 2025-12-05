import SwiftUI

struct TintDetailView: View {
    let tint: Tint

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // MARK: 제품명
                Text(tint.productName)
                    .font(.largeTitle)
                    .bold()

                // MARK: 브랜드
                Text(tint.brand)
                    .font(.title3)
                    .foregroundColor(.gray)

                // MARK: 컬러칩 + 색상명
                HStack(spacing: 12) {
                    colorCircle()   // ⭐ 함수 호출로 수정
                    Text(tint.colorFamily ?? "-")
                        .font(.headline)
                }
                .padding(.top, 8)

                // MARK: 평점
                HStack {
                    Text("⭐️ \(tint.rating)점")
                        .font(.title2)
                        .foregroundColor(.pink)
                    Spacer()
                }
                .padding(.top, 10)

                // MARK: 설명
                Text(tint.description ?? "(설명 없음)")
                    .font(.body)
                    .padding(.top, 4)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(tint.productName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper: 컬러 원형 뷰
    private func colorCircle() -> some View {
        var color: Color = .gray.opacity(0.3)

        // 1️⃣ HEX → Color 변환
        if let hex = tint.colorHex {
            color = Color(hex: hex)
        }
        // 2️⃣ tintColors에서 찾기
        else if let family = tint.colorFamily,
                let found = tintColors[family] {
            color = found
        }

        // 3️⃣ 최종적으로 circle 반환 (단 1번!)
        return Circle()
            .fill(color)
            .frame(width: 42, height: 42)
            .shadow(radius: 3)
    }

}
