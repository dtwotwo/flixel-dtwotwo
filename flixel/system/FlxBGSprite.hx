package flixel.system;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class FlxBGSprite extends FlxSprite
{
	public function new()
	{
		super();
		// TODO: Use unique:false, now that we're not editing the pixels
		makeGraphic(1, 1, FlxColor.WHITE, true, FlxG.bitmap.getUniqueKey("bg_graphic_"));
		scrollFactor.set();
	}

	/**
	 * Called by game loop, updates then blits or renders current frame of animation to the screen
	 */
	@:access(flixel.FlxCamera)
	override public function draw():Void
	{
		if (alpha == 0) return;

		for (camera in getCamerasLegacy())
		{
			if (!camera.visible || !camera.exists)
			{
				continue;
			}

			_matrix.identity();
			_matrix.scale(camera.viewWidth + 1, camera.viewHeight + 1);
			_matrix.translate(camera.viewMarginLeft, camera.viewMarginTop);
			camera.drawPixels(frame, _matrix, colorTransform);

			#if FLX_DEBUG
			FlxBasic.visibleCount++;
			#end
		}
	}
}