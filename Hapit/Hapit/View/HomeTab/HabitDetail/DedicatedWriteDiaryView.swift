//
//  DedicatedWriteDiaryView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/30.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI
import class PhotosUI.PHPickerViewController

struct DedicatedWriteDiaryView: View {
    @Environment(\.dismiss) private var dismiss
    @State var content = ""
    
    // MARK: 더미 데이터 - 데이터 연동 후 지우기 !!
    @State private var date = "2023년 01월 20일 금요일"
    @State private var habitName = "물마시기"
    
    // MARK: 옵셔널 타입으로 변경하기
    @State private var selectedImage: UIImage = UIImage(named: "bearBlue")! // ios 15
    
    @State private var isShowingPhotoPicker: Bool = false
    
    let maxCharacterLength = Int(300)
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(habitName)")
                            .font(.title2)
                            .bold()
                        Text("\(date)")
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                
                Divider().padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                VStack {
                    // 선택된 이미지 출력.
                    Image(uiImage: selectedImage)
                        .resizable()
                        .cornerRadius(10)
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(10)

                    // 글자수 300자 제한
                    TextField("릴루님의 습관일지를 작성해보세요!", text: $content) // ios 15
                    // .lineLimit(9, reservesSpace: false)
                        .font(.subheadline)
                        .frame(width: UIScreen.main.bounds.size.width)
                        .padding(.horizontal, 20)
                        .onReceive(Just(content), perform: { _ in
                            if maxCharacterLength < content.count {
                                content = String(content.prefix(maxCharacterLength))
                            }
                        })
                        
                    // 현재 글자수
                    HStack {
                        Spacer()
                        Text("\(content.count)/\(maxCharacterLength)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
     
                } // VStack
                //.formStyle(.columns) // ios 15
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17)
                                .foregroundColor(.gray)
                                .font(.custom("IMHyemin-Bold", size: 17))
                        } // label
                    } // ToolbarItem
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingPhotoPicker.toggle()
                            
                        } label: {
                            Image(systemName: "photo")
                        }
                    } // ToolbarItem
                } // toolbar
                
            } // ScrollView
            
            // 작성 완료 버튼
            Button {
                // 작성완료 액션
            } label: {
                Text("작성 완료")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.custom("IMHyemin-Bold", size: 17))
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            }
        } // Nav View
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(selectedImage: $selectedImage)
        }
    } // body
}

//struct DedicatedWriteDiaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DedicatedWriteDiaryView(selectedImage: .constant(nil))
//    }
//}
