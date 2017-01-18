# Programmeerproject Style Guide

## Code Formatting

**Inspiration from:** https://github.com/linkedin/swift-style-guide#3-coding-style

- Make functions as short as possible; separate pieces of code if they serve other purposes.
- Add a newline after each function.
- In general, there should be a space following a comma.
- There should be a space before and after a binary operator such as +, ==, or ->. There should also not be a space after a ( and before a ).
- Respect the standard indents that Xcode puts in your code.
- Delete all commented code - if you don't use it, you don't need it.
- When calling a function that has many parameters, put each argument on a separate line with a single extra indentation.
```Swift
someFunctionWithManyArguments(
    firstArgument: "Hello, I am a string",
    secondArgument: resultFromSomeFunction(),
    thirdArgument: someOtherLocalProperty)
```
- When dealing with an implicit array or dictionary large enough to warrant splitting it into multiple lines, treat the [ and ] as if they were braces in a method, if statement, etc. Closures in a method should be treated similarly.
```Swift
someDictionaryArgument: [
        "dictionary key 1": "some value 1, but also some more text here",
        "dictionary key 2": "some value 2"
    ]
```
- Let the flow of the app (what happens first) dictate the flow of your code.
```Swift
//Preferred
getData() { /*...*/ }
manipulateData() { /*...*/ }
exportData() { /*...*/ }

//Not-Preferred
exportData() { /*...*/ }
getData() { /*...*/ }
manipulateData() { /*...*/ }
```

### Standard layout of a ViewController
- Use MARK to mark a block of associated code.
- Collect Constants and variable on one place at the top of the file, as well as outlets.
- Put as few code as possible in the viewDidLoad.

```Swift
// MARK: Constants and variables
var admin = Bool()
/*...*/

// MARK: - Outlets
@IBOutlet weak var name: UITextField!
/*...*/

// MARK: UIViewController Lifecycle
override func viewDidLoad() {
   super.viewDidLoad()
}
override func didReceiveMemoryWarning() {
   super.didReceiveMemoryWarning()
}

// MARK: - ...
// Put some other code block here

// MARK: - Actions
@IBAction func signOut(_ sender: Any) {
   self.dismiss(animated: true, completion: {})
}
```

## Code Style

## Naming

## Comments

- Use MARK to mark a block of associated code.
- Prefer well written code over comments: the code must explain itself. 

###References
```Swift
// Enable user to dismiss keyboard by tapping outside of it. [3]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

/*...*/

// MARK: References
/*
 1. https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
 2. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
 3. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
 4. https://www.raywenderlich.com/117471/state-restoration-tutorial
 */
```
