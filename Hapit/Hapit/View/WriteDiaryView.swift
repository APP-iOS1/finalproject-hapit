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
    @State var text = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data? = nil
    let maxCharacterLength = Int(300)
    var wrappedSelectedImageData: Data {
        return selectedImageData ?? Data()
    }
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.square")
                        .resizable()
                        .frame(width: 30, height: 30)
                }.padding(.leading, 20)
                Spacer()
                //
                Button {
                    dismiss()
                } label: {
                    Text("등록")
                        .font(.title3)
                        .bold()
                }.padding(.trailing, 20)
            }
            .padding(.bottom, 10)
            
            Spacer()
            // Contents
            VStack {
                if let uiImage = UIImage(data: wrappedSelectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    // 등록한 사진 없을 때
                    PhotosPicker(selection: $selectedItem, matching: .images ,photoLibrary: .shared()) {
                        VStack {
                            Image("defaultPhoto")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                            Text("사진을 추가해주세요.")
                        }
                    }
                }
            }.frame(width: 200, height: 150)
            VStack {
                // 글자수 300자 제한
                TextField("", text: $text, axis: .vertical)
                    .frame(width: 330)
                    .lineLimit(6, reservesSpace: false)
                    .padding()
                    .onReceive(Just(text), perform: { _ in
                                    if maxCharacterLength < text.count {
                                        text = String(text.prefix(maxCharacterLength))
                                    }
                                })
                Spacer()
            }
            .frame(width: 350, height: 200)
            .border(.gray)
            Spacer()
        }
    }
}

struct WriteDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        WriteDiaryView()
    }
}
