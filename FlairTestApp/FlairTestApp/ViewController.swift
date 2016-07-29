//
//  ViewController.swift
//  FlairTestApp
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import UIKit
import Flair

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = Font(systemFontWeight: .black, sizeType: .dynamic(pointSizeBase: 24))
        let color = Color(red: 0, green: 0, blue: 1, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, textColor: colorSet)
        
        let label = UILabel(frame: CGRect(x: 50, y: 200, width: 200, height: 100))
        label.text = "Hello world"
        label.style = style
        view.addSubview(label)
    }

}

