//
//  ArticleView.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//


import SwiftUI
import ComposableArchitecture
 
struct ArticleView: View {
    @Bindable var store: StoreOf<ArticleFeature>
 
    var body: some View {
        NavigationView {
            ZStack {
                // 記事一覧
                List(store.articles, id: \.title) { article in
                    ArticleRow(article: article)
                }
                .listStyle(.plain)
                .navigationTitle("Tech News")
 
                // ローディング
                if store.isLoading {
                    ProgressView()
                        .scaleEffect(2.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
            // エラーアラート
            .alert(
                "エラー",
                isPresented: Binding(
                    get: { store.errorMessage != nil },
                    set: { if !$0 { store.send(.alertDismissed) } }
                ),
                actions: {
                    Button("OK") { store.send(.alertDismissed) }
                },
                message: {
                    Text(store.errorMessage ?? "")
                }
            )
        }
        // 画面表示時に記事取得
        .onAppear {
            store.send(.onAppear)
        }
    }
}
 
#Preview {
    ArticleView(
        store: Store(initialState: ArticleFeature.State()) {
            ArticleFeature()
        }
    )
}
