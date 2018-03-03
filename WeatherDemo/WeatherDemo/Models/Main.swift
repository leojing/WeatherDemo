//
//	Main.swift
//
//	Create by Jing Luo on 3/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Main : NSObject, NSCoding, Mappable{

	var humidity : Int?
	var pressure : Int?
	var temp : Float?
	var tempMax : Float?
	var tempMin : Float?


	class func newInstance(map: Map) -> Mappable?{
		return Main()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		humidity <- map["humidity"]
		pressure <- map["pressure"]
		temp <- map["temp"]
		tempMax <- map["temp_max"]
		tempMin <- map["temp_min"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         humidity = aDecoder.decodeObject(forKey: "humidity") as? Int
         pressure = aDecoder.decodeObject(forKey: "pressure") as? Int
         temp = aDecoder.decodeObject(forKey: "temp") as? Float
         tempMax = aDecoder.decodeObject(forKey: "temp_max") as? Float
         tempMin = aDecoder.decodeObject(forKey: "temp_min") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if humidity != nil{
			aCoder.encode(humidity, forKey: "humidity")
		}
		if pressure != nil{
			aCoder.encode(pressure, forKey: "pressure")
		}
		if temp != nil{
			aCoder.encode(temp, forKey: "temp")
		}
		if tempMax != nil{
			aCoder.encode(tempMax, forKey: "temp_max")
		}
		if tempMin != nil{
			aCoder.encode(tempMin, forKey: "temp_min")
		}

	}

}
