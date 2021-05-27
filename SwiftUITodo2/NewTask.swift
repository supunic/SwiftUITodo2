//
//  NewTask.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/28.
//

import SwiftUI

struct NewTask: View {
    var body: some View {
        // 画面遷移の管理で使用する、NavigationLinkと一緒に
        // タイトルやボタンを追加できる
        NavigationView {
            // NavigationViewに対してモディファイアを直接指定するではなく、内包するviewに対して指定する
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
