//
//  StructCollection.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/24/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation
import UIKit

struct frequencyData {
    let label: String!
    let code: String!
    let value: Float32!
}

struct categoryData {
    let label: String!
    let code: String!
    let value: Float32!
}

struct paymentData {
    let label: String!
    let value: Any!
    let format: String!
}

struct cellData {
    let cell: String!
    let code: String!
    let label: String!
    
}

struct tableCellData {
    let label: String!
    let value: String!
    let cellType: String!
}


func inputFieldIconConfig(textField: UITextField,icon_name: String ){
    let imageView = UIImageView(frame: CGRect(x:0, y: 0, width:50, height: textField.frame.size.height))
    imageView.image = UIImage(named: icon_name)
    imageView.contentMode = .center
    textField.leftView = imageView
    textField.leftViewMode = .always
}
