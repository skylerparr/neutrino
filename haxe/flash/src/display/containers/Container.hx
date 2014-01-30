package display.containers;

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

class Container extends Sprite {
    public var rawNumChildren(get, null): Int;

    public var rawChildContainer: Sprite;

    public function new() {
        super();
        init();
    }

    public function init(): Void {
        rawChildContainer = new Sprite();
        super.addChild(rawChildContainer);
    }

    override public function addChild(child:DisplayObject):DisplayObject {
        var retVal: DisplayObject = rawChildContainer.addChild(child);
        dispatchEvent(new ContainerEvent(ContainerEvent.RAW_CHILDREN_CHANGE, retVal, this));
        return retVal;
    }

    override public function addChildAt(child:DisplayObject, index:Int):DisplayObject {
        var retVal: DisplayObject = rawChildContainer.addChildAt(child, index);
        dispatchEvent(new ContainerEvent(ContainerEvent.RAW_CHILDREN_CHANGE, retVal, this));
        return retVal;
    }

    override public function getChildAt(index:Int):DisplayObject {
        return rawChildContainer.getChildAt(index);
    }

    override public function removeChild(child:DisplayObject):DisplayObject {
        var retVal: DisplayObject = rawChildContainer.removeChild(child);
        dispatchEvent(new ContainerEvent(ContainerEvent.RAW_CHILDREN_CHANGE, retVal, this));
        return retVal;
    }

    override public function removeChildAt(index:Int):DisplayObject {
        var retVal: DisplayObject = rawChildContainer.removeChildAt(index);
        dispatchEvent(new ContainerEvent(ContainerEvent.RAW_CHILDREN_CHANGE, retVal, this));
        return retVal;
    }

    override public function getChildIndex(child:DisplayObject):Int {
        return rawChildContainer.getChildIndex(child);
    }

    override public function setChildIndex(child:DisplayObject, index:Int):Void {
        rawChildContainer.setChildIndex(child, index);
    }

    override public function getChildByName(name:String):DisplayObject {
        return rawChildContainer.getChildByName(name);
    }

    override public function contains(child:DisplayObject):Bool {
        return rawChildContainer.contains(child);
    }

    override public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void {
        rawChildContainer.swapChildren(child1, child2);
        dispatchEvent(new ContainerEvent(ContainerEvent.RAW_CHILDREN_CHANGE, null, this));
    }

    override public function swapChildrenAt(index1:Int, index2:Int):Void {
        rawChildContainer.swapChildrenAt(index1, index2);
        dispatchEvent(new ContainerEvent(ContainerEvent.RAW_CHILDREN_CHANGE, null, this));
    }

    public function getrawChildContainer(): DisplayObjectContainer {
        return rawChildContainer;
    }

    public function addRawChild(value: DisplayObject): DisplayObject {
        return super.addChild(value);
    }

    public function addRawChildAt(value: DisplayObject, index: Int): DisplayObject {
        return super.addChildAt(value, index);
    }

    public function removeRawChild(value: DisplayObject): DisplayObject {
        return super.removeChild(value);
    }

    public function get_rawNumChildren(): Int {
        return super.numChildren;
    }

    public function removeRawChildAt(index:Int):DisplayObject {
        return super.removeChildAt(index);
    }

    public function getRawChildAt(index:Int):DisplayObject {
        return super.getChildAt(index);
    }

    public function rawContains(child:DisplayObject): Bool {
        return super.contains(child);
    }

    public function recalculateBounds(): Void {
        dispatchEvent(new ContainerEvent(ContainerEvent.RECALCULATE_BOUNDS, null, this));
    }

    #if cpp
    override public function get_numChildren(): Int {
        return rawChildContainer.numChidren;
    }
    #elseif flash
    @:getter(numChildren)
    public function get_numChildren():Int {
        return rawChildContainer.numChildren;
    }
    #end


}
