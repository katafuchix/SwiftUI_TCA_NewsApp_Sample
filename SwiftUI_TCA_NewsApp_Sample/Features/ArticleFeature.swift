//
//  ArticleFeature.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//

import ComposableArchitecture
import Foundation
 
@Reducer
struct ArticleFeature {
 
    // MARK: - Dependency
    @Dependency(\.articleClient) var articleClient
 
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var articles: [Article] = []      // 記事一覧
        var isLoading = false             // ローディング中フラグ
        var errorMessage: String? = nil   // エラーメッセージ
    }
 
    // MARK: - Action
    enum Action: Equatable {
        case onAppear                                      // 画面表示時に記事取得
        case fetchArticles                                 // 記事取得
        case fetchResponse(Result<[Article], ArticleError>) // 記事取得の結果
        case alertDismissed                                // エラーアラートを閉じた
    }
 
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
 
            // 画面表示時に記事取得を開始
            case .onAppear:
                return .send(.fetchArticles)
 
            // 記事取得開始 → ローディング表示
            case .fetchArticles:
                state.isLoading = true
                state.errorMessage = nil
                return .run { [articleClient] send in
                    do {
                        let articles = try await articleClient.fetchArticles()
                        await send(.fetchResponse(.success(articles)))
                    } catch let error as ArticleError {
                        await send(.fetchResponse(.failure(error)))
                    } catch {
                        await send(.fetchResponse(.failure(.serverError)))
                    }
                }
 
            // 記事取得成功 → 記事一覧をStateにセット
            case .fetchResponse(.success(let articles)):
                state.articles   = articles
                state.isLoading  = false
                return .none
 
            // 記事取得失敗 → エラーメッセージをセット
            case .fetchResponse(.failure(let error)):
                state.isLoading     = false
                state.errorMessage  = error.localizedDescription
                return .none
 
            // エラーアラートを閉じる
            case .alertDismissed:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
 
// MARK: - ArticleError のローカライズ
extension ArticleError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:    return "URLが不正です"
        case .serverError:   return "サーバーエラーが発生しました"
        case .decodingError: return "データの解析に失敗しました"
        }
    }
}
