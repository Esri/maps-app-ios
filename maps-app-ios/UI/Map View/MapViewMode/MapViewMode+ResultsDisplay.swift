// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    
    var extent:AGSEnvelope? {
        switch self {
        case .geocodeResult(let result):
            return result.extent ?? result.displayLocation?.extent
        case .routeResult:
            return envelopeForGraphics(graphics: self.graphics, expansionFactor: 1.2)
        default:
            return envelopeForGraphics(graphics: self.graphics)
        }
    }
    
    var focusExtent:AGSEnvelope? {
        switch self {
        case .geocodeResult(let result):
            return extent ?? result.displayLocation?.getSurroundingExtent(sizeInMeters: 400)
        default:
            return extent
        }
    }

    private func envelopeForGraphics(graphics:[AGSGraphic], expansionFactor:Double = 1) -> AGSEnvelope? {
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
}

extension AGSPoint {
    func getSurroundingExtent(sizeInMeters:Double) -> AGSEnvelope {
        let returnExtent = self.extent
        if returnExtent.width == 0 && returnExtent.height == 0,
            let outSR = returnExtent.spatialReference,
            let mercatorCenter = AGSGeometryEngine.projectGeometry(returnExtent.center, to: AGSSpatialReference.webMercator()),
            let buffer = AGSGeometryEngine.bufferGeometry(mercatorCenter, byDistance: sizeInMeters/2),
            let output = AGSGeometryEngine.projectGeometry(buffer.extent, to: outSR) as? AGSEnvelope {
            return output
        }
        return returnExtent
    }
}
