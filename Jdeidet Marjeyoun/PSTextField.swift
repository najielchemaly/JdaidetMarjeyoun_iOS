//
//  PSTextField.swift
//  PSTextFieldDemo
//
//  Created by Pawan Kumar Singh on 15/08/14.
//  Copyright (c) 2014 Pawan Kumar Singh. All rights reserved.
//

import UIKit

protocol PSTextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: PSTextField) -> Bool // return NO to disallow editing.
    func textFieldDidBeginEditing(_ textField: PSTextField) // became first responder
    func textFieldShouldEndEditing(_ textField: PSTextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    func textFieldDidEndEditing(_ textField: PSTextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: PSTextField, reason: UITextFieldDidEndEditingReason) // if implemented, called in place of textFieldDidEndEditing:
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    func textFieldShouldClear(_ textField: PSTextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldReturn(_ textField: PSTextField) -> Bool // called when 'return' key pressed. return NO to ignore.

}

extension PSTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: PSTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PSTextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: PSTextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: PSTextField){
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: PSTextField, reason: UITextFieldDidEndEditingReason){
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: PSTextField) -> Bool { return true}
    func textFieldShouldReturn(_ textField: PSTextField) -> Bool {return true}
    
}

var password: String = ""
class PSTextField: UITextField {
    
    enum PSDataValidationType{
        case password           //alphanumeric password like hs939wd!
        case confirmPassword    //alphanumeric password like hs939wd!
        case userName           //alphanumeric username like john231
        case firstName          //First name like Ramesh, Suresh, Gita etc
        case lastName           //Last name Yadav, Naidu etc
        case email              //Email id vishu@subdomain.domain
        case mobileNumber       //Mobile number - +911034567892
        case date
        case time
        case place
        case city
        case state
        case country
        case empty         //Will check for empty string
    }
    
    var dataValidationType: PSDataValidationType = .empty
    var popUpTriangleHorizontalRightMargin: CGFloat!
    var arrowRightMargin: CGFloat!
    lazy var error: NSError! = nil
    
    func validateInput() -> Bool {
        
        var tempError: NSError?
        var isDataFoundValid = true                //By default, we assume user has keyed correct input.
        
        switch dataValidationType {
            
        case .password:
            isDataFoundValid = self.text!.validatePassword(&tempError)
            
        case .confirmPassword:
            isDataFoundValid = self.text!.validateConfirmPassword(password: password, &tempError)
            
        case .userName:
            isDataFoundValid = self.text!.validateUserName(&tempError)
            
        case .firstName:
            isDataFoundValid = self.text!.validateFirstName(&tempError)
            
        case .lastName:
            isDataFoundValid = self.text!.validateLastName(&tempError)
            
        case .email:
            isDataFoundValid = self.text!.validateEmail(&tempError)
            
        case .mobileNumber:
            isDataFoundValid = self.text!.validatePhoneNumber(&tempError)
            
        case .date:
            isDataFoundValid = self.text!.validateDate(&tempError)
            
        case .time:
            isDataFoundValid = self.text!.validateTime(&tempError)
            
            
        case .place:
            isDataFoundValid = self.text!.validatePlace(&tempError)
            break
            
        case .city:
            isDataFoundValid = self.text!.validateCity(&tempError)
            
        case .state:
            isDataFoundValid = self.text!.validateState(&tempError)
            break
            
        case .country:
            isDataFoundValid = self.text!.validateCountry(&tempError)
            
        case .empty:
            isDataFoundValid = self.text!.validateEmpty(&tempError)
        }
        
        if(isDataFoundValid == false){
            self.error = tempError
            addErrorInfoDisclosure()
        }else{
            removeErrorInfoDisclosure()
        }
        
        return isDataFoundValid
    }
    
    func addErrorInfoDisclosure(){
        
        let infoView = UIView()
        infoView.frame.size = CGSize(width: self.frame.size.height, height: self.frame.size.height)
        infoView.frame.origin = CGPoint(x: 0, y: 0)
        
        let infoDisclosure = UIButton(type: .infoDark)
        infoDisclosure.tintColor = UIColor.red
//        infoDisclosure.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        infoDisclosure.addTarget(self, action: #selector(PSTextField.displayErrorAlert), for: .touchUpInside)
        infoDisclosure.center = infoView.center
        
        infoView.addSubview(infoDisclosure)

        leftView = infoView
        leftViewMode = .always
//        rightView = infoDisclosure
//        rightViewMode = .always
//        popUpTriangleHorizontalRightMargin = infoDisclosure.center.x
        
        self.arrowRightMargin = infoView.center.x
        
        if let parentView = self.superview {
            popUpTriangleHorizontalRightMargin = parentView.frame.origin.x
        }
    }
    
    func removeErrorInfoDisclosure(){
        
        leftView = nil
//        rightView = nil
    }
    
    func displayErrorAlert(){

        let popupViewTriangleTopTipPoint: CGPoint = CGPoint(x: self.frame.size.width-popUpTriangleHorizontalRightMargin, y: self.frame.size.height)

        let errorMessage: String = error.localizedDescription
        let errorAlertView: PSErrorAlertView = PSErrorAlertView(errorMessage: errorMessage)
        errorAlertView.popUpTriangleTipPoint = self.convert(popupViewTriangleTopTipPoint, to: nil)
        errorAlertView.popUpTriangleHorizontalRightMargin = popUpTriangleHorizontalRightMargin;
        errorAlertView.arrowRightMargin = self.arrowRightMargin
        errorAlertView.displayAlert()
    }
    
    override func awakeFromNib(){
        
        //setting default validation to validate for empty text.
        self.dataValidationType = .empty;
    }
}

