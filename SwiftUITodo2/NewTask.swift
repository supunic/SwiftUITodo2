//
//  NewTask.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/28.
//

import SwiftUI

struct NewTask: View {
    @State var task: String = ""
    @State var time: Date = Date()

    var body: some View {
        // 画面遷移の管理で使用する、NavigationLinkと一緒に
        // タイトルやボタンを追加できる
        NavigationView {
            // NavigationViewに対してモディファイアを直接指定するではなく、内包するviewに対して指定する
            
            // Form ... 指定することでデザインが変わる
            Form {
                TextField("タスクを入力", text: $task)
                DatePicker(selection: $time, label: { Text("日時") })
                Button(action: {}) {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("キャンセル")
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("タスクの追加")
        }
    }
}

struct NewTask_Previews: PreviewProvider {
    static var previews: some View {
        NewTask()
    }
}
