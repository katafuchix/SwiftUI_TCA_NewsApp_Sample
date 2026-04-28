# SwiftUI_TCA_NewsApp_Sample

## Rx版
- https://github.com/katafuchix/Rx-MVVM-NewsApp-Sample

## データフローのイメージ
```
[View] ---(Action)---> [Store/Reducer] ---(新しいState)---> [View]
                              |
                         [Effect]
                         (API通信など)
```

## 比較

| Rx MVVM	| TCA		|
|:-----------|:------------|
| PublishSubject<Void> trigger	| Action.fetchArticles		|																				
| BehaviorRelay<[Article]> articles	| State.articles	|																				
| Action<(), [Article]>	| Effect.run		|																		
| isLoading: Observable<Bool>	| State.isLoading	|																					
| error: Observable<ActionError>	| State.errorMessage		|																					
| ArticleRepositoryType	| ArticleClient（Dependency）		|																					
| ViewController + TableView	| ArticleView（SwiftUI）		|																					
