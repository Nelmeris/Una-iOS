//
//  DifficultyLevel.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

enum DifficultyLevel: String {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    case c2 = "C2"
    
    func description() -> String {
        switch self {
        case .a1:
            return "Элементарный"
        case .a2:
            return "Предпороговый"
        case .b1:
            return "Пороговый"
        case .b2:
            return "Постпороговый"
        case .c1:
            return "Комплементарное владение"
        case .c2:
            return "Носитель"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .a1:
            return UIColor(named: "LevelA1Color")!
        case .a2:
            return UIColor(named: "LevelA2Color")!
        case .b1:
            return UIColor(named: "LevelB1Color")!
        case .b2:
            return UIColor(named: "LevelB2Color")!
        case .c1:
            return UIColor(named: "LevelC1Color")!
        case .c2:
            return UIColor(named: "LevelC2Color")!
        }
    }
    
}
