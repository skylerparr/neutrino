package util;

import vo.ValueObject;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class SerializerTest {


    public function new() {

    }

    @Before
    public function setup():Void {
    }

    @After
    public function tearDown():Void {
    }

    @Test
    public function shouldSerializeStrings(): Void {
        var s: Sample1 = new Sample1();
        s.name = "foo";
        var o: Dynamic = Serializer.serialize(s);
        Assert.areEqual("foo", o.name);
    }

    @Test
    public function shouldSerializeInts(): Void {
        var s: Sample2 = new Sample2();
        s.count = 100;
        var o: Dynamic = Serializer.serialize(s);
        Assert.areEqual(100, o.count);
    }

    @Test
    public function shouldSerializeNestValueObjects(): Void {
        var s1: Sample1 = new Sample1();
        s1.name = "foo";
        var s2: Sample2 = new Sample2();
        s2.count = 100;
        var s4: Sample4 = new Sample4();
        s4.s1 = s1;
        var s3: Sample3 = new Sample3();
        s3.id = "39";
        s3.s4 = s4;
        s3.s2 = s2;
        var o: Dynamic = Serializer.serialize(s3);
        Assert.areEqual("39", o.id);
        Assert.areEqual("foo", o.s4.s1.name);
        Assert.areEqual(100, o.s2.count);
    }

    @Test
    public function shouldNotIncludeAValueIfItIsNull(): Void {
        var s2: Sample2 = new Sample2();
        s2.count = 100;
        var s3: Sample3 = new Sample3();
        s3.id = "39";
        s3.s4 = null;
        s3.s2 = s2;
        var o: Dynamic = Serializer.serialize(s3);
        Assert.areEqual("39", o.id);
        Assert.areEqual(null, o.s4);
    }

    @Test
    public function shouldNotIncludeAValueIfItIsWriteOnly(): Void {
        var s1: Sample1 = new Sample1();
        var s4: Sample4 = new Sample4();
        s4.s1 = s1;
        var o: Dynamic = Serializer.serialize(s4);
        Assert.areEqual(null, o.value);
    }

    @Test
    public function shouldDeserializeToTheRightType(): Void {
        var s: Sample1 = new Sample1();
        s.name = "foo";
        var o: Dynamic = Serializer.serialize(s);
        var r: Sample1 = Serializer.deserialize(o);
        Assert.areEqual("foo", r.name);
    }

    @Test
    public function shouldDeserializeNestedValueObjects(): Void {
        var s1: Sample1 = new Sample1();
        s1.name = "foo";
        var s2: Sample2 = new Sample2();
        s2.count = 100;
        var s4: Sample4 = new Sample4();
        s4.s1 = s1;
        var s3: Sample3 = new Sample3();
        s3.id = "39";
        s3.s4 = s4;
        s3.s2 = s2;
        var o: Dynamic = Serializer.serialize(s3);
        var r: Sample3 = Serializer.deserialize(o);
        Assert.areEqual("39", r.id);
        Assert.areEqual("foo", r.s4.s1.name);
        Assert.areEqual(100, r.s2.count);
    }

    @Test
    public function shouldNotFailIfValueIsReadOnly(): Void {
        var s1: Sample1 = new Sample1();
        var s4: Sample4 = new Sample4();
        s4.s1 = s1;
        var o: Dynamic = Serializer.serialize(s4);
        var r: Sample4 = Serializer.deserialize(o);
        Assert.areEqual(null, r.value2);
    }

    @Test
    public function shouldSerializeArrays(): Void {
        var s5: Sample5 = new Sample5();
        s5.array.push("1");
        s5.array.push("2");
        s5.array.push("3");
        var o: Dynamic = Serializer.serialize(s5);
        Assert.areEqual("1", o.array[0]);
        Assert.areEqual("2", o.array[1]);
        Assert.areEqual("3", o.array[2]);
    }

    @Test
    public function shouldSerializeArraysWithNestValueObjects(): Void {
        var s5: Sample5 = new Sample5();
        var s1: Sample1 = new Sample1();
        s1.name = "foo1";
        s5.array.push(s1);
        var s1: Sample1 = new Sample1();
        s1.name = "foo2";
        s5.array.push(s1);
        var s1: Sample1 = new Sample1();
        s1.name = "foo3";
        s5.array.push(s1);
        var o: Dynamic = Serializer.serialize(s5);
        Assert.areEqual("foo1", o.array[0].name);
        Assert.areEqual("foo2", o.array[1].name);
        Assert.areEqual("foo3", o.array[2].name);
    }

    @Test
    public function shouldDeserializeArrays(): Void {
        var s5: Sample5 = new Sample5();
        var s1: Sample1 = new Sample1();
        s1.name = "foo1";
        s5.array.push(s1);
        var s1: Sample1 = new Sample1();
        s1.name = "foo2";
        s5.array.push(s1);
        var s1: Sample1 = new Sample1();
        s1.name = "foo3";
        s5.array.push(s1);
        var o: Dynamic = Serializer.serialize(s5);
        var s: Sample5 = Serializer.deserialize(o);
        Assert.areEqual("foo1", s.array[0].name);
        Assert.areEqual("foo2", s.array[1].name);
        Assert.areEqual("foo3", s.array[2].name);
    }

    @Test
    public function shouldNotSerializeNonValueObjects(): Void {
        var s5: Sample5 = new Sample5();
        var s6: Sample6 = new Sample6();
        s5.s6 = s6;
        var o: Dynamic = Serializer.serialize(s5);
        Assert.areEqual(null, o.s6);
    }

    @Test
    public function shouldBeAbleToPutNullsIntoArrays(): Void {
        var s5: Sample5 = new Sample5();
        s5.array.push(null);
        s5.array.push(null);
        s5.array.push(null);
        var o: Dynamic = Serializer.serialize(s5);
        Assert.areEqual(null, o.array[0]);
        Assert.areEqual(null, o.array[1]);
        Assert.areEqual(null, o.array[2]);
    }

    @Test
    public function shouldBeAbleToDeserializeAndPutNullsIntoArrays(): Void {
        var s5: Sample5 = new Sample5();
        s5.array.push(null);
        s5.array.push(null);
        s5.array.push(null);
        var o: Dynamic = Serializer.serialize(s5);
        var v: Sample5 = Serializer.deserialize(o);
        Assert.areEqual(null, v.array[0]);
        Assert.areEqual(null, v.array[1]);
        Assert.areEqual(null, v.array[2]);
    }

    @Test
    public function shouldNotAssignToAFieldThatDoesNotExist(): Void {
        var data: Dynamic = {__type: "util.Sample1", name:"couch", value: [{foo: "bar"}]};
        var v: Sample1 = Serializer.deserialize(data);
        Assert.isNotNull(v);
    }

    @Test
    public function shouldPopulateArrayOfArray(): Void {
        var data: Dynamic = {__type: "util.Sample1", name:"couch", cats:[[{__type:"util.Sample2", count: 2},{__type:"util.Sample2", count: 4}]]};
        var v: Sample1 = Serializer.deserialize(data);
        Assert.areEqual(2, v.cats[0].length);
        var d: Dynamic = v.cats;
        Assert.isTrue(Std.is(d, Array));
        d = d[0];
        Assert.isTrue(Std.is(d, Array));
        d = d[0];
        Assert.areEqual(2, v.cats[0][0].count);

        var d: Dynamic = v.cats;
        d = d[0];
        Assert.isTrue(Std.is(d, Array));
        d = d[1];
        Assert.isNotNull(d);
        Assert.areEqual(4, v.cats[0][1].count);
    }

    @Test
    public function shouldSerializeArrayOfArray(): Void {
        var data: Dynamic = {__type: "util.Sample1", name:"couch", cats:[[{__type:"util.Sample2", count: 2},{__type:"util.Sample2", count: 4}]]};
        var v: Sample1 = Serializer.deserialize(data);
        var v: Dynamic = Serializer.serialize(v);
        var d: Dynamic = v.cats;
        Assert.isTrue(Std.is(d, Array));
        d = d[0];
        Assert.isTrue(Std.is(d, Array));
        d = d[0];
        Assert.areEqual(2, v.cats[0][0].count);

        var d: Dynamic = v.cats;
        d = d[0];
        Assert.isTrue(Std.is(d, Array));
        d = d[1];
        Assert.isNotNull(d);
        Assert.areEqual(4, v.cats[0][1].count);
    }

    @Test
    public function shouldSerializeDates(): Void {
        var data: Sample7 = new Sample7();
        data.fooDate = Date.fromTime(984375298);
        var v: Dynamic = Serializer.serialize(data);
        Assert.areEqual(Date.fromTime(984375298).getTime(), v.fooDate.getTime());
    }

    @Test
    public function shouldDeSerializeDates(): Void {
        var data: Sample7 = new Sample7();
        data.fooDate = Date.fromTime(984375298);
        var v: Dynamic = Serializer.serialize(data);
        data = cast Serializer.deserialize(v);
        Assert.areEqual(Date.fromTime(984375298).getTime(), data.fooDate.getTime());
    }

    @Test
    public function shouldNotFailWhenAssigningToFieldThatDoesNotExist(): Void {
        var data: Sample1 = new Sample1();
        var v: Dynamic = Serializer.serialize(data);
        v.password = "aksdfj";
        data = cast Serializer.deserialize(v);
        Assert.isNotNull(data);
    }
}

class Sample1 implements ValueObject {
    public var name(default, set): String;
    public var cats: Array<Array<Sample2>>;

    public function new() {

    }

    private function set_name(value:String):String {
        name = value;
        return name;
    }
}

class Sample2 implements ValueObject {
    public var count: Int;

    public function new() {

    }
}

class Sample3 implements ValueObject {
    public var id: String;
    public var s4: Sample4;
    public var s2: Sample2;
    public function new() {

    }
}

class Sample4 implements ValueObject {
    public var s1: Sample1;
    public var value(null, set): String;
    public var value2(get, null): String;

    public function new() {}
    private function set_value(v: String): String {
        value = v;
        return v;
    }
    private function get_value2(): String {
        return value2;
    }
}

class Sample5 implements ValueObject {
    public var array: Array<Dynamic>;
    public var s6: Sample6;
    public function new() {
        array = new Array();
    }
}

class Sample6 {
    public var foo: String;
    public function new() {}
}

class Sample7 {
    public var fooDate: Date;
    public function new() {}
}