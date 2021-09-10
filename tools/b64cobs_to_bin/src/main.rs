extern crate cobs;
extern crate base64;

use std::io::prelude::*;
use std::io::{BufReader, BufRead, Error};  // 
use std::path::Path;

use std::time::Instant;

use rayon::prelude::*;
use clap::{Arg, App};

const PACKETLENGTH: usize = 70;
const UNPACKLENGTH: usize = 88;  // packet[67] - padding[1] - packed digitial[3] + expanded digital[24]

fn decode_line(encoded: &String) -> [u8; UNPACKLENGTH] {
    let mut b64_decoded: [u8; PACKETLENGTH] = [0; PACKETLENGTH];
    let mut cobs_decoded: [u8; UNPACKLENGTH] = [255; UNPACKLENGTH];
    base64::decode_config_slice(&encoded, base64::STANDARD, &mut b64_decoded).unwrap();
    cobs::decode(&b64_decoded[..b64_decoded.len()-1], &mut cobs_decoded).unwrap();

    // unpack the digital channels
    let ofs = 64;
    for b_pos in 0..=7 {
        let bix = 7-b_pos;
        cobs_decoded[ofs+b_pos] = (cobs_decoded[ofs] & (0x1 << bix)) >> bix;
        cobs_decoded[ofs+b_pos+8] = (cobs_decoded[ofs+1] & (0x1 << bix)) >> bix;
        cobs_decoded[ofs+b_pos+16] = (cobs_decoded[ofs+2] & (0x1 << bix)) >> bix;
    }
    
    cobs_decoded
}

// Sequential
fn convert_sequential(inpath: &Path, outpath: &Path) -> Result<u64, Error> {
    let t_start = Instant::now();
    let mut input = std::fs::File::open(inpath)?;
    let mut buffered = BufReader::new(&mut input);

    let mut output = std::fs::File::create(outpath)?;
    let mut num_packets: u64 = 0;
    for line in buffered.by_ref().lines() {
        let decoded = decode_line(&line?);
        output.write_all(&decoded)?;
        num_packets += 1;
    }
    println!("Sequential took: {:.2}", t_start.elapsed().as_secs_f32());

    Ok(num_packets)
}

// Parallel
fn convert_parallel(inpath: &Path, outpath: &Path) -> Result<u64, Error> {
    let t_start = Instant::now();
    let input = std::fs::read(inpath)?;
    let mut num_packets = 0;
    let mut output = std::fs::File::create(outpath)?;

    let res: Vec<[u8; UNPACKLENGTH]> = input.lines()
        .map(Result::unwrap)
        .par_bridge()
        .map(|line| decode_line(&line))
        .collect();
    for line in res {
        output.write_all(&line)?;
        num_packets += 1;
    }
    println!("Parallel took: {:.2}", t_start.elapsed().as_secs_f32());

    Ok(num_packets)
}

fn main()  -> Result<(), Error> {
    let start = Instant::now();
    let matches = App::new("base64:COBS to BIN conversion")
        .version("0.1.0")
        .author("R. Eichler <r.eichler@science.ru.nl>")
        .about("Convert base64 and COBS encoded log of CommanderTeensy to memory-mappable flat binary file.")
        .arg(Arg::new("parallel")
            .short('p')
            .long("parallel")
            .about("Perform conversion in parallel. Totally doesn't work yet.")
            .takes_value(false))
        .arg(Arg::new("INPUT")
            .about("Path to .b64 file to convert.")
            .required(true)
            .index(1))
        .get_matches();

    let inpath = match matches.value_of("INPUT") {
        Some(p) => Path::new(p),
        None => Path::new("")
    };


    let num_packets = match matches.is_present("parallel") {
        true => convert_parallel(&inpath, &inpath.with_extension("bin"))?,
        false => convert_sequential(&inpath, &inpath.with_extension("bin"))?
    };
    
    let duration = start.elapsed();
    // println!("Done. Elapsed : {:?}", duration);
    println!("Converting {} packets (~{:.2} min) took: {:.2} s", num_packets, num_packets/1000/60, duration.as_secs_f64());
    
    Ok(())
}
