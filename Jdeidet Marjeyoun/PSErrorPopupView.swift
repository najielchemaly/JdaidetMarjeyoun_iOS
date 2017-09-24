//
//  PSErrorPopupView.swift
//  PSTextFieldDemo
//
//  Created by Pawan Kumar Singh on 15/08/14.
//  Copyright (c) 2014 Pawan Kumar Singh. All rights reserved.
//

import UIKit

let TRIANGLE_BASE_WIDTH: CGFloat = 16.0
let TRIANGLE_HEIGHT: CGFloat = 10.0
let RECTANGLE_HEIGHT: CGFloat = 3.0

class PSErrorPopupView: UIView {

    var errorMsg: String!
    var popUpPointX: CGFloat!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame aRect: CGRect, errorMessage aMessage: String, triangleCenterX x: CGFloat)
    {
        var tempFrame: CGRect = aRect
        tempFrame.size.height += 13.0
        self.init(frame: tempFrame)
        
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.errorMsg = aMessage
        self.popUpPointX = x-2
        
    }
  
    override func draw(_ rect :CGRect){
        
        // Drawing code
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        context.beginPath();
        
        //top triangle
        context.move(to: CGPoint(x: popUpPointX, y: 0.0))
        context.addLine(to: CGPoint(x: popUpPointX-TRIANGLE_BASE_WIDTH/2, y: TRIANGLE_HEIGHT))
        context.addLine(to: CGPoint(x: popUpPointX+TRIANGLE_BASE_WIDTH/2, y: TRIANGLE_HEIGHT))
        context.addLine(to: CGPoint(x: popUpPointX, y: 0.0))
        
        context.addRect(CGRect(x: 0.0, y: TRIANGLE_HEIGHT, width: self.frame.size.width, height: RECTANGLE_HEIGHT))
        
        context.closePath()
        context.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)          //Red color
        context.drawPath(using: .fill)
        
        let frame: CGRect = CGRect(x: 0.0, y: TRIANGLE_HEIGHT+RECTANGLE_HEIGHT, width: self.frame.size.width, height: self.frame.size.height);
        
        let errorLabel: UILabel = UILabel(frame: frame)
        errorLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.65)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont.systemFont(ofSize: 13.0)
        errorLabel.text = errorMsg
        addSubview(errorLabel)
        
    }
}
