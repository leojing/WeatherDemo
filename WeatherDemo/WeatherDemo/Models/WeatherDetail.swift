//
//	Weather.swift
//
//	Create by Jing Luo on 3/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class WeatherDetail : NSObject, NSCoding, Mappable{

	var descriptionField : String?
	var icon : String?
	var id : Int?
	var main : String?


	class func newInstance(map: Map) -> Mappable?{
		return WeatherDetail()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		descriptionField <- map["description"]
		icon <- map["icon"]
		id <- map["id"]
		main <- map["main"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         icon = aDecoder.decodeObject(forKey: "icon") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         main = aDecoder.decodeObject(forKey: "main") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if icon != nil{
			aCoder.encode(icon, forKey: "icon")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if main != nil{
			aCoder.encode(main, forKey: "main")
		}

	}

}
