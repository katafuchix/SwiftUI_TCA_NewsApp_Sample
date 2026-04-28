//
//  ArticleClient.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//

import Foundation
import ComposableArchitecture
 
// MARK: - ArticleClient
// TCAのDependencyとして定義することでテスト時にモックに差し替えられる
struct ArticleClient {
    var fetchArticles: () async throws -> [Article]
}
 
// MARK: - DependencyKey
extension ArticleClient: DependencyKey {
    // 本番用の実装
    static let liveValue = ArticleClient(
        fetchArticles: {
            let urlStr = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=\(Constants.api_key)"
            guard let url = URL(string: urlStr) else { throw ArticleError.invalidURL }
 
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
            let (data, response) = try await URLSession.shared.data(for: request)
 
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw ArticleError.serverError
            }
 
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            return apiResponse.articles
        }
    )
 
    // テスト用の実装（空配列を返すだけ）
    static let testValue = ArticleClient(
        fetchArticles: { [] }
    )
}
 
// MARK: - DependencyValues
extension DependencyValues {
    var articleClient: ArticleClient {
        get { self[ArticleClient.self] }
        set { self[ArticleClient.self] = newValue }
    }
}
 
// MARK: - Error
enum ArticleError: Error, Equatable {
    case invalidURL
    case serverError
    case decodingError
}
 
