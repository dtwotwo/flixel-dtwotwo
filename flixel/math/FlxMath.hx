package flixel.math;

import openfl.geom.Rectangle;
#if !macro
#if FLX_MOUSE
import flixel.FlxG;
#end
import flixel.FlxSprite;
#if FLX_TOUCH
import flixel.input.touch.FlxTouch;
#end
#end

/**
 * A class containing a set of math-related functions.
 */
class FlxMath
{
	/**
	 * Minimum value of a floating point number.
	 */
	public static inline final MIN_VALUE_FLOAT:Float = #if (flash || js || ios || blackberry) 0.0000000000000001 #else 5e-324 #end;

	/**
	 * Maximum value of a floating point number.
	 */
	public static inline final MAX_VALUE_FLOAT:Float = 1.79e+308;

	/**
	 * Minimum value of an integer.
	 */
	public static inline final MIN_VALUE_INT:Int = -MAX_VALUE_INT;

	/**
	 * Maximum value of an integer.
	 */
	public static inline final MAX_VALUE_INT:Int = 0x7FFFFFFF;

	/**
	 * Approximation of `Math.sqrt(2)`.
	 */
	public static inline final SQUARE_ROOT_OF_TWO:Float = 1.41421356237;

	/**
	 * Used to account for floating-point inaccuracies.
	 */
	public static inline final EPSILON:Float = 0.0000001;

	/**
	 * Round a decimal number to have reduced precision (less decimal numbers).
	 *
	 * ```haxe
	 * roundDecimal(1.2485, 2) = 1.25
	 * ```
	 *
	 * @param	Value		Any number.
	 * @param	Precision	Number of decimals the result should have.
	 * @return	The rounded value of that number.
	 */
	public static function roundDecimal(Value:Float, Precision:Int):Float
	{
		var mult = 1.;
		for (i in 0...Precision) mult *= 10;
		return Math.fround(Value * mult) / mult;
	}

	/**
	 * Bound a number by a minimum and maximum. Ensures that this number is
	 * no smaller than the minimum, and no larger than the maximum.
	 * Leaving a bound `null` means that side is unbounded.
	 *
	 * @param	Value	Any number.
	 * @param	Min		Any number.
	 * @param	Max		Any number.
	 * @return	The bounded value of the number.
	 */
	public static inline function bound(Value:Float, ?Min:Float, ?Max:Float):Float
	{
		final lowerBound:Float = (Min != null && Value < Min) ? Min : Value;
		return (Max != null && lowerBound > Max) ? Max : lowerBound;
	}

	/**
	 * Bound a integer by a minimum and maximum. Ensures that this integer is
	 * no smaller than the minimum, and no larger than the maximum.
	 * Leaving a bound `null` means that side is unbounded.
	 *
	 * @param	Value	Any integer.
	 * @param	Min		Any integer.
	 * @param	Max		Any integer.
	 * @return	The bounded value of the integer.
	 */
	public static inline function boundInt(Value:Int, ?Min:Int, ?Max:Int):Int
	{
		final lowerBound:Int = (Min != null && Value < Min) ? Min : Value;
		return (Max != null && lowerBound > Max) ? Max : lowerBound;
	}

	/**
	 * Returns the linear interpolation of two numbers if `ratio`
	 * is between 0 and 1, and the linear extrapolation otherwise.
	 *
	 * Examples:
	 *
	 * ```haxe
	 * lerp(a, b, 0) = a
	 * lerp(a, b, 1) = b
	 * lerp(5, 15, 0.5) = 10
	 * lerp(5, 15, -1) = -5
	 * ```
	 */
	public static inline function lerp(a:Float, b:Float, ratio:Float):Float
	{
		return a + ratio * (b - a);
	}

	/**
	 * Adjusts the lerp value to be frame rate independent.
	 * Multiplies the provided lerp value by the elapsed time adjusted to a 60 FPS base.
	 * 
	 * @param lerp The original lerp value.
	 */
	public static inline function cameraLerp(lerp:Float):Float
	{
		// multiply the lerp value by the elapsed time scaled to 60 FPS
		return lerp * (FlxG.elapsed * 60); // 1 / 60
	}

	/**
	 * Calculates the difference between two values based on a ratio.
	 * @param base The base value.
	 * @param target The target value.
	 * @param ratio The ratio to use for the calculation.
	 */
	public static inline function lerpDelta(base:Float, target:Float, ratio:Float):Float
	{
		return base + cameraLerp(ratio) * (target - base);
	}

	/**
	 * Adjusts the given lerp to account for the time that has passed
	 * 
	 * @param   lerp     The ratio to lerp in 1/60th of a second
	 * @param   elapsed  The amount of time that has actually passed
	 * @since 6.0.0
	 */
	public static function getElapsedLerp(lerp:Float, elapsed:Float):Float
	{
		return 1.0 - Math.pow(1.0 - lerp, elapsed * 60);
	}

	/**
	 * Converts a per-frame linear interpolation factor to an exponential decay factor
	 * based on the actual elapsed time.
	 * 
	 * Use this to apply consistent smoothing regardless of frame rate.
	 * 
	 * @param   lerp     The "strength" of the interpolation (larger = faster convergence)
	 * @param   elapsed  The actual time that has passed, in seconds
	 * @since 6.2.0
	 */
	public static function getExponentialDecayLerp(lerp:Float, elapsed:Float):Float
	{
		return Math.exp(-elapsed * lerp * 60);
	}

	/**
	 * Checks if number is in defined range. A null bound means that side is unbounded.
	 *
	 * @param Value		Number to check.
	 * @param Min		Lower bound of range.
	 * @param Max 		Higher bound of range.
	 * @return Returns true if Value is in range.
	 */
	public static inline function inBounds(Value:Float, Min:Null<Float>, Max:Null<Float>):Bool
	{
		return (Min == null || Value >= Min) && (Max == null || Value <= Max);
	}

	/**
	 * Returns `true` if the given number is odd.
	 */
	public static inline function isOdd(n:Float):Bool
	{
		return (Std.int(n) & 1) != 0;
	}

	/**
	 * Returns `true` if the given number is even.
	 */
	public static inline function isEven(n:Float):Bool
	{
		return (Std.int(n) & 1) == 0;
	}

	/**
	 * Returns `-1` if `a` is smaller, `1` if `b` is bigger and `0` if both numbers are equal.
	 */
	public static inline function numericComparison(a:Float, b:Float):Int
	{
		return (b > a ? -1 : (a > b ? 1 : 0));
	}

	/**
	 * Returns true if the given x/y coordinate is within the given rectangular block
	 *
	 * @param	pointX		The X value to test
	 * @param	pointY		The Y value to test
	 * @param	rectX		The X value of the region to test within
	 * @param	rectY		The Y value of the region to test within
	 * @param	rectWidth	The width of the region to test within
	 * @param	rectHeight	The height of the region to test within
	 *
	 * @return	true if pointX/pointY is within the region, otherwise false
	 */
	public static inline function pointInCoordinates(pointX:Float, pointY:Float, rectX:Float, rectY:Float, rectWidth:Float, rectHeight:Float):Bool
	{
		return pointX >= rectX && pointX <= (rectX + rectWidth) && pointY >= rectY && pointY <= (rectY + rectHeight);
	}

	/**
	 * Returns true if the given x/y coordinate is within the given rectangular block
	 *
	 * @param	pointX		The X value to test
	 * @param	pointY		The Y value to test
	 * @param	rect		The FlxRect to test within
	 * @return	true if pointX/pointY is within the FlxRect, otherwise false
	 */
	public static inline function pointInFlxRect(pointX:Float, pointY:Float, rect:FlxRect):Bool
	{
		return return rect.containsXY(pointX, pointY);
	}

	#if (FLX_MOUSE && !macro)
	/**
	 * Returns true if the mouse world x/y coordinate are within the given rectangular block
	 *
	 * @param	useWorldCoords	If true the world x/y coordinates of the mouse will be used, otherwise screen x/y
	 * @param	rect			The FlxRect to test within. If this is null for any reason this function always returns true.
	 *
	 * @return	true if mouse is within the FlxRect, otherwise false
	 */
	public static inline function mouseInFlxRect(useWorldCoords:Bool, rect:FlxRect):Bool
	{
		if (rect == null)
			return true;

		if (useWorldCoords)
			return pointInFlxRect(Math.floor(FlxG.mouse.x), Math.floor(FlxG.mouse.y), rect);
		else
			return pointInFlxRect(FlxG.mouse.viewX, FlxG.mouse.viewY, rect);
	}
	#end

	/**
	 * Returns true if the given x/y coordinate is within the Rectangle
	 *
	 * @param	pointX		The X value to test
	 * @param	pointY		The Y value to test
	 * @param	rect		The Rectangle to test within
	 * @return	true if pointX/pointY is within the Rectangle, otherwise false
	 */
	public static inline function pointInRectangle(pointX:Float, pointY:Float, rect:Rectangle):Bool
	{
		return pointX >= rect.x && pointX <= rect.right && pointY >= rect.y && pointY <= rect.bottom;
	}

	/**
	 * Adds the given amount to the value, but never lets the value
	 * go over the specified maximum or under the specified minimum.
	 *
	 * @param 	value 	The value to add the amount to
	 * @param 	amount 	The amount to add to the value
	 * @param 	max 	The maximum the value is allowed to be
	 * @param 	min 	The minimum the value is allowed to be
	 * @return The new value
	 */
	public static inline function maxAdd(value:Int, amount:Int, max:Int, min:Int = 0):Int
	{
		value += amount;

		if (value > max)
			value = max;
		else if (value < min)
			value = min;

		return value;
	}

	/**
	 * Makes sure that value always stays between 0 and max,
	 * by wrapping the value around.
	 *
	 * @param 	value 	The value to wrap around
	 * @param 	min		The minimum the value is allowed to be
	 * @param 	max 	The maximum the value is allowed to be
	 * @return The wrapped value
	 */
	public static function wrap(value:Int, min:Int, max:Int):Int
	{
		final range = max - min + 1;

		if (value < min)
			value += range * Std.int((min - value) / range + 1);

		return min + (value - min) % range;
	}

	public static inline function wrapMax(value:Int, max:Int):Int
	{
		final range = max + 1;
		value = value % range;

		if (value < 0)
			value += range;

		return value;
	}

	/**
	 * Remaps a number from one range to another.
	 *
	 * @param 	value	The incoming value to be converted
	 * @param 	start1 	Lower bound of the value's current range
	 * @param 	stop1 	Upper bound of the value's current range
	 * @param 	start2  Lower bound of the value's target range
	 * @param 	stop2 	Upper bound of the value's target range
	 * @return The remapped value
	 */
	public static function remapToRange(value:Float, start1:Float, stop1:Float, start2:Float, stop2:Float):Float
	{
		return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1));
	}

	/**
	 * Finds the dot product value of two vectors
	 *
	 * @param	ax		Vector X
	 * @param	ay		Vector Y
	 * @param	bx		Vector X
	 * @param	by		Vector Y
	 *
	 * @return	Result of the dot product
	 */
	public static inline function dotProduct(ax:Float, ay:Float, bx:Float, by:Float):Float
	{
		return ax * bx + ay * by;
	}

	/**
	 * Returns the length of the given vector.
	 */
	public static inline function vectorLength(dx:Float, dy:Float):Float
	{
		return Math.sqrt(dx * dx + dy * dy);
	}

	#if !macro
	/**
	 * Find the distance (in pixels, rounded) between two FlxSprites, taking their origin into account
	 *
	 * @param	SpriteA		The first FlxSprite
	 * @param	SpriteB		The second FlxSprite
	 * @return	Distance between the sprites in pixels
	 */
	public static inline function distanceBetween(SpriteA:FlxSprite, SpriteB:FlxSprite):Int
	{
		final dx = (SpriteA.x + SpriteA.origin.x) - (SpriteB.x + SpriteB.origin.x);
		final dy = (SpriteA.y + SpriteA.origin.y) - (SpriteB.y + SpriteB.origin.y);
		return Std.int(FlxMath.vectorLength(dx, dy));
	}

	/**
	 * Check if the distance between two FlxSprites is within a specified number.
	 * A faster algorithm than distanceBetween because the Math.sqrt() is avoided.
	 *
	 * @param	SpriteA		The first FlxSprite
	 * @param	SpriteB		The second FlxSprite
	 * @param	Distance	The distance to check
	 * @param	IncludeEqual	If set to true, the function will return true if the calculated distance is equal to the given Distance
	 * @return	True if the distance between the sprites is less than the given Distance
	 */
	public static inline function isDistanceWithin(SpriteA:FlxSprite, SpriteB:FlxSprite, Distance:Float, IncludeEqual:Bool = false):Bool
	{
		final dx = (SpriteA.x + SpriteA.origin.x) - (SpriteB.x + SpriteB.origin.x);
		final dy = (SpriteA.y + SpriteA.origin.y) - (SpriteB.y + SpriteB.origin.y);

		if (IncludeEqual)
			return dx * dx + dy * dy <= Distance * Distance;
		else
			return dx * dx + dy * dy < Distance * Distance;
	}

	/**
	 * Find the distance (in pixels, rounded) from an FlxSprite
	 * to the given FlxPoint, taking the source origin into account.
	 *
	 * @param	Sprite	The FlxSprite
	 * @param	Target	The FlxPoint
	 * @return	Distance in pixels
	 */
	public static inline function distanceToPoint(Sprite:FlxSprite, Target:FlxPoint):Int
	{
		final dx = (Sprite.x + Sprite.origin.x) - Target.x;
		final dy = (Sprite.y + Sprite.origin.y) - Target.y;
		Target.putWeak();
		return Std.int(FlxMath.vectorLength(dx, dy));
	}

	/**
	 * Check if the distance from an FlxSprite to the given
	 * FlxPoint is within a specified number.
	 * A faster algorithm than distanceToPoint because the Math.sqrt() is avoided.
	 *
	 * @param	Sprite	The FlxSprite
	 * @param	Target	The FlxPoint
	 * @param	Distance	The distance to check
	 * @param	IncludeEqual	If set to true, the function will return true if the calculated distance is equal to the given Distance
	 * @return	True if the distance between the sprites is less than the given Distance
	 */
	public static inline function isDistanceToPointWithin(Sprite:FlxSprite, Target:FlxPoint, Distance:Float, IncludeEqual:Bool = false):Bool
	{
		final dx = (Sprite.x + Sprite.origin.x) - (Target.x);
		final dy = (Sprite.y + Sprite.origin.y) - (Target.y);

		Target.putWeak();

		if (IncludeEqual)
			return dx * dx + dy * dy <= Distance * Distance;
		else
			return dx * dx + dy * dy < Distance * Distance;
	}

	#if FLX_MOUSE
	/**
	 * Find the distance (in pixels, rounded) from the object x/y and the mouse x/y
	 *
	 * @param	Sprite	The FlxSprite to test against
	 * @return	The distance between the given sprite and the mouse coordinates
	 */
	public static inline function distanceToMouse(Sprite:FlxSprite):Int
	{
		final dx = (Sprite.x + Sprite.origin.x) - FlxG.mouse.viewX;
		final dy = (Sprite.y + Sprite.origin.y) - FlxG.mouse.viewY;
		return Std.int(FlxMath.vectorLength(dx, dy));
	}

	/**
	 * Check if the distance from the object x/y and the mouse x/y is within a specified number.
	 * A faster algorithm than distanceToMouse because the Math.sqrt() is avoided.
	 *
	 * @param	Sprite		The FlxSprite to test against
	 * @param	Distance	The distance to check
	 * @param	IncludeEqual	If set to true, the function will return true if the calculated distance is equal to the given Distance
	 * @return	True if the distance between the sprites is less than the given Distance
	 */
	public static inline function isDistanceToMouseWithin(Sprite:FlxSprite, Distance:Float, IncludeEqual:Bool = false):Bool
	{
		final dx = (Sprite.x + Sprite.origin.x) - FlxG.mouse.viewX;
		final dy = (Sprite.y + Sprite.origin.y) - FlxG.mouse.viewY;

		if (IncludeEqual)
			return dx * dx + dy * dy <= Distance * Distance;
		else
			return dx * dx + dy * dy < Distance * Distance;
	}
	#end

	#if FLX_TOUCH
	/**
	 * Find the distance (in pixels, rounded) from the object x/y and the FlxPoint screen x/y
	 *
	 * @param	Sprite	The FlxSprite to test against
	 * @param	Touch	The FlxTouch to test against
	 * @return	The distance between the given sprite and the mouse coordinates
	 */
	public static inline function distanceToTouch(Sprite:FlxSprite, Touch:FlxTouch):Int
	{
		final dx = (Sprite.x + Sprite.origin.x) - Touch.viewX;
		final dy = (Sprite.y + Sprite.origin.y) - Touch.viewY;
		return Std.int(FlxMath.vectorLength(dx, dy));
	}

	/**
	 * Check if the distance from the object x/y and the FlxPoint screen x/y is within a specified number.
	 * A faster algorithm than distanceToTouch because the Math.sqrt() is avoided.
	 *
	 * @param	Sprite	The FlxSprite to test against
	 * @param	Distance	The distance to check
	 * @param	IncludeEqual	If set to true, the function will return true if the calculated distance is equal to the given Distance
	 * @return	True if the distance between the sprites is less than the given Distance
	 */
	public static inline function isDistanceToTouchWithin(Sprite:FlxSprite, Touch:FlxTouch, Distance:Float, IncludeEqual:Bool = false):Bool
	{
		final dx = (Sprite.x + Sprite.origin.x) - Touch.viewX;
		final dy = (Sprite.y + Sprite.origin.y) - Touch.viewY;

		if (IncludeEqual)
			return dx * dx + dy * dy <= Distance * Distance;
		else
			return dx * dx + dy * dy < Distance * Distance;
	}
	#end
	#end

	/**
	 * Returns the amount of decimals a `Float` has.
	 */
	public static inline function getDecimals(n:Float):Int
	{
		final numString = Std.string(n);
		final dotIndex = numString.indexOf(".");
		return dotIndex == -1 ? 0 : numString.length - dotIndex - 1;
	}

	public static inline function equal(aValueA:Float, aValueB:Float, aDiff:Float = EPSILON):Bool
	{
		return Math.abs(aValueA - aValueB) <= aDiff;
	}

	/**
	 * Returns `-1` if the number is smaller than `0` and `1` otherwise
	 */
	public static inline function signOf(n:Float):Int
	{
		return (n < 0) ? -1 : 1;
	}

	/**
	 * Checks if two numbers have the same sign (using `FlxMath.signOf()`).
	 */
	public static inline function sameSign(a:Float, b:Float):Bool
	{
		return signOf(a) == signOf(b);
	}

	/**
	 * A faster but slightly less accurate version of `Math.sin()`.
	 * About 2-6 times faster with < 0.05% average error.
	 *
	 * @param	n	The angle in radians.
	 * @return	An approximated sine of `n`.
	 */
	public static inline function fastSin(n:Float):Float
	{
		n *= 0.3183098862; // divide by pi to normalize

		// bound between -1 and 1
		if (n > 1)
			n -= (Math.ceil(n) >> 1) << 1;
		else if (n < -1)
			n += (Math.ceil(-n) >> 1) << 1;

		// this approx only works for -pi <= rads <= pi, but it's quite accurate in this region
		if (n > 0)
			return n * (3.1 + n * (0.5 + n * (-7.2 + n * 3.6)));
		else
			return n * (3.1 - n * (0.5 + n * (7.2 + n * 3.6)));
	}

	/**
	 * A faster, but less accurate version of `Math.cos()`.
	 * About 2-6 times faster with < 0.05% average error.
	 *
	 * @param	n	The angle in radians.
	 * @return	An approximated cosine of `n`.
	 */
	public static inline function fastCos(n:Float):Float
	{
		return fastSin(n + 1.570796327); // sin and cos are the same, offset by pi/2
	}

	/**
	 * Hyperbolic sine.
	 */
	public static inline function sinh(n:Float):Float
	{
		return (Math.exp(n) - Math.exp(-n)) * .5;
	}

	/**
	 * Returns the bigger argument.
	 */
	public static inline function maxInt(a:Int, b:Int):Int
	{
		return (a > b) ? a : b;
	}

	/**
	 * Returns the smaller argument.
	 */
	public static inline function minInt(a:Int, b:Int):Int
	{
		return (a > b) ? b : a;
	}

	/**
	 * Returns the absolute integer value.
	 */
	public static inline function absInt(n:Int):Int
	{
		return (n > 0) ? n : -n;
	}

	/**
	 * Clamps an integer value to ensure it stays within the specified minimum and maximum bounds.
	 */
	public static inline function clamp(v:Int, min:Int, max:Int):Int
	{
		return v < min ? min : (v > max ? max : v);
	}

	/**
	 * Performs a modulo operation to calculate the remainder of `a` divided by `b`.
	 * 
	 * The definition of "remainder" varies by implementation;
	 * this one is similar to GLSL or Python in that it uses Euclidean division, which always returns positive,
	 * while Haxe's `%` operator uses signed truncated division.
	 * 
	 * For example, `-5 % 3` returns `-2` while `FlxMath.mod(-5, 3)` returns `1`.
	 * 
	 * @param a The dividend.
	 * @param b The divisor.
	 * @return `a mod b`.
	 */
	public static inline function mod(a:Float, b:Float):Float
	{
		b = Math.abs(b);
		return a - b * Math.floor(a / b);
	}
}
