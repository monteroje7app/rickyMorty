//
//  BaseViewController.swift
//  ricky
//
//  Created by Jose Montero on 5/10/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var loadingView: UIView! {
        didSet {
            loadingView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false

    }
    
    func hideSpinner() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true

    }


}
