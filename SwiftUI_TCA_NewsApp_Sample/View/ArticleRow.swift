//
//  ArticleRow.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//

import SwiftUI

// MARK: - ArticleRow
// xibに合わせたデザイン
// - セル高さ: 101pt
// - 上下padding: 10pt、左padding: 20pt、右padding: 10pt
// - タイトル: システムフォント 18pt、2行まで
// - サブタイトル: システムフォント 14pt、グレー(0.33)、5行まで
// - 要素間spacing: 12pt
struct ArticleRow: View {
    let article: Article
 
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(article.title)
                .font(.system(size: 18))
                .lineLimit(2)
            Text(article.description)
                .font(.system(size: 14))
                .foregroundColor(Color(white: 0.33))
                .lineLimit(5)
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
