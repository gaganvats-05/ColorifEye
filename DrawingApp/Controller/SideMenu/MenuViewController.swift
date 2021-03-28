//
//  MenuViewController.swift
//  DrawingApp
//
//  Created by Gagan vats on 28/03/21.
//  Copyright © 2021 Ranosys. All rights reserved.
//

import UIKit
import SideMenu

protocol MenuViewControllerDelegate: class {
    
    func menu(_ menu: MenuViewController, didSelectItemAt index: Int, at point: CGPoint)
    func menuDidCancel(_ menu: MenuViewController)
}

class MenuViewController: UITableViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    var selectedItem = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = IndexPath(row: selectedItem, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    @IBAction func CanvasView(_ sender: UIButton) {
        
    }
    @IBAction func ImagePicker(_ sender: UIButton) {
        
    }
    @IBAction func Information(_ sender: UIButton) {
        
    }
}

extension MenuViewController {
    
    @IBAction fileprivate func dismissMenu() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Menu protocol
extension MenuViewController: Menu {
    
    var menuItems: [UIView] {
        return [tableView.tableHeaderView!] + tableView.visibleCells
    }
}

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath == tableView.indexPathForSelectedRow ? nil : indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rect = tableView.rectForRow(at: indexPath)
        var point = CGPoint(x: rect.midX, y: rect.midY)
        point = tableView.convert(point, to: nil)
        delegate?.menu(self, didSelectItemAt: indexPath.row, at: point)
    }
}

