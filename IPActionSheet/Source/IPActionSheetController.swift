//
//  IPActionSheetController.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

final class IPActionSheetController: UIViewController {

    let containerView: UIView = UIView()
    let visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: nil)
    
    var presenter: IPActionSheetPresenter?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presenter?.didLoad(view: view)
    }
}

extension IPActionSheetController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return IPActionSheetControllerPresentationTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return IPActionSheetControllerDismissalransition()
    }
}

extension IPActionSheetController {
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        
        presenter?.willTransition(to: newCollection, with: coordinator)
    }
}
