//
//  upyun.swift
//  heibaiyu
//
//  Created by jiwei.wang on 2/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation
import SwiftDate

public extension UpYun {
  
  func putUpYun(webp: Data,
                success: @escaping ((URLResponse,Any) -> Void),
                failure: @escaping ((Error) -> Void),
                progress: @escaping (CGFloat, Int64) -> Void) -> Void {
    self.uploadMethod = UPUploadMethod.mutUPload
    let success_ = success
    let failure_ = failure
    let progress_ = progress
    
    self.successBlocker = {
      (response, responseData) in
      blog.verbose((response, responseData))
      success_(response!, responseData!);
    }
    self.failBlocker = {
      (error) in
      blog.verbose(error)
      failure_(error!)
    }
    self.progressBlocker = {
      (percent:CGFloat, requestDidSendBytes:Int64) in
      blog.verbose((percent, requestDidSendBytes))
      progress_(percent, requestDidSendBytes)
    }
    let date = DateInRegion();
    let path = date.string(custom: "/yyyy/MM/dd/HH_mm_ss_")
    let saveKey = path + String(format: "%08X.webp", arc4random())
    blog.verbose(saveKey)
    self.uploadFile(webp, saveKey: saveKey)
  }
}
