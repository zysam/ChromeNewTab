gulp       = require 'gulp'
jade       = require 'gulp-jade'
#gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
stylus     = require 'gulp-stylus'
livereload = require 'gulp-livereload'

#livePort 与chromereload.js 里port相同，当然默认是LIVERELOAD_PORT = 35729
LIVERELOAD_PORT = 33333
paths =
	views       : ['!./src/vendor/**','!./src/partials/**','src/**/*.jade']
	styles      : 'src/styles/*.styl'
	images      : 'src/images/**/*'
	scripts     : ['src/scripts/*.coffee','src/*.coffee']
	manifest		: 'src/*.json'
	chromereload: 'src/chromereload.js'
	dest : 
		app    : './app'
	live : ['./app/**']

handleError = (err) ->
	#console.error.bind(console)
	console.log err.toString()
	@emit 'end'

gulp.task 'scripts:dev', ->
	gulp.src paths.scripts,{base:'src'}
		.pipe coffee()
		.on 'error',handleError
		.pipe gulp.dest paths.dest.app

gulp.task 'styles:dev', ->
	gulp.src paths.styles,{base:'src'}
		.pipe stylus()
		.on 'error',handleError
		.pipe gulp.dest paths.dest.app

gulp.task 'views:dev', ->
	gulp.src paths.views,{base:'src'}
		.pipe jade({pretty:true})
		.on 'error',handleError
		.pipe gulp.dest paths.dest.app

gulp.task 'manifest:dev', ->
	gulp.src paths.manifest,{base:'src'}
		.on 'error',handleError
		.pipe gulp.dest paths.dest.app

gulp.task 'chromereload:dev', ->
	gulp.src paths.chromereload,{base:'src'}
		.on 'error',handleError
		.pipe gulp.dest paths.dest.app

gulp.task 'images:dev', ->
	gulp.src paths.images,{base:'src'}
		.on 'error',handleError
		.pipe gulp.dest paths.dest.app

gulp.task 'watch', ->
	gulp.watch paths.views       , ['views:dev']
	gulp.watch paths.styles      , ['styles:dev']
	gulp.watch paths.scripts     , ['scripts:dev']
	gulp.watch paths.manifest    , ['manifest:dev']
	gulp.watch paths.images      , ['images:dev']

gulp.task 'livereload', ->
		s = livereload()
		gulp.watch paths.live, (evt)->
			s.changed evt.paths,LIVERELOAD_PORT
		.on 'error',handleError

gulp.task 'default', ['watch','livereload']
gulp.task 'dev',['styles:dev','views:dev','scripts:dev','chromereload:dev','manifest:dev','images:dev','default']
