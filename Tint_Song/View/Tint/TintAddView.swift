import SwiftUI

struct TintAddView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: TintViewModel
    
    @State var productName = ""
    @State var brand = ""
    @State var colorFamily = ""
    @State var rating = 5
    @State var description = ""
    
    // 🔥 사용자 추가 색상
    @State private var customColors: [String: Color] = [:]
    
    // ColorPicker 관련 상태
    @State private var showColorPicker = false
    @State private var newColorName = ""
    @State private var selectedCustomColor: Color = .pink
    
    // 🔥 HEX 저장용
    @State private var selectedColorHex: String? = nil
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: 제품 정보
                Section("제품 정보 *") {
                    TextField("제품명", text: $productName)
                    TextField("브랜드", text: $brand)
                }
                
                // MARK: 컬러 선택
                Section("컬러 선택") {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {

                            ForEach(colorKeys, id: \.self) { key in
                                if let color = allColors[key] {
                                    
                                    ZStack {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 36, height: 36)
                                            .shadow(radius: 2)
                                        
                                        if colorFamily == key {
                                            Circle()
                                                .stroke(Color.black.opacity(0.9), lineWidth: 2)
                                                .frame(width: 42, height: 42)
                                        }
                                    }
                                    .onTapGesture {
                                        colorFamily = key
                                        
                                        // 기본색 → HEX 매핑에서 가져오기
                                        if let hex = tintColorHexMap[key] {
                                            selectedColorHex = hex
                                        }
                                        
                                        // 사용자 지정색 → 직접 HEX 생성
                                        if let custom = customColors[key] {
                                            selectedColorHex = custom.toHex()
                                        }
                                    }
                                }
                            }
                            
                            // ➕ 새 색상 추가 버튼
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
                    
                    // MARK: ColorPicker UI
                    if showColorPicker {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            ColorPicker("직접 색상 선택", selection: $selectedCustomColor)
                            
                            TextField("색상 이름 입력 (예: 로지핑크)", text: $newColorName)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("색상 추가") {
                                guard !newColorName.isEmpty else { return }
                                
                                customColors[newColorName] = selectedCustomColor
                                
                                // 선택한 색 적용
                                colorFamily = newColorName
                                selectedColorHex = selectedCustomColor.toHex()
                                
                                newColorName = ""
                                showColorPicker = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 8)
                    }
                }
                
                // MARK: 평점
                Section("평점") {
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
                
                // 완료 버튼
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        Task {
                            let tint = Tint(
                                id: UUID(),
                                productName: productName,
                                brand: brand,
                                colorFamily: colorFamily,
                                colorHex: selectedColorHex,
                                rating: rating,
                                description: description
                            )
                            
                            await viewModel.addTint(tint)
                            dismiss()
                        }
                    }
                    .disabled(productName.isEmpty || brand.isEmpty || colorFamily.isEmpty)
                }
                
                // 취소 버튼
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
            }
        }
    }
    
    // MARK: ForEach용 key 배열
    private var colorKeys: [String] {
        Array(allColors.keys).sorted()
    }
    
    // MARK: 기본 + 사용자 색 합치기
    private var allColors: [String: Color] {
        tintColors.merging(customColors) { $1 }
    }
    
    // MARK: 기본색 HEX 매핑
    private var tintColorHexMap: [String: String] {
        tintColors.mapValues { $0.toHex() ?? "#000000" }
    }
}
