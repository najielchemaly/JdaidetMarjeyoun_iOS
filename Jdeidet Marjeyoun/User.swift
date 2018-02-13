/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User: NSObject, NSCoding {
	public var id : String?
	public var username : String?
    public var fullName : String?
	public var password : String?
	public var phoneNumber : String?
	public var email : String?
	public var address : String?
	public var blockNumber : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let User_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of User Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let User = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
    required public override init() {
        
    }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? String
        fullName = decoder.decodeObject(forKey:"fullName") as? String
        phoneNumber = decoder.decodeObject(forKey:"phoneNumber") as? String
        email = decoder.decodeObject(forKey:"email") as? String
        blockNumber = decoder.decodeObject(forKey:"blockNumber") as? String
        password = decoder.decodeObject(forKey:"password") as? String
        username = decoder.decodeObject(forKey:"username") as? String
        address = decoder.decodeObject(forKey:"address") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(fullName, forKey: "fullName")
        coder.encode(phoneNumber, forKey: "phoneNumber")
        coder.encode(email, forKey: "email")
        coder.encode(blockNumber, forKey: "blockNumber")
        coder.encode(password, forKey: "password")
        coder.encode(username, forKey: "username")
        coder.encode(address, forKey: "address")
    }
    
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		username = dictionary["userName"] as? String
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
		dictionary.setValue(self.username, forKey: "username")
        dictionary.setValue(self.fullName, forKey: "fullName")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.blockNumber, forKey: "blockNumber")

		return dictionary
	}

}
