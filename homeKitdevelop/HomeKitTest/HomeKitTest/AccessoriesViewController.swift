//
//  AccessoriesViewController.swift
//  HomeKitTest
//
//  Created by apple on 4/13/17.
//  Copyright © 2017 zyb. All rights reserved.
//

import UIKit
import SnapKit
import HomeKit
class AccessoriesViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
AccessorySearchListProtocol,
HMAccessoryDelegate{

    private lazy var accessoryListView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.Plain)
    private var room:HMRoom? = nil
    private var home:HMHome? = nil
    
    
    init(room:HMRoom){
    
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }
    
    
    init(room:HMRoom,home:HMHome){
        
        self.room = room
        self.home = home
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Accessories"
        self.accessoryListView.rowHeight = 40.0
        self.accessoryListView.delegate = self
        self.accessoryListView.dataSource = self
        self.accessoryListView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.accessoryListView)
        self.accessoryListView.snp_makeConstraints { (make) in
            let inset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            make.edges.equalTo(self.view).inset(inset)
        }
        self.accessoryListView.backgroundColor = UIColor.whiteColor()
        self.setUpNavi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

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
        return (self.room?.accessories.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let accessory:HMAccessory = (self.room?.accessories[indexPath.row])!
        cell.textLabel?.text = accessory.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let accessory:HMAccessory = (self.room?.accessories[indexPath.row])!
        let services = accessory.services
        accessory.delegate = self
        for serviceItem in services{
        

            
            let charactors = serviceItem.characteristics
            for characterItem in charactors{

                for pro in characterItem.properties{
                
                    print("属性:\(pro)")
                }
                
            }

        
        }
        
    

    }
    
    
    func addButton(sender:UIButton){
        
        let accessorySerchListViewController = AccessorySeachListViewController();
        accessorySerchListViewController.delegate = self
        self.navigationController?.pushViewController(accessorySerchListViewController, animated: true)
        
    }
    
    
    
    //MARK:-AccessorySearchListViewDeleagte
    func didSelectedAccessory(accessory: HMAccessory) {
        HomeKitManager.homeKitManager.asignAccessoryToRoom(self.home, room:self.room, accessory: accessory)
        self.accessoryListView.reloadData()
    }
    
    
    func accessory(accessory: HMAccessory, service: HMService, didUpdateValueForCharacteristic characteristic: HMCharacteristic) {
        print("\(accessory.name)+++\(service.name)")
    }

}
