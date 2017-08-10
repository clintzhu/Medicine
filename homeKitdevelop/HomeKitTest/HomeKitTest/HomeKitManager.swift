//
//  HomeKitManager.swift
//  HomeKitTest
//
//  Created by apple on 4/11/17.
//  Copyright © 2017 zyb. All rights reserved.
//

import HomeKit


@objc protocol HomeKitManagerProtocol {
 
// 只要协议中存在 option的 属性或方法  那么 协议必须被标记为@objc
 optional  func homeManagerDidUpdateHomes()->Void
 optional  func homeManagerDidAddHome()->Void
 optional  func primaryHomeDidUpdate()->Void
 optional  func homeManagerDidRemoveHome()->Void
    
}

class HomeKitManager: NSObject,HMHomeManagerDelegate{
    
    private  let homeManager:HMHomeManager = HMHomeManager()
    private static let homeKitManagerInner = HomeKitManager();
    var delegate:HomeKitManagerProtocol? = nil
    //MARK:-class 可以被子类重写  static 是不能被重写的

    class var homeKitManager:HomeKitManager{
    
        return homeKitManagerInner
    }
    
   private override init() {
    super.init()
    homeManager.delegate = self
    
}
    
    
    func addHomeByName(homeName:String) -> Void {
        self.homeManager.addHomeWithName(homeName) { (home, error) in

            
            
        }
    }
    
    
    func removeHomeByName(home:HMHome)->Void{
        
        self.homeManager.removeHome(home) { (error) in
        }
    }
    
    func homes()->Array<HMHome>{
    
        return self.homeManager.homes
    }
    
    
    //MARK:根据名字找到home
    func homeByHomeName(homeName:String) -> HMHome? {
        var homeItem:HMHome? = nil
        for item in self.homeManager.homes{
            if(homeName == item.name){
                homeItem = item
                break
            }
        }
        return homeItem
    }
    
    
    
    func asignAccessoryToRoom(home:HMHome?,room:HMRoom?,accessory:HMAccessory?)->Void{
        
        guard let existHome = home else{
            
            return
        }
        
        guard let existRoom = room else{
        
            return
        }
        
        guard let acce = accessory else{
        
            return
        }
        
        home?.addAccessory(acce, completionHandler: { (error) in
            if let checkError = error{
            
                    print("添加智能设备失败:\(checkError.description)")
            }
            else{
            
                existHome.assignAccessory(acce, toRoom:existRoom) { (error) in
                    
                    if let e = error{
                        print("无法添加智能硬件 \(e.description)")
                    }
                }
            }
        })
        

        
    }
    
    
    
    deinit{
    
    }
    
    //MARK:-homeManagerDelegate
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        self.delegate?.homeManagerDidAddHome!()
         print("已经更新了home")
    }
    
    func homeManagerDidUpdatePrimaryHome(manager: HMHomeManager) {
        
 
        print("已经更新了primaryHome")

    }
    
    func homeManager(manager: HMHomeManager, didAddHome home: HMHome) {
         print("已经添加了Home")
    }
    
    func homeManager(manager: HMHomeManager, didRemoveHome home: HMHome) {
        print("已经移除Home")

    }

}
