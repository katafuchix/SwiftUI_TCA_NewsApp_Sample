//
//  SwiftUI_TCA_NewsApp_SampleTests.swift
//  SwiftUI_TCA_NewsApp_SampleTests
//
//  Created by cano on 2026/04/29.
//

import Foundation
import Testing
import ComposableArchitecture
@testable import SwiftUI_TCA_NewsApp_Sample

@MainActor
struct SwiftUI_TCA_NewsApp_SampleTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
    }

    // MARK: - テスト用のダミーデータ
    let dummyArticles = [
        Article(title: "Article 1", description: "Description 1"),
        Article(title: "Article 2", description: "Description 2"),
        Article(title: "Article 3", description: "Description 3")
    ]
 
    // MARK: - 画面表示テスト
 
    @Test
    func onAppear_記事取得が開始される() async throws {
        let dummyArticles = self.dummyArticles
        let store = TestStore(initialState: ArticleFeature.State()) {
            ArticleFeature()
        } withDependencies: {
            $0.articleClient = ArticleClient(
                fetchArticles: { dummyArticles }
            )
        }
 
        // 画面表示 → fetchArticlesが発火する
        await store.send(.onAppear)
 
        // fetchArticlesのActionを受け取る
        await store.receive(\.fetchArticles) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // 記事取得成功
        await store.receive(\.fetchResponse.success) {
            $0.articles  = dummyArticles
            $0.isLoading = false
        }
    }
 
    // MARK: - 記事取得テスト
 
    @Test
    func fetchArticles_取得成功() async throws {
        let dummyArticles = self.dummyArticles
        let store = TestStore(initialState: ArticleFeature.State()) {
            ArticleFeature()
        } withDependencies: {
            // ダミーの記事を返すモックを注入
            $0.articleClient = ArticleClient(
                fetchArticles: { dummyArticles }
            )
        }
 
        // 記事取得開始 → ローディング開始
        await store.send(.fetchArticles) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // 記事取得成功 → articlesにセットされる
        await store.receive(\.fetchResponse.success) {
            $0.articles  = dummyArticles
            $0.isLoading = false
        }
    }
 
    @Test
    func fetchArticles_サーバーエラー() async throws {
        let store = TestStore(initialState: ArticleFeature.State()) {
            ArticleFeature()
        } withDependencies: {
            // サーバーエラーを返すモックを注入
            $0.articleClient = ArticleClient(
                fetchArticles: { throw ArticleError.serverError }
            )
        }
 
        await store.send(.fetchArticles) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // エラーが返ってくる → errorMessageがセットされる
        await store.receive(\.fetchResponse.failure) {
            $0.isLoading    = false
            $0.errorMessage = ArticleError.serverError.localizedDescription
        }
    }
 
    @Test
    func fetchArticles_URLエラー() async throws {
        let store = TestStore(initialState: ArticleFeature.State()) {
            ArticleFeature()
        } withDependencies: {
            $0.articleClient = ArticleClient(
                fetchArticles: { throw ArticleError.invalidURL }
            )
        }
 
        await store.send(.fetchArticles) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        await store.receive(\.fetchResponse.failure) {
            $0.isLoading    = false
            $0.errorMessage = ArticleError.invalidURL.localizedDescription
        }
    }
 
    @Test
    func fetchArticles_取得結果が空() async throws {
        let store = TestStore(initialState: ArticleFeature.State()) {
            ArticleFeature()
        } withDependencies: {
            // 空配列を返すモックを注入
            $0.articleClient = ArticleClient(
                fetchArticles: { [] }
            )
        }
 
        await store.send(.fetchArticles) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // 空配列が返ってくる → articlesが空のまま
        await store.receive(\.fetchResponse.success) {
            $0.articles  = []
            $0.isLoading = false
        }
    }
 
    // MARK: - エラーアラートテスト
 
    @Test
    func alertDismissed_エラーメッセージが消える() async throws {
        // エラーが表示されている状態からスタート
        let initialState = ArticleFeature.State(
            articles:     [],
            isLoading:    false,
            errorMessage: "サーバーエラーが発生しました"
        )
 
        let store = TestStore(initialState: initialState) {
            ArticleFeature()
        }
 
        // アラートを閉じる → errorMessageがnilになる
        await store.send(.alertDismissed) {
            $0.errorMessage = nil
        }
    }
}
