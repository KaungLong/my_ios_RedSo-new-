//
//  URL+Extension.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation

extension URL {
    
    static func getRedSoData(_ team: String,_ page: Int ) -> URL  {
        print("https://us-central1-redso-challenge.cloudfunctions.net/catalog?team=\(team)&page=\(page)")
        return URL(string: "https://us-central1-redso-challenge.cloudfunctions.net/catalog?team=\(team)&page=\(page)")!
    }
    
}
