import ActivityKit
import WidgetKit
import SwiftUI

struct HoneyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        // 修正点 1：这里要用 HoneyAttributes (我们自己写的文件)，而不是 HoneyWidgetAttributes
        ActivityConfiguration(for: HoneyAttributes.self) { context in
            // MARK: - 1. 锁屏界面 (Lock Screen)
            HStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(.pink)
                Text("正在购买: \(context.attributes.listName)")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("剩余 \(context.state.remainingCount) 项")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.8)) // 给个背景色防止看不清
            
        } dynamicIsland: { context in
            // MARK: - 2. 灵动岛界面 (Dynamic Island)
            DynamicIsland {
                // A. 展开区域 (Expanded)
                DynamicIslandExpandedRegion(.leading) {
                    Label("\(context.state.remainingCount)", systemImage: "cart.fill")
                        .font(.title2)
                        .foregroundColor(.pink)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("待办清单")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.listName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
            } compactLeading: {
                // B. 收起左侧 (Compact Leading)
                Image(systemName: "cart.fill")
                    .imageScale(.medium)
                    .foregroundColor(.pink)
                    .padding(.leading, 6)
                
            } compactTrailing: {
                // C. 收起右侧 (Compact Trailing)
                Text("\(context.state.remainingCount)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.trailing, 6)
                
            } minimal: {
                // D. 最小化 (Minimal) - 修正点 2：补上了这块代码
                Image(systemName: "cart.fill")
                    .foregroundColor(.pink)
            }
        }
    }
}
