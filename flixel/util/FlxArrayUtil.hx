package flixel.util;

using flixel.util.FlxStringUtil;
using StringTools;

/**
 * A set of functions for array manipulation.
 */
class FlxArrayUtil
{
	/**
	 * Safely removes an element from an array by swapping it with the last element and calling `pop()`
	 * (won't do anything if the element is not in the array). This is a lot faster than regular `splice()`,
	 * but it can only be used on arrays where order doesn't matter.
	 *
	 * @param	array	The array to remove the element from
	 * @param 	element	The element to remove from the array
	 * @return	The array
	 */
	@:generic
	public static inline function fastSplice<T>(array:Array<T>, element:T):Array<T>
	{
		var index = array.indexOf(element);
		if (index != -1)
			return swapAndPop(array, index);
		return array;
	}

	/**
	 * Removes an element from an array by swapping it with the last element and calling `pop()`.
	 * This is a lot faster than regular `splice()`, but it can only be used on arrays where order doesn't matter.
	 *
	 * IMPORTANT: always count down from length to zero if removing elements from within a loop
	 *
	 * ```haxe
	 * using flixel.util.FlxArrayUtil;
	 *
	 * var i = array.length;
	 * while (i-- > 0)
	 * {
	 *      if (array[i].shouldRemove)
	 *      {
	 *           array.swapAndPop(i);
	 *      }
	 * }
	 * ```
	 *
	 * @param	array	The array to remove the element from
	 * @param 	index	The index of the element to be removed from the array
	 * @return	The array
	 */
	#if FLX_GENERIC
	@:generic
	#end
	public static inline function swapAndPop<T>(array:Array<T>, index:Int):Array<T>
	{
		array[index] = array[array.length - 1]; // swap element to remove and last element
		array.pop();
		return array;
	}

	/**
	 * Swaps two elements of an array, which are located at indices `index1` and `index2`
	 * @param array The array whose elements need to be swapped
	 * @param index1 The index of one of the elements to be swapped
	 * @param index2 The index of the other element to be swapped
	 * @return The array
	 */
	public static inline function swapByIndex<T>(array:Array<T>, index1:Int, index2:Int):Array<T>
	{
		var temp = array[index1];
		array[index1] = array[index2];
		array[index2] = temp;
		return array;
	}

	/**
	 * Swaps two elements of an array, which are located at indices `index1` and `index2` and also checks if the indices are valid before swapping
	 * @param array The array whose elements need to be swapped
	 * @param index1 The index of one of the elements to be swapped
	 * @param index2 The index of the other element to be swapped
	 * @return The array
	 */
	public static inline function safeSwapByIndex<T>(array:Array<T>, index1:Int, index2:Int):Array<T>
	{
		if(index1 >= 0 && index1 < array.length && index2 >= 0 && index2 < array.length)
		{
			swapByIndex(array, index1, index2);
		}
		return array;
	}

	/**
	 * Swaps two items, `item1` and `item2` which are in the array
	 * @param array The array whose elements need to be swapped
	 * @param item1 One of the elements of the array which needs to be swapped
	 * @param item2 The other element of the array which needs to be swapped
	 * @return The array
	 */
	public static inline function swap<T>(array:Array<T>, item1:T, item2:T):Array<T>
	{
		return swapByIndex(array, array.indexOf(item1), array.indexOf(item2));
	}

	/**
	 * Swaps two items, `item1` and `item2` which are in the array, but only if both elements are present in the array
	 * @param array The array whose elements need to be swapped
	 * @param item1 One of the elements of the array which needs to be swapped
	 * @param item2 The other element of the array which needs to be swapped
	 * @return The array
	 */
	public static inline function safeSwap<T>(array:Array<T>, item1:T, item2:T):Array<T>
	{
		return safeSwapByIndex(array, array.indexOf(item1), array.indexOf(item2));
	}

	/**
	 * Converts a string of newline-separated values into an array of strings.
	 */
	public static function listFromString(text:String):Array<String>
	{
		return text.isNullOrEmpty() ? [] : text.split('\n').map(str -> str.trim());
	}

	/**
	 * Randomly shuffles the elements of the given array using the Fisher-Yates algorithm.
	 * 
	 * @param array The array to shuffle.
	 * @return The shuffled array (same reference).
	 */
	public static function shuffleArray<T>(array:Array<T>):Array<T>
	{
		for (i in array.length - 1...0) {
			final j = FlxG.random.int(0, i);
			final temp = array[i];
			array[i] = array[j];
			array[j] = temp;
		}
		return array;
	}

	/**
	 * Clear the given map.
	 */
	public static inline function clear<K:Any, V:Any>(map:Map<K, V>):Map<K, V>
	{
		map?.clear();
		return null;
	}

	/**
	 * Clears an array structure, but leaves the object data untouched
	 * Useful for cleaning up temporary references to data you want to preserve.
	 * WARNING: Does not attempt to properly destroy the contents.
	 *
	 * @param	array		The array to clear out
	 * @param	Recursive	Whether to search for arrays inside of arr and clear them out, too
	 */
	public static function clearArray<T>(array:Array<T>, recursive:Bool = false):Array<T>
	{
		if (array == null)
			return array;

		if (recursive)
		{
			while (array.length > 0)
			{
				var thing:T = array.pop();
				if ((thing is Array))
					clearArray(array, recursive);
			}
		}
		else
		{
			while (array.length > 0)
				array.pop();
		}

		return array;
	}

	/**
	 * Flattens 2D arrays into 1D arrays.
	 * Example: `[[1, 2], [3, 2], [1, 1]]` -> `[1, 2, 3, 2, 1, 1]`
	 */
	#if FLX_GENERIC
	@:generic
	#end
	public static function flatten2DArray<T>(array:Array<Array<T>>):Array<T>
	{
		var result = [];
		for (innerArray in array)
			for (element in innerArray)
				result.push(element);
		return result;
	}

	/**
	 * Compares the contents with `==` to see if the two arrays are the same.
	 * Also takes null arrays and the length of the arrays into account.
	 */
	public static function equals<T>(array1:Array<T>, array2:Array<T>):Bool
	{
		if (array1 == null && array2 == null)
			return true;
		if (array1 == null && array2 != null)
			return false;
		if (array1 != null && array2 == null)
			return false;
		if (array1.length != array2.length)
			return false;

		for (i in 0...array1.length)
			if (array1[i] != array2[i])
				return false;

		return true;
	}

	/**
	 * Returns the last element of an array or `null` if the array is `null` / empty.
	 */
	public static function last<T>(array:Array<T>):Null<T>
	{
		if (array == null || array.length == 0)
			return null;
		return array[array.length - 1];
	}

	/**
	 * Creates an array of all integers from `min` to `max` (inclusive).
	 * @param max The maximum value in the array.
	 * @param min The minimum value in the array (default is 0).
	 */
	inline static function rangeArray(max:Int, min = 0):Array<Int> {
		final result = [for (i in min...max) i];
		return result;
	}

	/**
	 * Pushes the element into the array (and if the array is null, creates it first) and returns the array.
	 * @since 4.6.0
	 */
	public static function safePush<T>(array:Null<Array<T>>, element:T):Array<T>
	{
		if (array == null)
			array = [];
		
		array.push(element);
		return array;
	}

	public static inline function contains<T>(array:Array<T>, element:T):Bool
	{
		return array.contains(element);
	}

	/**
	 * Returns true if the array is not null and contains the element.
	 * @since 5.0.0
	 */
	public static inline function safeContains<T>(array:Null<Array<T>>, element:T):Bool
	{
		return array != null && contains(array, element);
	}
}
