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
    var pictures: [Picture?] = [nil, nil, nil]
    var item: Item?
    var clickedImage = 0
    var isEditingItem = false

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextView!
    @IBOutlet weak var itemImage1: UIButton!
    @IBOutlet weak var itemImage2: UIButton!
    @IBOutlet weak var itemImage3: UIButton!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var activeStackView: UIStackView!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var removePictureButton1: UIButton!
    @IBOutlet weak var removePictureButton2: UIButton!
    @IBOutlet weak var removePictureButton3: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        ServerInterface.sharedInstance.addItemAdditionObserver(self)
        configureItemImageButtons()
        configureDescriptionTextView()
        configureRemovePictureButtons()
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }


    func viewTapped(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    func hideKeyboard() {
        itemNameTextField.resignFirstResponder()
        itemDescriptionTextField.resignFirstResponder()
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

    func configureDescriptionTextView() {
        itemDescriptionTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        itemDescriptionTextField.layer.borderWidth = 1.0
        itemDescriptionTextField.layer.cornerRadius = 5
    }

    func configureRemovePictureButtons() {
        removePictureButton1.setTitle("", forState: .Normal)
        removePictureButton1.userInteractionEnabled = false
        removePictureButton2.setTitle("", forState: .Normal)
        removePictureButton2.userInteractionEnabled = false
        removePictureButton3.setTitle("", forState: .Normal)
        removePictureButton3.userInteractionEnabled = false
    }

    func displayItemInformation() {
        itemNameTextField.text = item?.name
        itemDescriptionTextField.text = item?.description
        activeSwitch.on = (item?.active)!
        setImageButtonsFromBytes()
    }

    func setImageButtonsFromBytes() {
        let imageButtons = [itemImage1, itemImage2, itemImage3]
        let removePictureButtons = [removePictureButton1, removePictureButton2, removePictureButton3]
        if item != nil {
            for index in 0..<item!.pictures.count {
                imageButtons[index].setTitle("", forState: .Normal)
                imageButtons[index].setBackgroundImage(UIImage(data: item!.pictures[index].bytes), forState: .Normal)
                pictures[index] = item!.pictures[index]
                removePictureButtons[index].setTitle("Remove Picture", forState: .Normal)
                removePictureButtons[index].userInteractionEnabled = true
            }
        }
    }

    @IBAction func BackButtonTapped(sender: AnyObject) {
        item = nil
        pictures = []
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func AddItemButtonTapped(sender: AnyObject) {
        if itemNameTextField.hasText() && itemDescriptionTextField.hasText() && (itemImage1.currentBackgroundImage != nil || itemImage2.currentBackgroundImage != nil || itemImage3.currentBackgroundImage != nil) {
            if isEditingItem {
                item?.name = itemNameTextField.text!
                item?.description = itemDescriptionTextField.text!
                item?.active = activeSwitch.on
                item?.pictures = getCurrentPictures()
                ServerInterface.sharedInstance.performItemUpdate(self.item!, callback: { [unowned self] (result) in
                    switch result {
                    case let .Failure(msg):
                        self.outputFeedback(msg)
                    case .Success:
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    })
            } else {
                item = Item(id: nil, name: itemNameTextField.text!, description: itemDescriptionTextField.text!, active: true, pictures: getCurrentPictures())
                ServerInterface.sharedInstance.performItemAddition(item!)
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: {})

        }
    }

    func getCurrentPictures() -> [Picture] {
        var currentPictures = [Picture]()
        for picture in pictures {
            if picture != nil {
                currentPictures.append(picture!)
            }
        }
        return currentPictures
    }

    func presentUIImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {

            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
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

        let compressedImage = image.resizeToWidth(500)
        let selectedPicture = Picture(id: nil, bytes: UIImagePNGRepresentation(compressedImage)!)

        switch clickedImage {
        case 1:
            itemImage1.setTitle("", forState: .Normal)
            itemImage1.setBackgroundImage(compressedImage, forState: .Normal)
            pictures[0] = selectedPicture
            removePictureButton1.setTitle("Remove Picture", forState: .Normal)
            removePictureButton1.userInteractionEnabled = true
        case 2:
            itemImage2.setTitle("", forState: .Normal)
            itemImage2.setBackgroundImage(compressedImage, forState: .Normal)
            pictures[1] = selectedPicture
            removePictureButton2.setTitle("Remove Picture", forState: .Normal)
            removePictureButton2.userInteractionEnabled = true
        case 3:
            itemImage3.setTitle("", forState: .Normal)
            itemImage3.setBackgroundImage(compressedImage, forState: .Normal)
            pictures[2] = selectedPicture
            removePictureButton3.setTitle("Remove Picture", forState: .Normal)
            removePictureButton3.userInteractionEnabled = true
        default:
            outputFeedback("Invalid value for clickedImage")
        }
    }
    @IBAction func removePictureTapped(sender: UIButton) {
        switch sender.restorationIdentifier! {
        case "removePicture1":
            itemImage1.setBackgroundImage(nil, forState: .Normal)
            itemImage1.setTitle("Add Picture", forState: .Normal)
            pictures[0] = nil
        case "removePicture2":
            itemImage2.setBackgroundImage(nil, forState: .Normal)
            itemImage2.setTitle("Add Picture", forState: .Normal)
            pictures[1] = nil
        case "removePicture3":
            itemImage3.setBackgroundImage(nil, forState: .Normal)
            itemImage3.setTitle("Add Picture", forState: .Normal)
            pictures[2] = nil
        default:
            break
        }
        sender.setTitle("", forState: .Normal)
        sender.userInteractionEnabled = false
    }

    func update(result: ItemAddOrUpdateResult) {
        switch result {
        case .Success:
            navigationController?.popViewControllerAnimated(true)
        case let .Failure(message):
            outputFeedback(message)
        }
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            ServerInterface.sharedInstance.removeItemAdditionObserver(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func outputFeedback(message: String) {
        feedbackLabel.text = message
        feedbackLabel.alpha = 0.0
        feedbackLabel.hidden = false
        UIView.animateWithDuration(0.5) {
            self.feedbackLabel.alpha = 1.0
        }
        
    }
    
}
