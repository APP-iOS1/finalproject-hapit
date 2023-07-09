//
//  WriteDiaryView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI
import Combine
import PhotosUI

// MARK: 다운그레이드 중 ...
@available(iOS 16.0, *)
struct WriteDiaryView: View {
    @Environment(\.dismiss) private var dismiss
    @State var content = ""
    
    // MARK: 더미 데이터 - 데이터 연동 후 지우기 !!
    @State private var date = "2023년 01월 20일 금요일"
    @State private var habitName = "물마시기"
    
    @State private var selectedImage: PhotosPickerItem? // ios 15
    @State private var selectedImageData: Data? = nil // 뿌려주기 위한 이미지 데이터 변수
    
    let maxCharacterLength = Int(300)
    
    var wrappedSelectedImageData: Data {
        return selectedImageData ?? Data()
    }
    
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
                    if let image = UIImage(data: wrappedSelectedImageData) {
                        ZStack {
                            Image(uiImage: image)
                            
                                .resizable()
                                .cornerRadius(10)
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        selectedImageData = nil
                                    } label: {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                            .overlay {
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(Color("GrayFontColor"))
                                                    .font(.title3)
                                            }
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                    } // if let
             
                    // 글자수 300자 제한
                    TextField("릴루님의 습관일지를 작성해보세요!", text: $content, axis: .vertical) // ios 15
                    // .lineLimit(9, reservesSpace: false)
                        .font(.subheadline)
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
                            .foregroundColor(Color("GrayFontColor"))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
     
                } // VStack
                .formStyle(.columns) // ios 15
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17)
                                .foregroundColor(Color("GrayFontColor"))
                                .font(.custom("IMHyemin-Bold", size: 17))
                        } // label
                    } // ToolbarItem
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker( // ios 15
                            selection: $selectedImage,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Image(systemName: "photo")
                            }
                            .onChange(of: selectedImage) { newItem in
                                Task {
                                    // Retrieve selected asset in the form of Data
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
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
        } // Nav Stack
        
    } // body
}
