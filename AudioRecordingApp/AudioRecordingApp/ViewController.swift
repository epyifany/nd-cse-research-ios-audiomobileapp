//
//  ViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/13/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit
import CoreMedia
//var numberOfRecords: Int = 0

class ViewController: UIViewController {

    public struct Recording: Codable {
        public var filename: String?
        public var AudioID: String?
        public var Tag: String?
        public var Length: String?
        public var Size: String?
        public var SoundType: String?
        public var url: String?
        public var Date: String?
        public var Time: String?
    //        "AudioID": audioID,
    //        "Tag": Tag,
    //        "Length": Length,
    //        "Size": Size,
    //        "Type": Type,
    //        "url": url,
    //        "Date": date,
    //        "Time": uptime
    }

    
    public struct Units {
        
        public let bytes: Int64
        
        public var kilobytes: Double {
            return Double(bytes) / 1_024
        }
        
        public var megabytes: Double {
            return kilobytes / 1_024
        }
        
        public var gigabytes: Double {
            return megabytes / 1_024
        }
        
        public init(bytes: Int64) {
            self.bytes = bytes
        }
        //https://gist.github.com/fethica/52ef6d842604e416ccd57780c6dd28e6
        public func getReadableUnit() -> String {
            
            switch bytes {
            case 0..<1_024:
                return "\(bytes) bytes"
            case 1_024..<(1_024 * 1_024):
                return "\(String(format: "%.2f", kilobytes)) kb"
            case 1_024..<(1_024 * 1_024 * 1_024):
                return "\(String(format: "%.2f", megabytes)) mb"
            case (1_024 * 1_024 * 1_024)...Int64.max:
                return "\(String(format: "%.2f", gigabytes)) gb"
            default:
                return "\(bytes) bytes"
            }
        }
    }
    
    
    
    
//    public var returnFileTags: [String]{
//        return self.FileTags
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

