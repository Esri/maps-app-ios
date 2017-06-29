//
//  Bundle+AGSSymbol.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension Bundle {
    func agsSymbolFromJSON(resourceNamed name:String) -> AGSSymbol? {
        if let path = self.path(forResource: name, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary,
                   let symbol = try AGSSymbol.fromJSON(json) as? AGSSymbol {
                    return symbol
                }
            } catch {
                print("Error loading/parsing the JSON: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
