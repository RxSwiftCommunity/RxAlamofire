# Change Log
All notable changes to this project will be documented in this file.

---

## Master

#### Updated

* Rename `RxProgress.totalBytesWritten` to `RxProgress.bytesRemaining`.
* Rename `RxProgress.totalBytesExpectedToWrite` to `RxProgress.totalBytes`.

#### Fixed

* Fix `Reactive<DataRequest>.progress` logic so it actually completes.
