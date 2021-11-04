//
//  UIFont+Extensions.swift
//  Carsales
//
//  Created by Steven Layug on 1/11/21.
//

import Foundation
import UIKit

public extension UIFont {
    static func primaryFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func primaryFontSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
