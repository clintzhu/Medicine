//
//  AccessorySeachListViewController.swift
//  HomeKitTest
//
//  Created by apple on 4/13/17.
//  Copyright © 2017 zyb. All rights reserved.
//

import UIKit
import HomeKit
import SnapKit

@objc protocol AccessorySearchListProtocol{

    optional func didSelectedAccessory(accessory:HMAccessory);
}


class AccessorySeachListViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
HMAccessoryBrowserDelegate {

    private lazy var accessoryListView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.Plain)
    private lazy var browser:HMAccessoryBrowser = HMAccessoryBrowser()
    private var accessoryArray:Array = Array<HMAccessory>()
    
    var delegate:AccessorySearchListProtocol? = nil
    



    
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Accessories"
        self.accessoryListView.rowHeight = 40.0
        self.accessoryListView.delegate = self
        self.accessoryListView.dataSource = self
         self.browser.delegate = self
        self.accessoryListView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.accessoryListView)
        self.accessoryListView.snp_makeConstraints { (make) in
            let inset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            make.edges.equalTo(self.view).inset(inset)
        }
        self.accessoryListView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.browser.startSearchingForNewAccessories()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.browser.stopSearchingForNewAccessories()
    }
    
    

    
    
    
    //MARK:-UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accessoryArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = ""
        let accessory:HMAccessory = self.accessoryArray[indexPath.row]
        cell.textLabel?.text = accessory.name
        
        return cell
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accessory:HMAccessory = self.accessoryArray[indexPath.row]
        self.delegate?.didSelectedAccessory!(accessory)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    //MARK:-HMAccessoryBrowserDelegate
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        
        print("发现了一个新硬件 \(accessory.name)")
        self.accessoryArray.append(accessory)
        self.accessoryListView.reloadData()
        
    }
    
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        print("移除了一个新硬件 \(accessory.name)")

        let index :Int = self.accessoryArray.indexOf(accessory)!
        self.accessoryArray.removeAtIndex(index)
        self.accessoryListView.reloadData()

    }
    
    


}
