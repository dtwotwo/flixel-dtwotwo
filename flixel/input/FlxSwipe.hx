package flixel.input;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxStringUtil;

@:allow(flixel.input.mouse.FlxMouseButton)
@:allow(flixel.input.touch.FlxTouch)
class FlxSwipe implements IFlxDestroyable
{
	/**
	 * Either LEFT_MOUSE, MIDDLE_MOUSE or RIGHT_MOUSE,
	 * or the touchPointID of a FlxTouch.
	 */
	public var ID(default, null):Int;

	public var startPosition(default, null):FlxPoint;
	public var endPosition(default, null):FlxPoint;

	public var distance(get, never):Float;
	public var degrees(get, never):Float;
	public var radians(get, never):Float;
	public var duration(get, never):Float;

	var _startTimeInTicks:Float;
	var _endTimeInTicks:Float;

	function new(ID:Int, StartPosition:FlxPoint, EndPosition:FlxPoint, StartTimeInTicks:Float)
	{
		this.ID = ID;
		startPosition = StartPosition;
		endPosition = EndPosition;
		_startTimeInTicks = StartTimeInTicks;
		_endTimeInTicks = FlxG.game.ticks;
	}

	public function destroy()
	{
		startPosition = FlxDestroyUtil.put(startPosition);
		endPosition = FlxDestroyUtil.put(endPosition);
	}

	inline function toString():String
	{
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("ID", ID),
			LabelValuePair.weak("start", startPosition),
			LabelValuePair.weak("end", endPosition),
			LabelValuePair.weak("distance", distance),
			LabelValuePair.weak("degrees", degrees),
			LabelValuePair.weak("duration", duration)
		]);
	}

	inline function get_distance():Float
	{
		return FlxMath.vectorLength(startPosition.x - endPosition.x, startPosition.y - endPosition.y);
	}

	inline function get_degrees():Float
	{
		return startPosition.degreesTo(endPosition);
	}

	inline function get_radians():Float
	{
		return startPosition.radiansTo(endPosition);
	}

	inline function get_duration():Float
	{
		return (_endTimeInTicks - _startTimeInTicks) * .001;
	}
}
