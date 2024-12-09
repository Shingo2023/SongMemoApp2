//
//  SongTextModel.swift
// SongTextModelクラスは、歌詞テキスト(text)とそれに関連する情報（colorRange、sizeRange、actions）を管理するためのモデルです。Objectクラスを継承することで、Realmデータベースに保存することが可能になります。

//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//

import Foundation
//レルムで参照出来るようになる
import RealmSwift
//レルムを使うクラスにはObjectというクラスを継承。そのプロパティにはイニシャライザーが必要
class SongTextModel: Object {
    
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    
    @Persisted var text: String = ""
    //colorRangeは、歌詞の一部に適用される色範囲を保持するためのリストです。
    //ColorRangeModelオブジェクトのリストとして定義されており、複数の色範囲を管理できます。
    //ListはRealm専用のコンテナで、ColorRangeModelオブジェクトを複数格納できます。
    @Persisted var colorRange = List<ColorRangeModel>()
    //sizeRangeは、歌詞の一部に適用されるフォントサイズの範囲を保持するためのリストです。
    //SizeRangeModelオブジェクトのリストとして定義されており、複数のサイズ範囲を管理できます。
    @Persisted var sizeRange = List<SizeRangeModel>()
    //actionsは、歌詞に関連付けられたアクションを保持するためのリストです。
    //ActionModelオブジェクトのリストとして定義されており、複数のアクションを管理できます。
    @Persisted var actions = List<ActionModel>()
}
