using Godot;
using System;
using System.IO.Ports;

public partial class Jugador2 : CharacterBody2D
{
	private float gravedad = 270f;
	private float velocidad = 100f;
	private float direccion = 0f;
	private float fuerzaSalto = 230f;
	private float fuerzaSegSalto = 200f;

	private AnimatedSprite2D animSprite;

	[Export] public PackedScene ataqueLaser;

	private Node _vidaGlobal; 
	private bool puedeAtacar = true;
	private bool puedeAtacarNormal = false;
	private int vidaPersonaje = 10;

	public override void _Ready()
	{
		_vidaGlobal = GetNode("/root/GestorVida");
		animSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
	}

	public override void _PhysicsProcess(double delta)
	{
		direccion = Input.GetAxis("ui_left", "ui_right");
		Velocity = new Vector2(direccion * velocidad, Velocity.Y + gravedad * (float)delta);

		if (direccion != 0 && IsOnFloor())
		{
			animSprite.Play("WALK");
		}
		else if (IsOnFloor())
		{
			animSprite.Play("IDLE");
		}
		else if (Velocity.Y < 0)
		{
			animSprite.Play("JUMP");
		}
		else if (Velocity.Y > 0)
		{
			animSprite.Play("FALL");
		}

		// Flip horizontal del sprite según la dirección
		if (direccion != 0)
		{
			animSprite.FlipH = direccion < 0; // Si la dirección es negativa (izquierda), el sprite se voltea
		}

		Jump();
		MoveAndSlide();
		GameOver();
	}

	private void Jump()
	{
		if (Input.IsActionJustPressed("jump") && IsOnFloor())
		{
			Velocity = new Vector2(Velocity.X, -fuerzaSalto);
		}
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("Ataque normal"))
		{
			AtaqueLaserNormal();
		}
	}

	private void AtaqueLaserNormal()
	{
		if (!puedeAtacar) return;

		puedeAtacar = false;
		animSprite.Play("ATTACK");

		var laserNormal = (Node2D)ataqueLaser.Instantiate();
		laserNormal.Position = Position;
		laserNormal.Call("SetDireccion", animSprite.FlipH);

		laserNormal.Connect("destruirLaser", new Callable(this, nameof(ActivarProyectil)));
		AddSibling(laserNormal);
	}

	private void ActivarProyectil()
	{
		puedeAtacar = true;
	}

	public void RecibirDano(int dano)
	{
		vidaPersonaje -= dano;
		animSprite.Play("DAMAGE");

		if (vidaPersonaje <= 0)
		{
			GameOver();
		}
	}

	private void GameOver()
	{
		if (vidaPersonaje <= 0)
		{
			animSprite.Play("GAMEOVER");
			QueueFree();
		}
	}
}
