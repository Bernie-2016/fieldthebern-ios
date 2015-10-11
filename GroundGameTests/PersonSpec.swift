//
//  PersonSpec.swift
//  GroundGame
//
//  Created by Josh Smith on 10/11/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import Quick
import Nimble

class PersonSpec: QuickSpec {
    override func spec() {
        var josh: Person!
        
        beforeEach {
            josh = Person(firstName: "Josh", lastName: "Smith", partyAffiliation: "Democrat", canvasResponse: CanvasResponse.LeaningFor)
        }
        
        describe("Person") {
            
            describe("init with properties manually") {
                
                it("has the right properties") {
                    expect(josh.id).to(beNil())
                    expect(josh.firstName).to(equal("Josh"))
                    expect(josh.lastName).to(equal("Smith"))
                    expect(josh.name).to(equal("Josh Smith"))
                    expect(josh.partyAffiliation).to(equal(PartyAffiliation.Democrat))
                    expect(josh.canvasResponseString).to(equal("Leaning for Bernie"))
                }
                
                it("has the right image") {
                    let joshImageData = UIImagePNGRepresentation(josh.partyAffiliationImage!)
                    let democratImageData = UIImagePNGRepresentation(PartyAffiliationImage.Democrat!)
                    expect(joshImageData).to(equal(democratImageData))
                }
            }
        }
    }
}