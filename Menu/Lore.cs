using Godot;
using System.Collections.Generic;
using System.IO.Ports;

public partial class Indicaciones : Control
{
	private RichTextLabel pistasLabel;
	private List<string> pistas;
	private int indicePista;
	private SerialPort serialPort;

	public override void _Ready()
	{
		pistasLabel = GetNode<RichTextLabel>("Label");
		pistasLabel.Visible = true;

		pistas = new List<string>
		{
			"¡Atención! Estás a punto de desarmar la bomba.\n\n" +
			"Instrucciones:\n\n" +
			"1. Memoriza el patrón que aparecerá en la pantalla.\n\n" +
			"2. Presiona los botones en el orden exacto para desactivarla.\n\n" +
			"¡Cuidado! Un error puede ser fatal. ¡Hazlo con precisión!"
		};

		MostrarHistoria();
		OpenSerialPort();
	}

	private void MostrarHistoria()
	{
		if (indicePista < pistas.Count)
		{
			TweenMachineEffect(pistasLabel, pistas[indicePista], () =>
			{
				// Cambiar de escena una vez que termine la historia
				GetTree().ChangeSceneToFile("res://MundoTutorial.tscn");
			});
		}
	}

	private void TweenMachineEffect(RichTextLabel label, string texto, System.Action onComplete)
	{
		label.Clear();
		int longitudTexto = texto.Length;
		int i = 0;

		Timer timer = new Timer();
		timer.WaitTime = 0.05f; // Tiempo entre cada carácter
		timer.OneShot = false;
		timer.Timeout += () =>
		{
			if (i <= longitudTexto)
			{
				label.Text = texto.Substring(0, i);
				i++;
			}
			else
			{
				timer.Stop();
				onComplete?.Invoke();
			}
		};
		AddChild(timer);
		timer.Start();
	}

	private void OpenSerialPort()
	{
		try
		{
			serialPort = new SerialPort("COM8", 9600);
			serialPort.DataReceived += OnDataReceived;
			serialPort.Open();
			GD.Print("Puerto serial abierto");
		}
		catch (System.Exception e)
		{
			GD.Print("Error al abrir el puerto serial: " + e.Message);
		}
	}

	private void OnDataReceived(object sender, SerialDataReceivedEventArgs e)
	{
		string data = serialPort.ReadLine();
		GD.Print("Datos recibidos: " + data);
	}
}
