//
//  TrayIcon.swift
//  Dragon Drop
//
//  Created by Ish on 6/14/17.
//  Copyright © 2017 Illuminated Bits LLC. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices



class TrayIcon:NSObject,NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(type.rawValue, forKey:"type")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.image = aDecoder.decodeObject(forKey: "image") as? UIImage
        self.title = aDecoder.decodeObject(forKey: "title") as? NSString
        if let rawType = aDecoder.decodeObject(forKey:"type") as? String{
            
         self.type = ModuleType(rawValue: rawType) ?? .unknown
        }
        else{
            self.type = .unknown
        }
    }
    
    
    
    
    
    var image:UIImage?
    var title:NSString?
    var type:ModuleType
    
    init(image:UIImage?, name:NSString, type:ModuleType) {
        self.image = image ?? UIImage()
        self.title = name
        self.type = type
        super.init()
        
    }
    
    required init(itemProviderData data: Data, typeIdentifier: String) throws {
        self.type = .unknown
        super.init()
        setTrayIcon(with: data)
    }
    
    func setTrayIcon(with data:Data){
        if let obj =  NSKeyedUnarchiver.unarchiveObject(with: data) as? TrayIcon{
        self.image = obj.image
        self.title = obj.title
        self.type = obj.type
        }
    }
}


extension TrayIcon:NSItemProviderWriting{
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [CapsicumDataType.trayIcon]
        
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        switch typeIdentifier {
        case CapsicumDataType.trayIcon:
            let d = createTrayIcon()
            completionHandler(d, nil)
        case kUTTypeUTF8PlainText as NSString as String:
            completionHandler(String(title!).data(using: .utf8),nil)
            
        default:
            completionHandler(createTrayIcon(), nil)
            
        }
        return nil
    }
    
    func createTrayIcon() -> Data?{
        
      let data =   NSKeyedArchiver.archivedData(withRootObject: self)
        return data
    }
    
}

extension TrayIcon:NSItemProviderReading{
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [CapsicumDataType.trayIcon]
    }
    
    
}
