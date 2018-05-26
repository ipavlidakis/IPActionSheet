//
//  IPActionSheetPresenter.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

final class IPActionSheetPresenter {
    
    private let viewController: UIViewController
    private let configurator: IPActionSheetViewConfigurator
    private let presentationEvent: IPActionSheet.NavigationEvent
    private let router: IPActionSheetRouter
    
    init(viewController: UIViewController,
         configurator: IPActionSheetViewConfigurator,
         presentationEvent: IPActionSheet.NavigationEvent,
         router: IPActionSheetRouter) {
        
        self.viewController = viewController
        self.configurator = configurator
        self.presentationEvent = presentationEvent
        self.router = router
    }
    
    func didLoad(view: UIView) {
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emptySpaceTapped(_:)))
        
        presentationEvent.embeddedViewController.willMove(toParentViewController: viewController)
        viewController.addChildViewController(presentationEvent.embeddedViewController)
        presentationEvent.embeddedViewController.didMove(toParentViewController: viewController)
        
        configurator.configure(view: view,
                               tapGestureRecognizer: tapGestureRecognizer,
                               embeddedViewController: presentationEvent.embeddedViewController,
                               viewModel: IPActionSheetControllerViewModel(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .prominent))))
    }

    func willTransition(to newCollection: UITraitCollection,
                        with coordinator: UIViewControllerTransitionCoordinator) {
        
        configurator.configure(to: presentationEvent.embeddedViewController.preferredSize(for: newCollection),
                               with: coordinator)
    }
}

private extension IPActionSheetPresenter {
    
    @objc
    func emptySpaceTapped(_ sender: UITapGestureRecognizer) {
        
        router.performEvent(event: presentationEvent.reverse())
    }
}
