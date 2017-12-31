//
//  LeftSliderViewController.swift
//  SliderMenu
//
//  Created by Mathews on 17/05/17.
//  Copyright © 2017 mathews. All rights reserved.
//

import UIKit

class LeftSliderViewController: UIViewController {

    @IBOutlet weak var leftSliderTableView: UITableView!
    
    var rootViewDelegate: RootViewControllerDelegate?
    var sliderMenuDelegate: SliderMenuDelegate?
    var menuItems: [String] = ["First VC", "Second VC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTargets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension LeftSliderViewController {
    
    func addTargets() {
        self.leftSliderTableView.dataSource = self
        self.leftSliderTableView.delegate = self
    }
    
    
    /// Reloads the tableview in UI thread
    func reloadTable() {
        DispatchQueue.main.async {
            self.leftSliderTableView.reloadData()
        }
    }
}



// MARK: - UITableViewDataSource
extension LeftSliderViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftSliderMenuCell", for: indexPath) as! MenuTableViewCell
        cell.menuTitle.text = self.menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftSliderProfileCell") as! LeftSliderProfileHeaderCell
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LeftSliderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.rootViewDelegate?.didSelectMenu(item: self.menuItems[indexPath.row])
        sliderMenuDelegate?.toggleLeftSlider()
    }
}
