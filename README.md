# CPX Research iOS SDK

#### Monetize your product with fun surveys.

We will make it easy for you: Simply implement our solution and be ready to start monetizing your product immediately!
Let users earn your virtual currency by simply participating in exciting and well paid online surveys!

This SDK is owned by [MakeOpinion GmbH](http://www.makeopinion.com).

[Learn more.](https://cpx-research.com/)

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

![IMG_165AC09C4BCE-1_iphone12propacificblue_portrait](https://user-images.githubusercontent.com/7074507/136428835-081f0146-2c3a-4215-b1da-f5653650eb9b.png)

# Installation

- Open Xcode
- Select File -> Swift Packages -> Add Package Dependency...
- Enter `git@github.com:MakeOpinionGmbH/cpx-research-SDK-Ios.git` and click next
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
    func onSurveysUpdated(new: [SurveyItem],
                          updated: [SurveyItem],
                          removed: [SurveyItem]) {
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

```swift
import CPXResearch

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardConfiguration = CPXCardConfiguration(accentColor: UIColor(hex: "#41d7e5")!,
                                                     backgroundColor: .white,
                                                     inactiveStarColor: UIColor(hex: "#dfdfdf")!,
                                                     starColor: UIColor(hex: "#ffc400")!,
                                                     textColor: .label)
        
        if let cards = CPXResearch.shared.getCollectionView(configuration: cardConfiguration) {
            cards.translatesAutoresizingMaskIntoConstraints = false
            cvContainer.addSubview(cards)
            cards.topAnchor.constraint(equalTo: cvContainer.topAnchor).isActive = true
            cards.bottomAnchor.constraint(equalTo: cvContainer.bottomAnchor).isActive = true
            cards.leadingAnchor.constraint(equalTo: cvContainer.leadingAnchor).isActive = true
            cards.trailingAnchor.constraint(equalTo: cvContainer.trailingAnchor).isActive = true
        }
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

- (void)onSurveysUpdatedWithNew:(NSArray<SurveyItem *> * _Nonnull)new_
                        updated:(NSArray<SurveyItem *> * _Nonnull)updated
                        removed:(NSArray<SurveyItem *> * _Nonnull)removed {
    //handle changes on available surveys
}

- (void)onTransactionsUpdatedWithUnpaidTransactions:(NSArray<TransactionModel *> * _Nonnull)unpaidTransactions {
    //handle changes in unpaid transactions
}

@end
```
