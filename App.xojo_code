#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  RunSimpleTest()
		  
		  RunCustomSerializerTest()
		  
		  RunSerializeHierarchy()
		  
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function myCustomDeserializer(propInfo as Introspection.PropertyInfo, v as Variant) As variant
		  Select Case propInfo.Name
		    
		  Case "WhatDate"
		    
		    Return New DateTime( v.DoubleValue )
		    
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function myCustomSerializer(propInfo as Introspection.PropertyInfo, v as Variant) As Variant
		  Select Case propInfo.Name
		    
		  Case "WhatDate"
		    
		    Return Format( DateTime(v).SecondsFrom1970, "#############0.0000000000000000")
		    
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunCustomSerializerTest()
		  
		  // create the serializer instance
		  Dim serializer As New JSONSerializer
		  
		  // add suitable serializers and deserializers for custom handling
		  
		  serializer.AddCustomSerializer("DateTime", AddressOf myCustomSerializer)
		  serializer.AddCustomDeserializer("DateTime", AddressOf myCustomDeserializer)
		  
		  // create a Weather Forecast
		  Dim wf As New WeatherForecastWithPropertyName
		  
		  wf.WhatDate = DateTime.Now
		  wf.Summary = "foo"
		  wf.TemperatureCelsius = 9
		  wf.WindSpeed = 18
		  
		  // serialize the forcast object
		  Dim s As String = serializer.Serialize( wf ) 
		  
		  System.debuglog s
		  
		  // deserialize the serialized for into a new object
		  Dim wf1 As WeatherForecastWithPropertyName = serializer.Deserialize(s,  GetTypeInfo(WeatherForecastWithPropertyName) )
		  
		  // and see that we get back what we serialized
		  // note that the custom serializer / deserializer used here preserves the SecondsFrom1970
		  If wf.WhatDate.SecondsFrom1970 <> wf1.WhatDate.SecondsFrom1970 Then
		    Break
		  End If
		  If wf.Summary <> wf1.Summary Then
		    Break
		  End If
		  If wf.TemperatureCelsius <> wf1.TemperatureCelsius Then
		    Break
		  End If
		  If wf.WindSpeed <> wf1.WindSpeed Then
		    Break
		  End If
		  
		  serializer.RemoveCustomSerializer("DateTime", AddressOf myCustomSerializer)
		  serializer.RemoveCustomDeserializer("DateTime", AddressOf myCustomDeserializer)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunSerializeHierarchy()
		  
		  // create the serializer instance
		  Dim serializer As New JSONSerializer
		  
		  // add suitable serializers and deserializers for custom handling
		  // we add Class2 since we can serialize most of Class1 without help but for the Class2 instance we need to do something special 
		  serializer.AddCustomSerializer("Class2", AddressOf Class2.CustomSerializer)
		  
		  // create an instance
		  Dim c1 As New Class1
		  c1.name = "testclass1"
		  c1.c2 = New Class2
		  c1.c2.name = "testclass2"
		  c1.c2.c3 = New class3
		  c1.c2.c3.name = "testclass3"
		  
		  // serialize 
		  Dim s As String = serializer.Serialize( c1 ) 
		  
		  System.debuglog s
		  
		  
		  // now deserialize from what we just serialized
		  serializer = New JSONSerializer
		  
		  serializer.AddCustomDeserializer("Class2", AddressOf Class2.CustomDeSerializer)
		  
		  // deserialize the serialized for into a new object
		  Dim cDeserialized As Class1 = serializer.Deserialize(s,  GetTypeInfo(Class1) )
		  
		  // and see that we get back what we serialized
		  // NOTE you cant compare INSTANCES for being the same since deserialization
		  // creates new ones
		  // IF you implemented the custom operator_compare method on your classes then you could test that way
		  // see https://documentation.xojo.com/api/language/operators/operator_overloads/operator_compare.html#operator-compare
		  // and see if they had the same contents
		  
		  If (cDeserialized IsA Class1) = False Then 
		    Break
		  End If
		  
		  If cDeserialized.name <> "testclass1" Then
		    Break
		  End If
		  
		  If (cDeserialized.c2 IsA Class2) <> True Then
		    Break
		  End If
		  
		  If cDeserialized.c2.name <> "testclass2" Then
		    Break
		  End If
		  
		  If (cDeserialized.c2.c3 IsA Class3) <> True Then
		    Break
		  End If
		  
		  If cDeserialized.c2.c3.name <> "testclass3" Then
		    Break
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunSimpleTest()
		  
		  // create the serializer instance
		  Dim serializer As New JSONSerializer
		  
		  // NO custom serilzation / deserialization handling 
		  
		  // create a weather forecast instance
		  Dim wf As New WeatherForecastWithPropertyName
		  
		  wf.WhatDate = DateTime.Now
		  wf.Summary = "foo"
		  wf.TemperatureCelsius = 9
		  wf.WindSpeed = 18
		  
		  // serialize it
		  Dim s As String = serializer.Serialize( wf ) 
		  
		  system.debuglog s
		  
		  // deserialize it
		  Dim wf1 As WeatherForecastWithPropertyName = serializer.Deserialize(s,  GetTypeInfo(WeatherForecastWithPropertyName) )
		  
		  // note that the DEFAULT SERIALIZER / DESERIALIZER will restore the SQLDATETIME but not SecondsFrom1970 
		  // if you need to preserve it precisely use a custom serializer / deseriaizer that saves the SecondsFrom1970 value 
		  // and NOT the default SQLDateTime
		  // see RunCustomSerializeTest
		  
		  If wf.WhatDate.SQLDateTime <> wf1.WhatDate.SQLDateTime Then
		    Break
		  End If
		  If wf.Summary <> wf1.Summary Then
		    Break
		  End If
		  If wf.TemperatureCelsius <> wf1.TemperatureCelsius Then
		    Break
		  End If
		  If wf.WindSpeed <> wf1.WindSpeed Then
		    Break
		  End If
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
