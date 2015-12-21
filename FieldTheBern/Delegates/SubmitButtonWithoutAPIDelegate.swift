//
//  SubmitButtonWithoutAPIDelegate.swift
//  FieldTheBern
//
//  Created by Josh Smith on 12/20/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

protocol SubmitButtonWithoutAPIDelegate {
    func isSubmitting()
    func finishedSubmittingWithError(errorTitle: String, errorMessage: String)
}