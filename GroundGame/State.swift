//
//  State.swift
//  GroundGame
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import Dollar

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

struct States {
    private var list: [State]? = []
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("Primaries", ofType: "plist") {
            if let states = NSArray(contentsOfFile: path) {
                for stateInfo in states {
                    if let stateInfoDictionary = stateInfo as? NSDictionary {
                        let state = State(state: stateInfoDictionary)
                        self.list?.append(state)
                    }
                }
                return
            }
        }
        self.list = nil
    }
    
    func find(string: String) -> State? {
        if let states = self.list {
            for state in states {
                if state.code == string {
                    return state
                }
            }
        }
        return nil
    }

}