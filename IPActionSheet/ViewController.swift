//
//  ViewController.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

extension UINavigationController: IPActionSheetPresentable {
    
    func preferredSize(for traitCollection: UITraitCollection) -> CGSize {
        
        // More information:
        // https://developer.apple.com/ios/human-interface-guidelines/visual-design/adaptivity-and-layout/
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.regular, .regular):
            // iPad portrait & landscape
            return CGSize(width: 400, height: 300)
        case (.compact, .regular):
            // iPhone portrait
            return CGSize(width: view.frame.width, height: view.frame.width / 3)
        case (.regular, .compact):
            // iPhone Plus landscape
            return CGSize(width: 400, height: 300)
        case (.compact, .compact):
            // iPhone landscape
            return CGSize(width: 400, height: 200)
        default:
            return view.frame.size
        }
    }
}

final class ViewController: UIViewController {

    private var actionSheet: IPActionSheet!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        view.backgroundColor = .green
        actionSheet = IPActionSheet(viewController: self)
    }
    
    @IBAction func showActionSheet(_ sender: UIButton?) {
        
        let navController = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc1"))
        actionSheet.perform(for: .actionSheet, embeddedViewController: navController)
    }
}

final class vc1: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

final class vc2: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
