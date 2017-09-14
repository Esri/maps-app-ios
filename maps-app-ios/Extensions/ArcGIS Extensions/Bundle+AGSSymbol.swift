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
