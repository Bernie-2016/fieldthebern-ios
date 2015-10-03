//
//  AddressPointAnnotation.swift
//  GroundGame
//
//  Created by Josh Smith on 10/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

struct PinImage {
    static let Blue = UIImage(named: "blue-pin")
    static let Gray = UIImage(named: "grey-pin")
    static let LightBlue = UIImage(named: "light-blue-pin")
    static let Pink = UIImage(named: "pink-pin")
    static let Red = UIImage(named: "red-pin")
    static let White = UIImage(named: "white-pin")
}

class AddressPointAnnotation: MKPointAnnotation {
    
    var id: String?
    var result: VisitResult?
    
    var image: UIImage? {
        get {
            if let result = result {
                switch result {
                case .NotVisited:
                    return PinImage.Gray
                case .NotSure:
                    return PinImage.White
                case .NotInterested:
                    return PinImage.Red
                case .Interested:
                    return PinImage.Blue
                default:
                    return PinImage.Gray
                }
            } else {
                return nil
            }
        }
    }

}
