#tag Class
Protected Class JSONSerializer
	#tag Method, Flags = &h0, Description = 4120637573746F6D65722073657269616C697A657220666F7220746865206E616D656420747970650A596F75206861766520746F20706173732074686520586F6A6F2074797065206173206120535452494E472073696E636520586F6A6F20646F65736E742070726F7065726C792068616E646C6520496E74726F7370656374696F6E2E54797065696E666F20666F7220696E7472696E7369632074797065730A546865207061737365642064656C656761746520676574732063616C6C656420746F2073657269616C697A6520746865207479706520756E74696C2069742069732072656D6F766564
		Sub AddCustomDeserializer(typename as string, deserializer as CustomPropertyDeserializer)
		  If mCustomDeserializers Is Nil Then
		    mCustomDeserializers = New Dictionary
		  End If
		  
		  mCustomDeserializers.value( typename ) = deserializer
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4120637573746F6D65722073657269616C697A657220666F7220746865206E616D656420747970650A596F75206861766520746F20706173732074686520586F6A6F2074797065206173206120535452494E472073696E636520586F6A6F20646F65736E742070726F7065726C792068616E646C6520496E74726F7370656374696F6E2E54797065696E666F20666F7220696E7472696E7369632074797065730A546865207061737365642064656C656761746520676574732063616C6C656420746F2073657269616C697A6520746865207479706520756E74696C2069742069732072656D6F766564
		Sub AddCustomSerializer(typename as string, serializer as CustomPropertySerializer)
		  If mCustomSerializers Is Nil Then
		    mCustomSerializers = New Dictionary
		  End If
		  
		  mCustomSerializers.value( typename ) = serializer
		  
		  
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function CustomPropertyDeserializer(propInfo as Introspection.PropertyInfo, v as Variant) As variant
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function CustomPropertySerializer(propInfo as Introspection.PropertyInfo, v as Variant) As Variant
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function Deserialize(jsonString as string, returntype as Introspection.TypeInfo) As Variant
		  If returntype Is Nil Then
		    Return Nil
		  End If
		  
		  // find the no param constructor
		  Dim cons() As Introspection.ConstructorInfo = returntype.GetConstructors
		  
		  Dim v As Variant
		  
		  For Each con As Introspection.ConstructorInfo In cons
		    
		    Dim cons_params() As introspection.ParameterInfo = con.GetParameters()
		    
		    If cons_params.Count = 0 Then
		      v = con.Invoke()
		      Exit For
		    End If
		  Next
		  
		  If v Is Nil Then
		    Return Nil
		  End If
		  
		  Try
		    Dim j As New jsonitem(jsonString)
		    
		    // we only serialized PUBLIC properties
		    
		    Dim propInfos() As Introspection.PropertyInfo = returntype.GetProperties
		    
		    For Each propInfo As Introspection.PropertyInfo In propInfos
		       
		      If propInfo.IsPublic = False Then
		        Continue
		      End If
		       
		      Dim attrs() As Introspection.AttributeInfo = propInfo.GetAttributes
		      
		      Dim jSONPropName As String = propInfo.Name
		      For Each attr As Introspection.AttributeInfo In attrs
		        
		        If attr.Name = "JsonPropertyName" Then
		          jSONPropName = attr.Value
		          Exit For
		        End If
		      Next
		      
		      
		      Try
		        propInfo.Value(v) = j.Value(jSONPropName) 
		      Catch 
		        Dim customHandler As CustomPropertyDeserializer 
		        If mCustomDeserializers <> Nil Then
		          customHandler = mCustomDeserializers.Lookup(propInfo.PropertyType.Name, Nil) 
		        End If
		        If customHandler <> Nil Then
		          propInfo.Value(v) = customHandler.Invoke( propInfo, j.Value(jSONPropName) )
		        Else
		          // make sure we handle some things by default like DATE & DATETIME
		          Select Case propInfo.PropertyType.Name
		          Case "DateTime"
		            propInfo.Value(v) = DateTime.FromString( j.Value(jSONPropName) )
		          End Select
		          
		        End If
		      End Try
		      
		     Next
		    
		    Return v
		    
		  Catch jex As JSONException
		    break
		    Return Nil
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4120637573746F6D65722073657269616C697A657220666F7220746865206E616D656420747970650A596F75206861766520746F20706173732074686520586F6A6F2074797065206173206120535452494E472073696E636520586F6A6F20646F65736E742070726F7065726C792068616E646C6520496E74726F7370656374696F6E2E54797065696E666F20666F7220696E7472696E7369632074797065730A546865207061737365642064656C656761746520676574732063616C6C656420746F2073657269616C697A6520746865207479706520756E74696C2069742069732072656D6F766564
		Sub RemoveCustomDeserializer(typename as string, serializer as CustomPropertyDeserializer)
		  If mCustomDeserializers Is Nil Then
		    return
		  End If
		  
		  mCustomDeserializers.Remove( typename ) 
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4120637573746F6D65722073657269616C697A657220666F7220746865206E616D656420747970650A596F75206861766520746F20706173732074686520586F6A6F2074797065206173206120535452494E472073696E636520586F6A6F20646F65736E742070726F7065726C792068616E646C6520496E74726F7370656374696F6E2E54797065696E666F20666F7220696E7472696E7369632074797065730A546865207061737365642064656C656761746520676574732063616C6C656420746F2073657269616C697A6520746865207479706520756E74696C2069742069732072656D6F766564
		Sub RemoveCustomSerializer(typename as string, serializer as CustomPropertySerializer)
		  If mCustomSerializers Is Nil Then
		    return
		  End If
		  
		  mCustomSerializers.Remove( typename ) 
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetCustomizations()
		  mCustomSerializers = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Serialize(instance as Variant) As String
		  Dim tinfo As Introspection.TypeInfo = Introspection.GetType(instance)
		  
		  // we only serialize PUBLIC properties
		  
		  // properties get serialized as their name UNLESS they have a JsonPropertyName attribute
		  // public class WeatherForecastWithPropertyName
		  //   Public DateTimeOffset Date
		  //   Public int TemperatureCelsius { get; set; }
		  //   Public string? Summary { get; set; }
		  //   Attributes("JsonPropertyName" ="Wind") Public int WindSpeed
		  
		  Dim propInfos() As Introspection.PropertyInfo = tinfo.GetProperties
		  
		  Dim j As New JSONItem
		  
		  For Each propInfo As Introspection.PropertyInfo In propInfos
		    
		    If propInfo.IsPublic = False Then
		      Continue
		    End If
		    
		    Dim attrs() As Introspection.AttributeInfo = propInfo.GetAttributes
		    
		    Dim jSONPropName As String = propInfo.Name
		    For Each attr As Introspection.AttributeInfo In attrs
		      
		      If attr.Name = "JsonPropertyName" Then
		        jSONPropName = attr.Value
		        Exit For
		      End If
		    Next
		    
		    If mCustomSerializers <> Nil And mCustomSerializers.HasKey( propInfo.PropertyType.FullName ) Then
		      Dim customSerializer As CustomPropertySerializer = mCustomSerializers.Value(propInfo.PropertyType.FullName)
		      Try
		        j.Value(jSONPropName) = customSerializer.Invoke(propInfo, propInfo.Value(instance))
		      Catch 
		      End Try
		    Else
		      j.Value(jSONPropName) = propInfo.Value(instance)
		    End If
		    
		  Next
		  
		  Return j.ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCustomDeserializers As dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCustomSerializers As dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
