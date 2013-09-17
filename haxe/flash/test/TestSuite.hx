import massive.munit.TestSuite;

import ExampleTest;
import navigation.DictionaryModalManagerTest;
import signal.NoArgSignalFactoryTest;
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

		add(ExampleTest);
		add(navigation.DictionaryModalManagerTest);
		add(signal.NoArgSignalFactoryTest);
		add(ui.layer.BasicLayerManagerTest);
		add(ui.render.SettingsMappedUIRendererTest);
	}
}
