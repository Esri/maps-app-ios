//
//  URL+QueryString.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension URLComponents {
    func queryParameter(named name:String) -> String? {
        return self.queryItems?.filter({ $0.name == name }).first?.value
    }
}

extension URL {
    func queryParameter(named name:String) -> String? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        return components?.queryParameter(named:name)
    }
}
