# Swift Race Condition Examples

Example code for the article **“How to Avoid Race Conditions in Swift”**.

This repo shows a simple **ticket purchase** scenario and how different concurrency approaches can prevent race conditions:

- Naive shared state (race condition)
- Double-check approach
- `NSLock`
- Serial `DispatchQueue`
- Concurrent queue + `.barrier`
- Swift `actor`

## Article

[Add your blog link here.](https://leandrohdez.substack.com/p/evitando-race-conditions-en-swift)
