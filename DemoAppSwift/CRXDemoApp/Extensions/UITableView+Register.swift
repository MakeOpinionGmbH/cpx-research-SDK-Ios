//
//  UITableView+Register.swift
//  CRX Demo App
//
//  Created by Daniel Fredrich on 11.02.21.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ auto: T.Type) {
        register(T.autoNib, forCellReuseIdentifier: T.autoIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_ header: T.Type) {
        register(T.autoNib, forHeaderFooterViewReuseIdentifier: T.autoIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.autoIdentifier, for: indexPath) as? T else {
            fatalError("\(String(describing: type)) for \(indexPath.description) could not get dequeued")
        }
        return cell
    }

    func dequeueReusableView<T: UITableViewHeaderFooterView>(type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.autoIdentifier) as? T else {
            fatalError("Header/Footer of type \(String(describing: type)) could not get dequeued.")
        }
        return view
    }
}

extension UIView {
    static var autoIdentifier: String {
        return String(describing: self.self) + "Identifier"
    }

    static var autoNib: UINib {
        return UINib(nibName: String(describing: self.self), bundle: nil)
    }
}
