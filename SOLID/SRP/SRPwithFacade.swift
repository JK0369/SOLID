//
//  SRPwithFacade.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/16.
//

import Foundation

class Employee {
    enum WorkType {
        case finance // 재무
        case human // 인사
        case development // 개발
    }
    let workType: WorkType
    let data: Data
    let employeeFacade: EmployeeFacade

    init(workType: WorkType, data: Data) {
        self.workType = workType
        self.data = data
        self.employeeFacade = EmployeeFacade(payCalculator: PayCalculator(data: data),
                                             hourReporter: HourReporter(data: data),
                                             employeeSaver: EmployeeSaver(data: data))
    }
}

class EmployeeFacade {

    private let payCalculator: PayCalculator
    private let hourReporter: HourReporter
    private let employeeSaver: EmployeeSaver

    init(payCalculator: PayCalculator, hourReporter: HourReporter, employeeSaver: EmployeeSaver) {
        self.payCalculator = payCalculator
        self.hourReporter = hourReporter
        self.employeeSaver = employeeSaver
    }

    func calculatePay() {
        payCalculator.calculatePay()
    }

    func reportHours() {
        hourReporter.reportHours()
    }

    func save() {
        employeeSaver.save()
    }
}

class PayCalculator {

    var data: Data

    init(data: Data) {
        self.data = data
    }

    /// 업무 시간을 계산해서, 회계팀장에게 보고
    func calculatePay() {
        let workTime = Int.random(in: (0...100))
        let pay = workTime * 1000
        data.calculatedHourByPay = pay

        print("report \(pay) to CFO")
    }
}

class HourReporter {

    var data: Data

    init(data: Data) {
        self.data = data
    }

    /// 업무 시간을 계산해서, 인사팀장에게 보고
    func reportHours() {
        let workTime = Int.random(in: (0...100))
        data.calculatedHourByHour = workTime

        print("report \(workTime) to COO")
    }
}

class EmployeeSaver {

    var data: Data

    init(data: Data) {
        self.data = data
    }

    /// 현재 계산된 업무시간을 DB에 저장
    func save() {
        print("save \(data.calculatedHourByPay), \(data.calculatedHourByHour) to DB")
    }
}

class Data {
    var calculatedHourByPay: Int?
    var calculatedHourByHour: Int?
}

func main() {
    let data = Data()

    let financer = Employee(workType: .finance, data: data)
    financer.employeeFacade.calculatePay()

    let `operator` = Employee(workType: .human, data: data)
    `operator`.employeeFacade.reportHours()

    let developer = Employee(workType: .development, data: data)
    developer.employeeFacade.save()
}
