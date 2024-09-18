//
//  ColorRangeModel.swift
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//


import Foundation
import RealmSwift
//@objcMembersの効果 相互運用性の向上: Objective-Cコードとの連携が容易になり、個別に@objcを付与する手間が省けます。
//レルムを使うクラスにはObjectというクラスを継承。そのプロパティにはイニシャライザーが必要
@objcMembers class ColorRangeModel: Object {
    //@Persisted:パシスティッド 属性により、Realmに保存されるプロパティであることが示されています。
    @Persisted var startIndex: Int = 0
    @Persisted var endIndex: Int = 0
    @Persisted var Index: Int = 0
    @Persisted var color: String = ""
}
