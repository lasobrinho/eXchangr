//
//  BrowserViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    var mainStoryboard: UIStoryboard!

    @IBOutlet weak var noMoreItems: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!

    @IBOutlet weak var imageXConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageYConstraint: NSLayoutConstraint!
    @IBOutlet weak var ignoreBtnYConstraint: NSLayoutConstraint!
    @IBOutlet weak var exchangeBtnYConstraint: NSLayoutConstraint!

    var browseItems = [Item]()

    var currentItem: Item!
    var imageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)


        let string: NSString = "eXchangr"
        let title = NSMutableAttributedString(string: string as String)
        let attribute = [NSForegroundColorAttributeName : UIColor.redColor()]
        title.addAttributes(attribute, range: string.rangeOfString("X"))
        let titleLabel = UILabel()
        titleLabel.attributedText = title
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel


        view.clipsToBounds = true

        image.layer.cornerRadius = 10
        image.clipsToBounds = true

        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipe))
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipe))

        leftSwipeRecognizer.direction = .Left
        rightSwipeRecognizer.direction = .Right

        image.addGestureRecognizer(leftSwipeRecognizer)
        image.addGestureRecognizer(rightSwipeRecognizer)
        
        configureDescriptionTextView()

        toggleInterface(true)
        refreshData()
    }
    
    func configureDescriptionTextView() {
        descriptionText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        descriptionText.editable = false
        descriptionText.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }

    func imageSwipe(sender: UISwipeGestureRecognizer) {
        if currentItem != nil {
            if sender.direction == .Right {
                if imageIndex > 0 {
                    imageIndex -= 1
                }
            } else {
                if imageIndex < currentItem.pictures.count - 1 {
                    imageIndex += 1
                }
            }

            image.image = currentItem.pictures[imageIndex].asUIImage()
        } else {
            imageIndex = 0
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAnimation()
    }

    func prepareForAnimation() {
        imageYConstraint.constant = -view.center.y - image.frame.height/3
        ignoreBtnYConstraint.constant += view.frame.height * 3
        exchangeBtnYConstraint.constant += view.frame.height * 3
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        imageYConstraint.constant = 8
        self.ignoreBtnYConstraint.constant = 8
        self.exchangeBtnYConstraint.constant = 8
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func refreshData() {
        ServerInterface.sharedInstance.requestElegibleItemsList { [unowned self] (items) in
            self.browseItems = items
            self.loadUIElements()
        }
    }

    @IBAction func MyItemBarButtonTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("UserItemsViewController") as! UserItemsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func MenuButtonTapped(sender: AnyObject) {
        let menuController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController")
        NSNotificationCenter.defaultCenter().postNotificationName("showMenu", object: nil, userInfo: ["menuController" : menuController])
    }
    @IBAction func ExchangeButtonTapped(sender: AnyObject) {
        performReaction(interested: true)
        let image = UIImageView(image: UIImage(named: "exchange"))
        image.center = self.view.center
        image.alpha = 0.0
        self.view.addSubview(image)
        UIView.animateWithDuration(0.5, animations: {
            image.alpha = 1
            image.transform = CGAffineTransformMakeScale(3, 3)
            }) { (success) in
                image.removeFromSuperview()
        }
    }

    @IBAction func IgnoreButtonTapped(sender: AnyObject) {
        performReaction(interested: false)
        let image = UIImageView(image: UIImage(named: "ignore"))
        image.center = self.view.center
        image.alpha = 0.0
        self.view.addSubview(image)
        UIView.animateWithDuration(0.5, animations: {
            image.alpha = 1
            image.transform = CGAffineTransformMakeScale(3, 3)
        }) { (success) in
            image.removeFromSuperview()
        }
    }

    private func performReaction(interested interested: Bool) {
        if currentItem != nil {
            ServerInterface.sharedInstance.reactToItem(currentItem, interested: interested, callback: increaseCurrentIndexCallback)
        }
    }

    func increaseCurrentIndexCallback(success: Bool) {
        if success {
            let duration: NSTimeInterval = 0.3
            imageXConstraint.constant -= view.frame.width
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                }, completion: {
                    _ in
                    self.loadUIElements()
                    self.imageXConstraint.constant = self.view.center.x + self.view.frame.width
                    self.view.layoutIfNeeded()
                    self.imageXConstraint.constant = 0
                    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [], animations: {
                        self.view.layoutIfNeeded()
                        }, completion: nil)
            })
        }
    }

    func loadUIElements() {
        imageIndex = 0
        if browseItems.count > 0 {
            toggleInterface(false)
            currentItem = browseItems.popLast()
            image.image = currentItem.pictures[0].asUIImage()
            name.text = currentItem.name
            descriptionText.text = currentItem.description
            ServerInterface.sharedInstance.requestDistanceForItem(currentItem, callback: { (distance) in
                self.distance.text = "\(distance) miles"
            })
        } else {
            image.image = nil
            toggleInterface(true)
        }
    }

    func toggleInterface(hidden: Bool) {
        descriptionText.hidden = hidden
        image.hidden = hidden
        name.hidden = hidden
        ignoreButton.hidden = hidden
        exchangeButton.hidden = hidden
        distance.hidden = hidden
        noMoreItems.hidden = !hidden
    }
}
