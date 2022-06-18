//
//  PSErrorAlertView.swift
//  PSTextFieldDemo
//
//  Created by Pawan Kumar Singh on 15/08/14.
//  Copyright (c) 2014 Pawan Kumar Singh. All rights reserved.
//

import UIKit

class PSErrorAlertView: UIView {
    
    var popUpTriangleTipPoint: CGPoint = CGPoint.zero
    var popUpTriangleHorizontalRightMargin: CGFloat = 0.0
    var arrowRightMargin: CGFloat = 0.0
    var errorMsg: String!
    weak var popupView: PSErrorPopupView! = nil

    override init(frame : CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    convenience init(errorMessage: String)
    {
        let frame: CGRect = UIScreen.main.bounds
        self.init(frame: frame)
        errorMsg = errorMessage
        backgroundColor = UIColor.clear
        let tapGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PSErrorAlertView.dismissErrorAlertView(_:)))
        self.addGestureRecognizer(tapGestureRecogniser)

    }
    
    func displayAlert(){
        
        addPopupView()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(self)
    }
    
    func addPopupView(){
        
        var textSize: CGSize = self.errorMsg.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13.0)])
        textSize = CGSize(width: ceil(textSize.width)+10.0, height: ceil(textSize.height));    //Added 5 pixel margin from both ends.
        textSize.width = (textSize.width < 140.0) ? 140.0 : textSize.width;
        textSize.height = (textSize.height < 30.0) ? 30.0 : textSize.height;
        
        var frame: CGRect = CGRect.zero;
        
        frame.origin.x = popUpTriangleTipPoint.x + popUpTriangleHorizontalRightMargin - textSize.width;
        frame.origin.y = popUpTriangleTipPoint.y
        frame.size = textSize;
        
        // if lang = ar
        frame.origin.x = self.popUpTriangleHorizontalRightMargin
        
        let triangleMidX: CGFloat = self.arrowRightMargin
        
        // if lang = en
        //frame.size.width - self.popUpTriangleHorizontalRightMargin
        
        addSubview(PSErrorPopupView(frame: frame, errorMessage: errorMsg, triangleCenterX: triangleMidX))
        
    }
    
    @objc func dismissErrorAlertView(_ gestureRecog: UITapGestureRecognizer) {
        
        removeFromSuperview()
    }
}
