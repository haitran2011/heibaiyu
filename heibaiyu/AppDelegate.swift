//
//  AppDelegate.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/17/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Whisper
import XCGLogger
import SwiftyTimer
import Reachability
let blog = XCGLogger.default


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  var netyi_ts: Int = 0
		

  let connectNoti = Notification.Name("client_connect")
  let reachable = Reachability()!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // log
    let blogpath = Bundle.main.resourcePath?.appending("xcglog")
    blog.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: blogpath, fileLevel: .debug)
    /*
    let console = ConsoleDestination()  // log to Xcode Console
    let file = FileDestination()  // log to default swiftybeaver.log file
    let cloud = SBPlatformDestination(appID: "0G8Zdw", appSecret: "fUztpslboizfwDw968gabnktxe4homhx", encryptionKey: "9tPMxajdieYxscqnncnnq6bhxyrpD0ai") // to cloud
    console.format = "$DHH:mm:ss$d $L $M"
    file.format = "$DHH:mm:ss$d $L $M"
    cloud.format = "$DHH:mm:ss$d $L $M"
    blog.addDestination(console)
    blog.addDestination(file)
    blog.addDestination(cloud)
    blog.verbose("blog is ok")
 */
    // bundle language
    Bundle.setLanguage("zh-Hans")
    // net whether reachable
    NotificationCenter.default.addObserver(self, selector: #selector(self.reachableCheck(note:)), name: ReachabilityChangedNotification, object: reachable)
    do {
      try reachable.startNotifier()
    } catch {
      blog.debug(error)
    }
    // root vc
    let rootvc = StoryboardScene.Main.instantiateSignupController()
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    let barAppearace = UINavigationBar.appearance()
    barAppearace.barTintColor = UIColor(named: .huaqin)
    barAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    window?.rootViewController = rootvc
    return true
  }
  
  func startNetyi() {
    // netyi config
    var mainpath = Bundle.main.bundlePath
    mainpath.append("/root-ca.crt")
    if netyiwarpper.netyi_isOpened() {
      blog.debug("netyi is already open")
    }else {
      var ping = Chat_Ping()
      ping.msg = "ping"
      var ping_string = String()
      do {
        let data = try ping.serializeProtobuf()
        ping_string = String(data: data, encoding: .utf8)!
      }catch {
        blog.debug(error)
      }
      netyiwarpper.openyi_netWithcert(mainpath, with: ping_string, with: { [weak self] in
        DispatchQueue.main.async { [weak self] in
          NotificationCenter.default.post(name: (self?.connectNoti)!, object: self!, userInfo:nil)
        }
      }) {  (err_no, err_msg) in
        DispatchQueue.main.async {
          blog.debug((err_no, err_msg))
          if (60010 != err_no ||
            60012 != err_no) {
            netyiwarpper.closeyi_net();
          }
        }
      }
      netyiwarpper.netyi_net_isConnect(true)
    }
  }
  
  func reachableCheck(note: NSNotification) {
    let reachability = note.object as! Reachability
    DispatchQueue.main.async { [weak self] in
      if reachability.isReachable {
        self!.startNetyi();
        //
        if reachability.isReachableViaWiFi {
          blog.debug("Reachable via WiFi")
        } else {
          blog.debug("Reachable via Cellular")
        }
      } else {
        netyiwarpper.netyi_net_isConnect(false)
        blog.debug("Network not reachable")
      }
    }
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    netyiwarpper.closeyi_net()
  }


}

