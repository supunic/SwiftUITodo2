//
//  Binding+Extension.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/28.
//

import SwiftUI

extension Binding {
    // wrappedValue → オプショナル型の本来の値が入っているプロパティ

    // オプショナルDate と Bool を変換する Bindingイニシャライザ
    init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
        self.init(
            // bindingの値を参照するとき、渡ってきたオプショナルDate型の値がnilでなければtrue、nilならfalseを返す
            get: { source.wrappedValue != nil },
            // bindingの値を更新するとき、渡ってきたToggleの結果が$0に入り、trueならdefaultValue（今回はDate型）、falseならnilを値に代入
            set: { source.wrappedValue = $0 ? defaultValue : nil }
        )
    }
    
    // オプショナルDate と Date を変換する Bindingイニシャライザ
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        self.init(
            // bindingの値を参照するとき、渡ってきたオプショナルDate型の値がnilだった場合、defaultValue（今回はDate型）を代入し、Date型を返す
            get: {
                if source.wrappedValue == nil {
                    source.wrappedValue = defaultValue
                }
                return source.wrappedValue ?? defaultValue
            },
            // bindingの値を更新するとき、渡ってきたDatePickerの結果が$0に入り、Date型の値をオプショナルとして代入
            set: { source.wrappedValue = $0 }
        )
    }
}
