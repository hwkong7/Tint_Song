import SwiftUI

struct TintAddView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: TintViewModel
    
    @State var productName = ""
    @State var brand = ""
    @State var colorFamily = ""
    @State var rating = 5
    @State var description = ""

    // 🔥 사용자 정의 색상 저장
    @State private var customColors: [String: Color] = [:]

    // ColorPicker 관련 상태
    @State private var showColorPicker = false
    @State private var newColorName = ""
    @State private var selectedCustomColor: Color = .pink
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: 제품 정보
                Section("제품 정보 *") {
                    TextField("제품명", text: $productName)
                    TextField("브랜드", text: $brand)
                }
                
                // MARK: 색상 선택
                Section(header: Text("컬러 선택")) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            
                            // 기본 색상 + 새로 추가된 색상 모두 표시
                            ForEach(allColors.keys.sorted(), id: \.self) { key in
                                let color = allColors[key]!
                                
                                ZStack {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 36, height: 36)
                                        .shadow(radius: 2)
                                    
                                    // 선택된 색상은 테두리 표시
                                    if colorFamily == key {
                                        Circle()
                                            .stroke(Color.black.opacity(0.9), lineWidth: 2)
                                            .frame(width: 42, height: 42)
                                    }
                                }
                                .onTapGesture {
                                    colorFamily = key
                                }
                            }
                            
                            // ➕ 사용자 정의 색상 추가 버튼
                            Button {
                                showColorPicker = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Image(systemName: "plus")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // 🔥 ColorPicker UI
                    if showColorPicker {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            ColorPicker("직접 색상 선택", selection: $selectedCustomColor)
                                .padding(.vertical, 6)
                            
                            TextField("색상 이름 입력 (예: 로지핑크)", text: $newColorName)
                                .textFieldStyle(.roundedBorder)
                            
                            // 새 색상 추가 버튼
                            Button("색상 추가") {
                                if !newColorName.isEmpty {
                                    // 사용자 정의 색상 저장
                                    customColors[newColorName] = selectedCustomColor
                                    
                                    // 선택된 색상 업데이트
                                    colorFamily = newColorName
                                    
                                    // 초기화
                                    newColorName = ""
                                    showColorPicker = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 8)
                    }
                }
                
                // MARK: 평점
                Section("평점 *") {
                    Picker("평점", selection: $rating) {
                        ForEach(1...10, id: \.self) { score in
                            Text("\(score)점")
                        }
                    }
                }
                
                // MARK: 설명
                Section("설명") {
                    TextEditor(text: $description)
                        .frame(height: 120)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        Task {
                            let tint = Tint(
                                id: UUID(),
                                productName: productName,
                                brand: brand,
                                colorFamily: colorFamily,  // 새 색상이면 사용자가 입력한 이름 저장
                                rating: rating,
                                description: description
                            )
                            
                            await viewModel.addTint(tint)
                            dismiss()
                        }
                    }
                    .disabled(productName.isEmpty || brand.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
            }
        }
    }
    
    // MARK: 합쳐진 색상 목록 (기본 + 사용자 추가)
    private var allColors: [String: Color] {
        tintColors.merging(customColors) { $1 }
    }
}
