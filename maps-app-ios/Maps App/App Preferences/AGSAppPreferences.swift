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
    
    func getURL<K:RawRepresentable>(forKey key:K) -> URL? where K.RawValue == String {
        return AppSettings.preferencesStore.url(forKey: key.rawValue)
    }
    
    func getBool<K:RawRepresentable>(forKey key:K) -> Bool? where K.RawValue == String {
        return AppSettings.preferencesStore.bool(forKey: key.rawValue)
    }
    
    func getDouble<K:RawRepresentable>(forKey key:K) -> Double? where K.RawValue == String {
        return AppSettings.preferencesStore.double(forKey: key.rawValue)
    }
    
    func getFloat<K:RawRepresentable>(forKey key:K) -> Float? where K.RawValue == String {
        return AppSettings.preferencesStore.float(forKey: key.rawValue)
    }
    
    func getInt<K:RawRepresentable>(forKey key:K) -> Int? where K.RawValue == String {
        return AppSettings.preferencesStore.integer(forKey: key.rawValue)
    }
    
    func get<K:RawRepresentable>(forKey key:K) -> Any? where K.RawValue == String {
        return AppSettings.preferencesStore.object(forKey: key.rawValue)
    }
    
    func set<K:RawRepresentable>(value: Any?, forKey key:K) where K.RawValue == String {
        if let url = value as? URL {
            AppSettings.preferencesStore.set(url, forKey: key.rawValue)
        } else if let bool = value as? Bool {
            AppSettings.preferencesStore.set(bool, forKey: key.rawValue)
        } else if let double = value as? Double {
            AppSettings.preferencesStore.set(double, forKey: key.rawValue)
        } else if let float = value as? Float {
            AppSettings.preferencesStore.set(float, forKey: key.rawValue)
        } else if let anInt = value as? Int {
            AppSettings.preferencesStore.set(anInt, forKey: key.rawValue)
        } else {
            AppSettings.preferencesStore.set(value, forKey: key.rawValue)
        }
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
