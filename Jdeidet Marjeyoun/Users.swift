/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Users {
	public var id : Int?
	public var fullName : String?
	public var password : String?
	public var phoneNumber : String?
	public var email : String?
	public var address : String?
	public var blockNumber : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let users_list = Users.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Users Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Users]
    {
        var models:[Users] = []
        for item in array
        {
            models.append(Users(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let users = Users(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Users Instance.
*/
    required public init() {
        
    }
    
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		fullName = dictionary["fullName"] as? String
		password = dictionary["password"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
		email = dictionary["email"] as? String
		address = dictionary["address"] as? String
		blockNumber = dictionary["blockNumber"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.fullName, forKey: "fullName")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.blockNumber, forKey: "blockNumber")

		return dictionary
	}

}
