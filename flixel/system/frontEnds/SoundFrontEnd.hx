package flixel.system.frontEnds;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;
import flixel.system.FlxAssets;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxInputText;
import flixel.util.FlxSignal;
import openfl.media.Sound;

/**
 * Accessed via `FlxG.sound`.
 */
@:allow(flixel.FlxG)
class SoundFrontEnd
{
	/**
	 * A handy container for a background music object.
	 */
	public var music:FlxSound;

	/**
	 * Whether or not the game sounds are muted.
	 */
	public var muted:Bool = false;

	/**
	 * A signal that gets dispatched whenever the volume changes.
	 */
	public var onVolumeChange(default, null):FlxTypedSignal<Float->Void> = new FlxTypedSignal<Float->Void>();

	#if FLX_KEYBOARD

	public var keysAllowed:Bool = true;

	/**
	 * The key codes used to increase volume (see FlxG.keys for the keys available).
	 * Default keys: + (and numpad +). Set to null to deactivate.
	 */
	public var volumeUpKeys:Array<FlxKey> = [PLUS, NUMPADPLUS];

	/**
	 * The keys to decrease volume (see FlxG.keys for the keys available).
	 * Default keys: - (and numpad -). Set to null to deactivate.
	 */
	public var volumeDownKeys:Array<FlxKey> = [MINUS, NUMPADMINUS];

	/**
	 * The keys used to mute / unmute the game (see FlxG.keys for the keys available).
	 * Default keys: 0 (and numpad 0). Set to null to deactivate.
	 */
	public var muteKeys:Array<FlxKey> = [ZERO, NUMPADZERO];
	#end

	public var countToChange(default, set):Int = 15;

	inline function set_countToChange(val:Int)
	{
		volume = Math.round(FlxMath.bound(volume, 0, 1) * val) / val;
		return countToChange = val;
	}

	#if FLX_SOUND_TRAY
	/**
	 * Whether or not the soundTray should be shown when any of the
	 * volumeUp-, volumeDown- or muteKeys is pressed.
	 */
	public var soundTrayEnabled:Bool = true;

	/**
	 * The sound tray display container.
	 * A getter for `FlxG.game.soundTray`.
	 */
	public var soundTray(get, never):FlxSoundTray;

	inline function get_soundTray()
	{
		return FlxG.game.soundTray;
	}
	#end

	/**
	 * The group sounds played via playMusic() are added to unless specified otherwise.
	 */
	public var defaultMusicGroup:FlxSoundGroup = new FlxSoundGroup();

	/**
	 * The group sounds in load() / play() / stream() are added to unless specified otherwise.
	 */
	public var defaultSoundGroup:FlxSoundGroup = new FlxSoundGroup();

	/**
	 * A list of all the sounds being played in the game.
	 */
	public var list(default, null):FlxTypedGroup<FlxSound> = new FlxTypedGroup<FlxSound>();

	/**
	 * Set this to a number between 0 and 1 to change the global volume.
	 */
	public var volume(default, set):Float = 1;

	/**
	 * Set up and play a looping background soundtrack.
	 *
	 * **Note:** If the `FLX_DEFAULT_SOUND_EXT` flag is enabled, you may omit the file extension
	 *
	 * @param   embeddedMusic  The sound file you want to loop in the background.
	 * @param   volume         How loud the sound should be, from 0 to 1.
	 * @param   looped         Whether to loop this music.
	 * @param   group          The group to add this sound to.
	 */
	public function playMusic(embeddedMusic:FlxSoundAsset, volume = 1.0, looped = true, ?group:FlxSoundGroup):Void
	{
		if (group == null) group = defaultMusicGroup;

		if (music == null) music = new FlxSound();
		else if (music.active) music.stop();

		music.loadEmbedded(embeddedMusic, looped);
		music.volume = volume;
		music.persist = true;
		group.add(music);
		music.play();
	}

	/**
	 * Creates a new FlxSound object.
	 *
	 * **Note:** If the `FLX_DEFAULT_SOUND_EXT` flag is enabled, you may omit the file extension
	 *
	 * @param   embeddedSound   The embedded sound resource you want to play.  To stream, use the optional URL parameter instead.
	 * @param   volume          How loud to play it (0 to 1).
	 * @param   looped          Whether to loop this sound.
	 * @param   group           The group to add this sound to.
	 * @param   autoDestroy     Whether to destroy this sound when it finishes playing.
	 *                          Leave this value set to "false" if you want to re-use this FlxSound instance.
	 * @param   autoPlay        Whether to play the sound.
	 * @param   url             Load a sound from an external web resource instead.  Only used if EmbeddedSound = null.
	 * @param   onComplete      Called when the sound finished playing.
	 * @param   onLoad          Called when the sound finished loading.  Called immediately for succesfully loaded embedded sounds.
	 * @return  A FlxSound object.
	 */
	public function load(?embeddedSound:FlxSoundAsset, volume = 1.0, looped = false, ?group:FlxSoundGroup, autoDestroy = false, autoPlay = false, ?url:String,
			?onComplete:Void->Void, ?onLoad:Void->Void):FlxSound
	{
		if ((embeddedSound == null) && (url == null))
		{
			FlxG.log.warn("FlxG.sound.load() requires either\nan embedded sound or a URL to work.");
			return null;
		}

		var sound:FlxSound = list.recycle(FlxSound);

		if (embeddedSound != null)
		{
			sound.loadEmbedded(embeddedSound, looped, autoDestroy, onComplete);
			loadHelper(sound, volume, group, autoPlay);
			// Call OnlLoad() because the sound already loaded
			if (onLoad != null && sound._sound != null)
				onLoad();
		}
		else
		{
			var loadCallback = onLoad;
			if (autoPlay)
			{
				// Auto play the sound when it's done loading
				loadCallback = function()
				{
					sound.play();

					if (onLoad != null)
						onLoad();
				}
			}

			sound.loadStream(url, looped, autoDestroy, onComplete, loadCallback);
			loadHelper(sound, volume, group);
		}

		return sound;
	}

	function loadHelper(sound:FlxSound, volume:Float, group:FlxSoundGroup, autoPlay = false):FlxSound
	{
		if (group == null)
			group = defaultSoundGroup;

		sound.volume = volume;

		group.add(sound);

		if (autoPlay) sound.play();

		return sound;
	}

	/**
	 * Method for sound caching (especially useful on mobile targets). The game may freeze
	 * for some time the first time you try to play a sound if you don't use this method.
	 *
	 * @param   embeddedSound  Name of sound assets specified in your .xml project file
	 * @return  Cached Sound object
	 */
	public inline function cache(embeddedSound:String):Sound
	{
		// load the sound into the OpenFL assets cache
		if (FlxG.assets.exists(embeddedSound, SOUND))
			return FlxG.assets.getSoundUnsafe(embeddedSound, true);
		FlxG.log.error('Could not find a Sound asset with an ID of \'$embeddedSound\'.');
		return null;
	}

	/**
	 * Calls FlxG.sound.cache() on all sounds that are embedded.
	 * WARNING: can lead to high memory usage.
	 */
	public function cacheAll():Void
	{
		for (id in FlxG.assets.list(SOUND))
		{
			cache(id);
		}
	}

	/**
	 * Plays a sound from an embedded sound. Tries to recycle a cached sound first.
	 *
	 * **Note:** If the `FLX_DEFAULT_SOUND_EXT` flag is enabled, you may omit the file extension
	 *
	 * @param   embeddedSound  The embedded sound resource you want to play.
	 * @param   volume         How loud to play it (0 to 1).
	 * @param   looped         Whether to loop this sound.
	 * @param   group          The group to add this sound to.
	 * @param   autoDestroy    Whether to destroy this sound when it finishes playing.
	 *                         Leave this value set to "false" if you want to re-use this FlxSound instance.
	 * @param   onComplete     Called when the sound finished playing
	 * @return  A FlxSound object.
	 */
	public function play(embeddedSound:FlxSoundAsset, volume = 1.0, looped = false, ?group:FlxSoundGroup, autoDestroy = true, ?onComplete:Void->Void):FlxSound
	{
		if ((embeddedSound is String))
		{
			embeddedSound = cache(embeddedSound);
		}
		var sound = list.recycle(FlxSound).loadEmbedded(embeddedSound, looped, autoDestroy, onComplete);
		return loadHelper(sound, volume, group, true);
	}

	/**
	 * Plays a sound from a URL. Tries to recycle a cached sound first.
	 * NOTE: Just calls FlxG.sound.load() with AutoPlay == true.
	 *
	 * @param   url          Load a sound from an external web resource instead.
	 * @param   volume       How loud to play it (0 to 1).
	 * @param   looped       Whether to loop this sound.
	 * @param   group        The group to add this sound to.
	 * @param   autoDestroy  Whether to destroy this sound when it finishes playing.
	 *                       Leave this value set to "false" if you want to re-use this FlxSound instance.
	 * @param   onComplete   Called when the sound finished playing
	 * @param   onLoad       Called when the sound finished loading.
	 * @return  A FlxSound object.
	 */
	public function stream(url:String, volume = 1.0, looped = false, ?group:FlxSoundGroup, autoDestroy = true, ?onComplete:Void->Void,
			?onLoad:Void->Void):FlxSound
	{
		return load(null, volume, looped, group, autoDestroy, true, url, onComplete, onLoad);
	}

	/**
	 * Pause all sounds currently playing.
	 */
	public function pause():Void
	{
		if (music != null && music.exists && music.active)
		{
			music.pause();
		}

		for (sound in list.members)
		{
			if (sound != null && sound.exists && sound.active)
			{
				sound.pause();
			}
		}
	}

	/**
	 * Resume playing existing sounds.
	 */
	public function resume():Void
	{
		if (music != null && music.exists)
		{
			music.resume();
		}

		for (sound in list.members)
		{
			if (sound != null && sound.exists)
			{
				sound.resume();
			}
		}
	}

	/**
	 * Called by FlxGame on state changes to stop and destroy sounds.
	 *
	 * @param   forceDestroy  Kill sounds even if persist is true.
	 */
	public function destroy(forceDestroy = false):Void
	{
		if (forceDestroy)
			forEachSound(destroySound);
		else
			forEachSound(i -> if (!i.persist) destroySound(i));

		if (music != null && (forceDestroy || !music.persist))
			music = null;
	}

	public function forEachSound(func:FlxSound -> Void)
	{
		if (music != null)
			func(music);

		for (sound in list.members)
			if (sound != null)
				func(sound);
	}

	private inline function destroySound(sound:FlxSound):Void
	{
		defaultMusicGroup.remove(sound);
		defaultSoundGroup.remove(sound);
		sound?.destroy();
	}

	/**
	 * Toggles muted, also activating the sound tray.
	 */
	public function toggleMuted():Void
	{
		muted = !muted;

		onVolumeChange.dispatch(muted ? 0 : volume);

		showSoundTray(true);
	}

	/**
	 * Changes the volume by a certain amount, also activating the sound tray.
	 */
	public dynamic function changeVolume(amount:Float, ?forceSound = true):Void
	{
		muted = false;
		volume = Math.round((volume + amount) * countToChange) / countToChange;

		#if FLX_SOUND_TRAY
		showSoundTray(amount > 0, forceSound);
		#end
	}

	#if FLX_SOUND_TRAY
	/**
	 * Shows the sound tray if it is enabled.
	 * @param up Whether or not the volume is increasing.
	 */
	public function showSoundTray(up:Bool = false, ?forceSound = true):Void
	{
		if (FlxG.game.soundTray != null && soundTrayEnabled)
			FlxG.game.soundTray.show(up, forceSound);
	}
	#end

	/**
	 * Takes the volume scale used by Flixel fields and gives the final transformed volume that is
	 * actually used to play the sound. To reverse this operation, use `reverseSoundCurve`. This
	 * field is `dynamic` and can be overwritten.
	 */
	public dynamic function applySoundCurve(volume:Float)
	{
		return volume;

		// Example of linear to logarithmic sound curve:
		// final clampedVolume = Math.max(0, Math.min(1, volume));
		// return Math.exp(Math.log(0.001) * (1 - clampedVolume));
	}

	/**
	 * Takes a transformed volume and returns the corresponding volume scale used by Flixel fields.
	 * Used to reverse the operation of `applySoundCurve`. This field is `dynamic` and can be
	 * set to a custom function.
	 */
	public dynamic function reverseSoundCurve(curvedVolume:Float)
	{
		return curvedVolume;

		// Example of logarithmic to linear sound curve:
		// final clampedVolume = Math.max(minValue, Math.min(1, x));
		// return 1 - (Math.log(clampedVolume) / Math.log(0.001));
	}

	function new()
	{
		#if FLX_SAVE
		loadSavedPrefs();
		#end
	}

	@:noCompletion static inline final _pressDelay = .5;
	@:noCompletion private var volumeMult = 1;
	@:noCompletion private var holdTime = .0;

	/**
	 * Called by the game loop to make sure the sounds get updated each frame.
	 */
	@:allow(flixel.FlxGame)
	function update(elapsed:Float):Void
	{
		if (music != null && music.active)
			music.update(elapsed);

		if (list != null && list.active)
			list.update(elapsed);

		#if FLX_KEYBOARD
		if (keysAllowed && !FlxInputText.globalManager.isTyping) {
			final justPressedMute = FlxG.keys.anyJustPressed(muteKeys);
			final justPressedUp = FlxG.keys.anyJustPressed(volumeUpKeys);
			final justPressedDown = FlxG.keys.anyJustPressed(volumeDownKeys);

			if (justPressedMute)
				toggleMuted();
			else if (justPressedUp)
				changeVolume(volumeMult / countToChange);
			else if (justPressedDown)
				changeVolume(-volumeMult / countToChange);

			if (justPressedMute || justPressedUp || justPressedDown) holdTime = 0;

			final pressedUp = FlxG.keys.anyPressed(volumeUpKeys);
			if (pressedUp || FlxG.keys.anyPressed(volumeDownKeys)) {
				final checkLastHold = Math.round((holdTime - _pressDelay) * 10);
				@:privateAccess holdTime += FlxG.game._elapsedMS * .001;
				final checkNewHold = Math.round((holdTime - _pressDelay) * 10);

				if (holdTime > _pressDelay && checkNewHold - checkLastHold > 0)
					changeVolume((checkNewHold - checkLastHold) * (pressedUp ? volumeMult : -volumeMult) / countToChange, false);
			}
		}
		#end
	}

	@:allow(flixel.FlxGame)
	function onFocusLost():Void
	{
		if (music != null)
		{
			music.onFocusLost();
		}

		for (sound in list.members)
		{
			if (sound != null)
			{
				sound.onFocusLost();
			}
		}
	}

	@:allow(flixel.FlxGame)
	function onFocus():Void
	{
		if (music != null)
		{
			music.onFocus();
		}

		for (sound in list.members)
		{
			if (sound != null)
			{
				sound.onFocus();
			}
		}
	}

	#if FLX_SAVE
	/**
	 * Loads saved sound preferences if they exist.
	 */
	function loadSavedPrefs():Void
	{
		if (!FlxG.save.isBound)
			return;

		if (FlxG.save.data.volume != null)
		{
			volume = FlxG.save.data.volume;
		}

		if (FlxG.save.data.mute != null)
		{
			muted = FlxG.save.data.mute;
		}
	}
	#end

	inline function set_volume(volume:Float):Float {
		volume = FlxMath.bound(volume, 0, 1);

		onVolumeChange.dispatch(muted ? 0 : volume);

		return this.volume = volume;
	}
}
#end
