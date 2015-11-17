//
//  FTBOperation.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

//
// MARK: - Operation State
//

enum OperationState: Int {
    case Ready
    case Executing
    case Finished
    case Cancelled
}

//
// MARK: Base Operation
//

let StateKeyPath = "state"

class FTBOperation: NSOperation {
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> { return [StateKeyPath] }
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> { return [StateKeyPath] }
    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> { return [StateKeyPath] }
    class func keyPathsForValuesAffectingIsCancelled() -> Set<NSObject> { return [StateKeyPath] }
    
    override var executing: Bool { return state == .Executing }
    override var finished: Bool { return state == .Finished }
    override var cancelled: Bool { return state == .Cancelled }
    
    private var _state = OperationState.Ready
    var state: OperationState {
        get { return _state }
        set(newValue) {
            willChangeValueForKey(StateKeyPath)
            _state = newValue
            didChangeValueForKey(StateKeyPath)
        }
    }
    
    //
    // MARK: Lifecycle Methods
    //
    
    override var ready: Bool {
        switch state {
            case .Ready:
                return super.ready
            
            default:
                return false
        }
    }
    
    override func start() {
        let completionBlock = self.completionBlock
        self.completionBlock = { [weak self] in
            completionBlock?()
            self?.cleanup()
        }
    }
    
    //
    // MARK: Resource Methods
    //
    
    var dataTask: NSURLSessionDataTask?
    var queue = NSOperationQueue()
    
    override func cancel() {
        super.cancel()
        dataTask?.cancel()
        state = .Cancelled
    }
    
    func cleanup() {
        dataTask?.cancel()
        dataTask = nil
        queue.cancelAllOperations()
    }
}