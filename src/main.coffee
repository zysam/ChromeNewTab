'use strict'

chrome.app.runtime.onLaunched.addListener ->
	chrome.app.window.create 'index.html',{
		id : '三记'
		bounds : 
			height : 400
			width : 550
		#frame : 'none'
	}