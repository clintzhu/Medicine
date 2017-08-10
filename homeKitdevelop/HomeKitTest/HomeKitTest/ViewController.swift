//
//  ViewController.swift
//  HomeKitTest
//
//  Created by apple on 4/11/17.
//  Copyright © 2017 zyb. All rights reserved.
//

import UIKit
import HomeKit
class ViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HomeKitManagerProtocol{
    
    
    
    @IBOutlet var homeListView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "home"
        self.navigationController?.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.homeListView.rowHeight = 40.0
        self.setUpNavi()
        HomeKitManager.homeKitManager.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeKitManager.homeKitManager.homes().count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let homeItem:HMHome = HomeKitManager.homeKitManager.homes()[indexPath.row]
        let cell = tableView .dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = homeItem.name
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectHome:HMHome = HomeKitManager.homeKitManager.homes()[indexPath.row]
        let roomViewController:RoomListViewController = RoomListViewController(home: selectHome)
        self.navigationController?.pushViewController(roomViewController, animated: true)
        
    }
    
    //MARK:-自定义方法
    func setUpNavi()->Void{
    
        let naviLeftButton:UIButton  = UIButton(type: UIButtonType.ContactAdd)
        naviLeftButton.addTarget(self, action: #selector(rightButtonAction(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        let navigationBarItem:UIBarButtonItem = UIBarButtonItem(customView: naviLeftButton)
        self.navigationItem.rightBarButtonItem = navigationBarItem
    }
    
    
    func rightButtonAction(sender:UIButton){
        let inputAlterController:UIAlertController = UIAlertController(title: "输入家庭名称", message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        let Action:UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (alterAction) in
            
            let textField:UITextField =  (inputAlterController.textFields?.first)!
            if let content = textField.text{
                
                if content.characters.count > 0{
                    HomeKitManager.homeKitManager.addHomeByName(content)
                }
            }
        }
        
        
        
        inputAlterController.addAction(Action)
        
        inputAlterController.addTextFieldWithConfigurationHandler { (textField) in
            textField.delegate = self;
        }
        self.navigationController?.presentViewController(inputAlterController, animated: true, completion: { 
            
        })
    }
    
    
//MARK:-UITextFieldDeleate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    

    
//MARK:-HomeKitManagerProtocal
    
    func homeManagerDidAddHome() {
        self.homeListView.reloadData()
    }
    
    func homeManagerDidUpdateHomes() {
        
    }
    
    func homeManagerDidRemoveHome() {
        
    }
    
    func primaryHomeDidUpdate() {
        
    }
}

