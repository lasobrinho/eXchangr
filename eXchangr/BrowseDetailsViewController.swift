//
//  BrowseDetailsViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class BrowseDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    weak var item: Item!
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            nameLabel.text = item.name
            descriptionLabel.text = item.description
            imageView.image = item.pictures[0].asUIImage()
            ServerInterface.sharedInstance.requestDistanceForItem(item, callback: { [unowned self] (distance) in
                self.distanceLabel.text = "\(distance) miles"
                })
        }

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeRecognizer.direction = .Down
        self.view.addGestureRecognizer(swipeRecognizer)

        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftImageSwipe))
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightImageSwipe))

        leftSwipeRecognizer.direction = .Left
        rightSwipeRecognizer.direction = .Right

        imageView.addGestureRecognizer(leftSwipeRecognizer)
        imageView.addGestureRecognizer(rightSwipeRecognizer)
    }


    let swipeAnimationDuration: NSTimeInterval = 0.15
    func leftImageSwipe(sender: UISwipeGestureRecognizer) {
        if currentIndex < item.pictures.count - 1 {
            currentIndex += 1
            UIView.animateWithDuration(swipeAnimationDuration, animations: {
                self.imageView.center.x = -self.view.center.x
                }, completion: { (success) in
                    self.imageView.center.x = self.view.frame.width + self.view.center.x
                    UIView.animateWithDuration(self.swipeAnimationDuration, animations: {
                        self.imageView.image = self.item.pictures[self.currentIndex].asUIImage()
                        self.imageView.center.x = self.view.center.x
                        }, completion: nil)
            })
        }
    }

    func rightImageSwipe(sender: UISwipeGestureRecognizer) {
        if currentIndex > 0 {
            currentIndex -= 1
            UIView.animateWithDuration(swipeAnimationDuration, animations: {
                self.imageView.center.x = self.view.frame.width + self.view.center.x
                }, completion: { (success) in
                    self.imageView.center.x = -self.view.center.x
                    UIView.animateWithDuration(self.swipeAnimationDuration, animations: {
                        self.imageView.image = self.item.pictures[self.currentIndex].asUIImage()
                        self.imageView.center.x = self.view.center.x
                        }, completion: nil)
            })
        }
    }

    func swipeGesture(sender: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
