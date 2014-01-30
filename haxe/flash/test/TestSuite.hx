import massive.munit.TestSuite;

import auth.DataLoadApplicationAuthenticationTest;
import display.containers.ContainerTest;
import ExampleTest;
import navigation.DictionaryModalManagerTest;
import ui.layer.BasicLayerManagerTest;
import ui.render.SettingsMappedUIRendererTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(auth.DataLoadApplicationAuthenticationTest);
		add(display.containers.ContainerTest);
		add(ExampleTest);
		add(navigation.DictionaryModalManagerTest);
		add(ui.layer.BasicLayerManagerTest);
		add(ui.render.SettingsMappedUIRendererTest);
	}
}
