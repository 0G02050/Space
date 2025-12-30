import Foundation

// Identifiable: 告诉 SwiftUI 这个东西有唯一 ID，列表显示时不会乱
// Codable: 方便以后把数据转成 JSON 存到网络或本地
struct Item: Identifiable, Codable {
    // 1. 唯一身份证 (自动生成)
    var id: UUID = UUID()
    
    // 2. 商品名字 (比如 "酱油")
    var title: String
    
    // 3. 是否买到了 (默认为 false 还没买)
    var isCompleted: Bool = false
}
