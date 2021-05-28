//
//  EditTask.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/28.
//

import SwiftUI

struct EditTask: View {
    // @ObservedObject ... TodoEntity の値を変更したらその変更がすぐDBに反映される
    //                     （画面で入力したと同時に更新される、ただし永続化は別）
    @ObservedObject var todo: TodoEntity
    
    @State var showingSheet = false
    
    // presentationMode ... view の表示制御に使用するオブジェクト（presentationMode に Binding された値として入る）
    @Environment(\.presentationMode) var presentationMode
    
    var categries: [TodoEntity.Category] = [.ImpUrg_1st, .ImpNUrg_2nd, .NImpUrg_3rd, .NImpNUrg_4th]
    @Environment(\.managedObjectContext) var viewContext
    
    // DBの永続化
    fileprivate func save() {
        do {
            try self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    fileprivate func delete() {
        viewContext.delete(todo)
        save()
    }

    var body: some View {
        // NavigationView は 画面遷移を開始するトップページに1つ定義しておけば良いため、ここでは書かない
        Form {
            Section(header: Text("タスク")) {
                TextField("タスクを入力", text: Binding($todo.task, "new task"))
            }
            Section(header: Toggle(isOn: Binding(isNotNil: $todo.time,
                                                 defaultValue: Date())) { Text("時間を指定する") }) {
                if todo.time != nil {
                    DatePicker(selection: Binding($todo.time, Date()), label: { Text("日時") })
                } else {
                    Text("時間未設定").foregroundColor(.secondary)
                }
            }
            // 自動的に画面遷移が実装される ← SwiftUIの特徴
            Picker(selection: $todo.category, label: Text("種類")) {
//                    Text("重要かつ緊急").tag(0)
//                    Text("重要だが緊急ではない").tag(1)
//                    Text("重要でないが緊急").tag(2)
//                    Text("重要でも緊急でもない").tag(3)
                ForEach(categries, id: \.self) { category in
                    HStack {
                        CategoryImage(category)
                        Text(category.toString())
                    }
                    .tag(category.rawValue)
                }
            }
            Section(header: Text("操作")) {
                Button(action: {
                    self.showingSheet = true
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("Delete")
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("タスクの編集")
        .navigationBarItems(trailing: Button(action: {
            self.save()
            self.presentationMode.wrappedValue.dismiss()
        }) { Text("閉じる") })
        // actionSheet ... 削除確認ダイアログ いずれかのviewに対してactionSheet modifire を実装
        . actionSheet(isPresented: $showingSheet) {
            // ActionSheet ... 表示内容を示す構造体
            ActionSheet(title: Text("タスクの削除"),
                        message: Text("このタスクを削除します。よろしいですか？"),
                        buttons: [
                            // destructive ... 押したら削除されるなど、重要な処理を行う場合のデザイン（赤）
                            .destructive(Text("削除")) {
                                self.delete()
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            // cancel ... キャンセルボタン
                            .cancel(Text("キャンセル"))
                        ])
        }
    }
}

struct EditTask_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    static var previews: some View {
        let newTodo = TodoEntity(context: context)
        
        return NavigationView {
            EditTask(todo: newTodo).environment(\.managedObjectContext, context)
        }
    }
}

