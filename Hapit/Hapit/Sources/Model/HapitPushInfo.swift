//
//  HabitPushInfo.swift
//  Hapit
//
//  Created by 추현호 on 2023/02/03.
//

import Foundation
import RealmSwift

class HapitPushInfo: Object, ObjectKeyIdentifiable {
    @Persisted var pushID: String
    @Persisted var pushTime: Date?
    @Persisted var isChallengeAlarmOn: Bool
    
    convenience init(pushID: String, pushTime: Date? = nil, isChallengeAlarmOn: Bool) {
        //푸시인포를 받아올 인스턴스 초기화 후 변수 받아서 프로퍼티에 할당
        self.init()
        self.pushID = pushID
        self.pushTime = pushTime
        self.isChallengeAlarmOn = isChallengeAlarmOn
    }
    
}
