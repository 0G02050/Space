import ActivityKit
import SwiftUI

struct HoneyAttributes: ActivityAttributes {
    // MARK: - 动态数据 (ContentState)
    // 这里放随着时间会变化的数据
    // 比如：还剩多少个东西没买
    public struct ContentState: Codable, Hashable {
        var remainingCount: Int
    }

    // MARK: - 静态数据
    // 这里放活动开始后就不再变的数据
    // 比如：这个清单叫什么名字
    var listName: String
}
