# RxParchmentDataSources
A reactive wrapper built around [rechsteiner/Parchment](https://github.com/rechsteiner/Parchment)

# Usage

```swift
let items = Observable.of(["Item1","Item2","Item3"])

items.bind(to: pagingViewController.rx.items) { (pagingViewController: PagingViewController<PagingIndexItem>, index: Int, element: String) -> (controller: UIViewController, title: String) in
   return (controller: ItemViewController(item: element), title: element)
}.disposed(by: disposeBag)
```
