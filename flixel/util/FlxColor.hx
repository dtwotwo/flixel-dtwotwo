package flixel.util;

import flixel.math.FlxMath;
import flixel.system.macros.FlxMacroUtil;
import flixel.tweens.FlxEase;

/**
 * Class representing a color, based on Int. Provides a variety of methods for creating and converting colors.
 *
 * FlxColors can be written as Ints. This means you can pass a hex value such as
 * 0xff123456 to a function expecting a FlxColor, and it will automatically become a FlxColor "object".
 * Similarly, FlxColors may be treated as Ints.
 *
 * Note that when using properties of a FlxColor other than ARGB, the values are ultimately stored as
 * ARGB values, so repeatedly manipulating HSB/HSL/CMYK values may result in a gradual loss of precision.
 *
 * @author Joe Williamson (JoeCreates)
 */
abstract FlxColor(Int) from Int from UInt to Int to UInt
{
	public static inline final TRANSPARENT:FlxColor = 0x00000000;
	public static inline final WHITE:FlxColor = 0xFFFFFFFF;
	public static inline final GRAY:FlxColor = 0xFF808080;
	public static inline final BLACK:FlxColor = 0xFF000000;

	public static inline final GREEN:FlxColor = 0xFF008000;
	public static inline final LIME:FlxColor = 0xFF00FF00;
	public static inline final YELLOW:FlxColor = 0xFFFFFF00;
	public static inline final ORANGE:FlxColor = 0xFFFFA500;
	public static inline final RED:FlxColor = 0xFFFF0000;
	public static inline final PURPLE:FlxColor = 0xFF800080;
	public static inline final BLUE:FlxColor = 0xFF0000FF;
	public static inline final BROWN:FlxColor = 0xFF8B4513;
	public static inline final PINK:FlxColor = 0xFFFFC0CB;
	public static inline final MAGENTA:FlxColor = 0xFFFF00FF;
	public static inline final CYAN:FlxColor = 0xFF00FFFF;

	/**
	 * A `Map<String, Int>` whose values are the static colors of `FlxColor`.
	 * You can add more colors for `FlxColor.fromString(String)` if you need.
	 */
	public static var colorLookup(default, null):Map<String, Int> = FlxMacroUtil.buildMap("flixel.util.FlxColor");

	public var red(get, set):Int;
	public var blue(get, set):Int;
	public var green(get, set):Int;
	public var alpha(get, set):Int;

	public var redFast(get, set):Int;
	public var blueFast(get, set):Int;
	public var greenFast(get, set):Int;
	public var alphaFast(get, set):Int;

	public var redFloat(get, set):Float;
	public var blueFloat(get, set):Float;
	public var greenFloat(get, set):Float;
	public var alphaFloat(get, set):Float;

	public var cyan(get, set):Float;
	public var magenta(get, set):Float;
	public var yellow(get, set):Float;
	public var black(get, set):Float;

	/**
	 * The red, green and blue channels of this color as a 24 bit integer (from 0 to 0xFFFFFF)
	 */
	public var rgb(get, set):FlxColor;

	/**
	 * The hue of the color in degrees (from 0 to 359)
	 */
	public var hue(get, set):Float;

	/**
	 * The saturation of the color (from 0 to 1)
	 */
	public var saturation(get, set):Float;

	/**
	 * The brightness (aka value) of the color (from 0 to 1)
	 */
	public var brightness(get, set):Float;

	/**
	 * The lightness of the color (from 0 to 1)
	 */
	public var lightness(get, set):Float;

	/**
	 * The luminance, or "percieved brightness" of a color (from 0 to 1)
	 * RGB -> Luma calculation from https://www.w3.org/TR/AERT/#color-contrast
	 */
	public var luminance(get, never):Float;

	static final COLOR_REGEX = ~/^(0x|#)(([A-F0-9]{2}){3,4})$/i;

	/**
	 * Create a color from the least significant four bytes of an Int
	 *
	 * @param	Value And Int with bytes in the format 0xAARRGGBB
	 * @return	The color as a FlxColor
	 */
	public static inline function fromInt(Value:Int):FlxColor
	{
		return new FlxColor(Value);
	}

	/**
	 * Generate a color from integer RGB values (0 to 255)
	 *
	 * @param Red	The red value of the color from 0 to 255
	 * @param Green	The green value of the color from 0 to 255
	 * @param Blue	The green value of the color from 0 to 255
	 * @param Alpha	How opaque the color should be, from 0 to 255
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):FlxColor
	{
		var color = new FlxColor();
		return color.setRGB(Red, Green, Blue, Alpha);
	}

	/**
	 * Generate a color from an array of integer RGB values (0 to 255)
	 * @param Array The array of RGB values, each value should be from 0 to 255
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromRGB(Array:Array<Int>):FlxColor
	{
		var color = new FlxColor();
		return color.setRGB(Array[0], Array[1], Array[2], 255);
	}

	/**
	 * Generate a color from an array of integer RGB values (0 to 255)
	 * @param Array The array of RGB values, each value should be from 0 to 255
	 * @param Alpha How opaque the color should be, from 0 to 255
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromRGB(Array:Array<Int>, Alpha:Int = 255):FlxColor
	{
		var color = new FlxColor();
		return color.setRGB(Array[0], Array[1], Array[2], Alpha);
	}

	public static inline function fromRGBFast(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):FlxColor
	{
		var color = new FlxColor();
		return color.setRGBFast(Red, Green, Blue, Alpha);
	}

	public static inline function fromRGBUnsafe(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):FlxColor
	{
		var color = new FlxColor();
		return color.setRGBUnsafe(Red, Green, Blue, Alpha);
	}

	/**
	 * Generate a color from float RGB values (0 to 1)
	 *
	 * @param Red	The red value of the color from 0 to 1
	 * @param Green	The green value of the color from 0 to 1
	 * @param Blue	The green value of the color from 0 to 1
	 * @param Alpha	How opaque the color should be, from 0 to 1
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setRGBFloat(Red, Green, Blue, Alpha);
	}

	/**
	 * Generate a color from an array of float RGB values (0 to 1)
	 * @param Array The array of RGB values, each value should be from 0 to 1
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromRGBFloat(Array:Array<Float>):FlxColor
	{
		var color = new FlxColor();
		return color.setRGBFloat(Array[0], Array[1], Array[2], Array[3]);
	}

	/**
	 * Generate a color from an array of float RGB values (0 to 1)
	 * @param Array The array of RGB values, each value should be from 0 to 1
	 * @param Alpha How opaque the color should be, from 0 to 1
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromRGBFloat(Array:Array<Float>, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setRGBFloat(Array[0], Array[1], Array[2], Alpha);
	}

	/**
	 * Generate a color from CMYK values (0 to 1)
	 *
	 * @param Cyan		The cyan value of the color from 0 to 1
	 * @param Magenta	The magenta value of the color from 0 to 1
	 * @param Yellow	The yellow value of the color from 0 to 1
	 * @param Black		The black value of the color from 0 to 1
	 * @param Alpha		How opaque the color should be, from 0 to 1
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}

	/**
	 * Generate a color from an array of CMYK values (0 to 1)
	 * @param Array The array of CMYK, each value should be from 0 to 1
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromCMYK(Array:Array<Float>):FlxColor
	{
		var color = new FlxColor();
		return color.setCMYK(Array[0], Array[1], Array[2], Array[3], Array[4]);
	}

	/**
	 * Generate a color from an array of CMYK values (0 to 1)
	 * @param Array The array of CMYK, each value should be from 0 to 1
	 * @param Alpha How opaque the color should be, from 0 to 1
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromCMYK(Array:Array<Float>, Alpha:Float):FlxColor
	{
		var color = new FlxColor();
		return color.setCMYK(Array[0], Array[1], Array[2], Array[3], Alpha);
	}

	/**
	 * Generate a color from HSB (aka HSV) components.
	 *
	 * @param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
	 * @param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
	 * @param	Brightness	(aka Value) A number between 0 and 1, indicating how bright the color should be.  0 is black, 1 is full bright.
	 * @param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255.
	 * @return	The color as a FlxColor
	 */
	overload extern public static inline function fromHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setHSB(Hue, Saturation, Brightness, Alpha);
	}

	/**
	 * Generate a color from an array of HSB (aka HSV) components.
	 * @param Array The array of HSB values
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromHSB(Array:Array<Float>):FlxColor
	{
		var color = new FlxColor();
		return color.setHSB(Array[0], Array[1], Array[2], Array[3]);
	}

	/**
	 * Generate a color from an array of HSB (aka HSV) components.
	 * @param Array The array of HSB values
	 * @param Alpha How opaque the color should be, either between 0 and 1 or 0 and 255.
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromHSB(Array:Array<Float>, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setHSB(Array[0], Array[1], Array[2], Alpha);
	}

	/**
	 * Generate a color from HSL components.
	 *
	 * @param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
	 * @param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
	 * @param	Lightness	A number between 0 and 1, indicating the lightness of the color
	 * @param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255.
	 * @return	The color as a FlxColor
	 */
	overload extern public static inline function fromHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setHSL(Hue, Saturation, Lightness, Alpha);
	}

	/**
	 * Generate a color from HSL components.
	 * @param Array The array of HSL values.
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromHSL(Array:Array<Float>):FlxColor
	{
		var color = new FlxColor();
		return color.setHSL(Array[0], Array[1], Array[2], Array[3]);
	}

	/**
	 * Generate a color from HSL components.
	 * @param Array The array of HSL values.
	 * @param Alpha How opaque the color should be, either between 0 and 1 or 0 and 255.
	 * @return The color as a FlxColor
	 */
	overload extern public static inline function fromHSL(Array:Array<Float>, Alpha:Float = 1):FlxColor
	{
		var color = new FlxColor();
		return color.setHSL(Array[0], Array[1], Array[2], Alpha);
	}

	/**
	 * Parses a `String` and returns a `FlxColor` or `null` if the `String` couldn't be parsed.
	 *
	 * Examples (input -> output in hex):
	 *
	 * - `0x00FF00`    -> `0xFF00FF00`
	 * - `0xAA4578C2`  -> `0xAA4578C2`
	 * - `#0000FF`     -> `0xFF0000FF`
	 * - `#3F000011`   -> `0x3F000011`
	 * - `GRAY`        -> `0xFF808080`
	 * - `blue`        -> `0xFF0000FF`
	 *
	 * @param	str 	The string to be parsed
	 * @return	A `FlxColor` or `null` if the `String` couldn't be parsed
	 */
	public static function fromString(str:String):Null<FlxColor>
	{
		var result:Null<FlxColor> = null;
		str = StringTools.trim(str);

		if (COLOR_REGEX.match(str))
		{
			final hexColor:String = "0x" + COLOR_REGEX.matched(2);
			result = new FlxColor(Std.parseInt(hexColor));
			if (hexColor.length == 8)
				result.alphaFloat = 1;
		}
		else
		{
			str = str.toUpperCase();
			if (colorLookup.exists(str)) result = new FlxColor(colorLookup.get(str)); // for better result checking

			for (key in colorLookup.keys())
			{
				if (key.toUpperCase() == str)
				{
					result = new FlxColor(colorLookup.get(key));
					break;
				}
			}
		}

		return result;
	}

	/**
	 * Get HSB color wheel values in an array which will be 360 elements in size
	 *
	 * @param	Alpha Alpha value for each color of the color wheel, between 0 (transparent) and 255 (opaque)
	 * @return	HSB color wheel as Array of FlxColors
	 */
	public static function getHSBColorWheel(Alpha:Int = 255):Array<FlxColor>
	{
		return [for (c in 0...360) fromHSB(c, 1.0, 1.0, Alpha)];
	}

	/**
	 * Get an interpolated color based on two different colors.
	 *
	 * @param 	Color1 The first color
	 * @param 	Color2 The second color
	 * @param 	Factor Value from 0 to 1 representing how much to shift Color1 toward Color2
	 * @return	The interpolated color
	 */
	public static inline function interpolate(Color1:FlxColor, Color2:FlxColor, Factor:Float = 0.5):FlxColor
	{
		final r:Int = Std.int((Color2.red - Color1.red) * Factor + Color1.red);
		final g:Int = Std.int((Color2.green - Color1.green) * Factor + Color1.green);
		final b:Int = Std.int((Color2.blue - Color1.blue) * Factor + Color1.blue);
		final a:Int = Std.int((Color2.alpha - Color1.alpha) * Factor + Color1.alpha);

		return fromRGB(r, g, b, a);
	}

	/**
	 * Create a gradient from one color to another
	 *
	 * @param Color1 The color to shift from
	 * @param Color2 The color to shift to
	 * @param Steps How many colors the gradient should have
	 * @param Ease An optional easing function, such as those provided in FlxEase
	 * @return An array of colors of length Steps, shifting from Color1 to Color2
	 */
	public static function gradient(Color1:FlxColor, Color2:FlxColor, Steps:Int, ?Ease:EaseFunction):Array<FlxColor>
	{
		final output:Array<FlxColor> = [];

		if (Ease == null)
			Ease = FlxEase.linear;

		for (step in 0...Steps)
			output[step] = interpolate(Color1, Color2, Ease(step / (Steps - 1)));

		return output;
	}

	/**
	 * Divide the RGB channels of two FlxColors
	 */
	@:op(A / B)
	public static inline function divide(lhs:FlxColor, rhs:FlxColor):FlxColor
	{
		return FlxColor.fromRGBFloat(lhs.redFloat / rhs.redFloat, lhs.greenFloat / rhs.greenFloat, lhs.blueFloat / rhs.blueFloat);
	}

	/**
	 * Multiply the RGB channels of two FlxColors
	 */
	@:op(A * B)
	public static inline function multiply(lhs:FlxColor, rhs:FlxColor):FlxColor
	{
		return FlxColor.fromRGBFloat(lhs.redFloat * rhs.redFloat, lhs.greenFloat * rhs.greenFloat, lhs.blueFloat * rhs.blueFloat);
	}

	/**
	 * Add the RGB channels of two FlxColors
	 */
	@:op(A + B)
	public static inline function add(lhs:FlxColor, rhs:FlxColor):FlxColor
	{
		return FlxColor.fromRGB(lhs.red + rhs.red, lhs.green + rhs.green, lhs.blue + rhs.blue);
	}

	/**
	 * Subtract the RGB channels of one FlxColor from another
	 */
	@:op(A - B)
	public static inline function subtract(lhs:FlxColor, rhs:FlxColor):FlxColor
	{
		return FlxColor.fromRGB(lhs.red - rhs.red, lhs.green - rhs.green, lhs.blue - rhs.blue);
	}

	/**
	 * Returns a Complementary Color Harmony of this color.
	 * A complementary hue is one directly opposite the color given on the color wheel
	 *
	 * @return	The complimentary color
	 */
	public inline function getComplementHarmony():FlxColor
	{
		return fromHSB(FlxMath.wrapMax(Std.int(hue) + 180, 350), brightness, saturation, alphaFloat);
	}

	/**
	 * Returns an Analogous Color Harmony for the given color.
	 * An Analogous harmony are hues adjacent to each other on the color wheel
	 *
	 * @param	Threshold Control how adjacent the colors will be (default +- 30 degrees)
	 * @return 	Object containing 3 properties: original (the original color), warmer (the warmer analogous color) and colder (the colder analogous color)
	 */
	public inline function getAnalogousHarmony(Threshold:Int = 30):Harmony
	{
		final warmer:Int = fromHSB(FlxMath.wrapMax(Std.int(hue) - Threshold, 350), saturation, brightness, alphaFloat);
		final colder:Int = fromHSB(FlxMath.wrapMax(Std.int(hue) + Threshold, 350), saturation, brightness, alphaFloat);

		return {original: this, warmer: warmer, colder: colder};
	}

	/**
	 * Returns an Split Complement Color Harmony for this color.
	 * A Split Complement harmony are the two hues on either side of the color's Complement
	 *
	 * @param	Threshold Control how adjacent the colors will be to the Complement (default +- 30 degrees)
	 * @return 	Object containing 3 properties: original (the original color), warmer (the warmer analogous color) and colder (the colder analogous color)
	 */
	public inline function getSplitComplementHarmony(Threshold:Int = 30):Harmony
	{
		final oppositeHue:Int = FlxMath.wrapMax(Std.int(hue) + 180, 350);
		final warmer:FlxColor = fromHSB(FlxMath.wrapMax(oppositeHue - Threshold, 350), saturation, brightness, alphaFloat);
		final colder:FlxColor = fromHSB(FlxMath.wrapMax(oppositeHue + Threshold, 350), saturation, brightness, alphaFloat);

		return {original: this, warmer: warmer, colder: colder};
	}

	/**
	 * Returns a Triadic Color Harmony for this color. A Triadic harmony are 3 hues equidistant
	 * from each other on the color wheel.
	 *
	 * @return 	Object containing 3 properties: color1 (the original color), color2 and color3 (the equidistant colors)
	 */
	public inline function getTriadicHarmony():TriadicHarmony
	{
		final triadic1:FlxColor = fromHSB(FlxMath.wrapMax(Std.int(hue) + 120, 359), saturation, brightness, alphaFloat);
		final triadic2:FlxColor = fromHSB(FlxMath.wrapMax(Std.int(triadic1.hue) + 120, 359), saturation, brightness, alphaFloat);

		return {color1: this, color2: triadic1, color3: triadic2};
	}

	/**
	 * Return a String representation of the color in the format
	 *
	 * @param Alpha Whether to include the alpha value in the hex string
	 * @param Prefix Whether to include "0x" prefix at start of string
	 * @return	A string of length 10 in the format 0xAARRGGBB
	 */
	public inline function toHexString(Alpha:Bool = true, Prefix:Bool = true):String
	{
		return (Prefix ? "0x" : "") + (Alpha ? StringTools.hex(alpha, 2) : "") + StringTools.hex(red, 2) + StringTools.hex(green, 2) + StringTools.hex(blue, 2);
	}

	/**
	 * Return a String representation of the color in the format #RRGGBB
	 *
	 * @return	A string of length 7 in the format #RRGGBB
	 */
	public inline function toWebString():String
	{
		return "#" + toHexString(false, false);
	}

	/**
	 * Get a string of color information about this color
	 *
	 * @return A string containing information about this color
	 */
	public function getColorInfo():String
	{
		// Hex format
		var result:String = toHexString() + "\n";
		// RGB format
		result += "Alpha: " + alpha + " Red: " + red + " Green: " + green + " Blue: " + blue + "\n";
		// HSB/HSL info
		result += "Hue: " + FlxMath.roundDecimal(hue, 2) + " Saturation: " + FlxMath.roundDecimal(saturation, 2) + " Brightness: "
			+ FlxMath.roundDecimal(brightness, 2) + " Lightness: " + FlxMath.roundDecimal(lightness, 2);

		return result;
	}

	/**
	 * Get a darkened version of this color
	 *
	 * @param	Factor Value from 0 to 1 of how much to progress toward black.
	 * @return 	A darkened version of this color
	 */
	public function getDarkened(Factor:Float = 0.2):FlxColor
	{
		Factor = FlxMath.bound(Factor, 0, 1);
		var output:FlxColor = this;
		output.lightness = output.lightness * (1 - Factor);
		return output;
	}

	/**
	 * Get a lightened version of this color
	 *
	 * @param	Factor Value from 0 to 1 of how much to progress toward white.
	 * @return 	A lightened version of this color
	 */
	public inline function getLightened(Factor:Float = 0.2):FlxColor
	{
		Factor = FlxMath.bound(Factor, 0, 1);
		var output:FlxColor = this;
		output.lightness = output.lightness + (1 - lightness) * Factor;
		return output;
	}

	/**
	 * Get the inversion of this color
	 *
	 * @return The inversion of this color
	 */
	public inline function getInverted():FlxColor
	{
		final oldAlpha = alpha;
		var output:FlxColor = FlxColor.WHITE - this;
		output.alpha = oldAlpha;
		return output;
	}

	/**
	 * Set RGB values as integers (0 to 255)
	 *
	 * @param Red	The red value of the color from 0 to 255
	 * @param Green	The green value of the color from 0 to 255
	 * @param Blue	The green value of the color from 0 to 255
	 * @param Alpha	How opaque the color should be, from 0 to 255
	 * @return This color
	 */
	public inline function setRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):FlxColor
	{
		this = (boundChannel(Red) & 0xFF) << 16 | (boundChannel(Green) & 0xFF) << 8 | (boundChannel(Blue) & 0xFF) | (boundChannel(Alpha) & 0xFF) << 24;
		// red = Red;
		// green = Green;
		// blue = Blue;
		// alpha = Alpha;
		return this;
	}

	public inline function setRGBFast(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):FlxColor
	{
		this = (Red & 0xFF) << 16 | (Green & 0xFF) << 8 | (Blue & 0xFF) | (Alpha & 0xFF) << 24;
		// red = Red;
		// green = Green;
		// blue = Blue;
		// alpha = Alpha;
		return this;
	}

	public inline function setRGBUnsafe(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):FlxColor
	{
		this = (Red) << 16 | (Green) << 8 | (Blue) | (Alpha) << 24;
		// red = Red;
		// green = Green;
		// blue = Blue;
		// alpha = Alpha;
		return this;
	}

	/**
	 * Set RGB values as floats (0 to 1)
	 *
	 * @param Red	The red value of the color from 0 to 1
	 * @param Green	The green value of the color from 0 to 1
	 * @param Blue	The green value of the color from 0 to 1
	 * @param Alpha	How opaque the color should be, from 0 to 1
	 * @return This color
	 */
	public inline function setRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):FlxColor
	{
		this = setRGB(Std.int(Red * 255), Std.int(Green * 255), Std.int(Blue * 255), Std.int(Alpha * 255));
		// redFloat = Red;
		// greenFloat = Green;
		// blueFloat = Blue;
		// alphaFloat = Alpha;
		return this;
	}

	/**
	 * Set CMYK values as floats (0 to 1)
	 *
	 * @param Cyan		The cyan value of the color from 0 to 1
	 * @param Magenta	The magenta value of the color from 0 to 1
	 * @param Yellow	The yellow value of the color from 0 to 1
	 * @param Black		The black value of the color from 0 to 1
	 * @param Alpha		How opaque the color should be, from 0 to 1
	 * @return This color
	 */
	public inline function setCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):FlxColor
	{
		redFloat = (1 - Cyan) * (1 - Black);
		greenFloat = (1 - Magenta) * (1 - Black);
		blueFloat = (1 - Yellow) * (1 - Black);
		alphaFloat = Alpha;
		return this;
	}

	/**
	 * Set HSB (aka HSV) components
	 *
	 * @param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
	 * @param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
	 * @param	Brightness	(aka Value) A number between 0 and 1, indicating how bright the color should be.  0 is black, 1 is full bright.
	 * @param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255.
	 * @return	This color
	 */
	public inline function setHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha = 1.):FlxColor
	{
		final chroma = Brightness * Saturation;
		final match = Brightness - chroma;
		return setHueChromaMatch(Hue, chroma, match, Alpha);
	}

	/**
	 * Set HSL components.
	 *
	 * @param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
	 * @param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
	 * @param	Lightness	A number between 0 and 1, indicating the lightness of the color
	 * @param	Alpha		How opaque the color should be, either between 0 and 1 or 0 and 255
	 * @return	This color
	 */
	public inline function setHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha = 1.):FlxColor
	{
		final chroma = (1 - Math.abs(2 * Lightness - 1)) * Saturation;
		final match = Lightness - chroma * .5;
		return setHueChromaMatch(Hue, chroma, match, Alpha);
	}

	/**
	 * Private utility function to perform common operations between setHSB and setHSL
	 */
	inline function setHueChromaMatch(Hue:Float, Chroma:Float, Match:Float, Alpha:Float):FlxColor
	{
		Hue = FlxMath.mod(Hue, 360);
		final hueD = Hue / 60;
		final mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + Match;
		Chroma += Match;

		switch (Std.int(hueD))
		{
			case 0:
				setRGBFloat(Chroma, mid, Match, Alpha);
			case 1:
				setRGBFloat(mid, Chroma, Match, Alpha);
			case 2:
				setRGBFloat(Match, Chroma, mid, Alpha);
			case 3:
				setRGBFloat(Match, mid, Chroma, Alpha);
			case 4:
				setRGBFloat(mid, Match, Chroma, Alpha);
			case 5:
				setRGBFloat(Chroma, Match, mid, Alpha);
		}

		return this;
	}

	public function new(Value:Int = 0)
	{
		this = Value;
	}

	inline function getThis():Int
	{
		return this;
	}

	inline function get_red():Int
	{
		return (getThis() >> 16) & 0xff;
	}

	inline function get_redFast():Int
	{
		return (getThis() >> 16) & 0xFF;
	}

	inline function get_green():Int
	{
		return (getThis() >> 8) & 0xff;
	}

	inline function get_greenFast():Int
	{
		return (getThis() >> 8) & 0xFF;
	}

	inline function get_blue():Int
	{
		return getThis() & 0xff;
	}

	inline function get_blueFast():Int
	{
		return getThis() & 0xFF;
	}

	inline function get_alpha():Int
	{
		return (getThis() >> 24) & 0xff;
	}

	inline function get_alphaFast():Int
	{
		return (getThis() >> 24) & 0xFF;
	}

	inline function get_redFloat():Float
	{
		return red / 255;
	}

	inline function get_greenFloat():Float
	{
		return green / 255;
	}

	inline function get_blueFloat():Float
	{
		return blue / 255;
	}

	inline function get_alphaFloat():Float
	{
		return alpha / 255;
	}

	inline function set_red(Value:Int):Int
	{
		this = (this & 0xFF00FFFF) | (boundChannel(Value)) << 16;
		return Value;
	}

	inline function set_green(Value:Int):Int
	{
		this = (this & 0xFFFF00FF) | (boundChannel(Value)) << 8;
		return Value;
	}

	inline function set_blue(Value:Int):Int
	{
		this = (this & 0xFFFFFF00) | (boundChannel(Value));
		return Value;
	}

	inline function set_alpha(Value:Int):Int
	{
		this = (this & 0x00FFFFFF) | (boundChannel(Value)) << 24;
		return Value;
	}

	inline function set_redFast(Value:Int):Int
	{
		this = (this & 0xFF00FFFF) | ((Value & 0xFF)) << 16;
		return Value;
	}

	inline function set_greenFast(Value:Int):Int
	{
		this = (this & 0xFFFF00FF) | ((Value & 0xFF) << 8);
		return Value;
	}

	inline function set_blueFast(Value:Int):Int
	{
		this = (this & 0xFFFFFF00) | ((Value & 0xFF));
		return Value;
	}

	inline function set_alphaFast(Value:Int):Int
	{
		this = (this & 0xFF000000) | ((Value & 0xFF) << 24);
		return Value;
	}

	inline function set_redFloat(Value:Float):Float
	{
		red = Math.round(Value * 255);
		return Value;
	}

	inline function set_greenFloat(Value:Float):Float
	{
		green = Math.round(Value * 255);
		return Value;
	}

	inline function set_blueFloat(Value:Float):Float
	{
		blue = Math.round(Value * 255);
		return Value;
	}

	inline function set_alphaFloat(Value:Float):Float
	{
		alpha = Math.round(Value * 255);
		return Value;
	}

	inline function get_cyan():Float
	{
		final r = redFloat;
		final g = greenFloat;
		final b = blueFloat;
		final bri = Math.max(r, Math.max(g, b));
		final blck = 1 - bri;
		return (1 - r - blck) / bri;
	}

	inline function get_magenta():Float
	{
		final r = redFloat;
		final g = greenFloat;
		final b = blueFloat;
		final bri = Math.max(r, Math.max(g, b));
		final blck = 1 - bri;
		return (1 - g - blck) / bri;
	}

	inline function get_yellow():Float
	{
		final r = redFloat;
		final g = greenFloat;
		final b = blueFloat;
		final bri = Math.max(r, Math.max(g, b));
		final blck = 1 - bri;
		return (1 - b - blck) / bri;
	}

	inline function get_black():Float
	{
		return 1 - brightness;
	}

	inline function set_cyan(Value:Float):Float
	{
		setCMYK(Value, magenta, yellow, black, alphaFloat);
		return Value;
	}

	inline function set_magenta(Value:Float):Float
	{
		setCMYK(cyan, Value, yellow, black, alphaFloat);
		return Value;
	}

	inline function set_yellow(Value:Float):Float
	{
		setCMYK(cyan, magenta, Value, black, alphaFloat);
		return Value;
	}

	inline function set_black(Value:Float):Float
	{
		setCMYK(cyan, magenta, yellow, Value, alphaFloat);
		return Value;
	}

	function get_hue():Float
	{
		final r = redFloat;
		final g = greenFloat;
		final b = blueFloat;

		final max = Math.max(r, Math.max(g, b));
		final min = Math.min(r, Math.min(g, b));

		var h:Float = 0;

		if (max != min) {
			final d = max - min;
			if (max == r)
				h = (g - b) / d + (g < b ? 6 : 0);
			else if (max == g)
				h = (b - r) / d + 2;
			else if (max == b)
				h = (r - g) / d + 4;
			h /= 6;
		}

		return h * 360;
	}

	// old version of get_hue(), inaccurate and slow
	function get_hueOld():Float
	{
		// 1.7320508075688772 = Math.sqrt(3)
		final hueRad = Math.atan2(1.7320508075688772 * (greenFloat - blueFloat), 2 * redFloat - greenFloat - blueFloat);
		final hue = (hueRad != 0) ? flixel.math.FlxAngle.TO_DEG * hueRad : 0;
		return hue < 0 ? hue + 360 : hue;
	}

	inline function get_brightness():Float
	{
		return maxColor();
	}

	inline function get_luminance():Float
	{
		return (redFloat * 299 + greenFloat * 587 + blueFloat * 114) * .001;
	}

	inline function get_saturation():Float
	{
		final r = redFloat;
		final g = greenFloat;
		final b = blueFloat;
		final max = Math.max(r, Math.max(g, b));
		final min = Math.min(r, Math.min(g, b));
		return (max - min) / max;
	}

	inline function get_lightness():Float
	{
		final r = redFloat;
		final g = greenFloat;
		final b = blueFloat;
		final max = Math.max(r, Math.max(g, b));
		final min = Math.min(r, Math.min(g, b));
		return (max + min) * .5;
	}

	inline function set_hue(Value:Float):Float
	{
		setHSB(Value, saturation, brightness, alphaFloat);
		return Value;
	}

	inline function set_saturation(Value:Float):Float
	{
		setHSB(hue, Value, brightness, alphaFloat);
		return Value;
	}

	inline function set_brightness(Value:Float):Float
	{
		setHSB(hue, saturation, Value, alphaFloat);
		return Value;
	}

	inline function set_lightness(Value:Float):Float
	{
		setHSL(hue, saturation, Value, alphaFloat);
		return Value;
	}

	inline function set_rgb(value:FlxColor):FlxColor
	{
		this = (this & 0xff000000) | (value & 0x00ffffff);
		return value;
	}

	inline function get_rgb():FlxColor
	{
		return this & 0x00ffffff;
	}

	inline function maxColor():Float
	{
		return Math.max(redFloat, Math.max(greenFloat, blueFloat));
	}

	inline function minColor():Float
	{
		return Math.min(redFloat, Math.min(greenFloat, blueFloat));
	}

	inline function boundChannel(Value:Int):Int
	{
		#if cpp
		final v:Int = Value;
		return untyped __cpp__("((({0}) > 0xff) ? 0xff : (({0}) < 0) ? 0 : ({0}))", v);
		#else
		return Value > 0xff ? 0xff : Value < 0 ? 0 : Value;
		#end
	}
}

typedef Harmony =
{
	original:FlxColor,
	warmer:FlxColor,
	colder:FlxColor
}

typedef TriadicHarmony =
{
	color1:FlxColor,
	color2:FlxColor,
	color3:FlxColor
}
