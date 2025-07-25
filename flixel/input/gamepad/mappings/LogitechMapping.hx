package flixel.input.gamepad.mappings;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.id.LogitechID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;

class LogitechMapping extends FlxTypedGamepadMapping<LogitechID>
{
	#if FLX_JOYSTICK_API
	static inline final LEFT_ANALOG_STICK_FAKE_X = 20;
	static inline final LEFT_ANALOG_STICK_FAKE_Y = 21;

	static inline final RIGHT_ANALOG_STICK_FAKE_X = 22;
	static inline final RIGHT_ANALOG_STICK_FAKE_Y = 23;
	#end

	override function initValues():Void
	{
		leftStick = LogitechID.LEFT_ANALOG_STICK;
		rightStick = LogitechID.RIGHT_ANALOG_STICK;
	}

	override function getID(rawID:LogitechID):FlxGamepadInputID
	{
		return switch (rawID)
		{
			case LogitechID.TWO: A;
			case LogitechID.THREE: B;
			case LogitechID.ONE: X;
			case LogitechID.FOUR: Y;
			case LogitechID.NINE: BACK;
			case LogitechID.TEN: START;
			case LogitechID.LEFT_STICK_CLICK: LEFT_STICK_CLICK;
			case LogitechID.RIGHT_STICK_CLICK: RIGHT_STICK_CLICK;
			case LogitechID.FIVE: LEFT_SHOULDER;
			case LogitechID.SIX: RIGHT_SHOULDER;
			case LogitechID.SEVEN: LEFT_TRIGGER;
			case LogitechID.EIGHT: RIGHT_TRIGGER;
			case LogitechID.DPAD_DOWN: DPAD_DOWN;
			case LogitechID.DPAD_LEFT: DPAD_LEFT;
			case LogitechID.DPAD_RIGHT: DPAD_RIGHT;
			case LogitechID.DPAD_UP: DPAD_UP;
			case LogitechID.LOGITECH: GUIDE;
			case id if (id == leftStick.rawUp): LEFT_STICK_DIGITAL_UP;
			case id if (id == leftStick.rawDown): LEFT_STICK_DIGITAL_DOWN;
			case id if (id == leftStick.rawLeft): LEFT_STICK_DIGITAL_LEFT;
			case id if (id == leftStick.rawRight): LEFT_STICK_DIGITAL_RIGHT;
			case id if (id == rightStick.rawUp): RIGHT_STICK_DIGITAL_UP;
			case id if (id == rightStick.rawDown): RIGHT_STICK_DIGITAL_DOWN;
			case id if (id == rightStick.rawLeft): RIGHT_STICK_DIGITAL_LEFT;
			case id if (id == rightStick.rawRight): RIGHT_STICK_DIGITAL_RIGHT;
			case _: NONE;
		}
	}

	override function getRawID(ID:FlxGamepadInputID):LogitechID
	{
		return switch (ID)
		{
			case A: LogitechID.TWO;
			case B: LogitechID.THREE;
			case X: LogitechID.ONE;
			case Y: LogitechID.FOUR;
			case BACK: LogitechID.NINE;
			case GUIDE: LogitechID.LOGITECH;
			case START: LogitechID.TEN;
			case LEFT_STICK_CLICK: LogitechID.LEFT_STICK_CLICK;
			case RIGHT_STICK_CLICK: LogitechID.RIGHT_STICK_CLICK;
			case LEFT_SHOULDER: LogitechID.FIVE;
			case RIGHT_SHOULDER: LogitechID.SIX;
			case DPAD_UP: LogitechID.DPAD_UP;
			case DPAD_DOWN: LogitechID.DPAD_DOWN;
			case DPAD_LEFT: LogitechID.DPAD_LEFT;
			case DPAD_RIGHT: LogitechID.DPAD_RIGHT;
			case LEFT_TRIGGER: LogitechID.SEVEN;
			case RIGHT_TRIGGER: LogitechID.EIGHT;
			case LEFT_STICK_DIGITAL_UP: LogitechID.LEFT_ANALOG_STICK.rawUp;
			case LEFT_STICK_DIGITAL_DOWN: LogitechID.LEFT_ANALOG_STICK.rawDown;
			case LEFT_STICK_DIGITAL_LEFT: LogitechID.LEFT_ANALOG_STICK.rawLeft;
			case LEFT_STICK_DIGITAL_RIGHT: LogitechID.LEFT_ANALOG_STICK.rawRight;
			case RIGHT_STICK_DIGITAL_UP: LogitechID.RIGHT_ANALOG_STICK.rawUp;
			case RIGHT_STICK_DIGITAL_DOWN: LogitechID.RIGHT_ANALOG_STICK.rawDown;
			case RIGHT_STICK_DIGITAL_LEFT: LogitechID.RIGHT_ANALOG_STICK.rawLeft;
			case RIGHT_STICK_DIGITAL_RIGHT: LogitechID.RIGHT_ANALOG_STICK.rawRight;
			#if FLX_JOYSTICK_API
			case LEFT_TRIGGER_FAKE: LogitechID.SEVEN;
			case RIGHT_TRIGGER_FAKE: LogitechID.EIGHT;
			#end
			default: super.getRawID(ID);
		}
	}

	override function getMappedInput(id:FlxGamepadInputID)
	{
		return FlxGamepadMappedInput.LOGITECH(getRawID(id));
	}

	override function getInputLabel(id:FlxGamepadInputID)
	{
		return switch (id)
		{
			case A: "2";
			case B: "3";
			case X: "1";
			case Y: "4";
			case BACK: "9";
			case GUIDE: "logitech";
			case START: "10";
			case LEFT_SHOULDER: "5";
			case RIGHT_SHOULDER: "6";
			case LEFT_TRIGGER: "7";
			case RIGHT_TRIGGER: "8";
			#if FLX_JOYSTICK_API
			case LEFT_TRIGGER_FAKE: "7";
			case RIGHT_TRIGGER_FAKE: "8";
			#end
			default: super.getInputLabel(id);
		}
	}

	#if FLX_JOYSTICK_API
	override function axisIndexToRawID(axisID:LogitechID):Int
	{
		return if (axisID == leftStick.x) LEFT_ANALOG_STICK_FAKE_X; else if (axisID == leftStick.y) LEFT_ANALOG_STICK_FAKE_Y; else if (axisID == rightStick.x)
			RIGHT_ANALOG_STICK_FAKE_X;
		else if (axisID == rightStick.y)
			RIGHT_ANALOG_STICK_FAKE_Y;
		else
			axisID; // return what was passed in, no overlaps for other IDs
	}
	#end
}
