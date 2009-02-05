#input is specs/gl.spec

proc extension name {
    global extensions

    set extensions($name) 1
}

set dir [file dirname [info script]]

source [file join $dir GL_extensions]

proc is-extension-supported? name {
    global extensions

    return [info exists extensions($name)]
}

array set typemap {
    void void
    List GLuint
    Mode GLenum
    CheckedFloat32 GLfloat
    CheckedInt32 GLint
    Float32 GLfloat
    Int32 GLint
    Float64 GLdouble
    ListMode GLuint
    SizeI GLsizei
    ListNameType GLenum
    Void void
    BeginMode GLenum
    CoordF GLfloat
    UInt8 GLubyte
    Boolean GLboolean
    ColorIndexValueD GLdouble
    ColorB GLbyte
    ColorD GLdouble
    ColorF GLfloat
    ColorI GLint
    ColorS GLshort
    ColorUB GLubyte
    ColorUI GLuint
    ColorUS GLushort
    ColorIndexValueF GLfloat
    ColorIndexValueI GLint
    ColorIndexValueS GLshort
    Int8 GLbyte
    CoordD GLdouble
    Int16 GLshort
    CoordI GLint
    CoordS GLshort
    ClipPlaneName GLenum
    MaterialFace GLenum
    ColorMaterialParameter GLenum
    CullFaceMode GLenum
    FogParameter GLenum
    FrontFaceDirection GLenum
    HintTarget GLenum
    HintMode GLenum
    LightName GLenum
    LightParameter GLenum
    LightModelParameter GLenum
    LineStipple GLushort
    MaterialParameter GLenum
    PolygonMode GLenum
    WinCoord GLint
    ShadingModel GLenum
    TextureTarget GLenum
    TextureParameterName GLenum
    TextureComponentCount GLenum
    PixelFormat GLenum
    PixelType GLenum
    TextureEnvTarget GLenum
    TextureEnvParameter GLenum
    TextureCoordName GLenum
    TextureGenParameter GLenum
    FeedbackType GLenum
    FeedbackElement GLfloat
    SelectName GLuint
    RenderingMode GLenum
    DrawBufferMode GLenum
    ClearBufferMask GLbitfield
    MaskedColorIndexValueF GLfloat
    ClampedColorF GLclampf
    StencilValue GLint
    ClampedFloat64 GLclampd
    MaskedStencilValue GLuint
    MaskedColorIndexValueI GLuint
    AccumOp GLenum
    EnableCap GLenum
    AttribMask GLbitfield
    MapTarget GLenum
    MeshMode1 GLenum
    MeshMode2 GLenum
    AlphaFunction GLenum
    ClampedFloat32 GLclampf
    BlendingFactorSrc GLenum
    BlendingFactorDest GLenum
    LogicOp GLenum
    StencilFunction GLenum
    ClampedStencilValue GLint
    MaskedStencilValue GLuint
    StencilOp GLenum
    DepthFunction GLenum
    PixelTransferParameter GLenum
    PixelStoreParameter GLenum
    PixelMap GLenum
    UInt32 GLuint
    UInt16 GLushort
    ReadBufferMode GLenum
    PixelCopyType GLenum
    GetPName GLenum
    ErrorCode GLenum
    GetMapQuery GLenum
    String "const GLubyte *"
    StringName GLenum
    GetTextureParameter GLenum
    MatrixMode GLenum
    ColorPointerType GLenum
    DrawElementsType GLenum
    GetPointervPName GLenum
    VoidPointer "void *"
    IndexPointerType GLenum
    InterleavedArrayFormat GLenum
    NormalPointerType GLenum
    TexCoordPointerType GLenum
    VertexPointerType GLenum
    PixelInternalFormat GLenum
    Texture GLuint
    ColorIndexValueUB GLubyte
    ClientAttribMask GLbitfield
    BlendEquationMode GLenum
    ColorTableTarget GLenum
    ColorTableParameterPName GLenum
    GetColorTableParameterPName GLenum
    ConvolutionTarget GLenum
    ConvolutionParameter GLenum
    GetConvolutionParameterPName GLenum
    SeparableTarget GLenum
    HistogramTarget GLenum
    GetHistogramParameterPName GLenum
    MinmaxTarget GLenum
    GetMinmaxParameterPName GLenum
    TextureTarget GLenum
    TextureComponentCount GLenum
    TextureUnit GLenum
    CompressedTextureARB "void"
    BlendFuncSeparateParameterEXT GLenum
    FogPointerTypeEXT GLenum
    PointParameterNameARB GLenum
    GLenum GLenum
    BufferTargetARB GLenum
    ConstUInt32 "const GLuint"
    BufferSize GLsizeiptrARB
    ConstVoid "const GLvoid"
    BufferUsageARB GLenum
    BufferOffset GLintptrARB
    BufferAccessARB GLenum
    BufferPNameARB GLenum
    BufferPointerNameARB GLenum
    BlendEquationModeEXT GLenum
    DrawBufferModeATI GLenum
    StencilFaceDirection GLenum
    Char GLchar
    VertexAttribPropertyARB GLenum
    VertexAttribPointerPropertyARB GLenum
    CharPointer "GLchar *"
    VertexAttribPointerTypeARB GLenum
    ClampColorTargetARB unknown3.0
    ClampColorModeARB unknown3.0
    VertexAttribEnum unknown3.0
    DrawBufferName unknown3.0
    WeightPointerTypeARB GLenum
    ProgramTargetARB GLenum
    ProgramFormatARB GLenum
    ProgramStringPropertyARB GLenum
    BufferSizeARB GLsizeiptr
    BufferOffsetARB GLintptr
    handleARB GLhandleARB
    charPointerARB "GLcharARB *"
    charARB GLcharARB
    RenderbufferTarget GLenum
    FramebufferTarget GLenum
    FramebufferAttachment GLenum
    BinormalPointerTypeEXT GLenum
    HintTargetPGI GLenum
    ProgramParameterPName GLenum
    ProgramPropertyARB GLenum
}

proc psplit s {
    set r [list]
    set token ""

    foreach c [split $s ""] {
	if {[string is space -strict $c]} {
	    if {[string length $token]} {
		lappend r $token
	    }
	    set token ""
	} else {
	    append token $c
	}
    }

    if {[string length $token]} {
	lappend r $token
    }

    return $r
}

proc is-extension? str {
    #Check if the trailing name of the function is NV, or EXT, and so on.
    
    if {[string is upper [string index $str end]]
	&& [string is upper [string index $str end-1]]} {
	return 1
    } 

    return 0
}


proc parse {data arvar} {
    upvar 1 $arvar ar

    set state ""
    set name ""

    foreach line [split $data \n] {
	if {"attr" eq $state} {
	    if {[string match "\t*" $line]} {
		set plist [psplit $line]
		#puts PLIST:$plist
		set master $ar($name)
		set param [dict get $master parameters]

		switch -- [llength $plist] {
		    1 {
			dict set master [lindex $plist 0] ""
		    }

		    2 {
			#standard key, value pair
			set key [lindex $plist 0]
			set value [lindex $plist 1]

			dict set master $key $value
		    }

		    default {
			set key [lindex $plist 0]

			#puts PLIST:$plist

			if {"param" eq $key} {
			    lappend param [list [lindex $plist 1] [lindex $plist 2] [lindex $plist 3] [lindex $plist 4]]
			} else {
			    dict set master $key [lrange $plist 1 end]
			}
		    }		    
		}
		
		dict set master parameters $param

		set ar($name) $master
	    } else {
		set state ""
	    }
	} elseif {[regexp {^([A-Z_a-z0-9]+)\((.*)\)\S*} $line all name argv] > 0} {
	    #puts "MATCH:$name ARGV:$argv"
	    
	    #Trim the spaces in the elements.
	    set newargv [list]
	    foreach a [split $argv ,] {
		lappend newargv [string trim $a]
	    }
	    

	    set d [dict create name $name arguments $newargv \
		       parameters [dict create]]
	    set ar($name) $d
	    set state attr
	} 
    }
}

#This returns true if the category is valid for an extension.
proc is-valid-category? c {
    set clist [list display-list drawing drawing-control feedback \
		   framebuf misc modeling pixel-op pixel-rw state-req \
		   xform 1_1 VERSION_1_2 VERSION_1_3 VERSION_1_4 \
		   VERSION_1_5 VERSION_2_0 VERSION_2_1]

    set result [expr {$c in $clist}]


    if {!$result} {
	set result [is-extension-supported? $c]
    }

    return $result
}

proc main {argc argv} {
    global extensions typemap

    set fd [open [lindex $argv 0] r]
    set data [read $fd]
    close $fd

  
    array set ar {}
    
    parse $data ar
    
    array set newapi {}
    array set missingTypes {}

    foreach {key value} [array get ar] {
	puts "KEY:$key VALUE:$value"

	set category [dict get $value category]
	
	#Invalidate any of the extensions and things not in the spec we support.
	set valid 0

	#if {![is-extension? $key]} {
	#    set valid 1
	#} 

	set valid [is-valid-category? $category]
	puts VALID:$valid
	
	if {!$valid} {
	   continue
	}

	puts "VALID:$key"

	if {"BlitFramebuffer" eq $key} {
	    #This was promoted to an ARB extension after Leopard it seems.
	    set key BlitFramebufferEXT
	}

	if {"ARB_framebuffer_object" eq $category} {
	    #This wasn't an ARB extension in Leopard either.
	    if {![string match *EXT $key]} {
		append key EXT
	    }
	}

	set master [dict create]
	set rettype [dict get $value return]
	
	if {![info exists typemap($rettype)]} {
	    set missingTypes($rettype) $key
	} else {
	    dict set master return $typemap($rettype)
	}

	set newparams [list]


	foreach p [dict get $value parameters] {
	    set var [lindex $p 0]

	    set ptype [lindex $p 1]
	    
	    if {![info exists typemap($ptype)]} {
		set missingTypes($ptype) $key
		continue
	    }
    
	    set type $typemap($ptype)

	    #In the gl.spec file is MultiDrawArrays first and count
	    #are really 'in' so we make them const.
	    #The gl.spec notes this problem.
	    if {("MultiDrawArrays" eq $key || "MultiDrawArraysEXT" eq $key) 
		&& ("first" eq $var)} {
		set final_type "const $type *"
	    } elseif {("MultiDrawArrays" eq $key 
		       || "MultiDrawArraysEXT" eq $key) && "count" eq $var} {
		set final_type "const $type *"
	    } elseif {"array" eq [lindex $p 3]} {
		if {"in" eq [lindex $p 2]} {
		    set final_type "const $type *"
		} else {
		    set final_type "$type *"
		}
	    } else {
		set final_type $type
	    }
	    
	    lappend newparams [list $final_type $var]
	}

	dict set master parameters $newparams

	set newapi($key) $master
    }

    parray newapi

    if {[array size missingTypes]} {
	parray missingTypes
	return 1
    }

    puts "NOW GENERATING:[lindex $::argv 1]"
    set fd [open [lindex $::argv 1] w]
    
    set sorted [lsort -dictionary [array names newapi]]

    foreach f $sorted {
	set attr $newapi($f)
	set pstr ""
	foreach p [dict get $attr parameters] {
	    append pstr "[lindex $p 0] [lindex $p 1], "
	}
	set pstr [string trimright $pstr ", "]
	puts $fd "[dict get $attr return] gl[set f]($pstr); "
    }

    close $fd

    if {$::argc == 3} {
	puts "NOW GENERATING:[lindex $::argv 2]"
	#Dump the array as a serialized list.
	set fd [open [lindex $::argv 2] w]
	puts $fd [array get newapi]
	close $fd
    }

    return 0
}
exit [main $::argc $::argv]
