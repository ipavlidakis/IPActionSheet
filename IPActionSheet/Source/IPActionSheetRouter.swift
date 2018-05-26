//
//  IPActionSheetRouter.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

struct IPActionSheetRouter {
    
    let navigator: IPActionSheetNavigatorProtocol
    let wireframe: IPActionSheetWireframing
    
    func performEvent(event: IPActionSheetEvent) {
        
        switch event {
        case let event as IPActionSheet.NavigationEvent: handle(event)
        default: break
        }
    }
}

private extension IPActionSheetRouter {
    
    func navigate(to viewController: UIViewController,
                  event: IPActionSheet.NavigationEvent) {
        
        switch event.presentationMode {
        case .push: navigator.push(viewController, animated: event.animated)
        case .modal: navigator.presentModally(viewController, animated: event.animated, completion: event.completionBlock)
        case .inNewWindow: navigator.presentInNewWindow(viewController, in: event.window, animated: event.animated, completion: event.completionBlock)
        default: break
        }
    }
    
    func navigate(from event: IPActionSheet.NavigationEvent) {
        
        switch event.presentationMode {
        case .pop: navigator.pop(animated: event.animated)
        case .dismiss: navigator.dismissModal(animated: event.animated, completion: event.completionBlock)
        case .close: navigator.closeWindow(in: event.window)
        default: break
        }
    }
}

private extension IPActionSheetRouter {
    
    func handle(_ event: IPActionSheet.NavigationEvent) {
        
        guard IPActionSheet.PresentationMode.presentationModes.contains(event.presentationMode) else {
            
            navigate(from: event)
            return
        }
        
        guard let viewController = wireframe.viewController(for: event) else {
            
            return
        }
        
        viewController.modalPresentationStyle = event.contextMode
        navigate(to: viewController, event: event)
    }
}
