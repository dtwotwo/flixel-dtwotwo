package flixel.sound;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxSignal;
import flixel.util.FlxStringUtil;
import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

/**
 * This is the universal flixel sound object, used for streaming, music, and sound effects.
 */
class FlxSound extends FlxBasic
{
	/**
	 * The x position of this sound in world coordinates.
	 * Only really matters if you are doing proximity/panning stuff.
	 */
	public var x:Float;

	/**
	 * The y position of this sound in world coordinates.
	 * Only really matters if you are doing proximity/panning stuff.
	 */
	public var y:Float;

	/**
	 * Whether or not this sound should be automatically destroyed when you switch states.
	 */
	public var persist:Bool;

	/**
	 * The ID3 song name. Defaults to null. Currently only works for streamed sounds.
	 */
	public var name(default, null):String;

	/**
	 * The ID3 artist name. Defaults to null. Currently only works for streamed sounds.
	 */
	public var artist(default, null):String;

	/**
	 * Stores the average wave amplitude of both stereo channels
	 */
	public var amplitude(default, null):Float;

	/**
	 * Just the amplitude of the left stereo channel
	 */
	public var amplitudeLeft(default, null):Float;

	/**
	 * Just the amplitude of the right stereo channel
	 */
	public var amplitudeRight(default, null):Float;

	/**
	 * Whether to call `destroy()` when the sound has finished playing.
	 */
	public var autoDestroy:Bool;

	/**
	 * Tracker for sound complete callback. If assigned, will be called
	 * each time when sound reaches its end.
	 */
	public final onFinish:FlxSignal;

	/**
	 * Pan amount. -1 = full left, 1 = full right. Proximity based panning overrides this.
	 *
	 * Note: On desktop targets this only works with mono sounds, due to limitations of OpenAL.
	 * More info: [OpenFL Forums - SoundTransform.pan does not work](https://community.openfl.org/t/windows-legacy-soundtransform-pan-does-not-work/6616/2?u=geokureli)
	 */
	public var pan(get, set):Float;

	/**
	 * Whether or not the sound is currently playing.
	 */
	public var playing(get, never):Bool;

	/**
	 * Set volume to a value between 0 and 1 to change how this sound is.
	 */
	public var volume(get, set):Float;

	/**
	 * Whether or not the sound is muted.
	 */
	public var muted(get, set):Bool;

	#if FLX_PITCH
	/**
	 * Set pitch, which also alters the playback speed. Default is 1.
	 */
	public var pitch(get, set):Float;
	#end

	/**
	 * The position in runtime of the music playback in milliseconds.
	 * If set while paused, changes only come into effect after a `resume()` call.
	 */
	public var time(get, set):Float;

	/**
	 * The length of the sound in milliseconds.
	 * @since 4.2.0
	 */
	public var length(get, never):Float;

	/**
	 * The sound group this sound belongs to, can only be in one group.
	 */
	@:allow(flixel.sound.FlxSoundGroup)
	public var group(default, null):FlxSoundGroup;

	/**
	 * Whether or not this sound should loop.
	 */
	public var looped:Bool;

	/**
	 * In case of looping, the point (in milliseconds) from where to restart the sound when it loops back
	 * @since 4.1.0
	 */
	public var loopTime:Float = 0;

	/**
	 * At which point to stop playing the sound, in milliseconds.
	 * If not set / `null`, the sound completes normally.
	 * @since 4.2.0
	 */
	public var endTime:Null<Float>;

	/**
	 * The tween used to fade this sound's volume in and out (set via `fadeIn()` and `fadeOut()`)
	 * @since 4.1.0
	 */
	public var fadeTween:FlxTween;

	/**
	 * Internal tracker for a sound object.
	 */
	@:allow(flixel.system.frontEnds.SoundFrontEnd.load)
	var _sound:Sound;

	/**
	 * Internal tracker for a sound channel object.
	 */
	var _channel:SoundChannel;

	/**
	 * Internal tracker for a sound transform object.
	 */
	var _transform:SoundTransform;

	/**
	 * Internal tracker for whether the sound is paused or not (not the same as stopped).
	 */
	var _paused:Bool;

	/**
	 * Internal tracker for volume.
	 */
	var _volume:Float;

	/**
	 * Internal tracker for whether the sound is muted or not.
	 */
	var _muted:Bool;

	/**
	 * Internal tracker for sound channel position.
	 */
	var _time:Float = 0;

	/**
	 * Internal tracker for sound length, so that length can still be obtained while a sound is paused, because _sound becomes null.
	 */
	var _length:Float = 0;

	#if FLX_PITCH
	/**
	 * Internal tracker for pitch.
	 */
	var _pitch:Float = 1.0;
	#end

	/**
	 * Internal tracker for total volume adjustment.
	 */
	var _volumeAdjust:Float = 1.0;

	/**
	 * Internal tracker for the sound's "target" (for proximity and panning).
	 */
	var _target:FlxObject;

	/**
	 * Internal tracker for the maximum effective radius of this sound (for proximity and panning).
	 */
	var _radius:Float;

	/**
	 * Internal tracker for whether to pan the sound left and right.  Default is false.
	 */
	var _proximityPan:Bool;

	/**
	 * Helper var to prevent the sound from playing after focus was regained when it was already paused.
	 */
	var _resumeOnFocus:Bool = false;

	/**
	 * The FlxSound constructor gets all the variables initialized, but NOT ready to play a sound yet.
	 */
	public function new()
	{
		super();
		onFinish = new FlxSignal();
		reset();
	}

	/**
	 * An internal function for clearing all the variables used by sounds.
	 */
	function reset():Void
	{
		destroy();

		x = 0;
		y = 0;

		_time = 0;
		_paused = false;
		_volume = 1.0;
		_volumeAdjust = 1.0;
		_muted = false;
		looped = false;
		loopTime = 0.0;
		endTime = 0.0;
		_target = null;
		_radius = 0;
		_proximityPan = false;
		visible = false;
		amplitude = 0;
		amplitudeLeft = 0;
		amplitudeRight = 0;
		autoDestroy = false;

		if (_transform == null)
			_transform = new SoundTransform();
		_transform.pan = 0;
	}

	override public function destroy():Void
	{
		// Prevents double destroy
		if (group != null)
			group.remove(this);

		_transform = null;
		exists = false;
		active = false;
		_target = null;
		name = null;
		artist = null;

		if (_channel != null)
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, stopped);
			_channel.stop();
			_channel = null;
		}

		if (_sound != null)
		{
			_sound.removeEventListener(Event.ID3, gotID3);
			_sound = null;
		}

		onFinish.removeAll();

		super.destroy();
	}

	/**
	 * Handles fade out, fade in, panning, proximity, and amplitude operations each frame.
	 */
	override public function update(elapsed:Float):Void
	{
		if (!playing)
			return;

		_time = _channel.position;

		var radialMultiplier:Float = 1.0;

		// Distance-based volume control
		if (_target != null)
		{
			final targetPosition = _target.getPosition();
			radialMultiplier = targetPosition.distanceTo(FlxPoint.weak(x, y)) / _radius;
			targetPosition.put();
			radialMultiplier = 1 - FlxMath.bound(radialMultiplier, 0, 1);

			if (_proximityPan)
			{
				final d:Float = (x - _target.x) / _radius;
				_transform.pan = FlxMath.bound(d, -1, 1);
			}
		}

		_volumeAdjust = radialMultiplier;
		updateTransform();

		if (_transform.volume > 0)
		{
			amplitudeLeft = _channel.leftPeak / _transform.volume;
			amplitudeRight = _channel.rightPeak / _transform.volume;
			amplitude = (amplitudeLeft + amplitudeRight) * 0.5;
		}
		else
		{
			amplitudeLeft = 0;
			amplitudeRight = 0;
			amplitude = 0;
		}

		if (endTime != null && _time >= endTime)
			stopped();
	}

	override public function kill():Void
	{
		super.kill();
		cleanup(false);
	}

	/**
	 * One of the main setup functions for sounds, this function loads a sound from an embedded MP3.
	 *
	 * **Note:** If the `FLX_DEFAULT_SOUND_EXT` flag is enabled, you may omit the file extension
	 *
	 * @param	EmbeddedSound	An embedded Class object representing an MP3 file.
	 * @param	Looped			Whether or not this sound should loop endlessly.
	 * @param	AutoDestroy		Whether or not this FlxSound instance should be destroyed when the sound finishes playing.
	 * 							Default value is false, but `FlxG.sound.play()` and `FlxG.sound.stream()` will set it to true by default.
	 * @param	OnComplete		Called when the sound finished playing
	 * @return	This FlxSound instance (nice for chaining stuff together, if you're into that).
	 */
	public function loadEmbedded(EmbeddedSound:FlxSoundAsset, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void->Void):FlxSound
	{
		if (EmbeddedSound == null)
			return this;

		cleanup(true);

		if ((EmbeddedSound is Sound))
		{
			_sound = EmbeddedSound;
		}
		else if ((EmbeddedSound is Class))
		{
			_sound = Type.createInstance(EmbeddedSound, []);
		}
		else if ((EmbeddedSound is String))
		{
			if (FlxG.assets.exists(EmbeddedSound, SOUND))
				_sound = FlxG.assets.getSoundUnsafe(EmbeddedSound);
			else
				FlxG.log.error('Could not find a Sound asset with an ID of \'$EmbeddedSound\'.');
		}

		// NOTE: can't pull ID3 info from embedded sound currently
		return init(Looped, AutoDestroy, OnComplete);
	}

	/**
	 * One of the main setup functions for sounds, this function loads a sound from a URL.
	 *
	 * @param	SoundURL		A string representing the URL of the MP3 file you want to play.
	 * @param	Looped			Whether or not this sound should loop endlessly.
	 * @param	AutoDestroy		Whether or not this FlxSound instance should be destroyed when the sound finishes playing.
	 * 							Default value is false, but `FlxG.sound.play()` and `FlxG.sound.stream()` will set it to true by default.
	 * @param	OnComplete		Called when the sound finished playing
	 * @param	OnLoad			Called when the sound finished loading.
	 * @return	This FlxSound instance (nice for chaining stuff together, if you're into that).
	 */
	public function loadStream(SoundURL:String, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void->Void, ?OnLoad:Void->Void):FlxSound
	{
		cleanup(true);

		_sound = new Sound();
		_sound.addEventListener(Event.ID3, gotID3);
		var loadCallback:Event->Void = null;
		loadCallback = function(e:Event)
		{
			(e.target : IEventDispatcher).removeEventListener(e.type, loadCallback);
			// Check if the sound was destroyed before calling. Weak ref doesn't guarantee GC.
			if (_sound == e.target)
			{
				_length = _sound.length;
				if (OnLoad != null)
					OnLoad();
			}
		}
		// Use a weak reference so this can be garbage collected if destroyed before loading.
		_sound.addEventListener(Event.COMPLETE, loadCallback, false, 0, true);
		_sound.load(new URLRequest(SoundURL));

		return init(Looped, AutoDestroy, OnComplete);
	}

	/**
	 * One of the main setup functions for sounds, this function loads a sound from a ByteArray.
	 *
	 * @param	Bytes 			A ByteArray object.
	 * @param	Looped			Whether or not this sound should loop endlessly.
	 * @param	AutoDestroy		Whether or not this FlxSound instance should be destroyed when the sound finishes playing.
	 * 							Default value is false, but `FlxG.sound.play()` and `FlxG.sound.stream()` will set it to true by default.
	 * @return	This FlxSound instance (nice for chaining stuff together, if you're into that).
	 */
	public function loadByteArray(Bytes:ByteArray, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void->Void):FlxSound
	{
		cleanup(true);

		_sound = new Sound();
		_sound.addEventListener(Event.ID3, gotID3);
		_sound.loadCompressedDataFromByteArray(Bytes, Bytes.length);

		return init(Looped, AutoDestroy, OnComplete);
	}

	function init(Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void->Void):FlxSound
	{
		looped = Looped;
		autoDestroy = AutoDestroy;
		updateTransform();
		exists = true;
		onFinish.removeAll();
		onFinish.add(OnComplete);
		#if FLX_PITCH
		pitch = 1;
		#end
		_length = (_sound == null) ? 0 : _sound.length;
		endTime = _length;
		return this;
	}

	/**
	 * Call this function if you want this sound's volume to change
	 * based on distance from a particular FlxObject.
	 *
	 * @param	X			The X position of the sound.
	 * @param	Y			The Y position of the sound.
	 * @param	TargetObject		The object you want to track.
	 * @param	Radius			The maximum distance this sound can travel.
	 * @param	Pan			Whether panning should be used in addition to the volume changes.
	 * @return	This FlxSound instance (nice for chaining stuff together, if you're into that).
	 */
	public function proximity(X:Float, Y:Float, TargetObject:FlxObject, Radius:Float, Pan:Bool = true):FlxSound
	{
		x = X;
		y = Y;
		_target = TargetObject;
		_radius = Radius;
		_proximityPan = Pan;
		return this;
	}

	/**
	 * Call this function to play the sound - also works on paused sounds.
	 *
	 * @param   ForceRestart   Whether to start the sound over or not.
	 *                         Default value is false, meaning if the sound is already playing or was
	 *                         paused when you call play(), it will continue playing from its current
	 *                         position, NOT start again from the beginning.
	 * @param   StartTime      At which point to start playing the sound, in milliseconds.
	 * @param   EndTime        At which point to stop playing the sound, in milliseconds.
	 *                         If not set / `null`, the sound completes normally.
	 */
	public function play(ForceRestart:Bool = false, StartTime:Float = 0.0, ?EndTime:Float):FlxSound
	{
		if (!exists)
			return this;

		if (ForceRestart)
			cleanup(false, true);
		else if (playing) // Already playing sound
			return this;

		if (_paused)
			resume();
		else
			startSound(StartTime);

		endTime = EndTime;
		return this;
	}

	/**
	 * Unpause a sound. Only works on sounds that have been paused.
	 */
	public function resume():FlxSound
	{
		if (_paused)
			startSound(_time);
		return this;
	}

	/**
	 * Call this function to pause this sound.
	 */
	public function pause():FlxSound
	{
		if (!playing)
			return this;

		_time = _channel.position;
		_paused = true;
		cleanup(false, false);
		return this;
	}

	/**
	 * Call this function to stop this sound.
	 */
	public inline function stop():FlxSound
	{
		cleanup(autoDestroy, true);
		return this;
	}

	/**
	 * Helper function that tweens this sound's volume.
	 *
	 * @param	Duration	The amount of time the fade-out operation should take.
	 * @param	To			The volume to tween to, 0 by default.
	 */
	public inline function fadeOut(Duration:Float = 1, ?To:Float = 0, ?onComplete:FlxTween->Void):FlxSound
	{
		if (fadeTween != null)
			fadeTween.cancel();
		fadeTween = FlxTween.num(volume, To, Duration, {onComplete: onComplete}, volumeTween);

		return this;
	}

	/**
	 * Helper function that tweens this sound's volume.
	 *
	 * @param	Duration	The amount of time the fade-in operation should take.
	 * @param	From		The volume to tween from, 0 by default.
	 * @param	To			The volume to tween to, 1 by default.
	 */
	public inline function fadeIn(Duration:Float = 1, From:Float = 0, To:Float = 1, ?onComplete:FlxTween->Void):FlxSound
	{
		if (!playing)
			play();

		if (fadeTween != null)
			fadeTween.cancel();

		fadeTween = FlxTween.num(From, To, Duration, {onComplete: onComplete}, volumeTween);
		return this;
	}

	function volumeTween(f:Float):Void
	{
		volume = f;
	}

	/**
	 * Returns the currently selected "real" volume of the sound (takes fades and proximity into account).
	 *
	 * @return	The adjusted volume of the sound.
	 */
	public inline function getActualVolume():Float
	{
		return _volume * _volumeAdjust * (_muted ? 0 : 1);
	}

	/**
	 * Helper function to set the coordinates of this object.
	 * Sound positioning is used in conjunction with proximity/panning.
	 *
	 * @param        X        The new x position
	 * @param        Y        The new y position
	 */
	public inline function setPosition(X:Float = 0, Y:Float = 0):Void
	{
		x = X;
		y = Y;
	}

	/**
	 * Call after adjusting the volume to update the sound channel's settings.
	 */
	@:allow(flixel.sound.FlxSoundGroup)
	function updateTransform():Void
	{
		if (_transform == null) return;

		_transform.volume = calcTransformVolume();

		if (_channel != null)
			_channel.soundTransform = _transform;
	}

	function calcTransformVolume():Float
	{
		final volume = (group != null ? group.getVolume() : 1.0) * _volume * _volumeAdjust * (_muted ? 0 : 1);

		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.muted)
			return 0.0;

		return FlxG.sound.applySoundCurve(FlxG.sound.volume * volume);
		#else
		return volume;
		#end
	}

	/**
	 * An internal helper function used to attempt to start playing
	 * the sound and populate the _channel variable.
	 */
	function startSound(StartTime:Float):Void
	{
		if (_sound == null)
			return;

		_time = StartTime;
		_paused = false;

		if (_channel != null)
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, stopped);
			_channel.stop();
			_channel = null;
		}
		_channel = _sound.play(_time, 0, _transform);

		if (_channel != null)
		{
			#if FLX_PITCH
			pitch = _pitch;
			#end
			_channel.addEventListener(Event.SOUND_COMPLETE, stopped);
			active = true;
		}
		else
		{
			exists = false;
			active = false;
		}
	}

	/**
	 * An internal helper function used to clean up finished sounds or restart looped sounds.
	 */
	function stopped(?_):Void
	{
		onFinish.dispatch();

		if (looped)
		{
			cleanup(false);
			play(false, loopTime, endTime);
		}
		else
			cleanup(autoDestroy);
	}

	/**
	 * An internal helper function used to clean up (and potentially re-use) finished sounds.
	 * Will stop the current sound and destroy the associated SoundChannel, plus,
	 * any other commands ordered by the passed in parameters.
	 *
	 * @param  destroySound    Whether or not to destroy the sound. If this is true,
	 *                         the position and fading will be reset as well.
	 * @param  resetPosition   Whether or not to reset the position of the sound.
	 */
	function cleanup(destroySound:Bool, resetPosition:Bool = true):Void
	{
		if (destroySound)
		{
			reset();
			return;
		}

		if (_channel != null)
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, stopped);
			_channel.stop();
			_channel = null;
		}

		active = false;

		if (resetPosition)
		{
			_time = 0;
			_paused = false;
		}
	}

	/**
	 * Internal event handler for ID3 info (i.e. fetching the song name).
	 */
	function gotID3(_):Void
	{
		name = _sound.id3.songName;
		artist = _sound.id3.artist;
		_sound.removeEventListener(Event.ID3, gotID3);
	}

	#if FLX_SOUND_SYSTEM
	@:allow(flixel.system.frontEnds.SoundFrontEnd)
	function onFocus():Void
	{
		if (_resumeOnFocus)
		{
			_resumeOnFocus = false;
			resume();
		}
	}

	@:allow(flixel.system.frontEnds.SoundFrontEnd)
	function onFocusLost():Void
	{
		_resumeOnFocus = !_paused;
		pause();
	}
	#end

	inline function get_playing():Bool
	{
		return _channel != null;
	}

	inline function get_volume():Float
	{
		return _volume;
	}

	function set_volume(Volume:Float):Float
	{
		_volume = FlxMath.bound(Volume, 0, 1);
		updateTransform();
		return Volume;
	}

	inline function get_muted():Bool
	{
		return _muted;
	}

	function set_muted(Muted:Bool):Bool
	{
		_muted = Muted;
		updateTransform();
		return Muted;
	}

	#if FLX_PITCH
	inline function get_pitch():Float
	{
		return _pitch;
	}

	function set_pitch(v:Float):Float
	{
		if (_channel != null)
		{
			@:privateAccess
			if (_channel.__audioSource != null)
				_channel.__audioSource.pitch = v;
		}

		return _pitch = v;
	}
	#end

	inline function get_pan():Float
	{
		return _transform.pan;
	}

	inline function set_pan(pan:Float):Float
	{
		_transform.pan = pan;
		updateTransform();
		return pan;
	}

	inline function get_time():Float
	{
		return _time;
	}

	function set_time(time:Float):Float
	{
		if (playing)
		{
			cleanup(false, true);
			startSound(time);
		}
		return _time = time;
	}

	inline function get_length():Float
	{
		return _length;
	}

	override public function toString():String
	{
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("playing", playing),
			LabelValuePair.weak("time", time),
			LabelValuePair.weak("length", length),
			LabelValuePair.weak("volume", volume)
		]);
	}
}
