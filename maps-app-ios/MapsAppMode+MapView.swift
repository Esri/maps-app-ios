//
//  MapsAppMode+MapView.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/4/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppMode {
    var symbol:AGSSymbol? {
        switch self {
        case .routeResult:
            return AGSSimpleLineSymbol(style: .solid, color: UIColor.red, width: 2)
        case .geocodeResult:
            let symbol = AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "Red Pin"))
            symbol.offsetY = #imageLiteral(resourceName: "Red Pin").size.height/2
            return symbol
        default:
            return nil
        }
    }
    
    var graphic:AGSGraphic? {
        switch self {
        case .geocodeResult(let result):
            return AGSGraphic(geometry: result.displayLocation, symbol: self.symbol, attributes: nil)
        case .routeResult(let result):
            return AGSGraphic(geometry: result.routeGeometry, symbol: self.symbol, attributes: nil)
        default:
            return nil
        }
    }
    
    var extent:AGSEnvelope? {
        switch self {
        case .geocodeResult(let result):
            return result.extent
        default:
            return self.graphic?.geometry?.extent
        }
    }
}
