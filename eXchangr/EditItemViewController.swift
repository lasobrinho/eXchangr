//
//  EditItemViewController.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 4/22/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ItemAdditionObserver {
    
    var imagePicker: UIImagePickerController? = UIImagePickerController()
    var images = [UIImage]()
    var pictures = [Picture]()
    var item: Item?
    var clickedImage = 0
    var isEditingItem = false

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var itemImage1: UIButton!
    @IBOutlet weak var itemImage2: UIButton!
    @IBOutlet weak var itemImage3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addItemAdditionObserver(self)
        configureItemImageButtons()
        if item != nil {
            displayItemInformation()
            item = nil
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            ServerInterface.sharedInstance.removeItemAdditionObserver(self)
        }
    }
    
    func displayItemInformation() {
        itemNameTextField.text = item?.name
        itemDescriptionTextField.text = item?.description
        setUIImagesFromBytes(item!.pictures)
    }
    
    func setUIImagesFromBytes(itemPictures: [Picture]) {
        let imageButtons = [itemImage1, itemImage2, itemImage3]
        for index in 0..<itemPictures.count {
            imageButtons[index].setTitle("", forState: .Normal)
            imageButtons[index].setBackgroundImage(UIImage(data: itemPictures[index].bytes), forState: .Normal)
        }
    }
    
    func configureItemImageButtons() {
        let veryLightGrayColor = UIColor(white: 0.95, alpha: 1.0)
        
        itemImage1.backgroundColor = veryLightGrayColor
        itemImage1.layer.cornerRadius = 5
        itemImage1.layer.borderColor = UIColor.lightGrayColor().CGColor
        itemImage1.layer.borderWidth = 1
        
        itemImage2.backgroundColor = veryLightGrayColor
        itemImage2.layer.cornerRadius = 5
        itemImage2.layer.borderColor = UIColor.lightGrayColor().CGColor
        itemImage2.layer.borderWidth = 1
        
        itemImage3.backgroundColor = veryLightGrayColor
        itemImage3.layer.cornerRadius = 5
        itemImage3.layer.borderColor = UIColor.lightGrayColor().CGColor
        itemImage3.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func BackButtonTapped(sender: AnyObject) {
        item = nil
        pictures = []
        images = []
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddItemButtonTapped(sender: AnyObject) {
        if itemNameTextField.hasText() && itemDescriptionTextField.hasText() && (itemImage1.currentBackgroundImage != nil || itemImage2.currentBackgroundImage != nil || itemImage3.currentBackgroundImage != nil) {
            for image in images {
                pictures.append(Picture(id: nil, bytes: UIImagePNGRepresentation(image.resize(0.5))!))
            }
            
            item = Item(id: nil, name: itemNameTextField.text!, description: itemDescriptionTextField.text!, active: true, pictures: pictures)
            ServerInterface.sharedInstance.performItemAddition(item!)
        } else {
            print("All fields are required")
        }
    }
    
    func presentUIImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker!.allowsEditing = false
            
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func itemImage1Tapped(sender: AnyObject) {
        presentUIImagePicker()
        clickedImage = 1
    }
    
    @IBAction func itemImage2Tapped(sender: AnyObject) {
        presentUIImagePicker()
        clickedImage = 2
    }
    
    @IBAction func itemImage3Tapped(sender: AnyObject) {
        presentUIImagePicker()
        clickedImage = 3
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        images.append(image)
        
        switch(clickedImage){
        case 1:
            itemImage1.setTitle("", forState: .Normal)
            itemImage1.setBackgroundImage(image, forState: .Normal)
        case 2:
            itemImage2.setTitle("", forState: .Normal)
            itemImage2.setBackgroundImage(image, forState: .Normal)
        case 3:
            itemImage3.setTitle("", forState: .Normal)
            itemImage3.setBackgroundImage(image, forState: .Normal)
        default:
            print("Invalid value for clickedImage")
        }
    }
    
    func update(result: ItemAddOrUpdateResult) {
        switch result {
        case .Success:
            navigationController?.popViewControllerAnimated(true)
        case let .Failure(message):
            print(message)
        }
    }
    
    
    
}
