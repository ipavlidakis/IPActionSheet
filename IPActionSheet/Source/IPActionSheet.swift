//
//  IPActionSheet.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

final class IPActionSheet {
    
    private let router: IPActionSheetRouter
    
    convenience init(viewController: UIViewController) {
        
        let navigator: IPActionSheetNavigatorProtocol = IPActionSheetNavigator(sourceViewController: viewController)
        let wireframe: IPActionSheetWireframing = IPActionSheetWireframe()
        
        let router: IPActionSheetRouter = IPActionSheetRouter(navigator: navigator,
                                                              wireframe: wireframe)
        
        self.init(router: router)
    }
    
    init(router: IPActionSheetRouter) {
        
        self.router = router
    }
}

extension IPActionSheet {
    
    func perform(for position: Position,
                 embeddedViewController: IPActionSheetPresentableViewController) {
        
        switch position {
        case .actionSheet:
            
            let window: UIWindow = UIWindow()
            window.windowLevel = UIWindowLevelAlert
            window.backgroundColor = .clear
            
            let navigationEvent = NavigationEvent(position: position,
                                                  presentationMode: .modal,
                                                  animated: true,
                                                  contextMode: .overCurrentContext,
                                                  window: window,
                                                  embeddedViewController: embeddedViewController,
                                                  completionBlock: nil)
            
            router.performEvent(event: navigationEvent)
        }
    }
}
