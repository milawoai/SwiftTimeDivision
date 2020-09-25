//
//  SDDispatchSemaphoreWrapper.swift
//  SDSwiftUtils
//
//  Created by zhou on 2020/4/16.
//  Copyright © 2020 zhou. All rights reserved.
//

import Foundation

public struct SDDispatchSemaphoreWrapper {

    private let semaphore: DispatchSemaphore

    public init(withValue value: Int) {

        self.semaphore = DispatchSemaphore(value: value)
    }

    public func sync<R>(execute: () throws -> R) rethrows -> R {

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        defer {
            semaphore.signal()
            print("semaphore.signal()")
        }
        return try execute()
    }
}

