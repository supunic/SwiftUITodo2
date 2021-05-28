//
//  TaskToday.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/28.
//

import SwiftUI
import CoreData

struct TaskToday: View {
    @FetchRequest(
        // TodoEntity.time でのsort
        sortDescriptors: [NSSortDescriptor(keyPath: \TodoEntity.time,
                                           ascending: true)],
        // predicate ... DBの検索条件（nowの0時から次の日の0時までの1日分）
        // Date に Extension を追加
        predicate: NSPredicate(format:"time BETWEEN {%@ , %@}", Date.today as NSDate, Date.tomorrow as NSDate),
        animation: .default)

    var todoList: FetchedResults<TodoEntity>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("今日のタスク").font(.footnote).bold().padding()
            List(todoList) { todo in
                TodoDetailRow(todo: todo)
            }
        }.background(Color(UIColor.systemBackground))
    }
}

struct TaskToday_Previews: PreviewProvider {
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
                          category: .ImpUrg_1st, task: "炎上プロジェクト")
        TodoEntity.create(in: context,
                          category: .ImpNUrg_2nd, task: "自己啓発")
        TodoEntity.create(in: context,
                          category: .NImpUrg_3rd, task: "意味のない会議")
        TodoEntity.create(in: context,
                          category: .NImpNUrg_4th, task: "暇つぶし")

        return TaskToday().environment(\.managedObjectContext, context)
    }
}
