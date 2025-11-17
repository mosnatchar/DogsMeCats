//
//  DogsRouter.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit

final class DogsRouter: DogsRoutingLogic {
    weak var viewController: UIViewController?
    
    func routeToMeTab() {
        viewController?.tabBarController?.selectedIndex = 2
    }
}
