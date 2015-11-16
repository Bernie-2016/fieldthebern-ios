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
import SwiftyJSON

class PersonSpec: QuickSpec {
    override func spec() {
        
        var josh: Person!
        
        describe("Person") {
            
            describe("init with JSON") {
                var json: JSON!
                
                beforeEach {
                    let testBundle = NSBundle(forClass: self.dynamicType)
                    if let path = testBundle.pathForResource("Person", ofType: "json") {
                        print(path)
                        do {
                            let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)

                            json = JSON(data: data)
                            
                            josh = Person(json: json)
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
                
                it("has the right properties") {
                    expect(josh.id).to(equal("1"))
                    expect(josh.firstName).to(equal("Josh"))
                    expect(josh.lastName).to(equal("Smith"))
                    expect(josh.name).to(equal("Josh Smith"))
                    expect(josh.partyAffiliation).to(equal(PartyAffiliation.Democrat))
                    expect(josh.canvassResponseString).to(equal("Leaning for Bernie"))
                }
            
            }
            
            describe("init with properties manually") {
        
                beforeEach {
                    josh = Person(firstName: "Josh", lastName: "Smith", partyAffiliation: "Democrat", canvassResponse: CanvassResponse.LeaningFor)
                }

                it("has the right properties") {
                    expect(josh.id).to(beNil())
                    expect(josh.firstName).to(equal("Josh"))
                    expect(josh.lastName).to(equal("Smith"))
                    expect(josh.name).to(equal("Josh Smith"))
                    expect(josh.partyAffiliation).to(equal(PartyAffiliation.Democrat))
                    expect(josh.canvassResponseString).to(equal("Leaning for Bernie"))
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