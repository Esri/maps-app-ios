//
//  AppPreferences.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class AGSAppPreferences: NSObject {
    func getAGS<T:AGSJSONSerializable, K:RawRepresentable>(type:T.Type, forKey key:K) -> T? where K.RawValue == String {
        if let json = AppSettings.preferencesStore.object(forKey: key.rawValue) {
            do {
                let agsObject = try T.fromJSON(json) as! T
                return agsObject
            } catch {
                print("Unable to create \(T.self) object from preference \"\(key)\"! \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func setAGS<T:AGSJSONSerializable, K:RawRepresentable>(agsObject:T?, withKey key:K) where K.RawValue == String {
        if agsObject == nil {
            AppSettings.preferencesStore.removeObject(forKey: key.rawValue)
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
    
    func get<K:RawRepresentable>(forKey key:K) -> Any? where K.RawValue == String {
        return AppSettings.preferencesStore.object(forKey: key.rawValue)
    }
    
    func set<K:RawRepresentable>(value: Any?, forKey key:K) where K.RawValue == String {
        AppSettings.preferencesStore.set(value, forKey: key.rawValue)
    }
    
    private func writeToPreferences<T:AGSJSONSerializable>(agsObject:T, withKey key:String) {
        do {
            let json = try agsObject.toJSON()
            AppSettings.preferencesStore.set(json, forKey: key)
        } catch {
            print("Unable to save item \(T.self) to preference \"\(key)\"! \(error.localizedDescription)")
        }
    }
}
