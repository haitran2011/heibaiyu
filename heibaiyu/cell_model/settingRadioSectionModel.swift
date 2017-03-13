//
//  settingRadioSectionModel.swift
//  heibaiyu
//
//  Created by jiwei.wang on 3/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import Foundation

class settingRadioSectionModel: settingSectionModel {
  func setRadioModel(selectedModel: settingRadioCellModel) -> Void {
    for item in self.cellModels {
      let model = item as! settingRadioCellModel
      if model !== selectedModel {
        model.isRadioed = false
      }else {
        model.isRadioed = true
      }
    }
  }
}
