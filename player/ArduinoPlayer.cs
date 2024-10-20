using Godot;
using System;
using System.IO.Ports;

public partial class ArduinoPlayer : CharacterBody2D
{
	// Definimos el puerto serial para la comunicación con el Arduino
	private SerialPort serialPort;

	// Variables para los datos del joystick
	private int joystickX = 0;
	private int joystickY = 0;

	// Ajustamos la velocidad del personaje
	private float speed = 50.0f;  // Reducimos la velocidad

	// Offset para calibrar el joystick (ej. los valores iniciales de 6 y -4)
	private int offsetX = -4;
	private int offsetY = 6;

	public override void _Ready()
	{
		// Inicializamos el puerto serial en COM5
		serialPort = new SerialPort("COM3", 9600);  // Ajustamos a COM5
		serialPort.Open();
	}

	public override void _Process(double delta)
	{
		if (serialPort.IsOpen)
		{
			try
			{
				// Leer los datos de la serial desde el Arduino
				string data = serialPort.ReadLine();  // Ejemplo de datos esperados: "Joystick: 100,-50 | Botones: 0,1,0,1"
				
				// Procesamos los datos para separar el joystick
				string[] parts = data.Split('|');
				if (parts.Length == 2)
				{
					// Parseamos los valores del joystick
					string[] joystickData = parts[0].Replace("Joystick: ", "").Split(',');
					joystickX = int.Parse(joystickData[0]) - offsetX;  // Aplicamos la corrección
					joystickY = int.Parse(joystickData[1]) - offsetY;  // Aplicamos la corrección

					// Invertimos el eje X
					joystickX *= -1;

					// Aseguramos que los valores cercanos a 0 se consideren como 0 para evitar movimientos pequeños
					if (Math.Abs(joystickX) < 10) joystickX = 0;
					if (Math.Abs(joystickY) < 10) joystickY = 0;
				}

				// Controlamos el movimiento del personaje según el joystick
				Vector2 movement = new Vector2(joystickX, joystickY);
				Velocity = movement.Normalized() * speed;  // Movimiento normalizado para que no sea diagonal más rápido
				MoveAndSlide();
			}
			catch (Exception ex)
			{
				GD.PrintErr(ex.Message);  // En caso de error de lectura
			}
		}
	}
}
