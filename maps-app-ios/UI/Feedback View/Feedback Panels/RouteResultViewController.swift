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

class RouteResultViewController : UIViewController, AGSRouteTrackerDelegate {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    var previewNextManuever = false
    var displayManueverIndex = 0
    var traversedRouteOverlay = AGSGraphicsOverlay()
    
    var prevManueverIndex = 0
    var route:AGSRoute? {
        didSet {
            // Here we want to set the route results.
            if let result = route {
                if let from = result.stops.first {
                    self.fromLabel.text = from.name
                }
                
                if let to = result.stops.last {
                    self.toLabel.text = to.name
                }

                let time = durationFormatter.string(from: result.totalTime*60) ?? ""
                
                let distance = distanceFormatter.string(from: Measurement(value: result.totalLength, unit: UnitLength.meters))
                
                self.summaryLabel.text = "\(distance) ∙ \(time)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapsAppNotifications.observeRouteSolvedNotification(owner: self) { [weak self] route in
            self?.route = route
        }
        
        traversedRouteOverlay.renderer = AGSSimpleRenderer(symbol: AGSSimpleLineSymbol(style: .solid, color: .gray, width: 5))
    }
    
    deinit {
        MapsAppNotifications.deregisterNotificationBlocks(forOwner: self)
    }

    @IBAction func summaryTapped(_ sender: Any) {
        MapsAppNotifications.postMapViewResetExtentForModeNotification()
    }
    
    private lazy var durationFormatter:DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        formatter.allowsFractionalUnits = false
        return formatter
    }()
    
    private lazy var distanceFormatter:MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .long
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()
    
    
    @IBAction func navigate(_ sender: Any) {
        
        
        guard let mapView = mapsAppContext.currentMapView,
            let routeResult = mapsAppContext.routeResult else {
            return
        }
        
        //Setup route tracker
        if let routeTracker = AGSRouteTracker(routeResult: routeResult, routeIndex: 0) {

            routeTracker.voiceGuidanceUnitSystem = .imperial
            routeTracker.delegate = self
        
            //Simulate location based on GPX
            mapView.locationDisplay.stop()
            mapView.locationDisplay.autoPanMode = .navigation
            let gpxDS = AGSGPXLocationDataSource(name: "nav")
            mapView.locationDisplay.dataSource = gpxDS
            mapView.locationDisplay.start(completion: nil)
            
            //For location updates....
            mapView.locationDisplay.locationChangedHandler = {
                location in
                //update route tracker
                routeTracker.trackLocation(location, completion: nil)
            }

            traversedRouteOverlay = AGSGraphicsOverlay()
            traversedRouteOverlay.renderer = AGSSimpleRenderer(symbol: AGSSimpleLineSymbol(style: .solid, color: .gray, width: 5))
            mapView.graphicsOverlays.add(traversedRouteOverlay)
        }


    }

    //AGSRouteTrackerDelegate

    //Handle route tracker updates to refresh Manuever & Destination display
    func routeTracker(_ routeTracker: AGSRouteTracker, didUpdate trackingStatus: AGSTrackingStatus) {
        
        //Update Manuever display (direction & distance)
        let maneuverDistance = trackingStatus.maneuverProgress.remainingDistance
        let displayManueverIndex = manueverIndex(for: trackingStatus)
        MapsAppNotifications.postNextManeuverNotification(manueverIndex: IndexPath(row: displayManueverIndex, section: 0), text:text(for:maneuverDistance))

        
        //Update Destination display (distance & time)
        let remainingDestDistance = trackingStatus.routeProgress.remainingDistance
        let remainingDestTime = trackingStatus.routeProgress.remainingTime
        self.summaryLabel.text = text(forDistance:remainingDestDistance,time: remainingDestTime)
        
        //gray out the travelled route
        updateTraveledRoute(trackingStatus.routeProgress.traversedGeometry)
    }
   
    //Speak voice guidance provided by route tracker
    func routeTracker(_ routeTracker: AGSRouteTracker, didGenerateNewVoiceGuidance voiceGuidance: AGSVoiceGuidance) {
        
        let utterance = AVSpeechUtterance(string: voiceGuidance.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        //Manage display of approaching manuever
        if(voiceGuidance.type == .approachingManeuver){
            previewNextManuever = true
        }

        
    }
    
    
    //handle re-routing
    func routeTrackerRerouteDidStart(_ routeTracker: AGSRouteTracker) {
        //TODO
    }

    func routeTracker(_ routeTracker: AGSRouteTracker, rerouteDidCompleteWith trackingStatus: AGSTrackingStatus?, error: Error?) {
        //TODO
    }
    
    fileprivate func text(for remainingManeuverDistance: AGSTrackingDistance) -> String {
        return remainingManeuverDistance.displayText + " " +  remainingManeuverDistance.displayTextUnits.abbreviation + "."
    }
    
    fileprivate func text(forDistance remainingDestinationDistance: AGSTrackingDistance, time remainingDestinationTime: Double) -> String {
        return remainingDestinationDistance.displayText + " " + remainingDestinationDistance.displayTextUnits.abbreviation + " ∙ " + (durationFormatter.string(from: remainingDestinationTime*60) ?? "")
    }
    
    fileprivate func manueverIndex(for trackingStatus: AGSTrackingStatus) -> Int{
        // MARK: manage manueverIndex
        if(self.prevManueverIndex < trackingStatus.currentManeuverIndex){
            self.previewNextManuever = false
        }
        let displayManueverIndex = trackingStatus.currentManeuverIndex + (self.previewNextManuever ? 1 : 0)
        self.prevManueverIndex = displayManueverIndex
        return displayManueverIndex
    }
    
    fileprivate func updateTraveledRoute(_ geometry: AGSGeometry) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.traversedRouteOverlay.graphics.removeAllObjects()
            self.traversedRouteOverlay.graphics.add(AGSGraphic(geometry: geometry, symbol: nil, attributes: nil))        }
        
    }
    

}


