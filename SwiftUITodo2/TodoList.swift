//
//  TodoList.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/27.
//

import SwiftUI
import CoreData

struct TodoList: View {
    // @FetchRequest DBからデータを取得できる
    // sort ... NSSortDescriptorで設定、keyPathで対象、ascendingがtrueで昇順
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TodoEntity.time,
                                           ascending: true)],
        animation: .default)
    var todoList: FetchedResults<TodoEntity>
    
    let category: TodoEntity.Category

    var body: some View {
        List {
            // ForEach構造体
            ForEach(todoList) { todo in
                Text(todo.task ?? "no title")
            }
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    // AppDelegate型で型キャスト
    // AppDelegateにあるpersistentContainer（DBの永続コンテナ）に、
    // DB操作をするための機能が全て入っている
    // CoreDataを使用する場合、
    // project 作成時にAppDelegateが自動生成されている

    static let container = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer
    static let context = container.viewContext

    static var previews: some View {
        // TodoEntityの全テストデータを削除するためのrequest作成
        let request = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "TodoEntity"))
        // 取得したテストデータの全削除
        try! container.persistentStoreCoordinator.execute(request, with: context)
        // データを追加
        TodoEntity.create(in: context,
                          category: .ImpUrg_1st,
                          task: "Todo1")
        TodoEntity.create(in: context,
                          category: .ImpUrg_1st,
                          task: "Todo2")
        TodoEntity.create(in: context,
                          category: .ImpUrg_1st,
                          task: "Todo3")
        TodoEntity.create(in: context,
                          category: .ImpUrg_1st,
                          task: "Todo4")
        
        // 作成したcontextをviewに指定する場合、environmentを用いる
        // 設定先 → managedObjectContext
        // 対象 → CoreData コンテキスト
        return TodoList(category: .ImpUrg_1st)
            .environment(\.managedObjectContext, context)
    }
}
