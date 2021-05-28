//
//  CategoryView.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/27.
//

import SwiftUI

struct CategoryView: View {
    var category: TodoEntity.Category
    @State var numberObTasks = 0
    @State var showList = false
    @Environment(\.managedObjectContext) var viewContect
    @State var addNewTask = false
    
    fileprivate func update() {
        self.numberObTasks = TodoEntity.count(in: self.viewContect, category: self.category)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: category.image())
                .font(.largeTitle)
                    .foregroundColor(.white) // Image systemName で指定した場合fontで大きさを変えられる
                .sheet(isPresented: $showList, onDismiss: { self.update() }) {
                    TodoList(category: self.category)
                        .environment(\.managedObjectContext, self.viewContect)
                }
            Text(category.toString())
                .foregroundColor(.white)
            Text("・\(numberObTasks)タスク")
                .foregroundColor(.white)
            Button(action: {
                self.addNewTask = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }.sheet(isPresented: $addNewTask, onDismiss: { self.update() }) {
                NewTask(category: self.category.rawValue)
                    .environment(\.managedObjectContext, viewContect)
            }
            Spacer()
        }
            .padding()
        .frame( maxWidth: .infinity, minHeight: 150)
        .background(category.color())
        .cornerRadius(20)
        .onTapGesture {
            self.showList = true
        }
        .onAppear {
            self.update()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    static var previews: some View {
        VStack {
            CategoryView(category: TodoEntity.Category.ImpUrg_1st, numberObTasks: 100)
            CategoryView(category: TodoEntity.Category.ImpNUrg_2nd)
            CategoryView(category: TodoEntity.Category.NImpUrg_3rd)
            CategoryView(category: TodoEntity.Category.NImpNUrg_4th)
        }.environment(\.managedObjectContext, context)
    }
}
