//
//  UITableViewExt.swift
//  HieuSwiftData
//
//  Created by Lê Minh Hiếu on 5/8/25.
//

import Foundation
import UIKit

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

public extension UITableView
{
    /// Đăng kí cell cho tableView
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil)
    {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: className)
    }

    /// Đăng kí mảng cell cho tableView
    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil)
    {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    /// Xử lý tái sử dụng cell trong hàm CellForRowAt
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T
    {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

