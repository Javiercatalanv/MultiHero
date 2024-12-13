using Godot;
using System;
using System.IO.Ports;
using System.Threading;

public partial class NFCReader : Node
{
	private SerialPort _serialPort;
	private Thread _readThread;
	private bool _keepReading = true;

	[Export] public string PortName = "COM5"; // Cambia según tu configuración
	[Export] public int BaudRate = 9600;

	// Señal para enviar los UID detectados
	[Signal]
	public delegate void UIDReceivedEventHandler(string uid);

	public override void _Ready()
	{
		try
		{
			// Configura el puerto serial
			_serialPort = new SerialPort(PortName, BaudRate)
			{
				ReadTimeout = 1000,
				WriteTimeout = 1000
			};
			_serialPort.Open();

			// Inicia el hilo para leer datos del puerto serial
			_readThread = new Thread(ReadSerialData);
			_readThread.Start();

			GD.Print("Lector NFC conectado.");
		}
		catch (System.Exception ex)
		{
			GD.PrintErr($"Error al conectar al puerto serial: {ex.Message}");
		}
	}

	private void ReadSerialData()
	{
		while (_keepReading && _serialPort.IsOpen)
		{
			try
			{
				// Leer líneas completas del puerto serial
				string uid = _serialPort.ReadLine().Trim();
				GD.Print($"UID detectado: {uid}");

				// Emitir la señal con el UID detectado
				EmitSignal(SignalName.UIDReceived, uid);
			}
			catch (TimeoutException)
			{
				// Ignorar timeout
			}
		}
	}

	public override void _ExitTree()
	{
		// Detener el hilo y cerrar el puerto al salir del nodo
		_keepReading = false;
		_readThread?.Join();
		_serialPort?.Close();
		GD.Print("Conexión con el lector NFC cerrada.");
	}
}
