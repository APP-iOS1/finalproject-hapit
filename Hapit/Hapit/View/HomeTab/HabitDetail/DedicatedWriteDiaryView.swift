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
    
    @State private var selectedImage: UIImage?// ios 15
    @State private var isShowingPhotoPicker: Bool = false
    
    let maxCharacterLength = Int(300)
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(habitName)")
                            .font(.custom("IMHyemin-Bold", size: 22))
                        Text("\(date)")
                            .font(.custom("IMHyemin-Regular", size: 17))
                    }
                    Spacer()
                }.padding(.top, 10)
                
                Divider()
                
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .cornerRadius(10)
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }

                    // 글자수 300자 제한
                    // TODO: frame 조절
                    TextEditor(text: $content) // ios 15
                        .font(.custom("IMHyemin-Regular", size: 15))
                        .lineSpacing(10)
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
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
            .padding(.horizontal, 20)
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
