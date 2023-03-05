//
//  RedSoData.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation

struct  RedSoData: Decodable {
    var results: [CellData]
}

struct CellData: Codable {
    var id: String?
    var type: String
    var name: String?
    var position: String?
    var expertise: [String]?
    var avatar: String?
    var url: String?
}
