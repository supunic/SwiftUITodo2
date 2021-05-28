//
//  NewTask.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/28.
//

import SwiftUI

struct NewTask: View {
    @State var task: String = ""
    @State var time: Date? = Date()
    @State var category: Int16 = TodoEntity.Category.ImpUrg_1st.rawValue
    
    // presentationMode ... view の表示制御に使用するオブジェクト（presentationMode に Binding された値として入る）
    @Environment(\.presentationMode) var presentationMode
    
    var categries: [TodoEntity.Category] = [.ImpUrg_1st, .ImpNUrg_2nd, .NImpUrg_3rd, .NImpNUrg_4th]
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func save() {
        do {
            try self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    

    var body: some View {
        // 画面遷移の管理で使用する、NavigationLinkと一緒に
        // タイトルやボタンを追加できる
        NavigationView {
            // NavigationViewに対してモディファイアを直接指定するではなく、内包するviewに対して指定する
            
            // Form ... 指定することでデザインが変わる
            // Form や List には Section を作ることができる
            Form {
                Section(header: Text("タスク")) {
                    TextField("タスクを入力", text: $task)
                }
                Section(header: Toggle(isOn: Binding(isNotNil: $time, defaultValue: Date())) { Text("時間を指定する") }) {
                    if time != nil {
                        DatePicker(selection: Binding($time, Date()), label: { Text("日時") })
                    } else {
                        Text("時間未設定").foregroundColor(.secondary)
                    }
                    
                }
                // 自動的に画面遷移が実装される ← SwiftUIの特徴
                Picker(selection: $category, label: Text("種類")) {
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
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "minus.circle.fill")
                            Text("キャンセル")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("タスクの追加")
            .navigationBarItems(trailing: Button(action: {
                TodoEntity.create(in: self.viewContext,
                                  category: TodoEntity.Category(rawValue: self.category) ?? .ImpUrg_1st,
                                  task: self.task,
                                  time: self.time)
                self.save()
                self.presentationMode.wrappedValue.dismiss()
            }) { Text("保存") })
        }
    }
}

struct NewTask_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    static var previews: some View {
        NewTask().environment(\.managedObjectContext, context)
    }
}
