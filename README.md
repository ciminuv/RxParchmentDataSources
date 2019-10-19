# RxParchmentDataSources
A reactive wrapper built around [rechsteiner/Parchment](https://github.com/rechsteiner/Parchment)

## Installation

### CocoaPods

To integrate RxParchmentDataSources into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'RxParchment'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

To integrate RxParchmentDataSources into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Pubbus/RxParchmentDataSources"
```

# Usage

Working with RxParchmentDataSources will be very simple:

```swift
let items = Observable.of(["Item1","Item2","Item3"])

items.bind(to: pagingViewController.rx.items) { (pagingViewController: PagingViewController<PagingIndexItem>, index: Int, element: String) -> (controller: UIViewController, title: String) in
   return (controller: ItemViewController(item: element), title: element)
}.disposed(by: disposeBag)
```
