//
//  IPActionSheetPosition.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

protocol IPActionSheetEvent { }

protocol IPActionSheetPresentable where Self: UIViewController {
    
    func preferredSize(for traitCollection: UITraitCollection) -> CGSize
}

extension IPActionSheet {
    
    enum Position {
        
        case actionSheet
    }
    
    enum PresentationMode {
        
        case push, modal, inNewWindow
        case pop, dismiss, close
        case invalid
        
        static let presentationModes: [PresentationMode] = [.push, .modal, .inNewWindow]
        static let dismissalModes: [PresentationMode] = [.pop, .dismiss, .close]
        
        func reverse() -> PresentationMode {
            
            switch self {
            case .push: return .pop
            case .pop: return .push
            case .modal: return .dismiss
            case .inNewWindow: return .close
            case .close: return .inNewWindow
            default: return .invalid
            }
        }
    }
}

extension IPActionSheet {
    
    typealias IPActionSheetPresentableViewController = UIViewController & IPActionSheetPresentable
    
    struct NavigationEvent: IPActionSheetEvent {
        
        let position: Position
        let presentationMode: PresentationMode
        let animated: Bool
        let contextMode: UIModalPresentationStyle
        let window: UIWindow?
        let embeddedViewController: IPActionSheetPresentableViewController
        let completionBlock: PresentationCompletionBlock?
        
        func reverse() -> NavigationEvent {
            
            return NavigationEvent(position: position,
                                   presentationMode: presentationMode.reverse(),
                                   animated: animated,
                                   contextMode: contextMode,
                                   window: window,
                                   embeddedViewController: embeddedViewController,
                                   completionBlock: nil)
        }
    }
}

extension IPActionSheet {
    
    typealias PresentationCompletionBlock = () -> Swift.Void
}
