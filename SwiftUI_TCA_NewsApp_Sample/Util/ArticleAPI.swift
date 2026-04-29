//
//  ArticleAPI.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//

import Foundation

// MARK: - ArticleAPI
// APIエンドポイントをenumで定義するRouterパターン
// エンドポイントが増えてもcaseを追加するだけで対応できる
enum ArticleAPI {
    case topHeadlines
}
 
extension ArticleAPI {
 
    // ベースURL
    private var baseURL: URL { URL(string: "https://newsapi.org/v2")! }
 
    // エンドポイントのパス
    private var path: String {
        switch self {
        case .topHeadlines: return "/top-headlines"
        }
    }
 
    // HTTPメソッド
    private var method: String { "GET" }
 
    // クエリパラメータ
    private var queryItems: [URLQueryItem] {
        switch self {
        case .topHeadlines:
            return [
                URLQueryItem(name: "sources", value: "techcrunch"),
                URLQueryItem(name: "apiKey", value: Constants.api_key)
            ]
        }
    }
 
    // ヘッダー（x-api-keyを付与）
    /*private var headers: [String: String] {
        return ["x-api-key": Constants.api_key]
    }*/
 
    // URLRequestに変換
    func asURLRequest() -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = queryItems
 
        var request = URLRequest(
            url: components.url!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5.0
        )
        request.httpMethod = method
        // ヘッダーを付与
        //headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}
