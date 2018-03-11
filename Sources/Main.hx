package;

import kha.System;
import kha.input.Mouse;

class Main 
{
	public static var width = 1280;
	public static var height = 720;
	public static var title = 'khajak';
//	public static var app = new KhajakTest();
	public static var app:KhajakTest;

	public static inline function main():Void 
	{
		System.init({title: title, width: width, height: height}, init);
	}

	static inline function init():Void 
	{
		//Mouse.get().notify(onMouseDown, onMouseDown, null, null);
		app = new KhajakTest();
		System.notifyOnRender(app.render);
	}
}

