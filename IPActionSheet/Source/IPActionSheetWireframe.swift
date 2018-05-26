//
//  IPActionSheetWireframe.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

protocol IPActionSheetWireframing {
    
    func viewController(for event: IPActionSheet.NavigationEvent) -> UIViewController?
}

struct IPActionSheetWireframe: IPActionSheetWireframing {
    
    func viewController(for event: IPActionSheet.NavigationEvent) -> UIViewController? {
        
        switch event.position {
        case .actionSheet: return makeActionSheetViewController(event: event)
        }
    }
}

private extension IPActionSheetWireframe {
    
    func makeActionSheetViewController(event: IPActionSheet.NavigationEvent) -> IPActionSheetController {
        
        let viewController = IPActionSheetController()
        let viewControllerConfigurator = IPActionSheetViewConfigurator(containerView: viewController.containerView, visualEffectView: viewController.visualEffectView)
        let navigator = IPActionSheetNavigator(sourceViewController: viewController)
        let router = IPActionSheetRouter(navigator: navigator, wireframe: self)
        let viewControllerPresenter = IPActionSheetPresenter(viewController: viewController,
                                                             configurator: viewControllerConfigurator,
                                                             presentationEvent: event,
                                                             router: router)
        
        viewController.presenter = viewControllerPresenter
        viewController.transitioningDelegate = viewController
        
        return viewController
    }
}
