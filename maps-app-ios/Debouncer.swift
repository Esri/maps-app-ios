//
//  Debouncer.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//
// Many thanks to @webadnan on GitHub
// See https://github.com/webadnan/swift-debouncer

import Foundation

class Debouncer: NSObject {
    var callback: (() -> ())
    var delay: Double
    weak var timer: Timer?
    
    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    func fireNow() {
        self.callback()
    }
}
