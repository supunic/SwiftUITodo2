//
//  TodoDetailRow.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/27.
//

import SwiftUI

struct TodoDetailRow: View {
    // @stateのオブジェクト版
    // @ObservedObjectによって、変数が持つメンバに変更があれば画面に反映される
    @ObservedObject var todo: TodoEntity
    
    var body: some View {
        HStack {
            CategoryImage(TodoEntity.Category(rawValue: todo.category))
            CheckBox(checked: Binding(get: {
                // get: checkedの値を参照するとき → 自分が保持するIntの値を評価して、Boolで返却
                self.todo.state == TodoEntity.State.done.rawValue
            }, set: {
                // set: checkedの値を変更するとき → 引数で与えられた$0のIntの値を評価して、Boolで返却
                self.todo.state = $0 ? TodoEntity.State.done.rawValue : TodoEntity.State.todo.rawValue
            })) {
                if self.todo.state == TodoEntity.State.done.rawValue {
                    Text(self.todo.task ?? "no title").strikethrough()
                } else {
                    Text(self.todo.task ?? "no title")
                }
            }.foregroundColor(
                self.todo.state == TodoEntity.State.done.rawValue ? .secondary : .primary
            )
        }
        .gesture(DragGesture().onChanged({ value in
            // 右から左へのスワイプジェスチャー時の処理
            if value.predictedEndTranslation.width > 200 {
                if self.todo.state != TodoEntity.State.done.rawValue {
                    self.todo.state = TodoEntity.State.done.rawValue
                }
            // 左から右へのスワイプジェスチャー時の処理
            } else if value.predictedEndTranslation.width < -200 {
                if self.todo.state != TodoEntity.State.todo.rawValue {
                    self.todo.state = TodoEntity.State.todo.rawValue
                }
            }
        }))
    }
}

struct TodoDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        // DB操作を行うためのcontextを取得
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newTodo = TodoEntity(context: context)
        newTodo.task = "将来への人間関係づくり"
        newTodo.state = TodoEntity.State.todo.rawValue
        newTodo.category = 0

        return TodoDetailRow(todo: newTodo)
    }
}
