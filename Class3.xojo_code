#tag Class
Protected Class Class3
	#tag Method, Flags = &h0
		Shared Function CustomDeSerializer(propInfo as Introspection.PropertyInfo, v as Variant) As Variant
		  // create the serializer instance
		  Dim serializer As New JSONSerializer
		  
		  Return serializer.DeSerialize( JsonItem(v).ToString,  GetTypeInfo(Class3) ) 
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CustomSerializer(propInfo as Introspection.PropertyInfo, v as Variant) As Variant
		  
		  If v IsA Class3 Then
		    // create the serializer instance
		    Dim serializer As New JSONSerializer
		    
		    Return New JsonItem( serializer.Serialize( v ) )
		  End If
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		name As string = "class3"
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
