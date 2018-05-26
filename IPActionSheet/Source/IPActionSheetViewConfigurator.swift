//
//  IPActionSheetViewConfigurator.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

struct IPActionSheetViewConfigurator {
    
    func configure(view: UIView,
                   tapGestureRecognizer: UITapGestureRecognizer,
                   viewModel: IPActionSheetControllerViewModel) {
        
        
        configureView(view: view)
        configureVisualEffectView(view: view,
                                  tapGestureRecognizer: tapGestureRecognizer,
                                  viewModel: viewModel)
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
        
        let visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: viewModel.effect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(visualEffectView)
        visualEffectView.pinToSuperviewEdges(with: .zero, useSafeArea: false)?.activate()
        
        visualEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
}
