gulp           = require 'gulp'
coffee         = require 'gulp-coffee'
stylus         = require 'gulp-stylus'
indent         = require 'gulp-indent'
livereload     = require 'gulp-livereload'

gulp.task 'coffee', ->
	gulp.src('resources/coffee/*.coffee')
    .pipe coffee bare: true, indent tabs: false, amount: 4
	.pipe gulp.dest('public_html/javascripts/')
    .pipe livereload()

gulp.task 'stylus', ->
    gulp.src('resources/stylus/*.styl')
    .pipe(stylus(compress: true))
    .pipe gulp.dest('public_html/stylesheets/')
    .pipe livereload()

gulp.task 'watch', ->
    livereload.listen()
    gulp.watch 'resources/coffee/*.coffee', ['coffee']
    gulp.watch 'resources/stylus/*.styl', ['stylus']

gulp.task 'default', [
    'coffee'
    'stylus'
]