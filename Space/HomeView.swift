import SwiftUI

struct HomeView: View {
    // 用来存放用户输入的清单名字（比如“周末大采购”）
    @State private var inputListName: String = ""
    // 控制页面跳转的开关
    @State private var isShoppingStarted: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // 1. 欢迎标题
                VStack(spacing: 10) {
                    Image(systemName: "cart.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.pink)
                    Text("准备好购物了吗？")
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.top, 50)
                
                // 2. 输入区域
                VStack(alignment: .leading) {
                    Text("给今天的清单起个名：")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("例如：周五火锅局", text: $inputListName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 3. 开始按钮 (点击跳转)
                // 这里使用 navigationDestination 来告诉系统跳去哪里
                Button(action: {
                    if !inputListName.isEmpty {
                        isShoppingStarted = true
                    }
                }) {
                    Text("创建清单并出发")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(inputListName.isEmpty ? Color.gray.opacity(0.3) : Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(inputListName.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 50)
                
                // 4. 导航逻辑
                // 当 isShoppingStarted 变成 true 时，推入 ShoppingListView
                .navigationDestination(isPresented: $isShoppingStarted) {
                    // 把输入的名字传给下一页
                    ShoppingListView(listName: inputListName)
                }
            }
            .navigationTitle("首页")
        }
    }
}

#Preview {
    HomeView()
}
