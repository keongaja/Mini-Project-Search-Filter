//
//  extension.swift
//  searchFilter
//
//  Created by PPTSI-MBP on 12/03/18.
//  Copyright © 2018 Bobby Chandra Martonio. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


var q = ""
var pmax = 100000000
var pmin = 100
var pmaxPrice = 100000000 //jika ada return api max price di query
var pminPrice = 100 //jika ada return api min price di query
var wholesale = true
//var official = true
//var gold = true
var start = 0
var row = 10


extension Array where Element : Collection,
    Element.Iterator.Element : Equatable, Element.Index == Int {

    func indices(of x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.index(of: x) {
                return (i, j)
            }
        }
        return nil
    }
}

extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "id_ID")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double ))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        return formatter.string(from: number)!
    }

    func currencyToString() -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "id_ID")

        if let number = formatter.number(from: self) {
            let amount = number.decimalValue
            return String(describing: amount)
        } else {
            return "0"
        }
    }

}


extension UIViewController {

    func resetParam(){
        pmax = 100000000
        pmin = 100
        wholesale = true
        shopTypeList = [shopType(shop: "Gold Merchant", status: true),shopType(shop: "Officiak Store", status: true)]
//        official = true
//        gold = true
        start = 0
        row = 10
    }
    func getJSON(data: String) -> JSON {

        let data = data
        let dataFromString = data.data(using: .utf8, allowLossyConversion: false)
        var jsonData = JSON.null
        do {
            jsonData = try JSON(data: dataFromString!)
        } catch _ {
            
            //jsonData = nil
        }
        return jsonData
    }
}

extension UIView {

    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {

        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }

    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {

        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }

    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach({$0.isActive = true})

        return anchors
    }

}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


