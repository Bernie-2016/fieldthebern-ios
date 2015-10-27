//
//  States.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

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