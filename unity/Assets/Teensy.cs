using UnityEngine;
using System;
using System.Collections;
using System.Threading;
using System.IO;
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

    static SerialPort _serialPort;
    static bool _alive;

    // private static byte[] encodedData;
    public static float xvalue = 0;
    public static float yvalue = 0;
    public static int packetCount = 0;
    public static Packet State = new Packet();
    
    DateTime start;
    static double elapsed = 0;
    static double last_blink = 0;

    Thread readThread = new Thread(Read);
    private static LineSplitter splitter = new LineSplitter();

    public Font MyFont;

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
        // _serialPort.ReadBufferSize = 4096;
        // _serialPort.ReadTimeout = 200;
        // _serialPort.WriteTimeout = 200;
        // _serialPort.NewLine = "\0";
        _alive = true;
        _serialPort.Open();
        splitter.LineReceived += handlePacket;

        start = DateTime.Now;
        readThread.Start();
    }

    // Update is called once per frame
    void Update()
    {
        // sendData("1234567890");
    }

    public static void Read()
    {
        byte[] buffer = new byte[16];
        Action kickoffRead = null;
        kickoffRead = delegate
        {
            _serialPort.BaseStream.BeginRead(buffer, 0, buffer.Length, delegate (IAsyncResult ar)
            {
                try {
                    int actualLength = _serialPort.BaseStream.EndRead(ar);
                    byte[] received = new byte[actualLength];
                    Buffer.BlockCopy(buffer, 0, received, 0, actualLength);
                    splitter.OnIncomingBinaryBlock(received);
                }
                catch (IOException exc) {
                    Debug.LogException(exc);
                }
                if (_alive) {
                    kickoffRead();
                }
            }, null);
        };
        kickoffRead();
    }

    void OnGUI()
    {
        int lh = 12;
        int line = 0;
        elapsed = (DateTime.Now.Ticks - start.Ticks)  / 10000000f;
        GUI.skin.font = MyFont;
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Packet#: " + packetCount.ToString() + " @ " + elapsed.ToString("F1") + "s");
        GUI.Label(new Rect(10, lh*++line, 300, 20), (packetCount / elapsed).ToString("0000.") + " packets/s; ");
        line++;
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Pid: " + State.packetID.ToString());
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Tgen: " + ((double)State.usEnd - (double)State.usStart).ToString() + " µs");
            GUI.Label(new Rect(30, lh*++line, 300, 20),  "start: " + State.usStart.ToString());
            GUI.Label(new Rect(30, lh*++line, 300, 20),  "end  : " + State.usEnd.ToString());

        GUI.Label(new Rect(10, lh*++line, 300, 20), "Analog");
        for (int ch=0; ch<8; ch++) {
            if (State.analog.Length > 0) GUI.Label(new Rect(30, lh*++line, 300, 20), "Ch"+ch.ToString()+": " + (State.analog[ch]*3.3/16384).ToString("F2") + " V");
        }

        GUI.Label(new Rect(10, lh*++line, 300, 20), "Variables");
        for (int ch=0; ch<8; ch++) {
            if (State.variables.Length > 0) GUI.Label(new Rect(30, lh*++line, 300, 20), "Ch"+ch.ToString()+": " + (State.variables[ch]).ToString());
        }
        
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Din : " + Convert.ToString(State.DIN, 2).PadLeft(16, '0'));
        GUI.Label(new Rect(10, lh*++line, 300, 20), "Dout:   " + Convert.ToString(State.DOUT, 2).PadLeft(8, '0'));
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
        // Debug.Log("Input" + BitConverter.ToString(arr));
        // Debug.Log("Output: " + BitConverter.ToString(orr));
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

    public void sendData(string data)
    {
        // raw:     01-01-07-01
        // COBS: 04-01-01-07-01-00
        double delta = (DateTime.Now.Ticks - last_blink)/10000f;
        // Debug.Log(delta.ToString("F2"));
        if (delta > 1)
        {
            byte[] cmd = {4, 1, 1, 7, 1, 0};
            _serialPort.Write(cmd, 0, cmd.Length);
            // Debug.Log("Toggling!");
            last_blink = DateTime.Now.Ticks;
        }
    }
}
