//
//  ViewController.swift
//  AudioRecordingApp
//
//  Created by John Smith on 3/13/19.
//  Copyright © 2019 NDCSE. All rights reserved.
//

import UIKit

//var numberOfRecords: Int = 0

class ViewController: UIViewController {

//    var FileTags = Array(repeating: "Edit Tag", count: 5)
    
    
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

