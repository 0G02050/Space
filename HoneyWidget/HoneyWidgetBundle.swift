//
//  HoneyWidgetBundle.swift
//  HoneyWidget
//
//  Created by 小川正博 on 2025/12/24.
//

import WidgetKit
import SwiftUI

@main
struct HoneyWidgetBundle: WidgetBundle {
    var body: some Widget {
        HoneyWidget()
        HoneyWidgetControl()
        HoneyWidgetLiveActivity()
    }
}
