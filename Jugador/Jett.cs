using Godot;
using System;
using System.IO.Ports;

public partial class Player : CharacterBody2D
{
	[Export] public int Gravedad = 250;
	[Export] public int Velocidad = 120;
	[Export] public int MaxSaltos = 2;
	[Export] public int FuerzaSalto = 250;
	[Export] public int FuerzaSegSalto = 250;
	[Export] public PackedScene AtaqueNieve;
	[Export] public PackedScene AtaqueNormal;

	private float _direccion = 0.0f;
	private int _contSaltos = 0;
	private int _vidaPersonaje = 10;
	private bool _puedeAtacar = true;
	private bool _puedeAtacarNormal = true;

	private SerialPort _serialPort;
	private string _serialPortName = "COM12"; // Cambia si usas otro puerto
	private int _joystickX = 0;
	private int _joystickY = 0;
	private float _deadZone = 0.2f; // Zona muerta (ajusta según necesidad)
	private int _boton = 0; // Para guardar el número del botón presionado

	private Node _vidaGlobal; 
	private AnimatedSprite2D _anim; // Usamos AnimatedSprite2D
	private Sprite2D _sprite;

	public override void _Ready()
	{
		_vidaGlobal = GetNode("/root/GestorVida");
		_anim = GetNode<AnimatedSprite2D>("AnimationPlayer");
		_sprite = GetNode<Sprite2D>("playerSprite");

		_serialPort = new SerialPort(_serialPortName, 9600);
		try
		{
			_serialPort.Open();
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error abriendo el puerto {_serialPortName}: {e.Message}");
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		LeerDatosSerial();
		// Normaliza los datos del joystick y aplica la zona muerta
		if (Math.Abs(_joystickX) < _deadZone * 100) _joystickX = 0;
		if (Math.Abs(_joystickY) < _deadZone * 100) _joystickY = 0;
		
		_direccion = _joystickX / 100.0f; // Normaliza el eje X
		Velocity = new Vector2((float)(_direccion * Velocidad), (float)(Velocity.Y + Gravedad * delta));

		if (_direccion != 0 && IsOnFloor())
			//_anim.Play("correr");
		//else
			//_anim.Play("idel");

		// Flip horizontal del sprite según la dirección
		if (_direccion != 0)
		{
			//_sprite.FlipH = _direccion < 0; // Si la dirección es negativa (izquierda), el sprite se voltea
		}

		Jump();

		// Lógica de botones
		if (_boton == 6 && _contSaltos < MaxSaltos) // Botón 6 para saltar
		{
			Jump();
		}
		else if (_boton == 11 && _puedeAtacar) // Botón 11 para ataque especial
		{
			AtaqueEspecial();
		}
		else if (_boton == 10 && _puedeAtacarNormal) // Botón 10 para ataque normal
		{
			AtaqueNieveNormal();
		}

		MoveAndSlide();
		GameOver();
	}

	private void LeerDatosSerial()
	{
		if (_serialPort.IsOpen && _serialPort.BytesToRead > 0)
		{
			try
			{
				string data = _serialPort.ReadLine();
				string[] parts = data.Split(' ');

				if (parts.Length >= 2 && parts[0].StartsWith("Joystick:"))
				{
					string[] joystickData = parts[1].Split(',');
					_joystickX = int.Parse(joystickData[0]);
					_joystickY = int.Parse(joystickData[1]);
				}

				if (parts.Length >= 4 && parts[2].StartsWith("Boton:"))
				{
					_boton = int.Parse(parts[3]); // Guarda el número del botón
				}
			}
			catch (Exception e)
			{
				GD.PrintErr("Error leyendo datos del serial: ", e.Message);
			}
		}
	}

	private void Jump()
	{
		if (IsOnFloor())
			_contSaltos = 0;

		if (_contSaltos < MaxSaltos)
		{
			if (_boton == 6 && _contSaltos == 0 && IsOnFloor())
			{
				Velocity = new Vector2(Velocity.X, -FuerzaSalto);
				_contSaltos++;
			}
			else if (_boton == 6 && _contSaltos == 1)
			{
				Velocity = new Vector2(Velocity.X, 0);  // Detener el movimiento vertical
				Velocity = new Vector2(Velocity.X, -FuerzaSegSalto);
				_contSaltos++;
			}
		}

		Gravedad = (_boton == 6 && !IsOnFloor() && Velocity.Y > 0) ? 40 : 250;
	}

	private void AtaqueEspecial()
	{
		if (!_puedeAtacar) return;
		
		var newNieve = AtaqueNieve.Instantiate() as Node2D;
		newNieve.Position = Position;
		var ataqueNieve = (Node2D)newNieve;  // Aseguramos que laserNormal es de tipo Node2D
		ataqueNieve.Call("SetDireccion", _sprite.FlipH);
		AddSibling(newNieve);
		newNieve.Connect("ataque_desaparecido", new Callable(this, nameof(OnAtaqueDesaparecido)));
		_puedeAtacar = false;
	}

	public void OnAtaqueDesaparecido()
	{
		_puedeAtacar = true;
	}

	private void AtaqueNieveNormal()
	{
		if (!_puedeAtacarNormal) return;

		_puedeAtacarNormal = false;
		var nieveNormal = AtaqueNormal.Instantiate() as Node2D;
		nieveNormal.Position = Position;
		var ataque = (Node2D)nieveNormal;  // Aseguramos que laserNormal es de tipo Node2D
		ataque.Call("SetDireccion", _sprite.FlipH);
		nieveNormal.Connect("destruirNieve", new Callable(this, nameof(activarProyectil)));
		AddSibling(nieveNormal);
	}

	public void activarProyectil()
	{
		_puedeAtacarNormal = true;
	}

	private void GameOver()
	{
		if ((int)_vidaGlobal.Get("vidaActual") == 0)
			QueueFree();
	}
}
