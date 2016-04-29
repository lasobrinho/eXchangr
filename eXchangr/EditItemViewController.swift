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
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var activeStackView: UIStackView!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addItemAdditionObserver(self)
        configureItemImageButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        if isEditingItem {
            activeStackView.hidden = false
            navigationBarTitle.title = "Edit Item"
            saveButton.title = "Save"
            displayItemInformation()
        } else {
            activeStackView.hidden = true
            navigationBarTitle.title = "New Item"
            saveButton.title = "Add"
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
        activeSwitch.on = (item?.active)!
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
        itemImage1.clipsToBounds = true
        
        itemImage2.backgroundColor = veryLightGrayColor
        itemImage2.layer.cornerRadius = 5
        itemImage2.layer.borderColor = UIColor.lightGrayColor().CGColor
        itemImage2.layer.borderWidth = 1
        itemImage2.clipsToBounds = true
        
        itemImage3.backgroundColor = veryLightGrayColor
        itemImage3.layer.cornerRadius = 5
        itemImage3.layer.borderColor = UIColor.lightGrayColor().CGColor
        itemImage3.layer.borderWidth = 1
        itemImage3.clipsToBounds = true
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
            if isEditingItem {
                item?.name = itemNameTextField.text!
                item?.description = itemDescriptionTextField.text!
                item?.active = activeSwitch.on
                updatePictureList()
                getUserPictures()
                item?.pictures = pictures
                ServerInterface.sharedInstance.performItemUpdate(self.item!, callback: { [unowned self] (result) in
                    switch result {
                    case let .Failure(msg):
                        print(msg)
                    case .Success:
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            } else {
                getUserPictures()
                item = Item(id: nil, name: itemNameTextField.text!, description: itemDescriptionTextField.text!, active: true, pictures: pictures)
                ServerInterface.sharedInstance.performItemAddition(item!)
            }
            
        } else {
            print("All fields are required")
        }
    }
    
    func updatePictureList() {
        images = []
        print(itemImage1.currentBackgroundImage)
        print(itemImage2.currentBackgroundImage)
        print(itemImage3.currentBackgroundImage)
        if itemImage1.currentBackgroundImage != nil {
            images.append(itemImage1.currentBackgroundImage!)
        }
        if itemImage2.currentBackgroundImage != nil {
            images.append(itemImage2.currentBackgroundImage!)
        }
        if itemImage3.currentBackgroundImage != nil {
            images.append(itemImage3.currentBackgroundImage!)
        }
    }
    
    func getUserPictures() {
        pictures = []
        for image in images {
            pictures.append(Picture(id: nil, bytes: UIImagePNGRepresentation(image.resize(0.5))!))
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
