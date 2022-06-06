#!/usr/bin/env node

const esBuild = require('esbuild')

const watch = process.argv.includes('--watch')
const minify = process.argv.includes('--minify')

const watchOptions = {
	onRebuild: (error, result) => {
		if (error) {
			console.error('watch build failed:', error)
		} else {
			console.log(result)
			console.log('watch build succeeded. ')
		}
	}
}

const loaders = {
	'.js': 'jsx'
}

esBuild.build({
	entryPoints: ['app/javascript/application.js'],
	logLevel: 'info',
	bundle: true,
	outdir: 'app/assets/builds',
	watch: watch && watchOptions,
	sourcemap: 'linked',
	loader: loaders,
	publicPath: '/assets',
	minify
}).then(result => {
	console.log(result)
	if (watch) {
		console.log('Build finished, watching for changes...')
	} else {
		console.log('Build finished, Congrats')
	}
}).catch(result => {
	console.log(result)
	process.exit(1)
})
