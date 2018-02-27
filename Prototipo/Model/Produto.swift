//
//  Produto.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 27/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import Foundation
import RealmSwift

class Produto : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var state : Bool = false
    
}

