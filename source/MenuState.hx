package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var playButton:FlxButton;
	var title:FlxText;

	override public function create()
	{
		playButton = new FlxButton(0, 0, "Play", clickPlay);
		add(playButton);
		playButton.screenCenter();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}
