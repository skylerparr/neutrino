package com.thoughtorigin.flash.loader;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.display.Sprite;
import flash.net.URLRequest;
import flash.display.Bitmap;

class LazyLoader extends Sprite, implements AssetLoader {

	private var _loader: Loader;

	public function new(): Void {
		super();
	}

	public function loadImage(url: String): Void {
		var request: URLRequest = new URLRequest(url);
		_loader = new Loader();
		addListeners();
		_loader.load(request);
		addChild(_loader);
	}

	private function onImageLoaded(e: Event): Void {
		var retVal: Bitmap = cast(_loader.content, Bitmap);
		retVal.smoothing = true;
		cleanListeners();
		dispatchEvent(new Event(Event.COMPLETE));
	}

	public inline function getContent(): Bitmap {
		var retVal: Bitmap = cast(_loader.content, Bitmap);
		retVal.smoothing = true;
		return retVal;
	}

	private function onImageFail(e: IOErrorEvent): Void {
		cleanListeners();
		trace(e.text);
	}

	private inline function addListeners(): Void {
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageFail);
		_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageFail);
	}

	private function cleanListeners(): Void {
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onImageFail);
		_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageFail);
	}
}

