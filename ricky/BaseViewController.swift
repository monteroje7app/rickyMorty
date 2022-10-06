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

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideSpinner() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }


}
