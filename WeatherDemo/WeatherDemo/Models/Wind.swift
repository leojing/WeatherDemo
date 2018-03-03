//
//	Wind.swift
//
//	Create by Jing Luo on 3/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Wind : NSObject, NSCoding, Mappable{

	var deg : Int?
	var speed : Float?


	class func newInstance(map: Map) -> Mappable?{
		return Wind()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		deg <- map["deg"]
		speed <- map["speed"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         deg = aDecoder.decodeObject(forKey: "deg") as? Int
         speed = aDecoder.decodeObject(forKey: "speed") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if deg != nil{
			aCoder.encode(deg, forKey: "deg")
		}
		if speed != nil{
			aCoder.encode(speed, forKey: "speed")
		}

	}

}