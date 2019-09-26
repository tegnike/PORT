const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')

const webpack = require('webpack')

environment.plugins.append(
  'CommonsChunkVendor',
   new webpack.optimize.CommonsChunkPlugin({
     name: 'vendor',
     minChunks: (module) => {
       // this assumes your vendor imports exist in the node_modules directory
       return module.context && module.context.indexOf('node_modules') !== -1
     }
   })
 )

 environment.plugins.prepend(
   'Provide',
   new webpack.ProvidePlugin({
     jQuery: 'jquery/dist/jquery',
     Popper: 'popper.js/dist/popper'
   })
 )
 
environment.loaders.append('erb', erb)
module.exports = environment
