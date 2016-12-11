fs = require('fs')
path = require("path")
env = process.env.NODE_ENV or "development"
webpack = require("webpack")

if env != 'production'
  WEBPACK_DEV_SERVER_URL = "http://localhost:8080/"

ExtractTextPlugin = require('extract-text-webpack-plugin')

commonsChunkFilename = "[name].js"
outputFilename = "[name].js"
# Filenames dependent on environment
if env == "production"
  extractTextFilename = "[name].[contenthash].css"
  chunkFilename = "[name].chunk.[chunkhash].js"
else
  extractTextFilename = "[name].css"
  chunkFilename = "[name].chunk.js"

# Plugins
plugins = [
  ->
    @plugin('done', (stats) ->
      if env == "production"
        stats = JSON.stringify(stats.toJson().assetsByChunkName, null, 2)
        fs.writeFileSync('./manifest.json', stats)
    )
  ,
  new ExtractTextPlugin(extractTextFilename, allChunks: true),
  new webpack.optimize.CommonsChunkPlugin(
    name: "vendor"
    filename: commonsChunkFilename
  ),
  new webpack.optimize.CommonsChunkPlugin(
    name: "meta"
    chunks: ['vendor']
  ),
]

# Loaders
loaders = [
  { test: /\.cjsx$/, loaders: ['coffee', 'cjsx']}
  { test: /\.coffee$/, loader: 'coffee' }
  { test: /\.css$/, exclude: /node_modules/, loader: "style!css" }
  {
    test: /\.gif$/
    include: [
      path.resolve(__dirname, "src/images"),
      path.resolve(__dirname, "node_modules/jquery-ui")
    ]
    loader: "url?mimetype=image/gif&limit=10000"
  }
  {
    test: /\.jpg$/
    include: [path.resolve(__dirname, "src/images")]
    loader: "url?mimetype=image/jpg&limit=10000"
  }
  {
    test: /\.png$/
    include: [
      path.resolve(__dirname, "src/images"),
      path.resolve(__dirname, "node_modules/jquery-ui")
    ]
    loader: "url?mimetype=image/png&limit=10000"
  }
  {
    test: /\.woff[2]?(\?v=[0-9]\.[0-9]\.[0-9])?$/
    loader: "url?limit=10000&minetype=application/font-woff"
  }
  { test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file" }
]

# Entry points
entry = {
  index: "./src/index.coffee"
}

# Styles loader specs
modules_path = path.resolve(__dirname, './node_modules')
cssLoaderSpec = 'css!sass?outputStyle=expanded' +
  '&includePaths[]=' + modules_path +
  '&includePaths[]=' + path.resolve(__dirname, './src/styles')

# Additional plugins, loaders etc. dependent on environment
if env == "production"
  plugins.push(
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.DefinePlugin(
      'process.env':
        'NODE_ENV': JSON.stringify('production')
    )
    new webpack.optimize.UglifyJsPlugin(
      compress:
        warnings: false
    )
  )
  loaders.push(
    test: /\.(css|scss)$/
    loader: ExtractTextPlugin.extract("style-loader", cssLoaderSpec)
  )
else
  loaders.push(
    test: /\.(css|scss)$/
    loader: 'style!' + cssLoaderSpec
  )
  entry.dev = [
    "webpack-dev-server/client?" + WEBPACK_DEV_SERVER_URL,
    "webpack/hot/dev-server"
  ]

# Final config
module.exports =
  entry: entry

  devServer:
    hot: true

  output:
    filename: outputFilename
    chunkFilename: chunkFilename
    publicPath: WEBPACK_DEV_SERVER_URL
    path: path.resolve("dist")

  module:
    loaders: loaders

  resolve:
    extensions: ["", ".webpack.js", ".web.js", ".js", ".coffee", ".cjsx"]

  plugins: plugins
