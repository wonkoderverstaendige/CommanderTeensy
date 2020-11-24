[X] packet serial ID (uint32?)

[ ] RTC field (time_t 32bit)

[X] SerialEmulator

[X] Increase field size of state variables to at least `long`

[ ] Auto-negotiate serial port identity

[ ] Discover struct data sizes, types and purposes

[ ] per-type packet count?

[X] Something seems broken with the CRC, the first byte is always 0x44 and the second predictable.

[ ] COBS encoder for Unity side

[ ] per-type packet handling on teensy side

[ ] heartbeats from clients per serial port