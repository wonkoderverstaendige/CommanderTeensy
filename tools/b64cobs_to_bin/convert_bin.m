function [out] = convert_bin(inpath)
    % uint8_t type;          // 1 B, packet type
    % uint8_t size;          // 1 B, packet size
    % uint16_t crc16;        // 2 B, CRC16
    % unsigned long packetID;// 4 B, running packet count

    % unsigned long ts_start;// 4 B, gather start timestamp
    % unsigned long ts_end;  // 4 B, transmit timestamp
    % uint16_t analog[8];    // 2*8=16 B, ADC values
    % long states[8];        // 4*8=32 B, state variables
    % uint8_t digitalIn;     // 1*16=16 B, digital inputs
    % uint8_t digitalOut;    // 1*8=8 B, digital outputs

    cvt_exe = '.\target\release\b64cobs_to_bin.exe';
    newpath = strrep(inpath, '.b64', '.bin');

    if isfile(newpath)
        disp(['File ' newpath ' exists already. Skipping.']);
    else
        cmd = [cvt_exe ' ' inpath];
        disp(cmd);
        system(cmd);
    end
    
    fmt_n_bytes = 88;  % size of each packet in Bytes
    df = dir(newpath);
    fsize = df.bytes;
    n_packets = fsize / fmt_n_bytes;
    fprintf('Packets: %d',  n_packets);
    
    fmt = { 'uint8' 1 'type';
      'uint8' 1 'size';
      'uint16' 1 'crc16';
      'uint32' 1 'packetID';
      'uint32' 1 'ts_start';
      'uint32' 1 'ts_end';
      'uint16' [8 1] 'analog';
      'int32' [8 1] 'states';
      'uint8' [16 1] 'digital_in';
      'uint8' [8 1] 'digital_out'
    };

    mm = memmapfile(newpath, 'Format', fmt);
    out = mm.Data;
end

