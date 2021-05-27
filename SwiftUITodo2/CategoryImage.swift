//
//  CategoryImage.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/27.
//

import SwiftUI

struct CategoryImage: View {
    var category: TodoEntity.Category
    
    init(_ category: TodoEntity.Category?) {
        self.category = category ?? .ImpUrg_1st
    }
    
    var body: some View {
        // SF Symbles からアイコン表示
        Image(systemName: category.image())
            .resizable()
            .scaledToFit()
            .foregroundColor(.white) // white のviewを指定
            .padding(2.0)
            .frame(width: 30, height: 30) // 先に正方形にする、順番で表示が変わる
            .background(category.color()) // color Literalを使用 Colorはview
            .cornerRadius(6.0) // radiusの指定
        
            // .background(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
    }
}

struct CategoryImage_Previews: PreviewProvider {
    static var previews: some View {
        CategoryImage(.ImpUrg_1st)
    }
}
