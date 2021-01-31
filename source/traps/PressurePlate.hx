package traps;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.addons.effects.chainable.IFlxEffect;
import traps.ITrap.TriggerEvent;

enum TriggerEntity
{
	Mouse;
	Entity(sprite:FlxSprite);
}

class PressurePlate extends FlxEffectSprite
{
	private var trap:ITrap;

	public var sprite:FlxExtendedSprite;

	private var outlineEffect:IFlxEffect;

	private var entities:Array<TriggerEntity>;

	public function new(x:Int, y:Int, trap:ITrap)
	{
		this.outlineEffect = new FlxOutlineEffect();
		this.sprite = new FlxExtendedSprite(x, y);

		super(this.sprite, [this.outlineEffect]);

		this.sprite.loadGraphic("assets/tiled/tile_placeholder.png", true, 16, 16);
		this.sprite.animation.add("normal", [3], 60, true);
		this.sprite.animation.add("pressed", [2], 60, true);
		this.sprite.animation.play("normal");

		this.entities = [];
		this.trap = trap;

		// I don't know why this is necessary
		this.x = x;
		this.y = y;
	}

	public function dispatch(event:TriggerEvent)
	{
		if (this.entities.length == 0)
		{
			this.animation.play((event == Pressed) ? "pressed" : "normal", true);
			this.trap.triggerEvent(event);
		}
	}

	public function addEntity(entity:FlxSprite)
	{
		dispatch(Pressed);
		entities.push(Entity(entity));
	}

	override function update(dt:Float)
	{
		outlineEffect.active = this.sprite.mouseOver && !FlxG.mouse.pressed;

		if (this.sprite.mouseOver && FlxG.mouse.pressed)
		{
			dispatch(Pressed);
			this.entities.push(Mouse);
		}

		entities = entities.filter((entity) ->
		{
			switch (entity)
			{
				case Mouse:
					return (FlxG.mouse.pressed && this.sprite.mouseOver);
				case Entity(sprite):
					return FlxG.overlap(this, sprite);
			}
		});

		dispatch(Released);

		super.update(dt);
	}
}
