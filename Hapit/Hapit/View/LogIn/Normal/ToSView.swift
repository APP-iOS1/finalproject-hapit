//
//  ToSView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ToSView: View {
    @State private var agreeAll: Bool = false
    @State private var agreeService: Bool = false
    
    var body: some View {
        VStack {
            Group {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        .border(Color.pink, width: 2)
                    HStack {
                        Button(action: {
                            agreeAll.toggle()
                        }){
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.pink)
                        }
                        Text("약관 전체동의")
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
                
                Spacer().frame(height: 20)
                
                Group {
                    HStack {
                        Button(action: {
                            agreeService.toggle()
                        }){
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                        Text("(필수) 서비스 이용약관 동의")
                        NavigationLink(destination: ServiceToS()){
                            Image(systemName: "chevron.right")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer().frame(height: 20)
                    
                    HStack {
                        Button(action: {
                            agreeService.toggle()
                        }){
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                        Text("(필수) 개인정보 수집 및 이용동의")
                        NavigationLink(destination: ServiceToS()){
                            Image(systemName: "chevron.right")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer().frame(height: 20)
                    
                    HStack {
                        Button(action: {
                            agreeService.toggle()
                        }){
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                        Text("(선택) E-mail 광고성 정보 수신동의")
                        NavigationLink(destination: ServiceToS()){
                            Image(systemName: "chevron.right")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ToSView_Previews: PreviewProvider {
    static var previews: some View {
        ToSView()
    }
}
