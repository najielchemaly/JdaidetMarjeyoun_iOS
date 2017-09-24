//
//  ViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
    func didFinishPickingMedia(data: UIImage?)
    func didCancelPickingMedia()
}

class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var toolBarView: ToolBarView!
    
    var imagePickerDelegate: ImagePickerDelegate!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.   
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        
        if hasToolBar() {
            self.setupToolBarView()
        }
        
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVC = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleCameraTap(sender: UIButton? = nil) {
        let optionActionSheet = UIAlertController(title: "Select Source:", message: nil, preferredStyle: .actionSheet)
        optionActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
        optionActionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: openPhotoLibrary))
        optionActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(optionActionSheet, animated: true, completion: nil)
    }
    
    func openCamera(action: UIAlertAction) {
        self.imagePickerController.sourceType = .camera
        
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func openPhotoLibrary(action: UIAlertAction) {
        self.imagePickerController.sourceType = .photoLibrary
        
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var pickedImage: UIImage? = nil
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = image
        }
        
        self.imagePickerDelegate.didFinishPickingMedia(data: pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerDelegate.didCancelPickingMedia()
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupToolBarView() {
        let view = Bundle.main.loadNibNamed("ToolBarView", owner: self.view, options: nil)
        if let toolBarView = view?.first as? ToolBarView {
            self.toolBarView = toolBarView
            self.toolBarView.frame.size.width = self.view.frame.size.width
            self.toolBarView.frame.origin = CGPoint(x: 0, y: 20)
            self.view.addSubview(self.toolBarView)
        }
    }
    
    func setGradientBackground() {
        setGradientBackground(parentView: self.view)
    }
    
    func setGradientBackground(parentView: UIView) {
        let colorTop = Colors.lightBlue.cgColor
        let colorBottom = Colors.blue.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        let gradientView = UIView(frame: self.view.bounds)
        gradientView.layer.addSublayer(gradientLayer)
        parentView.addSubview(gradientView)
        parentView.sendSubview(toBack: gradientView)
    }
    
    var mainView: UIView!
    func showPopupView() {
        if let window = UIApplication.shared.keyWindow {
            mainView = UIView(frame: window.frame)
            
            let shadowView = UIView(frame: window.frame)
            shadowView.backgroundColor = Colors.text.withAlphaComponent(0.5)
            
            mainView.addSubview(shadowView)
            
            let view = Bundle.main.loadNibNamed("PopupView", owner: self.view, options: nil)
            if let popupView = view?.first as? PopupView {
                popupView.frame.origin.y = mainView.frame.size.height+popupView.frame.size.height
                
                popupView.buttonCancel.layer.borderWidth = 1
                popupView.buttonCancel.layer.borderColor = Colors.appBlue.cgColor
                
                popupView.buttonDone.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
                
                popupView.buttonCancel.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)
                
                mainView.addSubview(popupView)
                
                self.view.addSubview(mainView)
                self.view.bringSubview(toFront: mainView)
                
                UIView.animate(withDuration: 0.6, animations: {
                    popupView.center = window.center
                })
            }
        }
    }
    
    func hidePopupView() {
        if mainView != nil {
            
            if let popupView = mainView.subviews.last as? PopupView {
                UIView.animate(withDuration: 0.6, animations: {
                    popupView.center.y = self.mainView.frame.size.height+popupView.frame.size.height
                }, completion: { success in
                    self.mainView.removeFromSuperview()
                })
            }
        }
    }
    
    func buttonDoneTapped() {
        // send data to server
        
        self.redirectToVC(storyboardId: StoryboardIds.NavigationTabBarController, type: .Present)
    }
    
    func hasToolBar() -> Bool {
     
        if self is NewsViewController || self is NewsDetailsViewController || self is NotificationsViewController || self is ComplaintViewController || self is ContactsViewController || self is PlacesViewController || self is PlacesDetailsViewController || self is MapViewController || self is FeesViewController {
            return true
        }
        
        return false
    }
    
}

