package traps;

enum TriggerEvent
{
	Pressed;
	Released;
}

interface ITrap
{
	public function triggerEvent(event:TriggerEvent):Void;
}
