//
//  IPActionSheetNavigator.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

protocol IPActionSheetNavigatorProtocol {
    
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func presentModally(_ viewController: UIViewController, animated: Bool, completion: IPActionSheet.PresentationCompletionBlock?)
    func dismissModal(animated: Bool, completion: IPActionSheet.PresentationCompletionBlock?)
    func presentInNewWindow(_ viewController: UIViewController, in window: UIWindow?, animated: Bool, completion: IPActionSheet.PresentationCompletionBlock?)
    func closeWindow(in window: UIWindow?)
}

struct IPActionSheetNavigator {
    
    let sourceViewController: UIViewController
}

extension IPActionSheetNavigator: IPActionSheetNavigatorProtocol {
    
    func push(_ viewController: UIViewController,
              animated: Bool) {
        
        guard let navigationController: UINavigationController = sourceViewController.navigationController else {
            
            return
        }
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        
        guard let navigationController: UINavigationController = sourceViewController.navigationController else {
            
            return
        }
        
        navigationController.popViewController(animated: animated)
    }
    
    func presentModally(_ viewController: UIViewController,
                        animated: Bool,
                        completion: IPActionSheet.PresentationCompletionBlock?) {
        
        sourceViewController.present(viewController,
                                     animated: animated,
                                     completion: completion)
    }
    
    func dismissModal(animated: Bool,
                      completion: IPActionSheet.PresentationCompletionBlock?) {
        
        sourceViewController.dismiss(animated: animated, completion: completion)
    }
    
    func presentInNewWindow(_ viewController: UIViewController,
                            in window: UIWindow?,
                            animated: Bool,
                            completion: IPActionSheet.PresentationCompletionBlock?) {
        
        window?.rootViewController = viewController
        
        window?.makeKeyAndVisible()
    }

    func closeWindow(in window: UIWindow?) {
        
        window?.isHidden = true
    }
}
