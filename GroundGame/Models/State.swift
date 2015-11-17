//
//  State.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct State {
    
    var name: String?
    var type: String?
    var status: String?
    var only17: String?
    var date: String?
    var deadline: String?
    var details: String?
    var code: String?
    var icon: UIImage?

    init(state: NSDictionary) {
        self.name = state["state"] as? String
        self.type = state["type"]as? String
        self.status = state["status"] as? String
        self.only17 = state["only_17"] as? String
        self.date = state["date"] as? String
        self.deadline = state["deadline"] as? String
        self.details = state["details"] as? String
        self.code = state["code"] as? String
        
        if let iconName = state["state"] as? String {
            self.icon = UIImage(named: iconName)
        }
    }
}