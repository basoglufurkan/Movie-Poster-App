//
//  Helper.swift
//  Movie Poster App
//
//  Created by Furkan BAŞOĞLU on 1.11.2023.
//

import Foundation
import UIKit

func topNotch()-> Double {
    var topNotch: Double = 20.0
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        topNotch = Double(window?.safeAreaInsets.top ?? 0)
        
    }
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.first
        topNotch = Double(window?.safeAreaInsets.top ?? 0)
    }
    return topNotch
}

func image(data: Data?) -> UIImage? {
  if let data = data {
    return UIImage(data: data)
  }
  return UIImage(named: "img")
}
