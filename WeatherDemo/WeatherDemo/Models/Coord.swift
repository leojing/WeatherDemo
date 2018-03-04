//
//	Coord.swift
//
//	Create by Jing Luo on 3/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Coord : NSObject, NSCoding, Mappable{

	var lat : Float?
	var lon : Float?


	class func newInstance(map: Map) -> Mappable?{
		return Coord()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		lat <- map["lat"]
		lon <- map["lon"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         lat = aDecoder.decodeObject(forKey: "lat") as? Float
         lon = aDecoder.decodeObject(forKey: "lon") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lon != nil{
			aCoder.encode(lon, forKey: "lon")
		}

	}

}