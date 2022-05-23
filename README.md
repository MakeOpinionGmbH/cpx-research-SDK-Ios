# CPX Research iOS SDK

#### Monetize your product with fun surveys.

We will make it easy for you: Simply implement our solution and be ready to start monetizing your product immediately!
Let users earn your virtual currency by simply participating in exciting and well paid online surveys!

This SDK is owned by [MakeOpinion GmbH](http://www.makeopinion.com).

[Learn more.](https://cpx-research.com/)

[View available demo apps (in Swift and Objective-C)](https://github.com/MakeOpinionGmbH/cpx-research-SDK-Ios-demos)

# Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage Swift](#usage-swift)
- [Handling events](#implement-the-delegate-callbacks-swift)
- [CPX Survey Cards](#cpx-survey-cards)
- [Usage Objective-C](#usage-objc)
- [Handling events](#implement-the-delegate-callbacks-objc)

# Prerequisites

- iOS 11 or later

# Preview

![IMG_EB0E91DF747E-1_iphone12propacificblue_portrait](https://user-images.githubusercontent.com/7074507/136422244-0a8a71d7-da3d-4513-8c87-2bc037fb9cc8.png)

# Installation

- Open Xcode
- Select File -> Swift Packages -> Add Package Dependency...
- Enter `https://github.com/MakeOpinionGmbH/cpx-research-SDK-Ios.git` and click next
- Make sure the Package CPXResearch is checked and click finish

# Usage-Swift

## Initialize the framework

Enter the following code early in your App's life cycle, for example in the AppDelegate.

```swift
import CPXResearch

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let style = CPXConfiguration.CPXStyleConfiguration(
        position: .side(position: .right, size: .normal),
        //position: .side(position: .left, size: .normal),
        //position: .side(position: .right, size: .small),
        //position: .side(position: .left, size: .small),
        //position: .corner(position: .topLeft),
        //position: .corner(position: .topRight),
        //position: .corner(position: .bottomRight),
        //position: .corner(position: .bottomLeft),
        //position: .screen(position: .centerTop),
        //position: .screen(position: .centerBottom),
        text: "Earn up to 3 Coins in<br> 4 minutes with surveys",
        textColor: "#ffffff",
        backgroundColor: "#ffaf20",
        roundedCorners: true)

    let config = CPXConfiguration(appId: "<Your app id>",
                                    extUserId: "<Your external user id>",
                                    secureHash: "<Your secure hash>",
                                    style: style)

    CPXResearch.setup(with: config)

    return true
}
```

## Easy mode

In your ViewController activate the automatic banner display and set the delegate to handle CPX Research events. [Show delegate information.](#implement-the-delegate-callbacks-swift)

```swift
import CPXResearch

override func viewDidLoad() {
    super.viewDidLoad()

    CPXResearch.shared.delegate = self
    CPXResearch.shared.setSurvey(visible: true)
}
```

## Expert mode

In your ViewController set the delegate to handle CPX Research events. [Show delegate information.](#implement-the-delegate-callbacks-swift)

```swift
import CPXResearch

override func viewDidLoad() {
    super.viewDidLoad()

    CPXResearch.shared.delegate = self
}
```

Tell the framework to show the surveys list, call

```swift
    CPXResearch.shared.openSurveyList(on: viewController)
```

Show a specific survey

```swift
    CPXResearch.shared.openSurvey(by: surveyId, on: viewController)
```

Mark a transaction as paid

```swift
    CPXResearch.shared.markTransactionAsPaid(withId: transactionId,
                                             messageId: messageId)
```

## Implement the delegate callbacks swift

```swift
import CPXResearch

extension ViewController: CPXResearchDelegate {
    func onSurveysUpdated() {
        //handle changes on available surveys
    }

    func onTransactionsUpdated(unpaidTransactions: [TransactionModel]) {
        //handle changes in unpaid transactions
    }

    func onSurveysDidOpen() {
        //event that survey list in a webview is being displayed
    }

    func onSurveysDidClose() {
        //event that survey list in a webview is no longer displayed
    }
}
```

If you need several objects that handle callbacks you can use the following functions to add/remove the delegate.

```swift
import CPXResearch

public func addCPXObserver(_ observer: CPXResearchDelegate)
public func removeCPXObserver(_ observer: CPXResearchDelegate)
```

## CPX Survey Cards
To use the CollectionView with a default survey card cell you can get a fully prepared CollectionView from the SDK. Add this to a container view you have on your view controller. The CollectionView handles click and update events.

### CPXCardStyle
#### DEFAULT
![Preview DEFAULT](img/CPXCardStyle_DEFAULT.png)
#### SMALL
![Preview SMALL](img/CPXCardStyle_SMALL.png)

```swift
import CPXResearch

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaultConfiguration = CPXCardConfiguration.Builder
            .build()

        let smallCardConfiguration = CPXCardConfiguration.Builder
            .accentColor(UIColor(hex: "#41d7e5")!)
            .backgroundColor(.white)
            .starColor(UIColor(hex: "#ffc400")!)
            .inactiveStarColor(UIColor(hex: "#dfdfdf")!)
            .textColor(.label)
            .dividerColor(UIColor(hex: "#5A7DFE")!) // (only for SMALL style)
            .promotionAmountColor(.systemRed) // optional, text color of promotion offers, defaults to .systemRed
            .cardsOnScreen(4) // how many CPX Cards are visible at the same time, defaults to 3
            .maximumSurveys(4) // optional, maximum amount of CPX Cards that will be included in the CollectionView, default is Int.max to show a card for every survey
            .cornderRadius(4) // optional, defaults to 10
            .padding(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)) // optional, sets insets for the collectionview, defaults to .zero
            .cpxCardStyle(.small) // set card style
            .fixedCPXCardWidth(132) // instead of autocalculate use a fixed card width
            .currencyPrefixImage(UIImage(named: "current")!) // for SMALL style only: set an optional image before the currency text
            .hideCurrencyName(true) // hides the currency name behind the amount, defaults to false
            .hideRatingAmount(false) // set to false to show the total amount of ratings behind the stars, defaults to true
            .build() 
        
        let cardsSmall = CPXResearch.shared.getCollectionView(configuration: smallCardConfiguration)
        cardsSmall.translatesAutoresizingMaskIntoConstraints = false
        cvSmallContainer.addSubview(cardsSmall)
        cardsSmall.topAnchor.constraint(equalTo: cvSmallContainer.topAnchor).isActive = true
        cardsSmall.bottomAnchor.constraint(equalTo: cvSmallContainer.bottomAnchor).isActive = true
        cardsSmall.leadingAnchor.constraint(equalTo: cvSmallContainer.leadingAnchor).isActive = true
        cardsSmall.trailingAnchor.constraint(equalTo: cvSmallContainer.trailingAnchor).isActive = true
    }
```


# Usage-Objc

## Initialize the framework

Enter the following code early in your App's life cycle, for example in the AppDelegate.

```objc
@import CPXResearch;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CPXLegacyStyleConfiguration* style =
    [[CPXLegacyStyleConfiguration alloc] initWithPosition:LegacySurveyPositionCornerTopRight
                                                     text:@"Earn up to 3 Coins in<br> 4 minutes with surveys"
                                                 textSize:20
                                                textColor:@"#ffffff"
                                          backgroundColor:@"#ffaf20"
                                           roundedCorners:YES];

    CPXLegacyConfiguration* config =
    [[CPXLegacyConfiguration alloc] initWithAppId:@"<Your app id>"
                                        extUserId:@"<Your external user id>"
                                        secureHash:@"<Your secure hash>"
                                            email:nil
                                           subId1:nil
                                           subId2:nil
                                        extraInfo:nil
                                            style:style];
    [CPXResearch setupWith:config];

    return YES;
}
```

## Easy mode

In your ViewController activate the automatic banner display and set the delegate to handle CPX Research events. [Show delegate information.](#implement-the-delegate-callbacks-objc)

```objc
@import CPXResearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    CPXResearch.shared.delegate = self;
    [CPXResearch.shared setSurveyWithVisible:YES];
}
```

## Expert mode

In your ViewController set the delegate to handle CPX Research events. [Show delegate information.](#implement-the-delegate-callbacks-objc)

```objc
@import CPXResearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    CPXResearch.shared.delegate = self;
}
```

Tell the framework to show the surveys list, call

```objc
    [CPXResearch.shared openSurveyListOn:viewController];
```

Show a specific survey

```objc
    [CPXResearch.shared openSurveyBy:surveyId on:viewController];
```

Mark a transaction as paid

```objc
    [CPXResearch.shared markTransactionAsPaidWithId:transactionId messageId:messageId];
```

## Implement the delegate callbacks objc

```objc
@import CPXResearch;

@interface ViewController () <CPXResearchDelegate>

@end

@implementation ViewController

- (void)onSurveysDidClose {
    //event that survey list in a webview is no longer displayed
}

- (void)onSurveysDidOpen {
    //event that survey list in a webview is being displayed
}

- (void)onSurveysUpdated {
    //handle changes on available surveys
}

- (void)onTransactionsUpdatedWithUnpaidTransactions:(NSArray<TransactionModel *> * _Nonnull)unpaidTransactions {
    //handle changes in unpaid transactions
}

@end
```
