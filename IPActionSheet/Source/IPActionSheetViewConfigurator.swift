//
//  IPActionSheetViewConfigurator.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

final class IPActionSheetViewConfigurator {
    
    private let containerView: UIView
    private let visualEffectView: UIVisualEffectView
    
    private var containerViewSizeConstraints: IPLayoutConfiguration?
    
    init(containerView: UIView,
         visualEffectView: UIVisualEffectView) {
        
        self.containerView = containerView
        self.visualEffectView = visualEffectView
    }
    
    func configure(view: UIView,
                   tapGestureRecognizer: UITapGestureRecognizer,
                   embeddedViewController: IPActionSheet.IPActionSheetPresentableViewController,
                   viewModel: IPActionSheetControllerViewModel) {
        
        
        configureView(view: view)
        configureVisualEffectView(view: view,
                                  tapGestureRecognizer: tapGestureRecognizer,
                                  viewModel: viewModel)
        configureContainerView(view: view,
                               preferredSize:embeddedViewController.preferredSize(for: view.traitCollection))
        configureEmbeddedView(view: containerView, embeddedView: embeddedViewController.view)
    }
    
    func configure(to preferredSize: CGSize,
                   with coordinator: UIViewControllerTransitionCoordinator) {
     
        if let containerViewSizeConstraints = containerViewSizeConstraints {
            
            containerViewSizeConstraints.deactivate()
        }
        
        containerViewSizeConstraints = containerView.pinSize(size: preferredSize,
                                                             relations: UIPinRelations(width: .equal, height: .equal),
                                                             priorities: UIPinPriorities(width: .defaultHigh, height: .defaultHigh))?.activate()
        
        coordinator.animate(alongsideTransition: { (context) in
            
            self.containerView.layoutIfNeeded()
        }, completion: nil)
    }
}

private extension IPActionSheetViewConfigurator {
    
    func configureView(view: UIView) {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.isOpaque = false
    }
    
    func configureVisualEffectView(view: UIView,
                                   tapGestureRecognizer: UITapGestureRecognizer,
                                   viewModel: IPActionSheetControllerViewModel) {
        
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(visualEffectView, at: 0)
        visualEffectView.pinToSuperviewEdges(with: .zero, useSafeArea: false)?.activate()
        
        visualEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureContainerView(view: UIView,
                                preferredSize: CGSize) {
        
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5
        view.addSubview(containerView)
        
        containerView.pinToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8),
                                          relations: UIPinRelations(left: .greaterThanOrEqual,
                                                                    top: .greaterThanOrEqual,
                                                                    right: .lessThanOrEqual,
                                                                    bottom: .equal),
                                          useSafeArea: false)?.activate()
        containerView.pinCenterOnHorizontalAxis(priorities: UIPinPriorities(centerX: .defaultHigh))?.activate()
        
        containerViewSizeConstraints = containerView.pinSize(size: preferredSize,
                                                             relations: UIPinRelations(width: .equal, height: .equal),
                                                             priorities: UIPinPriorities(width: .defaultHigh, height: .defaultHigh))?.activate()
    }
    
    func configureEmbeddedView(view: UIView,
                               embeddedView: UIView) {
        
        embeddedView.translatesAutoresizingMaskIntoConstraints = true
        embeddedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        embeddedView.frame = view.frame
        view.addSubview(embeddedView)
    }
}
