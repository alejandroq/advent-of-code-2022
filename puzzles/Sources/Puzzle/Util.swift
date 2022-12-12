import Foundation

func measure(_ block: () -> Void) {
  let start = DispatchTime.now()
  block()
  let end = DispatchTime.now()
  let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
  let timeInterval = Double(nanoTime) / 1_000
  print("Time elapsed: \n\t\(timeInterval)µs\n\t\(timeInterval/1000)ms\n\t\(timeInterval/1000/1000)s")
  
}
