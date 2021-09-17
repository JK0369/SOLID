//
//  ColorModel.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/17.
//

import Foundation

struct ColorModel {
    enum ColorType: String {
        case blue = "blue"
        case red = "red"
    }
    let color: ColorType
    var currentBlueColor: Int = 0
    var currentRedColor: Int = 0
}
