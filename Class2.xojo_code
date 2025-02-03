#tag Class
Protected Class Class2
	#tag Method, Flags = &h0
		Sub Constructor()
		  c3 = New class3
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CustomSerializer(propInfo as Introspection.PropertyInfo, v as Variant) As Variant
		  
		  If v IsA Class2 Then
		    // create the serializer instance
		    Dim serializer As New JSONSerializer
		    
		    // add suitable serializers and deserializers for custom handling
		    serializer.AddCustomSerializer("Class3", AddressOf Class3.CustomSerializer)
		    
		    Return New JsonItem( serializer.Serialize( v ) )
		  End If
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		c3 As class3
	#tag EndProperty

	#tag Property, Flags = &h0
		name As string = "class2"
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="name"
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
