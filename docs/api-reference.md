# API reference

| API | Type | Description |
| --- | --- | --- |
| WalleePaymentResultObserver | protocol | Protocol for handling post-payment events `paymentResult` |
| `func paymentResult(paymentResultMessage: PaymentResult)` | function | Result handler for transaction state |
| `func launchPayment(token: String)` | function | Opening payment dialog (activity) |
| `func launchPayment(token: String, isSwiftUI: Bool)` | function | Opening payment dialog (activity) in **SwiftUI** |
| `func launchPayment(token: String, rootController: UIViewController)` | function | **Abandoned from v1.2.2.** Opening payment dialog (activity). |
| `func onHandleOpenURL(url: URL)` | function | this function is for handling deep link. It has to be called in [SceneDelegate](https://developer.apple.com/documentation/uikit/uiscenedelegate/3238059-scene) or [AppDelegate](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application?language=objc). Without this implementation SDK isn't able to send current response when transaction is complete. Returning `true` when all is set up correctly |
| `func setDarkTheme(dark: NSMutableDictionary)` | function | Can override the whole dark theme or just some specific color. |
| `func setLightTheme(light: NSMutableDictionary)` | function | Can override the whole light theme or just some specific color. |
| `func setCustomTheme(custom: NSMutableDictionary/nill, baseTheme: ThemeEnum)` | function | Force to use only this theme (independent on user's setup). Can override default light/dark theme and force to use it or completely replace all or specific colors (DARK/LIGHT) |
| `func presentModalView(isPresented: Binding<Bool>, token: Binding<String>)` | extension | **Abandoned from v1.2.2.** SwiftUI View modifier to present the UI part of the Payment SDK. |
| `func setAnimation(type: AnimationEnum)` | function | Defining type of animation for moving between the pages |
| `func configureApplePay(merchantId: String)` | function | Configuring ApplePay Merchant ID which is going to be used to process payments (requires additional portal configuration, see [Apple Pay integration](./apple-pay.md)) |
| `func configureDeepLink(deepLink: String)` | function | Implementing deep linking functionality within payment applications to seamlessly redirect users back to the customer app upon completion of transactions. |
