//
//  VisitJSONSpec.swift
//  GroundGame
//
//  Created by Josh Smith on 10/13/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import Quick
import Nimble
import MapKit
import SwiftyJSON

class VistJSONSpec: QuickSpec {
    override func spec() {
        
        var person1: Person!
        var person2: Person!
        var address: Address!
        var json: JSON!
        
        describe("VisitJSON") {

            describe("with just one person") {
                
                beforeEach {
                    person1 = Person(firstName: "Josh", lastName: "Smith", partyAffiliation: "Democrat", canvasResponse: CanvasResponse.LeaningFor)
                    address = Address(latitude: 32.752768, longitude: -117.116992, street1: "4166 Wilson Ave", street2: "1", city: "San Diego", stateCode: "CA", zipCode: "92104", result: .NotHome)
                    json = VisitJSON(duration: 1, address: address, people: [person1]).json
                }
                
                it("has the right number of included") {
                    expect(json["included"].count).to(equal(2))
                }
                
                it("has the right attributes for the address") {
                    let addressAttributes = json["included"][1]["attributes"]
                    
                    expect(addressAttributes["latitude"]).to(equal(32.752768))
                    expect(addressAttributes["longitude"]).to(equal(-117.116992))
                    expect(addressAttributes["street_1"]).to(equal("4166 Wilson Ave"))
                    expect(addressAttributes["street_2"]).to(equal("1"))
                    expect(addressAttributes["city"]).to(equal("San Diego"))
                    expect(addressAttributes["state_code"]).to(equal("CA"))
                    expect(addressAttributes["zip_code"]).to(equal("92104"))
                }
                
                it("has the right attributes for the person") {
                    let personAttributes = json["included"][0]["attributes"]
                    
                    expect(personAttributes["first_name"]).to(equal("Josh"))
                    expect(personAttributes["last_name"]).to(equal("Smith"))
                    expect(personAttributes["party_affiliation"]).to(equal("Democrat"))
                    expect(personAttributes["canvas_response"]).to(equal("Leaning for"))
                }
            }
            
            
            describe("with more than one person") {
                
                beforeEach {
                    person1 = Person(firstName: "Josh", lastName: "Smith", partyAffiliation: "Democrat", canvasResponse: CanvasResponse.LeaningFor)
                    person2 = Person(firstName: "Molly", lastName: "Smith", partyAffiliation: "Democrat", canvasResponse: CanvasResponse.LeaningFor)
                    address = Address(latitude: 32.752768, longitude: -117.116992, street1: "4166 Wilson Ave", street2: "1", city: "San Diego", stateCode: "CA", zipCode: "92104", result: .NotHome)
                    json = VisitJSON(duration: 1, address: address, people: [person1, person2]).json
                }
                
                it("has the right number of included") {
                    expect(json["included"].count).to(equal(3))
                }
            }
        }
    }
}