//
//  Fetch.swift
//  Haneke
//
//  Created by Hermes Pique on 9/28/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import Foundation

enum FetchState<T> {
    case pending
    case success(T)
    case failure(Error?)
}

public class Fetch<T> {
    
    public typealias Succeeder = (T) -> ()
    
    public typealias Failer = (Error?) -> ()
    
    private var onSuccess : Succeeder?
    
    private var onFailure : Failer?
    
    private var state : FetchState<T> = .pending
    
    public init() {}
    
    @discardableResult
    public func onSuccess(_ onSuccess: @escaping Succeeder) -> Self {
        self.onSuccess = onSuccess
        switch self.state {
        case FetchState.success(let value):
            onSuccess(value)
        default:
            break
        }
        return self
    }
    
    @discardableResult
    public func onFailure(_ onFailure: @escaping Failer) -> Self {
        self.onFailure = onFailure
        switch self.state {
        case .failure(let error):
            onFailure(error)
        default:
            break
        }
        return self
    }
    
    func succeed(_ value: T) {
        self.state = .success(value)
        self.onSuccess?(value)
    }
    
    func fail(_ error: Error? = nil) {
        self.state = .failure(error)
        self.onFailure?(error)
    }
    
    var hasFailed : Bool {
        switch self.state {
        case .failure(_):
            return true
        default:
            return false
            }
    }
    
    var hasSucceeded : Bool {
        switch self.state {
        case .success(_):
            return true
        default:
            return false
        }
    }
}
