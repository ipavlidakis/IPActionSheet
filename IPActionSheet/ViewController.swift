//
//  ViewController.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private var actionSheet: IPActionSheet!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        actionSheet = IPActionSheet(viewController: self)
    }
    
    @IBAction func showActionSheet(_ sender: UIButton?) {
        
        actionSheet.perform(for: .actionSheet)
    }
}

