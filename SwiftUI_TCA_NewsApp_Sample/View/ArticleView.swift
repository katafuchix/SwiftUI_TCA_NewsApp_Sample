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
                // Listだとtransitionが効かないためScrollView+LazyVStackを使用
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(store.articles, id: \.title) { article in
                            ArticleRow(article: article)
                                // 左からスライドイン + フェードイン
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .leading).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            Divider()
                        }
                    }
                }
                // 記事が追加されたときにスプリングアニメーションを適用
                .animation(.spring(duration: 1, bounce: 0.3), value: store.articles)
                .navigationTitle("Tech News")
                .navigationSubtitle("SwiftUI TCA")
 
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
