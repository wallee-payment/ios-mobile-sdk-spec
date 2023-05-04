# Table of contents

- [iOS WalleePaymentSdk](#ios-walleepaymentsdk)
- [API reference](#api-reference)
- [Installation](#installation)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Integration](#integration)
- [Set up wallee](#set-up-wallee)
- [Create transaction](#create-transaction)
- [Collect payment details](#collect-payment-details)
- [Handle result](#handle-result)
- [Verify payment](#verify-payment)
- [Theming](#theming)
- [Colors](#colors)
- [Default themes](#default-themes)
- [Light theme](#light-theme)
- [Dark theme](#dark-theme)

# [ios] WalleePaymentSdk

[ios SDK Release on GitHub](https://github.com/WhiteLabelGithubOwnerName/ios-mobile-sdk/releases/tag/0.1.0)

## API reference

| API                                                                           | Type                        | Description                                                    | 
|-------------------------------------------------------------------------------|-----------------------------|----------------------------------------------------------------|
| WalleePaymentResultObserver                                                   | protocol                    | Protocol for handling post-payment events `paymentResult`      |
| `func paymentResult(paymentResultMessage: PaymentResult)`                     | function                    | Result handler for transaction state                           |
| `func launchPayment(token: String, rootController: UIViewController)`         | function                    | Opening payment dialog (activity)                              |
| `func setDarkTheme(dark: NSMutableDictionary)`                                | function                    | Can override the whole dark theme or just some specific color. |
| `func setLightTheme(light: NSMutableDictionary)`                              | function                    | Can override the whole light theme or just some specific color. |
| `func setCustomTheme(custom: NSMutableDictionary/nill, baseTheme: ThemeEnum)` | function     | Force to use only this theme (independent on user's setup). Can override default light/dark theme and force to use it or completely replace all or specific colors (DARK/LIGHT) |

## Installation

### Requirements

- iOS 12.4 is the minimum version supported

### Configuration

Import the SDK to your app as [Cocoapod](https://cocoapods.org/)

`pod ‘WalleePaymentSdk’, '1.0.0' :source=> ‘https://github.com/WhiteLabelGithubOwnerName/ios-mobile-sdk.git’`

```sh
target 'DemoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod ‘WalleePaymentSdk’, '1.0.0' :source=> ‘https://github.com/WhiteLabelGithubOwnerName/ios-mobile-sdk.git’`
  target 'DemoAppTests' do
    inherit! :search_paths
  end

end
```

## Integration

### Set up Wallee

To use the iOS Payment SDK, you need a [wallee account](https://app-wallee.com/user/signup). After signing up, set up
your space and enable the payment methods you would like to support.

### Create transaction

For security reasons, your app cannot create transactions and fetch access tokens. This has to be done on your server by
talking to the [wallee Web Service API](https://app-wallee.com/en-us/doc/api/web-service). You can use one of the
official SDK libraries to make these calls.

To use the iOS Payment SDK to collect payments, an endpoint needs to be added on your server that creates a transaction
by calling the [create transaction](https://app-wallee.com/doc/api/web-service#transaction-service--create) API
endpoint. A transaction holds information about the customer and the line items and tracks charge attempts and the
payment state.

Once the transaction has been created, your endpoint can fetch an access token by calling
the [create transaction credentials](https://app-wallee.com/doc/api/web-service#transaction-service--create-transaction-credentials)
API endpoint. The access token is returned and passed to the iOS Payment SDK.

```bash
# Create a transaction
curl 'https://app-wallee.com/api/transaction/create?spaceId=1' \
  -X "POST" \
  -d "{{TRANSACTION_DATA}}"

# Fetch an access token for the created transaction
curl 'https://app-wallee.com/api/transaction/createTransactionCredentials?spaceId={{SPACE_ID}}&id={{TRANSACTION_ID}}' \
  -X 'POST'
```

### Collect payment details

Before launching the iOS Payment SDK to collect the payment, your checkout page should show the total amount, the
products that are being purchased and a checkout button to start the payment process.

Let your checkout activity extend `WalleePaymentResultObserver`, add the necessary function `paymentResult`.

```swift
import UIKit
import WalleePaymentSdk

class ViewController : UIViewController, WalleePaymentResultObserver { 

    func paymentResult(paymentResultMessage: PaymentResult)
    {
        ....
    }
}
```

Initialize the `WalleePaymentSdk` instance inside `viewDidLoad` of your checkout activity.

```swift
// ...
import UIKit
import WalleePaymentSdk

class ViewController: UIViewController, WalleePaymentResultObserver {
    
    var walleePaymentSdk: WalleePaymentSdk
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        walleePaymentSdk = WalleePaymentSdk(eventObserver: self)
    }
    // ...
}
```

When the customer taps the checkout button, call your endpoint that creates the transaction and returns the access
token, and launch the payment dialog.

```swift
// ...
import UIKit
import WalleePaymentSdk

class ViewController : UIViewController, WalleePaymentResultObserver {

    //...
    var walleePaymentSdk: WalleePaymentSdk

    @IBAction func openSdkClick()
    {
        walleePaymentSdk = WalleePaymentSdk(eventObserver: self)
        ...
        walleePaymentSdk.launchPayment(token: _token, rootController: self)
    }

    // ...
}
```

After the customer completes the payment, the dialog dismisses and the `paymentResult` method is called.

### Handle result

The response object contains these properties:

- `code` describing the result's type.

| Code                                                                     | Description                                                                                                                                                    | 
|--------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `COMPLETED`                                                              | The payment was successful.                                                                                                         |
| `FAILED`                                                                 | The payment failed. Check the `message` for more information.                                                                                                                         |
| `CANCELED`                                                               | The customer canceled the payment.                                                                                                                              |

- `message` providing a localized error message that can be shown to the customer.

```swift
import UIKit
import WalleePaymentSdk

class ViewController: UIViewController, WalleePaymentResultObserver {
    // ...
    
    @IBOutlet var resultCallbackText: UILabel?

    func paymentResult(paymentResultMessage: PaymentResult) {
        var colorCodeMap = [PaymentResultEnum.FAILED: UIColor.red, PaymentResultEnum.COMPLETED: UIColor.green, PaymentResultEnum.CANCELED: UIColor.orange]

        DispatchQueue.main.async {
            self.resultCallbackText?.text = paymentResultMessage.code.rawValue
            self.resultCallbackText?.textColor = colorCodeMap[paymentResultMessage.code];
        }
    }

    // ...
}
```

### Verify payment

As customers could quit the app or lose network connection before the result is handled or malicious clients could
manipulate the response, it is strongly recommended to set up your server to listen for webhook events the get
transactions' actual states. Find more information in
the [webhook documentation](https://app-wallee.com/en-us/doc/webhooks).

## Theming

The appearance of the payment dialog can be customized to match the look and feel of your app. This can be done for both
the light and dark theme individually.

Colors can be modified by passing a JSON object to the `WalleePaymentSdk` instance. You can either completely override
the theme or only change certain colors.

- `walleePaymentSdk.setLightTheme(NSMutableDictionary)` allows to modify the payment dialog's light theme.
- `walleePaymentSdk.setDarkTheme(NSMutableDictionary)` allows to modify the payment dialog's dark theme.
- `walleePaymentSdk.setCustomTheme(NSMutableDictionary|| nil, ThemeEnum)` allows to enforce a specific theme (dark,
  light or your own).

```swift
// ...
import UIKit
import WalleePaymentSdk


class ViewController : UIViewController, WalleePaymentResultObserver {

    let walleePaymentSdk = WalleePaymentSdk (eventObserver: self)
    
    @IBAction func openSdkClick()
    {
        ....
        changeColorSchema(wallee: wallee)
        ...
    }

    private func changeColorSchema(wallee: WalleePaymentSdk)
    {
        walleePaymentSdk.setLightTheme(light: getLightTheme())
    }

}
```

This overrides the colors `colorBackground`, `colorText`, `colorHeadingText` and `colorError` for both the dark and
light theme.

The `changeColorSchema` function allows to define the theme to be used by the payment dialog and prevent it from
switching themes based on the user's settings.
This way e.g. high-contrast and low-contrast themes can be added. The logic for
switching between these themes is up to you though.

You can also use `setCustomTheme` to force the usage of the light or dark theme.

```swift
walleePaymentSdk.setCustomTheme(custom: getNewCustomTheme(), baseTheme: .DARK)
```

```swift
walleePaymentSdk.setCustomTheme(custom: getNewCustomTheme(), baseTheme: .LIGHT)
```

### Colors

![Payment method list](imgs/theme-1.jpeg) ![Payment method details](imgs/theme-2.jpeg) ![Pyament method additional details](imgs/theme-3.jpeg)

### Default themes

#### Light theme

The theme can be provided via a function that returns an NSMutableDictionary object that holds the key-value pair for
the colors.

```swift
func getLightTheme() -> NSMutableDictionary {

   let lightTheme = NSMutableDictionary()
   
   lightTheme.setValue("#3b82f6", forKey: "colorPrimary")
   lightTheme.setValue("#ffffff", forKey: "colorBackground")
   lightTheme.setValue("#374151", forKey: "colorText")
   lightTheme.setValue("#6b7280", forKey: "colorSecondaryText")
   lightTheme.setValue("#111827", forKey: "colorHeadingText")
   lightTheme.setValue("#ef4444", forKey: "colorError")

   let component = NSMutableDictionary()
   componentsetValue("#ffffff", forKey: "colorBackground")
   componentsetValue("#d1d5db", forKey: "colorBorder")
   componentsetValue("#374151", forKey: "colorText")
   componentsetValue("#4b5563", forKey: "colorPlaceholderText")
   componentsetValue("#3b82f6", forKey: "colorFocus")
   componentsetValue("#1e3a8a", forKey: "colorSelectedText")
   componentsetValue("#eff6ff", forKey: "colorSelectedBackground")
   componentsetValue("#bfdbfe", forKey: "colorSelectedBorder")
   componentsetValue("#80808019", forKey: "colorDisabledBackground")
   lightTheme.setValue(component, forKey: "component")

   let buttonPrimary = NSMutableDictionary()
   buttonPrimary.setValue("#2563eb", forKey: "colorBackground")
   buttonPrimary.setValue("#ffffff", forKey: "colorText")
   buttonPrimary.setValue("#1d4ed8", forKey: "colorHover")
   lightTheme.setValue(buttonPrimary, forKey: "buttonPrimary")

   let buttonSecondary = NSMutableDictionary()
   buttonSecondary.setValue("#bfdbfe", forKey: "colorBackground")
   buttonSecondary.setValue("#1d4ed8", forKey: "colorText")
   buttonSecondary.setValue("#bfdbfe", forKey: "colorHover")
   lightTheme.setValue(buttonSecondary, forKey: "buttonSecondary")

   let buttonText = NSMutableDictionary()
   buttonText.setValue("#6b7280", forKey: "colorText")
   buttonText.setValue("#374151", forKey: "colorHover")
   lightTheme.setValue(buttonText, forKey: "buttonText")

   let buttonIcon = NSMutableDictionary()
   buttonIcon.setValue("#9ca3af", forKey: "colorText")
   buttonIcon.setValue("#6b7280", forKey: "colorHover")

   lightTheme.setValue(buttonIcon, forKey: "buttonIcon")
   return lightTheme
}
```

#### Dark theme

```swift
func getDarkTheme() -> NSMutableDictionary{

    let darkTheme = NSMutableDictionary()
    
    darkTheme.setValue("#3b82f6", forKey: "colorPrimary")
    darkTheme.setValue("#1f2937", forKey: "colorBackground")
    darkTheme.setValue("#e5e7eb", forKey: "colorText")
    darkTheme.setValue("#9ca3af", forKey: "colorSecondaryText")
    darkTheme.setValue("#f9fafb", forKey: "colorHeadingText")
    darkTheme.setValue("#ef4444", forKey: "colorError")
    
    let component = NSMutableDictionary()
    component.setValue("#374151", forKey: "colorBackground")
    component.setValue("#6b7280", forKey: "colorBorder")
    component.setValue("#f3f4f6", forKey: "colorText")
    component.setValue("#9ca3af", forKey: "colorPlaceholderText")
    component.setValue("#3b82f6", forKey: "colorFocus")
    component.setValue("#f3f4f6", forKey: "colorSelectedText")
    component.setValue("#4b5563", forKey: "colorSelectedBackground")
    component.setValue("#9ca3af", forKey: "colorSelectedBorder")
    component.setValue("#9ca3af", forKey: "colorDisabledBackground")
    darkTheme.setValue(component, forKey: "component")
    
    let buttonPrimary = NSMutableDictionary()
    buttonPrimary.setValue("#2563eb", forKey: "colorBackground")
    buttonPrimary.setValue("#ffffff", forKey: "colorText")
    buttonPrimary.setValue("#1d4ed8", forKey: "colorHover")
    darkTheme.setValue(buttonPrimary, forKey: "buttonPrimary")
    
    let buttonSecondary = NSMutableDictionary()
    buttonSecondary.setValue("#6b7280", forKey: "colorBackground")
    buttonSecondary.setValue("#f3f4f6", forKey: "colorText")
    buttonSecondary.setValue("#4b5563", forKey: "colorHover")
    darkTheme.setValue(buttonSecondary, forKey: "buttonSecondary")
    
    let buttonText = NSMutableDictionary()
    buttonText.setValue("#9ca3af", forKey: "colorText")
    buttonText.setValue("#d1d5db", forKey: "colorHover")
    darkTheme.setValue(buttonText, forKey: "buttonText")
    
    let buttonIcon = NSMutableDictionary()
    buttonIcon.setValue("#d1d5db", forKey: "colorText")
    buttonIcon.setValue("#f3f4f6", forKey: "colorHover")
    darkTheme.setValue(buttonIcon, forKey: "buttonIcon")

    return darkTheme
}
```
