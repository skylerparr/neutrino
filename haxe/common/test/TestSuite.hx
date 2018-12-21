import massive.munit.TestSuite;

import ExampleTest;
import navigation.ConfigurableStateManagerTest;
import vo.BoundValueObjectTest;
import service.MappedServiceLocatorTest;
import util.SerializerTest;
import util.ParserTest;
import util.MapSubscriberTest;

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
		add(vo.BoundValueObjectTest);
		add(service.MappedServiceLocatorTest);
		add(util.SerializerTest);
		add(util.ParserTest);
		add(util.MapSubscriberTest);
	}
}
