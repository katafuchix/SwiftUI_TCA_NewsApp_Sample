//
//  ArticleRow.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//

import SwiftUI

// MARK: - ArticleRow
// 元のArticleCellに相当するSwiftUIのRow
struct ArticleRow: View {
    let article: Article
 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
            Text(article.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 8)
    }
}
