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
    
    var presenter: IPActionSheetPresenter?
    
    override func viewDidLoad() {
        
        presenter?.didLoad(view: view)
    }
}
