//
//  WriteDiaryView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI
import Combine
import PhotosUI

struct WriteDiaryView: View {
    @Environment(\.dismiss) private var dismiss
    @State var content = ""
    
    // MARK: 더미 데이터 - 데이터 연동 후 지우기 !!
    @State private var date = "2023년 01월 20일 금요일"
    @State private var habitName = "물마시기"
    
    @State private var selectedImages: [PhotosPickerItem] = [] // 이미지 변수
    @State private var selectedImageData: [Data] = [] // 뿌려주기 위한 이미지 데이터 변수
    
    let maxCharacterLength = Int(300)
    
    //    var wrappedSelectedImageData: Data {
    //        return selectedImageData ?? Data()
    //    }
    
    var body: some View {
        NavigationStack {
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
                    // 선택된 이미지가 하나라면 이미지가 꽉 차게 출력시켜준다.
                    if selectedImageData.count == 1 {
                        // 선택된 이미지 출력.
                        ForEach(selectedImageData, id: \.self) { imageData in
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .cornerRadius(10)
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                            } // if let
                        } // ForEach
                    } else { // 여러개면 스크롤뷰로 작게 보여준다.
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                // 선택된 이미지 출력.
                                ForEach(selectedImageData, id: \.self) { imageData in
                                    if let image = UIImage(data: imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .cornerRadius(10)
                                            .scaledToFit()
                                            .frame(maxHeight: 200)
                                    } // if let
                                } // ForEach
                            } // HStack
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                        }
                    }
                    
                    
              
                    
                    // 글자수 300자 제한
                    TextField("릴루님의 습관일지를 작성해보세요!", text: $content, axis: .vertical)
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
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    
                    
                    
                } // VStack
                .formStyle(.columns)
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
                                .fontWeight(.light)
                        } // label
                    } // ToolbarItem
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // 갤러리
                        PhotosPicker(selection: $selectedImages, matching: .images, photoLibrary: .shared()) {
                            Image(systemName: "photo")
                        }
                        .onChange(of: selectedImages) { newImages in
                            // 선택된 이미지가 없다면 비워줘야 함.
                            if newImages.isEmpty { selectedImageData = [] }
                            // 선택된 이미지가 있다면 뿌려주기 위해 배열에 담기.
                            for newImage in newImages {
                                Task {
                                    // 배열 초기화
                                    selectedImageData = []
                                    // Retrieve selected asset in the form of Data
                                    if let data = try? await newImage.loadTransferable(type: Data.self) {
                                        selectedImageData.append(data)
                                    }
                                } // Task
                            } // for
                        } // onChanged
                        
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
                    .bold()
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            }

            
        } // Nav Stack
    
    } // body
}

struct WriteDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        WriteDiaryView()
    }
}
