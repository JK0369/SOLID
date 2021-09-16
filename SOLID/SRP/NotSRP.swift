//
//  NotSRP.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/16.
//

import Foundation
/*
class Employee {
    
    enum WorkType {
        case finance // 재무
        case human // 인사
        case development // 개발
    }
    let workType: WorkType

    init(workType: WorkType) {
        self.workType = workType
    }
}

class Calculator {

    static var calculatedHour: Int?

    /// 업무 시간을 계산해서, 회계팀장에게 보고
    static func calculatePay() {
        let workTime = regularHours()
        calculatedHour = workTime
        let pay = workTime * 1000

        print("report \(pay) to CFO")
    }

    /// 업무 시간을 계산해서, 인사팀장에게 보고
    static func reportHours() {
        let workTime = regularHours()
        calculatedHour = workTime

        print("report \(workTime) to COO")
    }

    /// 현재 계산된 업무시간을 DB에 저장
    static func save() {
        guard let calculatedHour = calculatedHour else { return }

        print("save \(calculatedHour) to DB")
    }

    /// 초과 근무를 제외한 업무 시간을 계산하는 메소드 (코드의 중복을 피하기 위한 편의 함수)
    static private func regularHours() -> Int {
        return Int.random(in: (0...100))
    }
}
*/
