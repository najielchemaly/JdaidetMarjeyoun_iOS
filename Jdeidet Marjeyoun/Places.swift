/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Places {
	public var id : Int?
	public var title : String?
	public var shortDescription : String?
	public var description : String?
	public var thumb : String?
	public var images : Array<String>?
	public var category : String?
	public var location : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Places_list = Places.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Places Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Places]
    {
        var models:[Places] = []
        for item in array
        {
            models.append(Places(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Places = Places(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Places Instance.
*/
    
    required public init(title: String, description: String, location: String, thumb: String) {
        self.title = title
        self.description = description
        self.location = location
        self.thumb = thumb
    }
    
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		title = dictionary["title"] as? String
		shortDescription = dictionary["shortDescription"] as? String
		description = dictionary["description"] as? String
		thumb = dictionary["thumb"] as? String
		if (dictionary["images"] != nil) { images = String.modelsFromDictionaryArray(array: dictionary["images"] as! NSArray) }
		category = dictionary["category"] as? String
		location = dictionary["location"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.shortDescription, forKey: "shortDescription")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.thumb, forKey: "thumb")
		dictionary.setValue(self.category, forKey: "category")
		dictionary.setValue(self.location, forKey: "location")

		return dictionary
	}

}
