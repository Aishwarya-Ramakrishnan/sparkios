// Copyright 2016 Cisco Systems Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import ObjectMapper

struct MediaCluster: Mappable {
    var statusCode: Int?
    var group: [String /* media cluster tag */ : [String /* transport */ : [String] /* transport address */ ]]?
    
    init?(_ map: Map){
    }
    
    mutating func mapping(map: Map) {
        statusCode <- map["statusCode"]
        group <- map["clusters"]
    }
}