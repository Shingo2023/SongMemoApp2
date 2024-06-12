//
//  SongTextModel.swift
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//

import Foundation

struct SongTextModel {
    var id: Int
    var text: String
    var colorRange: [ColorRangeModel]
    var sizeRange: [SizeRangeModel]
    var actions: [ActionModel]
}
