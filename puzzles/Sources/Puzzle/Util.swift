import Foundation

func measure(_ block: () -> Void) {
  let start = DispatchTime.now()
  block()
  let end = DispatchTime.now()
  let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
  let timeInterval = Double(nanoTime) / 1_000
  print("Time elapsed: \(timeInterval)µs")
}
