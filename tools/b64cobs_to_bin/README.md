Convert base64+COBS encoded log files to memory-mappable binary files.

Build with `$ cargo build --release` and run executable with path to .b64 as argument.

`$ b64_cobs_t0_bin.exe [path_to_b64]`. Release build converts 60 min file in <8 seconds.

Todo:
- Add channel counts/layout arguments
- parallelized conversion for additional speedup and premature optimization points


