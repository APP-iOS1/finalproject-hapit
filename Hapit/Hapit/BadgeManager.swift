//
//  BadgeManager.swift
//  Hapit
//
//  Created by greenthings on 2023/02/07.
//

import Foundation

final class BadgeManager: ObservableObject{
    
    enum BadgeImage: String{
        case noob = "bearYellow"
        case pro = "bearBlue1"
        case master = "bearPrincess"
        case tenDaysChallenge = "bearBlue2"
        case oneDay = "bearRed"
        case thirtyDays = "bearRed2"
        case sixthysixDays = "bearPurple"
        case threeDaysOff = "bearOMG"
        case reed = "bearYellow2"
        case celeb = "bearBlue3"
        case firstDayPost = "bearDeepGreen"
        case other = "bearLock"
    }

    
    enum BadgeName: String{
        case noob = "noob"
        case pro = "pro"
        case master = "master"
        case tenDaysChallenge = "tenDaysChallenge"
        case oneDay = "oneDay"
        case thirtyDays = "thirtyDays"
        case sixthysixDays = "sixthysixDays"
        case threeDaysOff = "threeDaysOff"
        case reed = "reed"
        case celeb = "celeb"
        case firstDayPost = "firstDayPost"
        case other = "other"
    }
    
    @Published var noob: Bool = UserDefaults.standard.bool(forKey: "noob")
    @Published var pro: Bool = UserDefaults.standard.bool(forKey: "pro")
    @Published var master: Bool = UserDefaults.standard.bool(forKey: "master")
    @Published var tenDaysChallenge: Bool = UserDefaults.standard.bool(forKey: "tenDaysChallenge")
    @Published var oneDay: Bool = UserDefaults.standard.bool(forKey: "oneDay")
    @Published var thirtyDays: Bool = UserDefaults.standard.bool(forKey: "thirtyDays")
    @Published var sixthysixDays: Bool = UserDefaults.standard.bool(forKey: "sixthysixDays")
    @Published var threeDaysOff: Bool = UserDefaults.standard.bool(forKey: "threeDaysOff")
    @Published var reed: Bool = UserDefaults.standard.bool(forKey: "reed")
    @Published var celeb: Bool = UserDefaults.standard.bool(forKey: "celeb")
    @Published var firstDayPost: Bool = UserDefaults.standard.bool(forKey: "firstDayPost")
    
    // MARK: - Save the status of badge
    func save(value: Bool = true, forkey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
}
