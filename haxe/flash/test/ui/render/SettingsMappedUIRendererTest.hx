package ui.render;

import ui.render.mock.MockModalActions;
import ui.render.mock.MockModalController;
import ui.render.mock.MockModalView;
import flash.display.Sprite;
import haxe.Json;
import massive.munit.Assert;
import flash.display.DisplayObject;
import core.ObjectCreator;
import mockatoo.Mockatoo;
import mockatoo.Mockatoo.*;

using mockatoo.Mockatoo;

class SettingsMappedUIRendererTest {

    private var _uiRenderer: TestableSettingsMappedUIRenderer;
    private var _objectCreator: ObjectCreator;

    public function new() {

    }

    @Before
    public function setup():Void {
        _uiRenderer = new TestableSettingsMappedUIRenderer();

        _objectCreator = mock(ObjectCreator);
        _uiRenderer.objectCreator = _objectCreator;

        _uiRenderer.modalData = mockModalData();
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldLoadTheModalSettingsFileAndCreateTheModalBasedOnTheSettings(): Void {
        _objectCreator.createInstance(cast any, cast any).returns(new Sprite());
        var renderedView: DisplayObject = null;
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
            renderedView = view;
        });
        Assert.isNotNull(renderedView);
    }

    @Test
    public function shouldReturnNullViewIfViewNotFound(): Void {
        _objectCreator.createInstance(cast any, cast any).returns(null);
        var renderedView: DisplayObject = null;
        var callbackCalled: Bool = false;
        _uiRenderer.renderView("view123", function(view: DisplayObject): Void {
            renderedView = view;
            callbackCalled = true;
        });
        Assert.isNull(renderedView);
        Assert.isFalse(callbackCalled);
    }
    
    @Test
    public function shouldCreateAControllerAndActionClassByDefault(): Void {
        _objectCreator.createInstance(MockModalView, cast any).returns(new MockModalView());
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
        });
        Assert.isTrue(_objectCreator.createInstance(MockModalActions, cast any).verify());
        Assert.isTrue(_objectCreator.createInstance(MockModalController, cast any).verify());
        Assert.isTrue(_objectCreator.createInstance(MockModalView, cast any).verify());
    }

    @Test
    public function shouldAssignControllerAndActionsIfFieldsExistOnView(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
        });
        Assert.areEqual(controller, view.controller);
        Assert.areEqual(actions, view.actions);
    }

    @Test
    public function shouldAssignAssignControllerAndViewToActionsIfFieldExists(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
        });
        Assert.areEqual(controller, actions.controller);
        Assert.areEqual(view, actions.view);
    }

    @Test
    public function shouldAssignViewAndActionsToControllerIfFieldsExists(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
        });
        Assert.areEqual(actions, controller.actions);
        Assert.areEqual(view, controller.view);
    }

    @Test
    public function shouldDisposeAllObjectCounterParts(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
        });
        var cbCalled: Bool = false;
        _uiRenderer.dispose(view, function(): Void {
            cbCalled = true;
        });
        Assert.isTrue(view.disposed);
        Assert.isTrue(controller.disposed);
        Assert.isTrue(actions.disposed);
    }

    @Test
    public function shouldNotThrowExceptionIfDisposeFunctionIsNull(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {
        });
        _uiRenderer.dispose(view, null);
    }

    @Test
    public function shouldNotThrowExceptionIfOnCompleteFunctionIsNull(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", null);
    }

    @Test
    public function shouldCallRenderOnViewIfViewIsRenderable(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {});
        Assert.isTrue(view.rendered);
    }

    @Test
    public function shouldCallSetupOnTheController(): Void {
        var view: MockModalView = new MockModalView();
        var controller: MockModalController = new MockModalController();
        var actions: MockModalActions = new MockModalActions();
        _objectCreator.createInstance(MockModalView, cast any).returns(view);
        _objectCreator.createInstance(MockModalController, cast any).returns(controller);
        _objectCreator.createInstance(MockModalActions, cast any).returns(actions);
        _uiRenderer.renderView("view1", function(view: DisplayObject): Void {});
        Assert.isTrue(controller.isSetup);
    }

    private inline function mockModalData(): String {
        new MockModalView();
        new MockModalController();
        new MockModalActions();
        return Json.stringify({"modals":[
        {"name": "view1", "map": "ui.render.mock.MockModal"}
        ]});
    }
}

class TestableSettingsMappedUIRenderer extends SettingsMappedUIRenderer {
    public var modalData: String;

    public function new() {
        super();
    }

    override public function getModalData(): String {
        return modalData;
    }
}