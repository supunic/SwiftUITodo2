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
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: category.image())
                .font(.largeTitle) // Image systemName で指定した場合fontで大きさを変えられる
                .sheet(isPresented: $showList) {
                    TodoList(category: self.category)
                        .environment(\.managedObjectContext, self.viewContect)
                }
            Text(category.toString())
            Text("・\(numberObTasks)タスク")
            Button(action: {}) {
                Image(systemName: "plus")
            }
            Spacer()
        }
        .padding()
        .frame( maxWidth: .infinity, minHeight: 150)
        .foregroundColor(.white)
        .background(category.color())
        .cornerRadius(20)
        .onTapGesture {
            self.showList = true
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
