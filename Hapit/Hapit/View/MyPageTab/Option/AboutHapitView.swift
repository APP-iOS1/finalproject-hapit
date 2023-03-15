//
//  AboutHapitView.swift
//  Hapit
//
//  Created by 이주희 on 2023/03/14.
//

import SwiftUI

struct AboutHapitView: View {
    var body: some View {
        VStack {
            Image("new_logo")
                .padding()
            
            VStack(alignment: .leading) {
                Text("해핏(Hapit)은 스스로 습관을 형성하기 어려운 사람들을 위해 귀여운 요소들을 통한 습관 런닝 메이트 역할을 해주는 앱입니다! \n")
                    .font(.custom("IMHyemin-Bold", size: 20))
                
                Text("왜 습관을 66일동안 진행하나요?")
                    .font(.custom("IMHyemin-Bold", size: 18))
                    
                Text("European Journal of Social Psychology에서 발표된 연구 결과에 따르면 평균적으로 습관이 되기까지 정확히 66일이 걸린다고 합니다🤓 해핏과 함께 66일 동안 챌린지를 수행해보아요!")
                    .font(.custom("IMHyemin-Regular", size: 16))
                
                Text("\n")
                    .font(.custom("IMHyemin-Bold", size: 20))
                
                Text("챌린지를 하루라도 체크하지 못하면 어떻게 되나요?")
                    .font(.custom("IMHyemin-Bold", size: 18))
                Text("아쉽지만 0일째로 초기화 됩니다🥲 끈기를 가지고 습관을 형성해보아요!")
                    .font(.custom("IMHyemin-Regular", size: 16))
            }.padding()
        }
    }
}

struct AboutHapitView_Previews: PreviewProvider {
    static var previews: some View {
        AboutHapitView()
    }
}
