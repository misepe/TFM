;###################################################################
;# Copyright        : (c) All Rights Reserved                      #
;# Company          : X-FAB Global Services GmbH                   #
;# Address          : Haarbergstr. 67, 99097 Erfurt, Germany       #
;###################################################################

let( ( loadTECH libId libPath loadFile)	
	loadTECH = "xh018"
	libId = ddGetObj( "PRIMLIB" )	
	
	when( ddIsId( libId )
		libPath = ddGetObjReadPath( libId )
		load( strcat(libPath "/anhs.ile"))
	)
	
	when(!boundp('thesSdl_loaded) && libPath
		loadFile = strcat( libPath "/../skill/thesSdl.il")
		if( isFile(loadFile) then
			load(loadFile)
		else
            when( isDir("./.xkit")
			    warn("%s PDK loadFile - %s - not found.\n", loadTECH, loadFile)
            )
		)
	)
)
