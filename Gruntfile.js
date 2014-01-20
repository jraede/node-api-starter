
var f, semver;

semver = require('semver');

f = require('util').format;
module.exports = function(grunt) {
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-exec');
	grunt.loadNpmTasks('grunt-sed');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.initConfig({
		version: grunt.file.readJSON('package.json').version,
		
	});

	f = require('util').format;

module.exports = function(grunt) {
	grunt.loadNpmTasks('grunt-exec');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.initConfig({
		exec:{
			test: {
				cmd:'NODE_ENV=test mocha'
			},
			run_tests: {
				cmd: function() {
					return f('grunt test');
				}
			},
			git_is_clean: {
				cmd: function() {
					return f('test -z "$(git status --porcelain)"');
				}
			},
			git_on_master: {
				cmd:function() {
					return f('test $(git symbolic-ref -q HEAD)=refs/head/master');
				}
			},
			git_add: {
				cmd: function() {
					return f('git add . && git add -u .');
				}
			},
			git_commit: {
				cmd: function(m) {
					return f('git commit -m "%s"', m);
				}
			},
			git_tag: {
				cmd: function(v) {
					return f('git tag v%s -am "%s"', v, v);
				}
			},
			git_push_dev: {
				cmd: function() {
					return f('git push origin master && git push --tags');
				}
			},
			git_push: {
				cmd: function(m) {
					return f('git push %s master',m);
				}
			}
		},
		watch: {
			coffee:{
				files:['coffee/**/*.coffee', 'coffee/*.coffee'],
				tasks:['coffee']
			}
		},
		coffee: {
			source:{
				options:{
					preserve_dirs:true,
					bare:true
				},
				files:[
					{
						expand:true,
						flatten:false,
						cwd:'coffee',
						src:['*.coffee','**/*.coffee'],
						dest:'',
						ext:'.js'
					}
				]
			}
		}
		
	});

	
	grunt.registerTask('dropTestDb', function() {
		var mongoose = require('mongoose');
		var done = this.async();
		mongoose.connect('mongodb://localhost/cornerstone_test')
		mongoose.connection.on('open', function () { 
			mongoose.connection.db.dropDatabase(function(err) {
				if(err) {
					console.log(err);
				} else {
					console.log('Successfully dropped db');
				}
				mongoose.connection.close(done);
			});
		});
	});

	grunt.registerTask('test', ['exec:test']);
	grunt.registerTask('release', 'Ship it.', function(version) {
		var curVersion, link, remote, tasks, _ref;
		curVersion = grunt.config.get('version');
		version = semver.inc(curVersion, version) || version;
		if (!semver.valid(version) || semver.lte(version, curVersion)) {
			grunt.fatal('invalid version dummy');
		}
		grunt.config.set('version', version);
		tasks = ['exec:run_tests', 'exec:git_on_master', 'exec:git_is_clean', 'exec:git_tag:' + version, 'exec:git_push_bitbucket'];
		_ref = grunt.config.get('release_remotes');
		for (remote in _ref) {
			link = _ref[remote];
			tasks.push('exec:git_push:' + remote);
		}
		return grunt.task.run(tasks);
	});
};
};
