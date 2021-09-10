Convert base64+COBS encoded log files to memory-mappable binary files. Expands digital channel bitfield to individual 
bytes for ease of mapping at cost of disk space.

Build with `$ cargo build --release` and run executable with path to .b64 as argument.

`$ b64_cobs_to_bin.exe [path_to_b64]`. Release build converts 60 min file in <8 seconds.

Todo:
- Add channel counts/layout arguments
- make digital expansion optional
- parallelized conversion for additional speedup and premature optimization points


