//
//  MapViewMode+ResultsDisplay.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/4/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

enum StopType {
    case first
    case waypoint
    case last
    
    var symbol:AGSMarkerSymbol {
        var image:UIImage!
        
        switch self {
        case .first:
            image = #imageLiteral(resourceName: "Route Start Pin")
        case .waypoint:
            image = #imageLiteral(resourceName: "Route Waypoint Pin")
        case .last:
            image = #imageLiteral(resourceName: "Route End Pin")
        }

        let pms = AGSPictureMarkerSymbol(image: image)
        pms.offsetY = image.size.height/2
        
        return pms
    }
}

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
    
    var graphics:[AGSGraphic] {
        switch self {
        case .geocodeResult(let result):
            return [AGSGraphic(geometry: result.displayLocation, symbol: self.symbol, attributes: nil)]
        case .routeResult(let result):
            var graphics:[AGSGraphic] = [
                AGSGraphic(geometry: result.routeGeometry, symbol: self.symbol, attributes: nil)
            ]
            
            for stop in result.stops {
                let type:StopType = stop == result.stops.first ? .first : (stop == result.stops.last ? .last : .waypoint)
                let graphic = AGSGraphic(geometry: stop.geometry, symbol: type.symbol, attributes: nil)
                graphics.append(graphic)
            }
            
            return graphics
        default:
            return []
        }
    }
    
    func envelopeForGraphics(graphics:[AGSGraphic], expansionFactor:Double = 1) -> AGSEnvelope? {
        let geoms = graphics.flatMap({ graphic -> AGSGeometry? in
            return graphic.geometry
        })
        if let builder = geoms.first?.extent.toBuilder() {
            for geom in geoms.dropFirst() {
                builder.union(with: geom.extent)
            }
            builder.expand(byFactor: expansionFactor)
            return builder.toGeometry()
        }
        return nil
    }
    
    var extent:AGSEnvelope? {
        switch self {
        case .geocodeResult(let result):
            return result.extent
        case .routeResult:
             return envelopeForGraphics(graphics: self.graphics, expansionFactor: 1.2)
        default:
            return envelopeForGraphics(graphics: self.graphics)
        }
    }
}
