# Swift Race Condition Examples

Example code for the article **“How to Avoid Race Conditions in Swift”**.

This repo shows a simple **ticket purchase** scenario and how different concurrency approaches can prevent race conditions:

<img alt="image" src="https://github.com/user-attachments/assets/52b90f95-ebba-4e7b-95ae-eb2d46592b7c" />

- Naive shared state (race condition)
- Double-check approach
- `NSLock`
- Serial `DispatchQueue`
- Concurrent queue + `.barrier`
- Swift `actor`

## Read full article

<img width="48" height="48"
     style="border-radius:20%;"
     alt="image"
     src="https://github.com/user-attachments/assets/ba191861-b79f-4bb7-920e-a6830a312b07" />

[Read here](https://leandrohdez.substack.com/p/evitando-race-conditions-en-swift)
