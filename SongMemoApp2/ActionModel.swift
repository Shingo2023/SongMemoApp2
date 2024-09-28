//
//  ActionModel.swift
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//

import Foundation
import RealmSwift
//レルムを使うクラスにはObjectというクラスを継承。そのプロパティにはイニシャライザーが必要
@objcMembers class ActionModel: Object {
    //レルムを使うクラスにはObjectというクラスを継承。そのプロパティにはイニシャライザーが必要
    //UUIDデータを識別するためのもの いくつかのアクションを取り扱う上であった方がいい
    @Persisted var id: String = UUID().uuidString
    @Persisted var actionType: String = ""
    @Persisted var actionValue: String = ""
    @Persisted var name: String = ""  // 新しいプロパティを追加
    @Persisted var mark: String = ""   // markプロパティを追加
}
