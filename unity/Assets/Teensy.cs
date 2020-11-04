using UnityEngine;
using System;
using System.Collections;
using System.Threading;
using System.IO.Ports;
using System.Text;


public struct Packet
{
    public byte type, length;
    public ushort crc16;
    public uint packetID, usStart, usEnd;
    public ushort[] analog;
    public int[] variables;
    public ushort DIN;
    public byte DOUT;
}


public class Teensy : MonoBehaviour
{
    const byte PACKET_SIZE_B = 68;

    private Teensy m_Instance;
    public Teensy Instance {
        get { return m_Instance; }
    }

    static SerialPort _serialPort;
    static bool _alive;

    private static string encodedPacket;
    public static float xvalue = 0;
    public static float yvalue = 0;
    public static int packetCount = 0;
    public static Packet State = new Packet();
    
    DateTime start = DateTime.Now;

    Thread readThread = new Thread(Read);

    // not sure when this is called. On init, before start?
    void Awake()
    {
        m_Instance = this;
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 60;
    }

    // kill it with fire!
    void OnDestroy()
    {
        _alive = false;
        readThread.Join();
        _serialPort.Close();
        m_Instance = null;
    }

    // Start is called before the first frame update
    void Start()
    {
        _serialPort = new SerialPort("COM8", 57600);
        _serialPort.ReadBufferSize = 8192;
        _serialPort.ReadTimeout = 200;
        _serialPort.WriteTimeout = 200;
        _serialPort.NewLine = "\0";
        _alive = true;
        _serialPort.Open();
        readThread.Start();
    }

    // Update is called once per frame
    void Update()
    {
        _serialPort.Write("A");
    }

    public static void Read()
    {
        while (_alive) {

            try
            {
                encodedPacket = _serialPort.ReadLine();
                packetCount++;
                
                if (encodedPacket == null) continue;
                if (encodedPacket.Length != PACKET_SIZE_B + 1) 
                {
                    print("Improper packet length." + encodedPacket.Length);
                    continue;
                }
                unpackPacket(deCOBS(encodedPacket));
            }
            catch (TimeoutException)
            {
                //throw;
                print("Serial timeout.");
            }
        }
    }

    void OnGUI()
    {
        int lh = 12;
        int line = 0;
        double elapsed = (DateTime.Now.Ticks - start.Ticks)  / 10000000f;
        GUI.Label(new Rect(10, lh*++line, 300, 20), packetCount.ToString() + "; " +  (packetCount / elapsed).ToString("F1") + " packets/s; " + elapsed.ToString("F2"));
        line++;
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Pid: " + State.packetID.ToString());
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Tgen: " + ((double)State.usEnd - (double)State.usStart).ToString() + " µs");
            GUI.Label(new Rect(30, lh*++line, 300, 20),  "start: " + State.usStart.ToString());
            GUI.Label(new Rect(30, lh*++line, 300, 20),  "end : " + State.usStart.ToString());

        GUI.Label(new Rect(10, lh*++line, 300, 20), "Analog");
        for (int ch=0; ch<8; ch++) {
            GUI.Label(new Rect(30, lh*++line, 300, 20), "Ch"+ch.ToString()+": " + (State.analog[ch]*3.3/16384).ToString("F2") + " V");
        }

        GUI.Label(new Rect(10, lh*++line, 300, 20), "Variables");
        for (int ch=0; ch<8; ch++) {
            GUI.Label(new Rect(30, lh*++line, 300, 20), "Ch"+ch.ToString()+": " + (State.variables[ch]).ToString());
        }
        
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Din : " + Convert.ToString(State.DIN, 2).PadLeft(16, '0'));
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Dout:    " + Convert.ToString(State.DOUT, 2).PadLeft(8, '0'));
    }

    public static void unpackPacket(byte[] bytes)
    // uint8_t type;          // 1 B, o: 0,   packet type
    // uint8_t length;        // 1 B, o: 1,   packet size
    // uint16_t crc16;        // 2 B, o: 2,   CRC16
    // unsigned long packetID;// 4 B, o: 4    running packet count
    
    // unsigned long us_start;// 4 B, o: 8,   gather start timestamp
    // unsigned long us_end;  // 4 B, o: 12,  transmit timestamp
    // uint16_t analog[8];    // 16 B, o: 16, ADC values
    // long variables[8];     // 32 B, o: 32, variables (encoder, speed, etc)
    
    // uint16_t digitalIn;    // 2 B, o: 64,  digital inputs
    // uint8_t digitalOut;    // 1 B, o: 66,  digital outputs
    // uint8_t padding[1];    // 1 B, o: 67,  align to 4B
    {
        State.type = bytes[0];
        State.length = bytes[1];
        State.crc16 = BitConverter.ToUInt16(bytes, 2);
        State.packetID = BitConverter.ToUInt32(bytes, 4);

        State.usStart = BitConverter.ToUInt32(bytes, 8);
        State.usEnd = BitConverter.ToUInt32(bytes, 12);
        State.analog = new ushort[8];
        for (byte i=0; i<8; i++)
        {
            State.analog[i] = BitConverter.ToUInt16(bytes, 16+2*i);
        }
        
        State.variables = new int[8];
        for (byte i=0; i<8; i++)
        {
            State.variables[i] = BitConverter.ToInt32(bytes, 32+4*i);
        }

        State.DIN = BitConverter.ToUInt16(bytes, 64);
        State.DOUT = bytes[66];
    }

    public static byte[] deCOBS(string COBSPacketString)
    // poor man's buggy COBS decoder
    {
        byte[] arr = Encoding.ASCII.GetBytes(COBSPacketString);
		byte[] orr = new Byte[arr[2]];
		Array.Copy(arr, 1, orr, 0, arr[2]);
		int idx = -1;
		int dist = arr[0];
		int _dist = 0;
		
        try {
            while (idx+dist < orr.Length && dist > 0)
            {
                _dist = orr[idx+dist];
                orr[idx+dist] = 0;
                idx = (idx + dist);
                dist = _dist;
            }
        } catch (IndexOutOfRangeException) {
            print("INDEX OUT OF BOUNDS!");
            print("Input" + BitConverter.ToString(arr));
            print("Output" + BitConverter.ToString(orr));
        }
        print("Input" + BitConverter.ToString(arr));
        print("Output: " + BitConverter.ToString(orr));
        return orr;
    }

    public static void sendData(string data)
    {
        _serialPort.WriteLine(data);
    }
}
