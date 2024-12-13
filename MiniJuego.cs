using Godot;
using System;
using System.Collections.Generic;
using System.IO.Ports;

public partial class Game : Node{
	private SerialPort serialPort;
	private List<string> tarjetasCorrectas;
	private List<string> tarjetasLeidas;
	private bool minijuegoActivo;
	private RichTextLabel mensajeLabel;

	public override void _Ready(){
		tarjetasCorrectas = new List<string>{
			"Tarjeta1", // Aquí deberás poner los identificadores reales de las tarjetas NFC
			"Tarjeta2",
			"Tarjeta3",
			"Tarjeta4"
		};

		tarjetasLeidas = new List<string>();
		minijuegoActivo = false;
		mensajeLabel = GetNode<RichTextLabel>("MensajeLabel");

		OpenSerialPort();
	}

	// Abrir el puerto serial para leer las tarjetas NFC
	private void OpenSerialPort(){
		try{
			serialPort = new SerialPort("COM8", 9600); // Ajusta el puerto y la velocidad según tu configuración
			serialPort.DataReceived += OnDataReceived;
			serialPort.Open();
			GD.Print("Puerto serial abierto");
		}
		catch (Exception e){
			GD.Print("Error al abrir el puerto serial: " + e.Message);
		}
	}

	// Evento cuando se reciben datos desde el puerto serial
	private void OnDataReceived(object sender, SerialDataReceivedEventArgs e){
		string data = serialPort.ReadLine().Trim(); // Lee la tarjeta NFC
		GD.Print("Datos recibidos: " + data);

		if (minijuegoActivo){
			tarjetasLeidas.Add(data);
			VerificarTarjetas();
		}
	}

	// Función para verificar las tarjetas leídas
	private void VerificarTarjetas(){
		if (tarjetasLeidas.Count == tarjetasCorrectas.Count){
			for (int i = 0; i < tarjetasCorrectas.Count; i++){
				if (tarjetasLeidas[i] != tarjetasCorrectas[i]){
					
					// Si alguna tarjeta es incorrecta, muestra un mensaje de error
					mensajeLabel.Text = "¡Error! Secuencia incorrecta.";
					tarjetasLeidas.Clear();
					return;
				}
			}

			// Si la secuencia es correcta, muestra un mensaje de éxito
			mensajeLabel.Text = "¡Felicidades! Has desactivado la bomba.";
			minijuegoActivo = false;
		}
	}

	// Activar el minijuego cuando el personaje toque la puerta
	public void ActivarMinijuego(){
		minijuegoActivo = true;
		tarjetasLeidas.Clear();
		mensajeLabel.Text = "Escanea las tarjetas en el orden correcto para desactivar la bomba.";
	}

	// Detectar colisión entre el personaje y la puerta
	public void OnPlayerTouchDoor(){
		if (!minijuegoActivo){
			ActivarMinijuego();
		}
	}
}
