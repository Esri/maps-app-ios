//
//  MapViewController+ModeHistory.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapViewController {
    func updateModeHistory(newMode:MapViewMode?) {
        guard let newMode = newMode else {
            return
        }
        
        if !modeHistory.contains(newMode) {
            // If we're not at the latest entry in the results history, we want to forget everything after the current position.
            let numberOfRecordsToRemove = modeHistory.count-(modeIndex+1)
            modeHistory.removeLast(numberOfRecordsToRemove)
            
            // Now add the new value, and update the current index appropriately.
            modeHistory.append(newMode)
            modeIndex = modeHistory.count-1
        }
    }

    // MARK: Previous/Next mode logic
    var hasPreviousMode:Bool {
        return modeIndex > 0
    }
    
    var hasNextMode:Bool {
        return modeIndex < modeHistory.count-1
    }
    
    private func setPreviousMode() {
        modeIndex = previousModeIndex
    }
    
    private func setNextMode() {
        modeIndex = nextModeIndex
    }
    
    private var previousModeIndex:Int {
        return max(0, modeIndex-1)
    }
    
    private var nextModeIndex:Int {
        return min(modeIndex+1, modeHistory.count-1)
    }
    
    private var previousMode:MapViewMode? {
        guard hasPreviousMode else {
            return nil
        }
        return modeHistory[previousModeIndex]
    }
    
    private var nextMode:MapViewMode? {
        guard hasNextMode else {
            return nil
        }
        return modeHistory[nextModeIndex]
    }

    // MARK: Shake to "undo" mode change.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard hasPreviousMode || hasNextMode else {
            return
        }
        
        if motion == .motionShake {
            self.present(alertControllerForCurrentHistoryState, animated: true, completion: nil)
        }
    }
    
    var alertControllerForCurrentHistoryState:UIAlertController {
        let prevNextAlertController = UIAlertController(title: "Step to…", message: nil, preferredStyle: .alert)
        if let previousMode = previousMode {
            let previousAction = UIAlertAction(title: "Previous \(previousMode.shortHumanReadableDescription)", style: .default, handler: { _ in
                self.setPreviousMode()
                prevNextAlertController.dismiss(animated: true, completion: nil)
            })
            prevNextAlertController.addAction(previousAction)
        }
        
        if let nextMode = nextMode {
            let nextAction = UIAlertAction(title: "Next \(nextMode.shortHumanReadableDescription)", style: .default, handler: { _ in
                self.setNextMode()
                prevNextAlertController.dismiss(animated: true, completion: nil)
            })
            prevNextAlertController.addAction(nextAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { _ in
            prevNextAlertController.dismiss(animated: true, completion: nil)
        })
        prevNextAlertController.addAction(cancelAction)
        
        return prevNextAlertController
    }
    
    // MARK: Button UI
    @IBAction func previousMode(_ sender: UIButton) {
        setPreviousMode()
    }
    
    @IBAction func nextMode(_ sender: UIButton) {
        setNextMode()
    }
    
    func setModeHistoryUI() {
        guard modeHistory.count > 1 else {
            prevNextModeView.isHidden = true
            return
        }
        
        prevNextModeView.isHidden = false
        
        prevModeButton.isEnabled = hasPreviousMode
        nextModeButton.isEnabled = hasNextMode
    }
}
