//
//  SDTimeDivision.swift
//  SDSwiftUtils
//
//  Created by zhou on 2020/4/16.
//  Copyright © 2020 zhou. All rights reserved.
//

import Foundation

public class example {
    var td: SDTimeDivision = SDTimeDivision(seconds: 3)
    
    func test() {
        for _ in 0..10 {
            td.timeDivision {
                print("我被分时了")
            }
        }
    }
    
}

example().test()
