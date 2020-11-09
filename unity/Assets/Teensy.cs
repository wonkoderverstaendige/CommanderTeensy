using UnityEditor;
using UnityEngine;
using System;
using System.Collections;
using System.Threading;
using System.IO;
using System.IO.Ports;
using System.Text;


public struct Packet
{
    public DateTime received;
    public byte[] raw;
    public byte type, length;
    public ushort crc16, crc16_tested;
    public uint packetID, usStart, usEnd;
    public ushort[] analog;
    public int[] variables;
    public ushort DIN;
    public byte DOUT;
    public byte test;
}


public class Crc16
// from http://sanity-free.org/147/standard_crc16_and_crc16_kermit_implementation_in_csharp.html
// Thanks Steve!
{
    static ushort[] table = new ushort[256];

    public ushort ComputeChecksum( params byte[] bytes ) {
        ushort crc = 0;
        for(int i = 0; i < bytes.Length; ++i) {
            byte index = (byte)(crc ^ bytes[i]);
            crc = (ushort)((crc >> 8) ^ table[index]);
        }
        return crc; // BitConverter.GetBytes()
    }

    public Crc16() {
        ushort polynomial = 0x8408;
        ushort value;
        ushort temp;
        for(ushort i = 0; i < table.Length; ++i) {
            value = 0;
            temp = i;
            for(byte j = 0; j < 8; ++j) {
                if(((value ^ temp) & 0x0001) != 0) {
                    value = (ushort)((value >> 1) ^ polynomial);
                }else {
                    value >>= 1;
                }
                temp >>= 1;
            }
            table[i] = value;
        }
    }
}

public enum SerialPortStatus { NoConnection, Connected, Reconnecting };

public class LineSplitter
// from: https://www.sparxeng.com/blog/software/reading-lines-serial-port
// Thanks Ben!
{
    public event Action<byte[]> LineReceived;
    public byte Delimiter = (byte)'\0';
    byte[] leftover;
 
    public void OnIncomingBinaryBlock(byte[] buffer)
    {
        // Debug.Log("OnIncomingBinaryBlock " + buffer.Length.ToString());
        int offset = 0;
        while (true)
        {
            int newlineIndex = Array.IndexOf(buffer, Delimiter, offset);
            if (newlineIndex < offset)
            {
                leftover = ConcatArray(leftover, buffer, offset, buffer.Length - offset);
                break;
            }
            ++newlineIndex;
            byte[] full_line = ConcatArray(leftover, buffer, offset, newlineIndex - offset);
            leftover = null;
            offset = newlineIndex;
            LineReceived?.Invoke(full_line); // raise an event for further processing
        }
    }
 
    static byte[] ConcatArray(byte[] head, byte[] tail, int tailOffset, int tailCount)
    {
        byte[] result;
        if (head == null)
        {
            result = new byte[tailCount];
            Array.Copy(tail, tailOffset, result, 0, tailCount);
        }
        else
        {
            result = new byte[head.Length + tailCount];
            head.CopyTo(result, 0);
            Array.Copy(tail, tailOffset, result, head.Length, tailCount);
        }
 
        return result;
    }
}

public class Teensy : MonoBehaviour
{
    const byte PACKET_SIZE_B = 68;

    private Teensy m_Instance;
    public Teensy Instance {
        get { return m_Instance; }
    }

    static string port = "COM8";
    static SerialPort _serialPort;
    static SerialPortStatus _serialPortStatus = SerialPortStatus.NoConnection;
    static bool _alive;

    public static float xvalue = 0;
    public static float yvalue = 0;
    public static int packetCount = 0;
    public static double packetsPerSecond = 0;
    public static Packet State = new Packet();
    
    static DateTime ReceiveStart;
    static double elapsed = 0;
    static double last_blink = 0;

    Thread readThread = new Thread(Read);
    private static LineSplitter splitter = new LineSplitter();

    public Font MyFont;

    private static Crc16 CRC = new Crc16();

    // not sure when this is called. On init, before start?
    void Awake()
    {
        m_Instance = this;
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 60;
        Debug.Log("Waking up");
    }

    // kill it with fire!
    void OnDestroy()
    {
        Debug.Log("On Destroy");
        _alive = false;
        if (readThread.ThreadState == ThreadState.Running) readThread.Join();
        if (_serialPort.IsOpen) _serialPort.Close();
        m_Instance = null;
    }

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("Starting up");
        _alive = true;
        splitter.LineReceived += handlePacket;
        readThread.Start();
    }

    // attempt to connec to the serial port
    public static bool Connect(string p) {
        _serialPort = new SerialPort(p, 57600);
        try {
            _serialPort.Open();
        } catch (IOException exc) {
            Debug.Log("Connection failed: " + exc.ToString());
        }

        if (_serialPort.IsOpen) {
            port = p;
            _serialPortStatus = SerialPortStatus.Connected;
            ReceiveStart = DateTime.Now;
            return true;
        } else {
            _serialPortStatus = SerialPortStatus.NoConnection;
            return false;
        }
    }

    // Update is called once per frame
    void Update()
    {
        // handle flags
        // lickWasSeen? print("Hello!");
        // lickWasSeen = false;
    }

    public static void Read()
    {
        byte[] buffer = new byte[16];
        Action kickoffRead = null;
        Action reconnect = null;
        Action next = kickoffRead;

        reconnect = delegate {
            // if (_serialPort == null || !_serialPort.IsOpen) {
            Debug.Log("Attempting to reconnect to port " + "COM8"); // faking the reconnection status indication.
            _serialPortStatus = SerialPortStatus.Reconnecting;
            Thread.Sleep(400);
            if (Connect("COM8")) {
                Debug.Log("We decided we are connected?");
                next = kickoffRead;
            } else {
                Thread.Sleep(2600);
                next = reconnect;
            }
            // }
            if (_alive) next();
        };

        kickoffRead = delegate {
            _serialPort.BaseStream.BeginRead(buffer, 0, buffer.Length, delegate (IAsyncResult ar)
            {
                try {
                    int actualLength = _serialPort.BaseStream.EndRead(ar);
                    byte[] received = new byte[actualLength];
                    Buffer.BlockCopy(buffer, 0, received, 0, actualLength);
                    splitter.OnIncomingBinaryBlock(received);
                    next = kickoffRead;
                }
                catch (IOException exc) {
                    Debug.Log("Serial read fail: " + exc.ToString());
                    next = reconnect;
                }
                catch (InvalidOperationException exc) {
                    Debug.Log("Serial read fail: " + exc.ToString());
                    next = reconnect;
                }
                if (_alive) next();
            }, null);
        };

        reconnect();
    }

    void OnGUI()
    {
        int lh = 12;
        int line = 0;
        elapsed = (DateTime.Now.Ticks - ReceiveStart.Ticks)  / 10000000f;
        packetsPerSecond = 0.9 * packetsPerSecond + 0.1 * (packetCount / elapsed);

        GUI.skin.font = MyFont;

        GUI.Label(new Rect(10, lh*++line, 300, 20), "Serial " + port);
        if (_serialPortStatus == SerialPortStatus.Connected) {
            GUI.contentColor = Color.green;
        } else if (_serialPortStatus == SerialPortStatus.Reconnecting) {
            GUI.contentColor = Color.yellow;
        } else {
            GUI.contentColor = Color.red;
        }
        GUI.Label(new Rect(100, lh*line, 300, 20), _serialPortStatus.ToString());
        GUI.contentColor = Color.white;

        GUI.Label(new Rect(10, lh*++line, 300, 20), "Packet#: " + packetCount.ToString() + " @ " + elapsed.ToString("F1") + "s");
        GUI.Label(new Rect(10, lh*++line, 300, 20), Math.Ceiling(packetsPerSecond).ToString("0000.") + " packets/s; ");

        // CRC16
        if (State.received.Ticks != 0) {
            bool crcOK = State.crc16 == State.crc16_tested;
            GUI.contentColor = crcOK? Color.green : Color.red;
            GUI.Label(new Rect(10, lh*++line, 300, 20), "CRC16 " + (crcOK? "OK" : "BAD"));
            GUI.contentColor = Color.white;
                GUI.Label(new Rect(30, lh*++line, 300, 20), "TX: " + State.crc16.ToString("X4"));
                GUI.Label(new Rect(30, lh*++line, 300, 20), "RX: " + State.crc16_tested.ToString("X4"));

            line++;
            GUI.Label(new Rect(10, lh*++line, 300, 20), "Pid: " + State.packetID.ToString());
            if ((DateTime.Now.Ticks - State.received.Ticks) / 10000f > 200) GUI.Label(new Rect(110, lh*line, 300, 20), "STALE!");  // if data older than 200ms... oh dear.
            GUI.Label(new Rect(10, lh*++line, 300, 20), "Tgen: " + ((double)State.usEnd - (double)State.usStart).ToString() + " µs");
                GUI.Label(new Rect(30, lh*++line, 300, 20),  "start: " + State.usStart.ToString());
                GUI.Label(new Rect(30, lh*++line, 300, 20),  "end  : " + State.usEnd.ToString());

            GUI.Label(new Rect(10, lh*++line, 300, 20), "Analog");
            for (int ch=0; ch<8; ch++) {
                if (State.analog != null) GUI.Label(new Rect(30, lh*++line, 300, 20), "Ch"+ch.ToString()+": " + (State.analog[ch]*3.3/16384).ToString("F2") + " V");
            }

            GUI.Label(new Rect(10, lh*++line, 300, 20), "Variables");
            for (int ch=0; ch<8; ch++) {
                if (State.variables != null) GUI.Label(new Rect(30, lh*++line, 300, 20), "Ch"+ch.ToString()+": " + (State.variables[ch]).ToString());
            }
            
            GUI.Label(new Rect(10, lh*++line, 300, 20), "Din : " + Convert.ToString(State.DIN, 2).PadLeft(16, '0'));
            GUI.Label(new Rect(10, lh*++line, 300, 20), "Dout:   " + Convert.ToString(State.DOUT, 2).PadLeft(8, '0'));
        }
    }

    private void handlePacket(byte[] bytes) {
        if (bytes.Length != PACKET_SIZE_B + 2) 
        {
            Debug.Log("Improper packet length." + bytes.Length);
            return;
        }
        applyPacket(deCOBS(bytes));
        packetCount++;
    }

    public static byte[] enCOBS(byte[] arr)
    // poor man's buggy COBS encoder
    {
        return arr;
    }

    public static byte[] deCOBS(byte[] arr)
    // poor man's buggy COBS decoder
    {
		byte[] orr = new Byte[arr[2]]; // length indicated in incoming packet
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
            Debug.Log("INDEX OUT OF BOUNDS!");
            Debug.Log("Input" + BitConverter.ToString(arr));
            Debug.Log("Output" + BitConverter.ToString(orr));
        }
        return orr;
    }

    public static void applyPacket(byte[] bytes)
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
        State.received = DateTime.Now;
        State.raw = bytes;
        State.type = bytes[0];
        State.length = bytes[1];

        State.crc16 = BitConverter.ToUInt16(bytes, 2);
        byte[] tmp = new byte[bytes.Length];
        bytes.CopyTo(tmp, 0); // make copy
        tmp[2] = 0; // set crc16 field to zero, as was when
        tmp[3] = 0; // crc16_ccitt was calculated before sending.
        State.crc16_tested = CRC.ComputeChecksum(tmp);

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

    public void sendData(string dat) {
        _sendData(dat);
    }

    public static void _sendData(string data)
    {
        if (_serialPort == null || !_serialPort.IsOpen) return;
        // raw:     01-01-07-01
        // COBS: 04-01-01-07-01-00
        double delta = (DateTime.Now.Ticks - last_blink)/10000f;
        if (delta > 1)
        {
            if (data == "position") {
                byte[] cmd = {4, 1, 1, 7, 1, 0};
                _serialPort.Write(cmd, 0, cmd.Length);
            } else {
                byte[] cmd = {4, 1, 1, 7, 1, 0};
                _serialPort.Write(cmd, 0, cmd.Length);
                _serialPort.BaseStream.Flush();
                last_blink = DateTime.Now.Ticks;
            }
        }
    }
}
