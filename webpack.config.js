module.exports = {
  entry: './web/static/js/app.js',
  output: {
    path: './priv/static/js',
    filename: 'app.js'
  },
  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: 'babel',
      query: {
        presets: ['react', 'es2015', 'stage-0', 'stage-1', 'stage-2', 'stage-3']
      }
    }]
  },
  resolve: {
    modulesDirectories: [
      'node_modules',
      __dirname + '/web/static/js',
      __dirname + '/priv/static/js',
      __dirname + '/deps/phoenix_html/web/static/js'
    ]
  }
}
