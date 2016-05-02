//
//  ViewCustomizers.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class ViewCustomizers {
    
    static func makeRoundedView(view: UIView) {
        view.layer.cornerRadius = view.frame.width / 20
        view.clipsToBounds = true
    }
    
}
