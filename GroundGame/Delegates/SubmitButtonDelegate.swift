//
//  SubmitButtonDelegate.swift
//  GroundGame
//
//  Created by Josh Smith on 10/14/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

protocol SubmitButtonDelegate {
    func isSubmitting()
    func finishedSubmittingWithError(error: APIError)
}