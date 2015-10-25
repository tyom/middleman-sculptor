var webpack = require("webpack");

module.exports = {
  entry: {
    'iframe-content-window': 'iframeContentWindow',
    glyptotheque: './source/glyptotheque/app.js',
    main: './source/assets/scripts/main.js',
    store: 'store',
  },
  output: {
    path: './source/assets/scripts',
    filename: '[name].bundle.js'
  },
  module: {
    loaders: [
      { include: /\.json$/, loaders: ['json-loader'] },
      { include: /store\.js$/, loader: 'expose?store' }
    ]
  },
  resolve: {
    alias: {
      'iframeContentWindow': './node_modules/iframe-resizer/js/iframeResizer.contentWindow.min.js'
    },
    modulesDirectories: [
      'node_modules',
      'node_modules/mojular/node_modules'
    ],
    extensions: ['', '.json', '.js']
  },
  plugins: [
    new webpack.optimize.DedupePlugin()
  ]
};
