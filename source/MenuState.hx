package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var playButton:FlxButton;

	override public function create()
	{
		// add play button
		playButton = new FlxButton(0, 0, "Play", clickPlay);
		add(playButton);
		playButton.screenCenter();
		// add title
		var title = new FlxText(420, 200, 0, "The Trials of Anubis", 80, true);
		title.setFormat("assets/fonts/history.ttf", 80, 0xFFFFFFFF, "right", FlxTextBorderStyle.SHADOW, 0xFFFF0000);
		title.borderSize = 8;
		add(title);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function clickPlay()
	{
		FlxG.switchState(new CutsceneState());
	}
}
