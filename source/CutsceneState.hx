package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxAccelerometer;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class CutsceneState extends FlxState
{
	var playButton:FlxButton;
	var cutsceneText:Array<String>;
	var page:Int;
	var text:FlxText;

	override public function create()
	{
		// add bg
		var bg = new FlxSprite(0, 0);
		bg.loadGraphic("assets/images/weigh.jpg");
		add(bg);

		// add button
		playButton = new FlxButton(850, 500, "Next", clickPlay);
		add(playButton);

		// add textbg
		var box = new FlxSprite(80, 380);
		box.makeGraphic(750, 140, 0x99FF0000);
		add(box);

		page = 0;
		cutsceneText = [
			"Anubis puts your heart onto the scale.",
			"It plummets like a rock.",
			"Anubis declares in booming voice, “The pharaoh Pepe, is hereby denounced to eternal punishment, soul fed to the Devourer of the Dead for his blatant misconduct during his time in the mortal realm.”",
			"Crying out in disbelief, you object, “How can this be, I was a brilliant ruler, I conquered new territories, I brought prosperity through trade, I was the greatest builder Egypt has ever se-”",
			"“SILENCE”, Anubis bellows. “I do not want to hear of your meaningless achievements. The scale is judgement.”",
			"“Please, just give me one more chance...”, you beg.",
			"Anubis smirks, “All those who seek a final chance at salvation are welcome to face my Trials of Redemption. May Osiris smile upon you, Pharaoh...”"
		];

		// add text
		text = new FlxText(100, 400, 730, cutsceneText[page], 22, true);
		text.setFormat("assets/fonts/roman.ttf", 22);
		add(text);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function clickPlay()
	{
		trace(cutsceneText.length);
		if (page < cutsceneText.length - 1)
		{
			page++;
			text.text = cutsceneText[page];
			if (page == cutsceneText.length - 1)
			{
				playButton.text = "Start Trials";
			}
		}
		else
		{
			FlxG.switchState(new PlayState());
		}
	}
}
