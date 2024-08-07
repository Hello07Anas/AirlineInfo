//
//  CustoumAlert.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import UIKit

public struct CustoumAlert {
    
    static func showAlert(title: String?,
                          message: String?,
                          preferredStyle: UIAlertController.Style,
                          from viewController: UIViewController,
                          actions: [UIAlertAction]? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let actions {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
