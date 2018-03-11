package;

import kha.input.Keyboard;
import kha.input.KeyCode;
import kha.input.Gamepad;

import kha.Scheduler;

class InputManager 
{
	public static var TARGET_DELAY = 1.0;
	public static var TRIGGER_THRESHOLD = 0.75;
	
	public static var the(default, null): InputManager;
	
	private var leftSide: Array<Bool>;
	private var rightSide: Array<Bool>;
	
	public var strenghtLeft: Array<Bool>;
	private var strenght: Array<Float>;
	private var startDown: Array<Bool>;
	
	public var currentLeft(default, null): Array<Bool>;
	
	private var time: Array<Float>;
	
	public inline function new() 
	{
		leftSide = [false, false];
		rightSide = [false, false];
		strenghtLeft = [false, false];
		startDown = [false, false];
		currentLeft = [false, false];
		strenght = [0.0, 0.0];
		time = [Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY];
		
		for (i in 0...2) {
			registerGamepadListenener(i);
		}
	}
	
	public static inline function init(inputManager: InputManager) {
		the = inputManager;
	}
	
	public inline function getStart(ID: Int): Bool {
		return startDown[ID];
	}
	
	public inline function getCharge(ID: Int): Float {
		var linear = Math.max(1 - Math.abs(TARGET_DELAY - (Scheduler.time() - time[ID])), 0);
		return linear * linear;
	}
	
	public inline function getStrength(ID: Int, left: Bool): Float {
		if (left && !strenghtLeft[ID])
			return 0.0;
		if (!left && strenghtLeft[ID])
			return 0.0;
		
		var result = strenght[ID];
		strenght[ID] = 0.0;
		return result;
	}
	
	public inline function registerGamepadListenener(ID: Int) {

		Keyboard.get().notify(onKeyDown, onKeyUp);

		if (kha.input.Gamepad.get(ID) != null) {
			kha.input.Gamepad.get(ID).notify(onGamepadAxis.bind(ID), onGamepadButton.bind(ID));
		}
	}
	
    inline function onKeyDown(inputKey:KeyCode) {
			if (inputKey == KeyCode.S) {
				startDown[0] = true;
			}
			if (inputKey == KeyCode.K) {
				startDown[1] = true;
			}
			else if (inputKey == KeyCode.Q) {
				onInsert(0, true);
			}
			else if (inputKey == KeyCode.U) {
				onInsert(1, true);
			}
			else if (inputKey == KeyCode.E) {
			onInsert(0, false);
			}
			else if (inputKey == KeyCode.O) {
			onInsert(1, false);
			}
			else if (inputKey == KeyCode.A) {
			onPush(0, true);
			}
			else if (inputKey == KeyCode.J) {
			onPush(1, true);
			}
			else if (inputKey == KeyCode.D) {
			onPush(0, false);
			}
			else if (inputKey == KeyCode.L) {
			onPush(1, false);
			}
    }

    inline function onKeyUp(inputKey:KeyCode) {
			if (inputKey == KeyCode.S) {
				startDown[0] = false;
			}
			if (inputKey == KeyCode.K) {
				startDown[1] = false;
			}
    }
	
	inline function onGamepadAxis(padID: Int, axis: Int, value: Float) {
		//trace("[axis_" + padID + "] " + axis + ": " + value);
	}
	
	inline function onGamepadButton(padID: Int, button: Int, value: Float) {
		if (button == 0) {
			startDown[padID] = value > 0.75;
		}
		else if (button == 4 && value > TRIGGER_THRESHOLD) {
			onInsert(padID, true);
		}
		else if (button == 5 && value > TRIGGER_THRESHOLD) {
			onInsert(padID, false);
		}
		else if (button == 6 && value > TRIGGER_THRESHOLD) {
			onPush(padID, true);
		}
		else if (button == 7 && value > TRIGGER_THRESHOLD) {
			onPush(padID, false);
		}
		//trace("[button_" + padID + "] " + button + ": " + value);
	}
	
	private inline function onInsert(ID: Int, left: Bool) {
		rightSide[ID] = !left;
		leftSide[ID] = left;
		currentLeft[ID] = left;
		strenght[ID] = 0.0;
		time[ID] = Scheduler.time();
		kha.audio1.Audio.play(kha.Assets.sounds.insert);
	}
	
	private inline function onPush(ID: Int, left: Bool) {
		if (rightSide[ID] && !left || leftSide[ID] && left) {
			strenght[ID] = getCharge(ID);
			leftSide[ID] = false;
			rightSide[ID] = false;
			strenghtLeft[ID] = left;
			time[ID] = Math.NEGATIVE_INFINITY;
			kha.audio1.Audio.play(kha.Assets.sounds.pull);
		}
	}
	
	private inline function clamp(value: Float, min: Float, max: Float) {
		return Math.min(Math.max(value, min), max);
	}
}