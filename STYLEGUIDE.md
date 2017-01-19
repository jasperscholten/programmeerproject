# Programmeerproject Style Guide

*Inspiration for this Style Guide comes from:*

- <a href="https://github.com/linkedin/swift-style-guide#3-coding-style">LinkedIn Swift Style Guide<a>
- <a href="https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/index.html#//apple_ref/doc/uid/TP40014097-CH3-ID0">Apple Official Swift Documentation<a>
- <a href="https://github.com/raywenderlich/swift-style-guide">Ray Wenderlich Swift Style Guide<a>

*If you don't find what you're looking for in our Style Guide, please go through these three Style Guides (in the given order, starting with Apple's official documentation).*

### For Code Style, refer to that section in <a href="https://github.com/linkedin/swift-style-guide/blob/master/README.md#3-coding-style">LinkedIn Swift Style Guide<a>

## Code Formatting

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
3}

// MARK: - ...
// Put some other code block here

// MARK: - Actions
@IBAction func signOut(_ sender: Any) {
   self.dismiss(animated: true, completion: {})
}
```

### Spacing

- Indent code with tabs, not with spaces.
- An empty line at the end of files.
- Method braces and other braces (if/else/switch/while etc.) always open on the
same line as the statement but close on a new line.
- Vertical spaces should be used in long methods to separate its name from implementation.
   - You may also want to use vertical spaces to divide code into logical chunks.
   - Shorter methods (one or two lines) don't need such spacing.
- Don’t leave trailing whitespace.
   - Not even leading indentation on blank lines.

## Naming

### General

- Clarity at the point of use. 
- Use US English spelling to match Apple's API.
- Clear naming and avoid ambigous words.
- Do not abbreviate, use shortened names, or single letter names.
- Using names based on roles not on types
- Every word  in a name should convey salient information.
- Protocols that describe what something is should read as nouns.
- protocols that describe a capability should be names using suffixes.
- Stick to the established meaning. 
- Using terms that don't surprise experts or confuse beginners. 
- avoid abbreviations.
- Using camel case.
- Using uppercase for types (and protocols), lowercase for everything else. 


### Methods
- Name functions and methods according to their side affects.
- Uses of boolean methods and properties should read as assertions.
- Giving the same base nae to methods that share the same meaning.
- Begin factory methods with make.

## Documentation

### Additional MarkDown Files.
It is generally considered to be the standard to add a DESIGN.md file describing;
ome parts that you may describe here:

- a diagram of modules or classes that you’ve decided to implement, in appropriate detail
- advanced sketches of your UI that clearly explain which features are connected to which underlying part of the code
- a list of APIs and frameworks or plugins that you will be using to provide functionality in your app
- a list of data sources if you will get data from an external source
- a list of database tables and fields (and their types) if you will use a database

As well as a README.md that should be the first thing a visitor will see when opening your repository containing;
- The name of your app.
- A table of content.
- Basics of your app.
- Data and resources.
- Database; tables and variables used.
- Or use the Apple guideline: https://developer.apple.com/library/content/samplecode/Lister/Listings/README_md.html

## Comments

- Prefer well written code over comments: the code must explain itself. When they are needed, use comments to explain why a particular piece of code does something. Comments must be kept up-to-date or deleted.
- Avoid block comments inline with code, as the code should be as self-documenting as possible. Exception: This does not apply to those comments used to generate documentation.
- For complicated classes, describe the usage of the class with some potential examples as seems appropriate. Remember that markdown syntax is valid in Swift's comment docs. Newlines, lists, etc. are therefore appropriate.
- Always leave a space after //.
- Always leave comments on their own line.
- Use MARK to mark a block of associated code.
- When using // MARK: - whatever, leave a newline after the comment.

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
