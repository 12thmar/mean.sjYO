'use strict';

module.exports = function (grunt) {
    
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
		clean: {
			ouput: ['ToBeCleaned/*']
		},
     
    });

   // Load NPM tasks
	require('load-grunt-tasks')(grunt);
    // Making grunt default to force in order not to break the project.
	grunt.option('force', true);

	grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.registerTask('default', ['clean']);
}