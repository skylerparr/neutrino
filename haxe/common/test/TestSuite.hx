import massive.munit.TestSuite;

import ExampleTest;
import navigation.ConfigurableStateManagerTest;
import service.MappedServiceLocatorTest;
import util.MapSubscriberTest;
import util.SerializerTest;
import vo.BoundValueObjectTest;

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
		add(navigation.ConfigurableStateManagerTest);
		add(service.MappedServiceLocatorTest);
		add(util.MapSubscriberTest);
		add(util.SerializerTest);
		add(vo.BoundValueObjectTest);
	}
}
