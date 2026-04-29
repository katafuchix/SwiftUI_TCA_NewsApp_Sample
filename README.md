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


### TCA Basic View

```
import ComposableArchitecture

struct <#App#>Feature: Reducer {
    struct State: Equatable {
        init(){}
    }
    enum Action: Equatable {
        
    }
    var body: some ReducerOf {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct <#App#>View: View {
    let store: StoreOf<<#App#>Feature>
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            <#code#>
        }
    }
}

#Preview {
    <#App#>View(store: Store(initialState: .init(), reducer: {
        <#App#>Feature()
    }))
}
```
