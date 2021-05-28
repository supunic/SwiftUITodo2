//
//  CheckBox.swift
//  SwiftUITodo2
//
//  Created by 遠藤聖也 on 2021/05/27.
//

import SwiftUI

// struct → 構造体 継承がないクラス的な 複製可能な辞書的な 値型
// <Lavel> → 型パラメータ
// where Label: View → 型パラメータの条件定義（今回はView型であることを明示）
struct CheckBox<Label>: View where Label: View{
    // @State → checkedというステータスをSwiftUIで管理するための宣言、これをつけることで変数の変更をリアクティブに画面に反映できる
//    @State var checked: Bool = false
    
    // @Binding アノテーション → 親のviewと値を共有したいときに使用する
    //                        CheckBox view 内部から checked の値を更新できるようになる
    // .constant(false)でBinding型のBool値を定義できる
    @Binding var checked: Bool
    
    // lavel をクロージャで定義
    private var label: () -> Label
    
    // イニシャライザ
    // @ViewBuilder → viewを改行で並べて列挙して複数のviewを渡すことができる（クロージャの戻り値に複数のviewを入れられるようになる）
    // @escaping → クロージャに対して付与する属性の1つ、クロージャが関数スコープから抜けても存在し続けるように
    public init(checked: Binding<Bool>, @ViewBuilder label: @escaping () -> Label) {
        self._checked = checked // Binding構造体の内部の値（今回の場合Bool値）に直接アクセスする場合は「 _ 」をつける
        self.label = label
    }
    
    var body: some View {
        // バインディング構造体 → $マークが必要
        // 値を複数のviewで共有するためのもの
        // 別のviewでcheckedが使える
//        Toggle(isOn: $checked) {
//            Text("チェックボックス")
//        }
        HStack {
            Image(systemName: checked ? "checkmark.circle" : "circle")
                .onTapGesture {
                    self.checked.toggle()
            }
            label()
        }
    }
}

// PreviewProvider → Canvas へのプレビュー用のコード、実際のプログラムの実行には関係ない
// struct → 構造体の定義
struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        // on　と off を同時に表示したい
        VStack {
            // 構造型 CheckBox
            // インスタンス生成時にinitで定義された()内に引数を入れる
            // CheckBox は第二引数にクロージャを定義している
            // CheckBox は最後の引数にクロージャを定義している
            // → 関数の外に出して呼び出せる
            CheckBox(checked: .constant(false)) {
                Text("牛乳を買う")
            }
            // 元はこれ
            // CheckBox(checked: .constant(false), label: {
            //     Text("牛乳を買う")
            // })
            CheckBox(checked: .constant(true)) {
                // @ViewBuilder をつけてるため複数のviewを差し込める
                Image(systemName: "hand.thumbsup")
                Text("牛乳を買う")
            }
        }
        // 2つのpreviewを表示する
//        Group {
//            CheckBox(checked: .constant(false))
//            CheckBox(checked: .constant(true))
//        }
    }
}
