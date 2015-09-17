//
//  Float+Extensions.swift
//  Thunder Ball
//
//  Created by Drew Nibeck on 9/16/15.
//  Copyright © 2015 Thunder Ball. All rights reserved.
//

import Foundation

extension Float {
  public static func random() -> Float {
    return Float(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  public static func random(min: Float, max: Float) -> Float {
    assert(min < max)
    return Float.random() * (max - min) + min
  }
}
