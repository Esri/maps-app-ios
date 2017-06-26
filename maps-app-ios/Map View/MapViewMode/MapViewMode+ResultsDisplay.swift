//
//  MapViewMode+ResultsDisplay.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/4/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewMode {
    var symbol:AGSSymbol? {
        switch self {
        case .routeResult:
            return AGSSimpleLineSymbol(style: .solid, color: UIColor.red, width: 2)
        case .geocodeResult:
            let symbol = AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "Location Pin"))
            symbol.offsetY = (symbol.image?.size.height ?? 0)/2
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
        case .routeResult(let result):
            if let extent = self.graphic?.geometry?.extent {
                let builder = extent.toBuilder()
                for stop in result.stops {
                    if let stopPoint = stop.geometry {
                        builder.union(with: stopPoint)
                    }
                }
                builder.expand(byFactor: 1.2)
                return builder.toGeometry()
            }
            fallthrough
        default:
            return self.graphic?.geometry?.extent
        }
    }
}
