//
//  StoreHTTPClient.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation

    //MARK: - NetworkError 處理
    enum NetworkError: Error {
        case invalidURL
        case invalidServerResponse
        case decodingError
    }

//MARK: - API 客戶端
class StoreHTTPClient {

   static func getData(team: String, page: Int) async throws -> [CellData] {
        
        let (data, response) = try await URLSession.shared.data(from: URL.getRedSoData(team, page))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else{
            throw NetworkError.invalidServerResponse
        }
        
        guard let redSoData = try? JSONDecoder().decode(RedSoData.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        let cellData: [CellData] = redSoData.results
        
        return cellData
    }
    
}
