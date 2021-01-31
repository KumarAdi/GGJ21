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
	private var trapName:String;
	private var trapMap:Map<String, ITrap>;

	public var sprite:FlxExtendedSprite;

	private var outlineEffect:IFlxEffect;

	private var entities:Array<TriggerEntity>;

	public function new(x:Int, y:Int, trapName:String, trapMap:Map<String, ITrap>)
	{
		this.outlineEffect = new FlxOutlineEffect();
		this.sprite = new FlxExtendedSprite(x, y);

		super(this.sprite, [this.outlineEffect]);

		this.sprite.loadGraphic(AssetPaths.tiles__png, true, 60, 60);
		this.sprite.animation.add("normal", [51], 60, false);
		this.sprite.animation.add("pressed", [52], 60, false);
		this.sprite.animation.play("normal");

		this.entities = [];
		this.trapName = trapName;
		this.trapMap = trapMap;

		// I don't know why this is necessary
		this.x = x;
		this.y = y;
	}

	public function dispatch(event:TriggerEvent)
	{
		if (this.entities.length == 0)
		{
			var animationName = switch event
			{
				case Pressed:
					"pressed";
				case Released:
					"normal";
			};
			this.sprite.animation.play(animationName, true);
			this.trapMap[trapName].triggerEvent(event);
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

		if (entities.length > 0)
		{
			entities = entities.filter((entity) ->
			{
				var keep = switch (entity)
				{
					case Mouse:
						(FlxG.mouse.pressed && this.sprite.mouseOver);
					case Entity(sprite):
						FlxG.overlap(this, sprite);
				}

				return keep;
			});

			dispatch(Released);
		}

		super.update(dt);
	}
}
