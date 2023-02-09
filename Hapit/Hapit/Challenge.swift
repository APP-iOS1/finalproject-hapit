//
//  Habit.swift
//  Hapit
//

import Foundation
import RealmSwift

// MARK: - 습관
struct Challenge: Hashable, Codable, Identifiable {
    
    // 고유한 아이디
    var id: String
    // 작성자
    var creator: String
    // 친구 목록 : 같이 습관을 수행하는 친구를 위함.
    var mateArray: [String]
    // 습관 제목
    var challengeTitle: String
    // 작성 시각
    var createdAt: Date
    // 몇번 수행되었는지 : 일기의 갯수를 계산.
    // MARK: 일지 작성은 선택이어서 일기 갯수로 수행 횟수를 판단할 수 없어용 ㅎㅅㅎ
    var count: Int
    
    // MARK: 임시 - 챌린지 체크 여부
    var isChecked: Bool
    
    // MARK: uid 값
    var uid: String
    // 챌린지 체크 여부 [체크한 날짜]
    // var isChecked: [String]
    // 18, 19일을 체크. ["1/18", "1/19", "1/21"]
    // 배열에 추가될 때마다 카운트. 연속일로 카운트 출력. 안 하는 날이 생기면 카운트를 초기화.
    // isChecked 배열 변수 따로
    // 연속일 체크하는 변수 따로
    // 작성한 시각인 createAt을 String 타입으로 리턴합니다.
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: createdAt)
    }
    
    // MARK: Local Challenge에서 사용될 List<String>형의 변수
    var mateList: List<String> {
        var tempList: List<String> = List<String>()
        for mate in mateArray {
            tempList.append(mate)
        }
        return tempList
    }

    // MARK: LocalChallenge형의 변수
    var localChallenge: LocalChallenge {
        var tempLocalChallenge = LocalChallenge(localChallengeId: id, creator: creator, mateList: mateList, challengeTitle: challengeTitle, createdAt: createdAt, count: count, isChecked: isChecked, isChallengeAlarmOn: false)
        
        return tempLocalChallenge
    }
}
