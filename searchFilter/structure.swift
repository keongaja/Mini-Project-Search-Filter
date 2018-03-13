//
//  structure.swift
//  searchFilter
//
//  Created by PPTSI-MBP on 12/03/18.
//  Copyright © 2018 Bobby Chandra Martonio. All rights reserved.
//

import UIKit

let shopTypeList = ["Gold Merchan","Officiak Store"]

struct shop {
    var id : String
    var name : String
    var uri : String
    var is_gold : String
    var rating : String
    var location : String
    var reputation_image_uri : String
    var shop_lucky : String
    var city : String
}

struct badges {
    var title : String
    var uri : String
}

struct dataProduk {
    var name : String
    var uri : String
    var image_uri : String
    var image_uri_700 : String
    var price : String
    var shop : shop
    var condition : String
    var preorder : String
    var department_id : String
    var count_review : String
    var count_talk : String
    var count_sold : String
    var badges : badges
    var original_price : String
    var discount_expired : String
    var discount_percentage : String
    var stock : String
}

