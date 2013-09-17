package navigation;

import ui.render.UIRenderer;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.display.DisplayObject;
import core.ObjectCreator;
import massive.munit.Assert;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.* ;

using mockatoo.Mockatoo;

class DictionaryModalManagerTest {

    private var _modalManager: DictionaryModalManager;
    private var _uiRenderer: UIRenderer;
    private var _dialogLayer: Sprite;
    private var _shadeLayer: Sprite;

    public function new() {
    }

    @Before
    public function setup():Void {
        _modalManager = new DictionaryModalManager();
        _uiRenderer = mock(UIRenderer);

        _modalManager.uiRenderer = _uiRenderer;

        _dialogLayer = new Sprite();
        _modalManager.dialogLayer = _dialogLayer;
        _shadeLayer = new Sprite();
        _modalManager.shadeLayer = _shadeLayer;
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldOpenModalByName(): Void {
        var viewName: String = "viewName";
        var view: DisplayObject = setupRenderView(viewName);
        _modalManager.openModal(viewName);
        Assert.areEqual(1, _dialogLayer.numChildren);
        Assert.areEqual(view, _modalManager.viewNameMap.get(viewName));
    }

    @Test
    public function shouldCloseTheModalByName(): Void {
        var viewName: String = "view";
        var view: DisplayObject = setupRenderView(viewName);
        _modalManager.openModal(viewName);
        _modalManager.closeModal(viewName);
        Assert.areEqual(0, _dialogLayer.numChildren);
        Assert.isNull(_modalManager.viewNameMap.get(viewName));
    }

    @Test
    public function shouldNotThrowExceptionIfViewIsNotFoundToClose(): Void {
        var viewName: String = "view";
        var view: DisplayObject = setupRenderView(viewName);
        _modalManager.closeModal(viewName);
    }

    @Test
    public function shouldAppendAnyNumberOfModals(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        var view2: DisplayObject = setupRenderView("view2");
        var view3: DisplayObject = setupRenderView("view3");
        _modalManager.appendModal("view1");
        _modalManager.appendModal("view2");
        _modalManager.appendModal("view3");
        Assert.areEqual(3, _dialogLayer.numChildren);
        Assert.areEqual(view1, _dialogLayer.getChildAt(0));
        Assert.areEqual(view2, _dialogLayer.getChildAt(1));
        Assert.areEqual(view3, _dialogLayer.getChildAt(2));
        Assert.areEqual(view1, _modalManager.viewNameMap.get("view1"));
        Assert.areEqual(view2, _modalManager.viewNameMap.get("view2"));
        Assert.areEqual(view3, _modalManager.viewNameMap.get("view3"));
    }

    @Test
    public function shouldNotAddDisplayToDialogLayerIfUIRenderReturnsANullView(): Void {
        _uiRenderer.renderView(cast any, cast any).calls(function(args: Array<Dynamic>): Void {
            args[1](null);
        });
        _modalManager.appendModal("view1");
        Assert.areEqual(0, _dialogLayer.numChildren);
        Assert.isNull(_modalManager.viewNameMap.get("view1"));
    }

    @Test
    public function shouldCloseAllOpenModals(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        var view2: DisplayObject = setupRenderView("view2");
        var view3: DisplayObject = setupRenderView("view3");
        _modalManager.appendModal("view1");
        _modalManager.appendModal("view2");
        _modalManager.appendModal("view3");
        _modalManager.closeAllModals();
        Assert.areEqual(0, _dialogLayer.numChildren);
    }

    @Test
    public function shouldCloseAllFirstWhenOpeningAModal(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        var view2: DisplayObject = setupRenderView("view2");
        var view3: DisplayObject = setupRenderView("view3");
        _modalManager.appendModal("view1");
        _modalManager.appendModal("view2");
        _modalManager.appendModal("view3");
        var view4: DisplayObject = setupRenderView("view4");
        _modalManager.openModal("view4");
        Assert.areEqual(1, _dialogLayer.numChildren);
        Assert.areEqual(view4, _modalManager.viewNameMap.get("view4"));
    }

    @Test
    public function shouldAddShadeLayerThatBlocksUserInput(): Void {
        var viewName: String = "viewName";
        var view: DisplayObject = setupRenderView(viewName);
        Assert.areEqual(0, _shadeLayer.numChildren);
        _modalManager.openModal(viewName);
        Assert.areEqual(1, _shadeLayer.numChildren);
    }

    @Test
    public function shouldRemoveShadeLayerIfThereAreNoModalsShowing(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        var view2: DisplayObject = setupRenderView("view2");
        var view3: DisplayObject = setupRenderView("view3");
        _modalManager.appendModal("view1");
        _modalManager.appendModal("view2");
        _modalManager.appendModal("view3");
        Assert.areEqual(1, _shadeLayer.numChildren);
        _modalManager.closeModal("view1");
        Assert.areEqual(1, _shadeLayer.numChildren);
        _modalManager.closeModal("view2");
        Assert.areEqual(1, _shadeLayer.numChildren);
        _modalManager.closeModal("view3");
        Assert.areEqual(0, _shadeLayer.numChildren);
    }

    @Test
    public function shouldOpenContextualModalButAddMouseEventToShadeLayer(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        _modalManager.openContextualMenu("view1");
        Assert.isTrue(_shadeLayer.getChildAt(0).hasEventListener(MouseEvent.CLICK));
    }

    @Test
    public function shouldCloseTheContextualModalAndRemoveTheShadeLayerMouseListener(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        _modalManager.openContextualMenu("view1");
        var shadeChild: DisplayObject = _shadeLayer.getChildAt(0);
        _modalManager.closeContextualMenu();
        Assert.areEqual(0, _shadeLayer.numChildren);
        Assert.isFalse(shadeChild.hasEventListener(MouseEvent.CLICK));
    }

    @Test
    public function shouldCloseContextualMenuIfShadeLayerIsClicked(): Void {
        var view1: DisplayObject = setupRenderView("view1");
        _modalManager.openContextualMenu("view1");
        var shadeChild: DisplayObject = _shadeLayer.getChildAt(0);
        shadeChild.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        Assert.areEqual(0, _shadeLayer.numChildren);
        Assert.isFalse(shadeChild.hasEventListener(MouseEvent.CLICK));
    }

    @Test
    public function shouldDisposeViewWhenClosing(): Void {
        var viewName: String = "view";
        var view: DisplayObject = setupRenderView(viewName);
        _modalManager.openModal(viewName);
        _modalManager.closeModal(viewName);
        Assert.isTrue(_uiRenderer.dispose(view, cast any).verify());
    }

    @Test
    public function shouldNotAddShadeChildEventListenerOnNonContextualModal(): Void {
        var viewName: String = "viewName";
        var view: DisplayObject = setupRenderView(viewName);
        _modalManager.openModal(viewName);
        var shadeChild: DisplayObject = _shadeLayer.getChildAt(0);
        Assert.isFalse(shadeChild.hasEventListener(MouseEvent.CLICK));
    }

    private inline function setupRenderView(viewName: String): DisplayObject {
        var view: Sprite = new Sprite();
        _uiRenderer.renderView(viewName, cast any).calls(function(args: Array<Dynamic>): Void {
            args[1](view);
        });
        return view;
    }
}