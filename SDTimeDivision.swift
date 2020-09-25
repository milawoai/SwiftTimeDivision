//
//  SDTimeDivision.swift
//  SDSwiftUtils
//
//  Created by zhou on 2020/4/16.
//  Copyright © 2020 zhou. All rights reserved.
//

import Foundation

public class SDTimeDivision {
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)

    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var divisionTime: Int
    fileprivate let semaphore: SDDispatchSemaphoreWrapper
    fileprivate let execSemaphore: SDDispatchSemaphoreWrapper
    private var execQueue: [() -> Void]?

    public init(seconds: Int) {
        self.divisionTime = seconds
        self.semaphore = SDDispatchSemaphoreWrapper(withValue: 1)
        self.execSemaphore = SDDispatchSemaphoreWrapper(withValue: 1)
    }

    deinit {
        execQueue = nil
        //todo 干掉执行队列
    }

   public func timeDivision(block: @escaping () -> Void) {
        self.semaphore.sync { () -> Void in
            if execQueue == nil || execQueue?.count ?? 0 <= 0 {
                execQueue = [block]
                startExecQueue()
            } else {
                execQueue?.append(block)
            }
        }
    }

   public func startExecQueue() {
        self.execSemaphore.sync { () -> Void in
            job.cancel()
            if execQueue == nil || execQueue?.count ?? 0 <= 0 {
                return
            }
            if let block =  execQueue?.removeFirst() {
                block()
            }
            if execQueue == nil || execQueue?.count ?? 0 <= 0 {
                return
            }
            job = DispatchWorkItem { [weak self] in
                self?.startExecQueue()
            }
            queue.asyncAfter(deadline: .now() + Double(divisionTime), execute: job)
        }
    }
}
