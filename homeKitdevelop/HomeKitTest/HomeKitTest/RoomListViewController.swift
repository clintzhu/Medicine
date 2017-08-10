//
//  RoomListViewController.swift
//  HomeKitTest
//
//  Created by apple on 4/13/17.
//  Copyright © 2017 zyb. All rights reserved.
//

import UIKit
import SnapKit
import HomeKit
class RoomListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    private lazy var roomListView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.Plain)
    private var home:HMHome? = nil;
    
    init(home:HMHome?){
    
        super.init(nibName: nil, bundle: nil)
        self.home = home
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "room"
        self.roomListView.rowHeight = 40.0
        self.roomListView.delegate = self
        self.roomListView.dataSource = self
        self.roomListView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.roomListView)
        self.roomListView.snp_makeConstraints { (make) in
            let inset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            make.edges.equalTo(self.view).inset(inset)
        }
        self.roomListView.backgroundColor = UIColor.whiteColor()
        self.setUpNavi()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpNavi()->Void{
    
        let button:UIButton = UIButton(type: UIButtonType.ContactAdd)
        button.addTarget(self, action: #selector(addButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let barItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    
    //MARK:-UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.home?.rooms.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let room:HMRoom = (self.home?.rooms[indexPath.row])!
        cell.textLabel?.text = room.name

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let room:HMRoom = (self.home?.rooms[indexPath.row])!
        let accessoriesViewController:AccessoriesViewController = AccessoriesViewController(room: room, home: self.home!)
        self.navigationController?.pushViewController(accessoriesViewController, animated: true)
    }
    
    
    func addButton(sender:UIButton){
        
        let AlterController:UIAlertController = UIAlertController(title: "房间名", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let action:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default) { (alter) in
            
            
            
            let textField:UITextField =  (AlterController.textFields?.first)!
            if let content = textField.text{
                
                if content.characters.count > 0{
                    self.home?.addRoomWithName(content, completionHandler: { (room, error) in
                        self.roomListView.reloadData()
                    })
                }
            }
        }
        AlterController.addAction(action)
        
        AlterController.addTextFieldWithConfigurationHandler { (textField) in
            textField.delegate = self
            
        }
        
        self.navigationController?.presentViewController(AlterController, animated: true, completion: { 
            
        })
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }

}
