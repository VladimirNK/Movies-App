//
//  UITableView+Extension.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 22.06.2024.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        let identifier = String(describing: cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
