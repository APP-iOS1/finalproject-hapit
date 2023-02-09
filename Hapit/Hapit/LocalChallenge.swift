//
//  HabitPushInfo.swift
//  Hapit
//
//  Created by 추현호 on 2023/02/03.
//

import Foundation
import RealmSwift

class LocalChallenge: Object, ObjectKeyIdentifiable {
    @Persisted var localChallengeId: String
    @Persisted var creator: String
    @Persisted var mateArray: List<String> //[String]
    @Persisted var challengeTitle: String
    @Persisted var createdAt: Date
    @Persisted var count: Int
    @Persisted var isChecked: Bool
    @Persisted var pushTime: Date?
    @Persisted var isChallengeAlarmOn: Bool
    
    //이는 모든 멤버를 초기화하고 상속받은 멤버들을 customizing을 하기 위해서
    convenience init(localChallengeId: String, creator: String, challengeTitle: String, createdAt: Date, count: Int, isChecked: Bool, pushTime: Date? = nil, isChallengeAlarmOn: Bool) {
        //푸시인포를 받아올 인스턴스 초기화 후 변수 받아서 프로퍼티에 할당
        self.init()
        self.localChallengeId = localChallengeId
        self.creator = creator
        self.challengeTitle = challengeTitle
        self.createdAt = createdAt
        self.count = count
        self.isChecked = isChecked
        self.pushTime = pushTime
        self.isChallengeAlarmOn = isChallengeAlarmOn
    }
    
}
