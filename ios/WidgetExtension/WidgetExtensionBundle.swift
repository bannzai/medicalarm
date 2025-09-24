//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by bannzai on 2025/09/22.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
      if #available(iOS 26.0, *) {
        AlarmLiveActivityWidget()
      }
    }
}
