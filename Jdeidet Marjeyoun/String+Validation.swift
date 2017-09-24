//
//  String+Validation.swift
//  PSTextFieldDemo
//
//  Created by Pawan Kumar Singh on 16/08/14.
//  Copyright (c) 2014 Pawan Kumar Singh. All rights reserved.
//

import Foundation

extension String{
    
    enum PSDataValidationErrorCode: Int {
        
        case psEmailLengthZeroErrorCode = 1000              //Blank Email field
        case psEmailInvalidFormatErrorCode                  //Email format invalid
        
        case psUserNameLengthZeroErrorCode                  //Blank Username field
        case psUserNameLengthMinimumErrorCode               //Username can't be less than minimum 7 character
        case psUserNameLengthMaximumErrorCode               //Username can't be more than maximim 50 character
        case psUserNameInvalidFormatErrorCode               //Username format invalid
        
        case psFirstNameLengthZeroErrorCode                 //Blank first name
        case psFirstNameInvalidFormatErrorCode              //Any other character than A-Z or a-z or blankspace
        case psFirstNameMaxAllowedCharsErrorCode            //Maximum allowed charcters (44 is considered for demo).
        
        case psLastNameLengthZeroErrorCode                  //Blank last name
        case psLastNameInvalidFormatErrorCode               //Any other character than A-Z or a-z or blankspace
        case psLastNameMaxAllowedCharsErrorCode             //Maximum allowed charcters (44 is considered for demo).
        
        case psPasswordLengthZeroErrorCode                  //Blank password
        case psPasswordLengthMinimumErrorCode               //minimum length, (7 is considered for demo).
        case psPasswordInvalidFormatErrorCode               //invalid characters
        case psConfirmPasswordInvalidFormatErrorCode        //invalid characters
        
        case psCountryISDCodeLengthZeroErrorCode
        case psInvalidCountryISDCodeErrorCode
        case psPhoneNumberLengthZeroErrorCode
        case psInvalidPhoneNumberErrorCode
        
        case psCountryNameLengthZeroErrorCode
        case psCountryNameInvalidFormatErrorCode
        
        case psStateNameLengthZeroErrorCode
        case psStateNameInvalidFormatErrorCode
        
        case psCityNameLengthZeroErrorCode
        case psCityNameInvalidFormatErrorCode
        
        case psPlaceNameLengthZeroErrorCode
        case psPlaceNameInvalidFormatErrorCode
        
        case psDateLengthZeroErrorCode
        case psTimeLengthZeroErrorCode
        
        case psEmptyDataValidationErrorCode
        
    }
    
    var PSDataValidationErrorDomain: String { return "com.pserror.inputvalidation"}

    var PSEmailLengthZeroErrorDesc: String { return "Email field empty."}
    var PSEmailInvalidFormatErrorDesc: String { return "Email address is not valid."}
    var PSUserNameLengthZeroErrorDesc: String { return"Username field empty."}
    var PSUserNameInvalidFormatErrorDesc: String { return"User name cannot contain special characters."}
    var PSUserNameLengthMinimumErrorDesc: String { return "User name cannot be less than 7 characters."}
    var PSUserNameLengthMaximumErrorDesc: String { return "Name cannot be more than 50 characters."}
    var PSPersonNameValidationErrorDesc: String { return "Invalid Name."}
    
    var PSFirstNameEmptyErrorDesc: String { return "First name can't be empty."}
    var PSFirstNameMaxAllowedCharsErrorDesc: String { return "First name can't be more than 44 characters."}
    var PSFirstNameInvalidFormatErrorDesc: String { return "First name can't contain special characters."}
    
    var PSLastNameEmptyErrorDesc: String { return "Last name can't be empty"}
    var PSLastNameMaxAllowedCharsErrorDesc: String { return "Last name can't be more than 44 characters."}
    var PSLastNameInvalidFormatErrorDesc: String { return "Last name can't contain special characters"}
    
    var PSPasswordInvalidFormatErrorDesc: String { return "Invalid Password."}
    var PSConfirmPasswordInvalidFormatErrorDesc: String { return "Password do not match."}
    var PSPasswordLengthZeroErrorDesc: String { return "Password field empty."}
    var PSPasswordLengthMinimumErrorDesc: String { return "Password should be minimum 7 characters."}
    var PSPersonNameLengthZeroErrorDesc: String { return "Username field can't be empty."}
    var PSCountryISDCodeLengthZeroErrorDesc: String { return "Enter country code."}
    var PSInvalidCountryISDCodeErrorDesc: String { return "Enter valid country code."}
    var PSPhoneNumberLengthZeroErrorDesc: String { return "Enter phone number."}
    var PSInvalidPhoneNumberErrorDesc: String { return "Enter valid phone number."}
    var PSEmptyStringErrorDesc: String { return "This field can't be empty."}
    
    var PSDateEmptyErrorDesc: String { return "Date can't be empty."}
    var PSTimeEmptyErrorDesc: String { return"Time can't be empty."}
    
    var PSPlaceNameEmptyErrorDesc: String { return"Place can't be empty."}
    var PSPlaceNameInvalidFormatErrorDesc: String { return"Place name is invalid."}
    
    var PSCityNameEmptyErrorDesc: String { return"City can't be empty."}
    var PSCityNameInvalidFormatErrorDesc: String { return"City name is invalid."}
    
    var PSStateNameEmptyErrorDesc: String { return"State can't be empty."}
    var PSStateNameInvalidFormatErrorDesc: String { return"State name is invalid."}
    
    var PSCountryNameEmptyErrorDesc: String { return"Country can't be empty."}
    var PSCountryNameInvalidFormatErrorDesc: String { return "Country name is invalid."}

    func validateUserName(_ error: NSErrorPointer) -> Bool {

        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String! = PSEmptyStringErrorDesc
        let userNameRegex: String = "[A-Z0-9a-z._-]{7,32}"
        let userName: NSPredicate! = NSPredicate(format: "SELF MATCHES %@",userNameRegex)
        
        if(isEmpty){
            
            errorCode = .psUserNameLengthZeroErrorCode
            errorDescStr = PSUserNameLengthZeroErrorDesc
            
        }
//        else if(self.characters.count < 7){
//            
//            errorCode = .psUserNameLengthMinimumErrorCode
//            errorDescStr = PSUserNameLengthMinimumErrorDesc
//            
//        }
        else if(self.characters.count > 50){
            
            errorCode = .psUserNameLengthMinimumErrorCode
            errorDescStr = PSUserNameLengthMinimumErrorDesc
            
        }else if (userName.evaluate(with: self) == false) {
            
            errorCode = .psUserNameInvalidFormatErrorCode
            errorDescStr = PSUserNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:errorDescStr])
        }
        return success
    }
    
    func validateFirstName(_ error: NSErrorPointer) -> Bool{
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String! = PSEmptyStringErrorDesc
        let firstNameRegex: String = "[A-Za-z. ]{1,44}"
        let firstName: NSPredicate! = NSPredicate(format: "SELF MATCHES %@",firstNameRegex)
        
        if(isEmpty){
            
            errorCode = .psFirstNameLengthZeroErrorCode
            errorDescStr = PSFirstNameEmptyErrorDesc
            
        }else if(self.characters.count > 44){
            
            errorCode = .psFirstNameMaxAllowedCharsErrorCode
            errorDescStr = PSFirstNameMaxAllowedCharsErrorDesc
            
        }else if (firstName.evaluate(with: self) == false) {
            
            errorCode = .psFirstNameInvalidFormatErrorCode
            errorDescStr = PSFirstNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:errorDescStr])
        }
        return success
    }

    func validateLastName(_ error: NSErrorPointer) -> Bool{
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String! = PSEmptyStringErrorDesc
        let lastNameRegex: String = "[A-Za-z. ]{1,44}"
        let lastName: NSPredicate! = NSPredicate(format: "SELF MATCHES %@",lastNameRegex)
        
        if(isEmpty){
            
            errorCode = .psLastNameLengthZeroErrorCode
            errorDescStr = PSLastNameEmptyErrorDesc
            
        }else if(self.characters.count > 44){
            
            errorCode = .psLastNameMaxAllowedCharsErrorCode
            errorDescStr = PSLastNameMaxAllowedCharsErrorDesc
            
        }else if (lastName.evaluate(with: self) == false) {
            
            errorCode = .psLastNameInvalidFormatErrorCode
            errorDescStr = PSLastNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:errorDescStr])
        }
        return success
    }
    
    
    func validateEmail(_ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String! = PSEmptyStringErrorDesc
        let emailRegex: String = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate: NSPredicate! = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if(isEmpty){
            
            errorCode = .psEmailLengthZeroErrorCode
            errorDescStr = PSEmailLengthZeroErrorDesc
            
        }else if(emailPredicate.evaluate(with: self) == false) {
            
            errorCode = .psEmailInvalidFormatErrorCode
            errorDescStr = PSEmailInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorDescStr])
        }
        return success;
    }
    
    func validateConfirmPassword(password: String, _ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String! = PSEmptyStringErrorDesc
        
        if self.lowercased() != password.lowercased() {
            errorCode = .psConfirmPasswordInvalidFormatErrorCode
            errorDescStr = PSConfirmPasswordInvalidFormatErrorDesc
            
            success = false
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorDescStr])
        }
        
        return success
    }
    
    func validatePassword(_ error: NSErrorPointer) -> Bool{

        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String! = PSEmptyStringErrorDesc

        let passwordRegex: String = "[A-Z0-9a-z]{7,32}"
        let password: NSPredicate! = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
    
        if(isEmpty){
            
            errorCode = .psPasswordLengthZeroErrorCode
            errorDescStr = PSPasswordLengthZeroErrorDesc
            
        }else if(self.characters.count < 7){
            
            errorCode = .psPasswordLengthMinimumErrorCode
            errorDescStr = PSPasswordLengthMinimumErrorDesc

        }else if (password.evaluate(with: self) == false) {
            
            errorCode = .psPasswordInvalidFormatErrorCode
            errorDescStr = PSPasswordInvalidFormatErrorDesc
            
        }else {
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:errorDescStr])
        }
        return success;
    }
    
    func validateCountryCode(_ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDesc: String = PSEmptyStringErrorDesc
        let phoneRegex: String = "[+][0-9]{1,4}"
        let countryCodeTest: NSPredicate! = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        
        if(isEmpty){
            errorCode = .psCountryISDCodeLengthZeroErrorCode
            errorDesc = PSCountryISDCodeLengthZeroErrorDesc
            
        }else if(countryCodeTest.evaluate(with: self) == false)
        {
            errorCode = .psInvalidCountryISDCodeErrorCode
            errorDesc = PSInvalidCountryISDCodeErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if (success == false){
            error?.pointee = NSError(domain:PSDataValidationErrorDomain, code:errorCode.rawValue, userInfo:[NSLocalizedDescriptionKey:errorDesc])
        }
        return success;
    }
    
    func validatePhoneNumber(_ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDesc: String = PSEmptyStringErrorDesc
        let phoneRegex: String = "[0-9]{7,13}"
        let countryCodeTest: NSPredicate! = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    
        if(isEmpty){
            
            errorCode = .psCountryISDCodeLengthZeroErrorCode
            errorDesc = PSPhoneNumberLengthZeroErrorDesc
            
        }else if(countryCodeTest.evaluate(with: self) == false){
            errorCode = .psInvalidCountryISDCodeErrorCode
            errorDesc = PSInvalidPhoneNumberErrorDesc
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false)
        {
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey:errorDesc])
        }
        return success;
    }

    func validateEmpty(_ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        if(isEmpty){
            let errorCode: Int = PSDataValidationErrorCode.psEmptyDataValidationErrorCode.rawValue
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode, userInfo:[NSLocalizedDescriptionKey:PSEmptyStringErrorDesc])
        }else{
            error?.pointee = nil
            success = true
        }
        return success;
    }

    
    func validateDate(_ error: NSErrorPointer) -> Bool{
        
        var success = false
        if(isEmpty){
            let errorCode: Int = PSDataValidationErrorCode.psDateLengthZeroErrorCode.rawValue
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode, userInfo:[NSLocalizedDescriptionKey:PSDateEmptyErrorDesc])
        }else{
            success = true
        }
        return success;
    }
    
    func validateTime(_ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        if(isEmpty){

            let errorCode: Int = PSDataValidationErrorCode.psTimeLengthZeroErrorCode.rawValue
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code: errorCode, userInfo:[NSLocalizedDescriptionKey:PSTimeEmptyErrorDesc])
            
        }else{
            success = true
        }
        return success
    }
    
    func validatePlace(_ error: NSErrorPointer) -> Bool {

        var success = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String = PSEmptyStringErrorDesc
        let placeNameRegex: String = "[A-Za-z ]{1,44}"
        let placeName: NSPredicate! = NSPredicate(format:"SELF MATCHES %@", placeNameRegex)
    
        if(isEmpty){
            
            errorCode = .psPlaceNameLengthZeroErrorCode
            errorDescStr = PSPlaceNameEmptyErrorDesc
            
        }else if (placeName.evaluate(with: self)) {
            
            errorCode = .psPlaceNameInvalidFormatErrorCode
            errorDescStr = PSPlaceNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain: PSDataValidationErrorDomain, code:errorCode.rawValue, userInfo:[NSLocalizedDescriptionKey: errorDescStr])
        }
        
        return success;
    }
    
    func validateCity(_ error: NSErrorPointer) -> Bool {
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String = PSEmptyStringErrorDesc
        let cityNameRegex: String = "[A-Za-z ]{1,44}"
        let cityName: NSPredicate! = NSPredicate(format:"SELF MATCHES %@", cityNameRegex)
    
        if(isEmpty){
            
            errorCode = .psCityNameLengthZeroErrorCode;
            errorDescStr = PSCityNameEmptyErrorDesc
            
        }else if (cityName.evaluate(with: self)) {
            
            errorCode = .psCityNameInvalidFormatErrorCode;
            errorDescStr = PSCityNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = false
        }
        
        if(success == false){
            error?.pointee = NSError(domain:PSDataValidationErrorDomain, code:errorCode.rawValue, userInfo:[NSLocalizedDescriptionKey: errorDescStr])
        }
        return success
    }
    
    func validateState(_ error: NSErrorPointer) -> Bool {

        var success = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String = PSEmptyStringErrorDesc
        let stateNameRegex: String = "[A-Za-z ]{1,44}"
        let stateName: NSPredicate! = NSPredicate(format:"SELF MATCHES %@", stateNameRegex)
    
        if(isEmpty){
            
            errorCode = .psStateNameLengthZeroErrorCode
            errorDescStr = PSStateNameEmptyErrorDesc
            
        }else if (stateName.evaluate(with: self)) {
            
            errorCode = .psStateNameInvalidFormatErrorCode
            errorDescStr = PSStateNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain:PSDataValidationErrorDomain, code:errorCode.rawValue, userInfo:[NSLocalizedDescriptionKey: errorDescStr])
        }
        return success
    }

    func validateCountry(_ error: NSErrorPointer) -> Bool {
        
        var success: Bool = false
        var errorCode: PSDataValidationErrorCode = .psEmptyDataValidationErrorCode
        var errorDescStr: String = PSEmptyStringErrorDesc
        let countryNameRegex: String = "[A-Za-z ]{1,44}"
        let countryName: NSPredicate! = NSPredicate(format: "SELF MATCHES %@", countryNameRegex)
        
        if(isEmpty){
            
            errorCode = .psCountryNameLengthZeroErrorCode
            errorDescStr = PSCountryNameEmptyErrorDesc
            
        }else if (countryName.evaluate(with: self)) {
            
            errorCode = .psCountryNameInvalidFormatErrorCode
            errorDescStr = PSCountryNameInvalidFormatErrorDesc
            
        }else{
            error?.pointee = nil
            success = true
        }
        
        if(success == false){
            error?.pointee = NSError(domain:PSDataValidationErrorDomain, code:errorCode.rawValue, userInfo:[NSLocalizedDescriptionKey: errorDescStr])
        }
        return success;
    }
}
