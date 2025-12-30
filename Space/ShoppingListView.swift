import SwiftUI
import ActivityKit

struct ShoppingListView: View {
    var listName: String
    // MARK: - 数据源
    // 初始为空，或者留几个默认的
    @State private var items: [Item] = [
        Item(title: "测试商品")
    ]
    
    // 新增：用来接收用户输入的文字
    @State private var newItemName: String = ""
    
    @State private var currentActivity: Activity<HoneyAttributes>? = nil
    
    var body: some View {
        VStack {
            // MARK: - 1. 顶部输入区域 (新增)
            HStack {
                TextField("输入想买的东西...", text: $newItemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addItem) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .disabled(newItemName.isEmpty) // 没字的时候不能点
            }
            .padding()
            
            // MARK: - 2. 控制区域
            if currentActivity == nil {
                Button(action: startLiveActivity) {
                    Label("开启灵动岛 (出发)", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .padding(.horizontal)
            } else {
                Button(action: endLiveActivity) {
                    Label("结束购物", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .padding(.horizontal)
            }
            
            // MARK: - 3. 列表区域
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.title)
                            .strikethrough(item.isCompleted)
                            .foregroundColor(item.isCompleted ? .gray : .primary)
                        Spacer()
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .gray)
                            .font(.title2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleStatus(for: item)
                    }
                }
                .onDelete(perform: deleteItems) // 👈 新增：左滑删除功能
            }
        }
    }
    
    // MARK: - 逻辑控制
    
    // 新增：添加商品
    func addItem() {
        let newItem = Item(title: newItemName)
        withAnimation {
            items.append(newItem)
        }
        newItemName = "" // 清空输入框
        
        // 如果灵动岛开着，顺便更新一下数量
        if currentActivity != nil {
            updateLiveActivity()
        }
    }
    
    // 新增：左滑删除
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        if currentActivity != nil {
            updateLiveActivity()
        }
    }
    
    func toggleStatus(for item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            withAnimation {
                items[index].isCompleted.toggle()
            }
            updateLiveActivity()
        }
    }
    
    // MARK: - 灵动岛逻辑 (保持不变)
    func startLiveActivity() {
        let attributes = HoneyAttributes(listName: "我的购物清单")
        let remainingCount = items.filter { !$0.isCompleted }.count
        let initialState = HoneyAttributes.ContentState(remainingCount: remainingCount)
        let content = ActivityContent(state: initialState, staleDate: nil)
        
        do {
            let activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            currentActivity = activity
        } catch {
            print("Error: \(error)")
        }
    }
    
    func updateLiveActivity() {
        let remainingCount = items.filter { !$0.isCompleted }.count
        let updatedState = HoneyAttributes.ContentState(remainingCount: remainingCount)
        let content = ActivityContent(state: updatedState, staleDate: nil)
        
        Task {
            await currentActivity?.update(content)
        }
    }
    
    func endLiveActivity() {
        let finalState = HoneyAttributes.ContentState(remainingCount: 0)
        let content = ActivityContent(state: finalState, staleDate: nil)
        
        Task {
            await currentActivity?.end(content, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}


