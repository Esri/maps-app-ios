//
//  AppPreferences.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class AGSAppPreferences: NSObject {
    func getAGS<T:AGSJSONSerializable>(type:T.Type, forKey key:AGSAppPreferenceKey) -> T? {
        if let json = UserDefaults.standard.object(forKey: key.rawValue) {
            do {
                let agsObject = try T.fromJSON(json) as! T
                return agsObject
            } catch {
                print("Unable to create \(T.self) object from preference \"\(key)\"! \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func setAGS<T:AGSJSONSerializable>(agsObject:T?, withKey key:AGSAppPreferenceKey) {
        if agsObject == nil {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            return
        }
        
        if let agsLoadableObject = agsObject as? AGSLoadable {
            agsLoadableObject.load() { error in
                guard error == nil else {
                    print("Error loading the \(T.self) while waiting to serialize to preference \"\(key)!\" \(error!.localizedDescription)")
                    return
                }
                
                self.writeToPreferences(agsObject: agsObject!, withKey: key.rawValue)
            }
        } else {
            self.writeToPreferences(agsObject: agsObject!, withKey: key.rawValue)
        }
    }
    
    func get(forKey key:AGSAppPreferenceKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func set(value: Any?, forKey key:AGSAppPreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private func writeToPreferences<T:AGSJSONSerializable>(agsObject:T, withKey key:String) {
        do {
            let json = try agsObject.toJSON()
            UserDefaults.standard.set(json, forKey: key)
        } catch {
            print("Unable to save item \(T.self) to preference \"\(key)\"! \(error.localizedDescription)")
        }
    }
}
