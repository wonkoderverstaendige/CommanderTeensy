extern crate cobs;
extern crate base64;

use std::fs::File;
use std::io::prelude::*;
use std::io::{BufReader, BufRead, Error, SeekFrom};
use std::path::Path;

use std::time::Instant;

use rayon::prelude::*;
use clap::{Arg, App};

const PACKETLENGTH: usize = 70;
const UNPACKLENGTH: usize = 88;  // packet[67] - padding[1] - packed digitial[3] + expanded digital[24]
const PRINT: bool = !true;

fn decode_line(encoded: &String) -> [u8; UNPACKLENGTH] {
    let mut b64_decoded: [u8; PACKETLENGTH] = [0; PACKETLENGTH];
    let mut cobs_decoded: [u8; UNPACKLENGTH] = [255; UNPACKLENGTH];
    base64::decode_config_slice(&encoded, base64::STANDARD, &mut b64_decoded).unwrap();
    cobs::decode(&b64_decoded[..b64_decoded.len()-1], &mut cobs_decoded).unwrap();

    // unpack the digital channels
    let ofs = 64;
    let din0: u8 = cobs_decoded[ofs];
    let din1: u8 = cobs_decoded[ofs+1];
    let dout0: u8 = cobs_decoded[ofs+2];
    for b_pos in 0..=7 {
        let bix = 7-b_pos;
        cobs_decoded[ofs+b_pos] = (din0 & (0x1 << bix)) >> bix;
        // println!("b{:?}: {:08b}", b_pos, cobs_decoded[ofs+b_pos]);
        cobs_decoded[ofs+b_pos+8] = (din1 & (0x1 << bix)) >> bix;
        cobs_decoded[ofs+b_pos+16] = (dout0 & (0x1 << bix)) >> bix;
    }
    if PRINT { 
        println!("In: {:08b} {:08b}; Out: {:08b}", din1, din0, dout0);
    }
    
    cobs_decoded
}


fn main()  -> Result<(), Error> {
    let matches = App::new("base64:COBS to BIN conversion")
        .version("0.1.0")
        .author("Ronny E. <r.eichler@science.ru.nl>")
        .about("Convert base64 and COBS encoded log of CommanderTeensy to memory-mappable flat binary file.")
        .arg(Arg::new("config")
            .short('c')
            .long("config")
            .value_name("FILE")
            .about("Sets a custom config file")
            .takes_value(true))
        .arg(Arg::new("INPUT")
            .about("Path to .b64 file to convert.")
            .required(true)
            .index(1))
        .get_matches();

    let start = Instant::now();

    let inpath = match matches.value_of("INPUT") {
        Some(p) => Path::new(p),
        None => Path::new("")
    };
    let mut input = File::open(inpath)?;
    let mut buffered = BufReader::new(&mut input);

    // Sequential
    let outpath_s = inpath.with_extension("sbin");
    let mut output_s = File::create(outpath_s)?;
    let t_sequential = Instant::now();
    let mut num_packets: u64 = 0;
    for line in buffered.by_ref().lines() {
        let decoded = decode_line(&line?);
        output_s.write_all(&decoded)?;
        num_packets += 1;
        if PRINT {
                println!("{:?}", decoded);
            }
        }
    let dur_s = t_sequential.elapsed();
    // println!("Converting {} packets ({:.2} min) took: {:#?}", num_packets, num_packets/1000/60, dur_s);
            

    // Parallel
    // let outpath_p = inpath.with_extension("pbin");
    // let mut output_p = File::create(outpath_p)?;
    // buffered.by_ref().seek(SeekFrom::Start(0))?;
    // let t_parallel = Instant::now();
    // let res: Vec<[u8; UNPACKLENGTH]> = buffered.by_ref().lines()
    //     .map(Result::unwrap)
    //     .par_bridge()
    //     .map(|line| decode_line(&line))
    //     .collect();
    // for line in res {
    //     output_p.write_all(&line)?
    // }
    // let dur_p = t_parallel.elapsed();
    // println!("Parallel took: {:?}", dur_p);
            

    let duration = start.elapsed();
    // println!("Done. Elapsed : {:?}", duration);
    println!("Converting {} packets (~{:.2} min) took: {:.2} s", num_packets, num_packets/1000/60, dur_s.as_secs_f64());
    
    Ok(())

}
